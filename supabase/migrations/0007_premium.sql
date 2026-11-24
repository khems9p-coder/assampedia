-- Phase 6c: Premium subscription.
-- Free: the first 3 pages of every group, the first 3 quizzes of every type,
-- and all daily questions. Everything else needs an active subscription.
-- Titles and summaries stay visible to everyone so lists can show a lock.

-- ---------- Who has Premium ----------
create table if not exists public.premium_access (
  user_id uuid primary key references auth.users (id) on delete cascade,
  expires_at timestamptz not null,
  product_id text,
  -- Google Play's purchase token; one purchase can unlock only one account.
  purchase_token text unique,
  source text not null default 'google_play' check (source in ('google_play', 'admin_gift')),
  updated_at timestamptz not null default now()
);

alter table public.premium_access enable row level security;

drop policy if exists "read own premium" on public.premium_access;
create policy "read own premium" on public.premium_access
  for select using (user_id = (select auth.uid()) or (select public.is_admin()));
-- Purchases are written by the verify-purchase server function. Admins may
-- also give free access (for testing or as a gift).
drop policy if exists "admins write premium" on public.premium_access;
create policy "admins write premium" on public.premium_access
  for all using ((select public.is_admin())) with check ((select public.is_admin()));

grant select on public.premium_access to authenticated;
grant insert, update, delete on public.premium_access to authenticated;

create or replace function public.has_premium()
returns boolean
language sql
stable
security definer set search_path = ''
as $$
  select public.is_admin() or exists (
    select 1 from public.premium_access p
    where p.user_id = (select auth.uid()) and p.expires_at > now()
  );
$$;

grant execute on function public.has_premium() to anon, authenticated;

-- ---------- Which pages are free ----------
-- The first 3 visible pages of a group, in the order readers see them
-- (current affairs: newest first; everything else: by position).
create or replace function public.content_is_free(cid uuid)
returns boolean
language sql
stable
security definer set search_path = ''
as $$
  with target as (
    select category_id, kind from public.content where id = cid
  ),
  ranked as (
    select c.id,
           row_number() over (
             order by case when t.kind = 'current_affairs' then c.event_date end desc nulls last,
                      c.position, c.id
           ) as rn
    from public.content c, target t
    where c.category_id is not distinct from t.category_id
      and exists (
        select 1 from public.content_versions v
        where v.content_id = c.id and public.version_is_live(v)
      )
  )
  select coalesce((select t.category_id is null from target t), true)
      or coalesce((select r.rn <= 3 from ranked r where r.id = cid), false);
$$;

grant execute on function public.content_is_free(uuid) to anon, authenticated;

drop policy if exists "read live blocks" on public.content_blocks;
create policy "read live blocks" on public.content_blocks
  for select using (
    (select public.is_admin()) or (
      exists (
        select 1 from public.content_versions v
        where v.content_id = content_blocks.content_id
          and v.lang = content_blocks.lang
          and public.version_is_live(v)
      )
      and ((select public.has_premium()) or public.content_is_free(content_blocks.content_id))
    )
  );

-- ---------- Which quizzes are free ----------
create or replace function public.question_set_is_free(sid uuid)
returns boolean
language sql
stable
security definer set search_path = ''
as $$
  with target as (
    select kind from public.question_sets where id = sid
  ),
  ranked as (
    select s.id, row_number() over (order by s.position, s.id) as rn
    from public.question_sets s, target t
    where s.kind = t.kind and s.is_published
  )
  select coalesce((select t.kind = 'daily' from target t), false)
      or coalesce((select r.rn <= 3 from ranked r where r.id = sid), false);
$$;

grant execute on function public.question_set_is_free(uuid) to anon, authenticated;

drop policy if exists "read questions of published sets" on public.questions;
create policy "read questions of published sets" on public.questions
  for select using (
    (select public.is_admin())
    or (
      exists (select 1 from public.question_sets s where s.id = set_id and s.is_published)
      and ((select public.has_premium()) or public.question_set_is_free(set_id))
    )
  );

-- ---------- Question counts readers can see even when a quiz is locked ----------
alter table public.question_sets add column if not exists question_count int not null default 0;

create or replace function public.update_question_count()
returns trigger
language plpgsql
security definer set search_path = ''
as $$
begin
  update public.question_sets s
  set question_count = (select count(*) from public.questions q where q.set_id = s.id)
  where s.id in (
    case when tg_op <> 'INSERT' then old.set_id end,
    case when tg_op <> 'DELETE' then new.set_id end
  );
  return null;
end;
$$;

drop trigger if exists questions_count on public.questions;
create trigger questions_count
  after insert or update of set_id or delete on public.questions
  for each row execute function public.update_question_count();

update public.question_sets s
set question_count = (select count(*) from public.questions q where q.set_id = s.id);
