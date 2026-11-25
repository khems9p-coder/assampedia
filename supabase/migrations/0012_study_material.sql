-- Study Material: sections and sub-sections (any depth) holding pictures,
-- PDFs, YouTube videos, note pages and quizzes. Each section is Free or
-- Premium. Free material is the hook; Premium needs the subscription.
-- Rule: an item is free when its section is free, when the admin marks it
-- free, or when it is one of the first 3 items of its section (the preview).
-- Files live in the private 'study' bucket: the app can open a file only
-- when its item is free or the reader has Premium.
-- Safe to run more than once.

create table if not exists public.study_sections (
  id uuid primary key default gen_random_uuid(),
  parent_id uuid references public.study_sections (id) on delete cascade,
  -- 'free' sections show under Free, 'premium' ones under Premium.
  tier text not null default 'free' check (tier in ('free', 'premium')),
  -- A fixed name for sections the app knows about (e.g. the free PDF section).
  slug text unique,
  title_as text,
  title_en text,
  description_as text,
  description_en text,
  icon text,
  position int not null default 0,
  is_published boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  check (coalesce(title_as, title_en) is not null),
  check (parent_id is null or parent_id <> id)
);

create table if not exists public.study_items (
  id uuid primary key default gen_random_uuid(),
  section_id uuid not null references public.study_sections (id) on delete cascade,
  position int not null default 0,
  item_type text not null check (item_type in ('pdf', 'image', 'video', 'page', 'quiz')),
  title_as text,
  title_en text,
  description_as text,
  description_en text,
  -- pdf / image: the file's path in the 'study' bucket; size in bytes.
  file_path text,
  file_size bigint,
  -- video: a YouTube (or other) link.
  video_url text,
  -- page: a chapter or exam page; quiz: a practice set.
  content_id uuid references public.content (id) on delete cascade,
  set_id uuid references public.question_sets (id) on delete cascade,
  -- The admin's "Free" switch (a free sample inside a premium section).
  is_free boolean not null default false,
  is_published boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  check (
    (item_type in ('pdf', 'image') and file_path is not null)
    or (item_type = 'video' and video_url is not null)
    or (item_type = 'page' and content_id is not null)
    or (item_type = 'quiz' and set_id is not null)
  ),
  check (item_type in ('page', 'quiz') or coalesce(title_as, title_en) is not null)
);

create index if not exists study_sections_parent_idx on public.study_sections (parent_id, position);
create index if not exists study_items_section_idx on public.study_items (section_id, position);
create index if not exists study_items_file_idx on public.study_items (file_path);
create index if not exists study_items_content_idx on public.study_items (content_id);
create index if not exists study_items_set_idx on public.study_items (set_id);

alter table public.study_sections enable row level security;
alter table public.study_items enable row level security;

-- A section is visible when it and every section above it are published.
create or replace function public.study_section_visible(sid uuid)
returns boolean
language sql
stable
security definer set search_path = ''
as $$
  with recursive up as (
    select id, parent_id, is_published, 1 as depth from public.study_sections where id = sid
    union all
    select s.id, s.parent_id, s.is_published, up.depth + 1
    from public.study_sections s join up on s.id = up.parent_id
    where up.depth < 50
  )
  select exists (select 1 from up) and not exists (select 1 from up where not is_published);
$$;

drop policy if exists "read published sections" on public.study_sections;
create policy "read published sections" on public.study_sections
  for select using ((select public.is_admin()) or public.study_section_visible(id));
drop policy if exists "admins write sections" on public.study_sections;
create policy "admins write sections" on public.study_sections
  for all using ((select public.is_admin())) with check ((select public.is_admin()));

-- Titles of every item in a visible section can be read (so lists show locks);
-- the file itself is protected by the storage rules below.
drop policy if exists "read published items" on public.study_items;
create policy "read published items" on public.study_items
  for select using ((select public.is_admin()) or (is_published and public.study_section_visible(section_id)));
drop policy if exists "admins write items" on public.study_items;
create policy "admins write items" on public.study_items
  for all using ((select public.is_admin())) with check ((select public.is_admin()));

grant select on public.study_sections, public.study_items to anon, authenticated;
grant insert, update, delete on public.study_sections, public.study_items to authenticated;

-- ---------- Which items are free ----------
create or replace function public.study_item_is_free(iid uuid)
returns boolean
language sql
stable
security definer set search_path = ''
as $$
  with target as (
    select i.id, i.section_id, i.is_free, s.tier
    from public.study_items i join public.study_sections s on s.id = i.section_id
    where i.id = iid
  ),
  ranked as (
    select i.id, row_number() over (order by i.position, i.id) as rn
    from public.study_items i, target t
    where i.section_id = t.section_id and i.is_published
  )
  select coalesce((select t.tier = 'free' or t.is_free from target t), false)
      or coalesce((select r.rn <= 3 from ranked r where r.id = iid), false);
$$;

grant execute on function public.study_section_visible(uuid) to anon, authenticated;
grant execute on function public.study_item_is_free(uuid) to anon, authenticated;

-- The items of one section, in order, with which ones open for this reader's plan.
create or replace function public.study_section_items(sid uuid)
returns table (
  id uuid,
  item_position int,
  item_type text,
  title_as text,
  title_en text,
  description_as text,
  description_en text,
  file_path text,
  file_size bigint,
  video_url text,
  content_id uuid,
  set_id uuid,
  is_free boolean
)
language sql
stable
security definer set search_path = ''
as $$
  select i.id, i.position, i.item_type,
         coalesce(nullif(i.title_as, ''),
                  (select v.title from public.content_versions v
                   where v.content_id = i.content_id and v.lang = 'as' and public.version_is_live(v)),
                  q.title_as),
         coalesce(nullif(i.title_en, ''),
                  (select v.title from public.content_versions v
                   where v.content_id = i.content_id and v.lang = 'en' and public.version_is_live(v)),
                  q.title_en),
         i.description_as, i.description_en, i.file_path, i.file_size,
         -- A locked video's link is only sent to readers who may watch it.
         case when public.has_premium() or public.study_item_is_free(i.id) then i.video_url end,
         i.content_id, i.set_id,
         public.study_item_is_free(i.id)
  from public.study_items i
  left join public.question_sets q on q.id = i.set_id
  where i.section_id = sid
    and ((select public.is_admin()) or (i.is_published and public.study_section_visible(sid)))
  order by i.position, i.id;
$$;

grant execute on function public.study_section_items(uuid) to anon, authenticated;

-- ---------- Pages and quizzes marked free here open for free readers too ----------
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
      or coalesce((select r.rn <= 3 from ranked r where r.id = cid), false)
      or exists (
        select 1 from public.course_items i
        join lateral public.course_visible_items(i.course_id) f on f.id = i.id
        where i.content_id = cid and f.rn <= 3
      )
      or exists (
        select 1 from public.study_items s
        where s.content_id = cid and s.is_published and public.study_item_is_free(s.id)
      );
$$;

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
      or coalesce((select r.rn <= 3 from ranked r where r.id = sid), false)
      or exists (
        select 1 from public.course_items i
        join lateral public.course_visible_items(i.course_id) f on f.id = i.id
        where i.set_id = sid and f.rn <= 3
      )
      or exists (
        select 1 from public.study_items s
        where s.set_id = sid and s.is_published and public.study_item_is_free(s.id)
      );
$$;

-- ---------- Private file storage ----------
insert into storage.buckets (id, name, public) values ('study', 'study', false)
on conflict (id) do nothing;

create or replace function public.study_file_allowed(path text)
returns boolean
language sql
stable
security definer set search_path = ''
as $$
  select public.is_admin() or exists (
    select 1 from public.study_items i
    where i.file_path = path and i.is_published
      and public.study_section_visible(i.section_id)
      and (public.has_premium() or public.study_item_is_free(i.id))
  );
$$;

grant execute on function public.study_file_allowed(text) to anon, authenticated;

drop policy if exists "read allowed study files" on storage.objects;
create policy "read allowed study files" on storage.objects
  for select using (bucket_id = 'study' and public.study_file_allowed(name));
drop policy if exists "admins upload study files" on storage.objects;
create policy "admins upload study files" on storage.objects
  for insert with check (bucket_id = 'study' and (select public.is_admin()));
drop policy if exists "admins change study files" on storage.objects;
create policy "admins change study files" on storage.objects
  for update using (bucket_id = 'study' and (select public.is_admin()));
drop policy if exists "admins delete study files" on storage.objects;
create policy "admins delete study files" on storage.objects
  for delete using (bucket_id = 'study' and (select public.is_admin()));

-- ---------- Starter sections ----------
insert into public.study_sections (slug, tier, position, title_en, title_as, description_en, description_as, icon, is_published)
values
  ('free-pdf', 'free', 0, 'Free PDF Study Material', 'বিনামূলীয়া পিডিএফ অধ্যয়ন সামগ্ৰী',
   'Syllabus, notes, previous-year papers and monthly current affairs as PDFs. Free for everyone.',
   'পাঠ্যক্ৰম, টোকা, পূৰ্বৰ বছৰৰ প্ৰশ্নকাকত আৰু মাহেকীয়া সাম্প্ৰতিক ঘটনা পিডিএফ হিচাপে। সকলোৰে বাবে বিনামূলীয়া।',
   'menu_book', true),
  ('premium-notes', 'premium', 0, 'Premium notes and classes', 'প্ৰিমিয়াম টোকা আৰু শ্ৰেণী',
   'Full PDF notes, video classes and extra practice. The first 3 items of every section are free to try.',
   'সম্পূৰ্ণ পিডিএফ টোকা, ভিডিঅ’ শ্ৰেণী আৰু অতিৰিক্ত অনুশীলন। প্ৰতিটো শাখাৰ প্ৰথম ৩টা বিনামূলীয়াকৈ চাব পাৰি।',
   'workspace_premium', false)
on conflict (slug) do nothing;
