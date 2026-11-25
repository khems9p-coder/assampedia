-- Courses: ordered study paths (for example APSC CCE, ADRE, Assam Police)
-- built from pages and quizzes that are already in the app.
-- Free rule: the first 3 lessons of every published course are free, as well
-- as everything that was already free (first 3 pages of a group, and so on).
-- Safe to run more than once.

create table if not exists public.courses (
  id uuid primary key default gen_random_uuid(),
  slug text not null unique,
  title_as text,
  title_en text,
  description_as text,
  description_en text,
  icon text,
  position int not null default 0,
  is_published boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  check (coalesce(title_as, title_en) is not null)
);

-- One lesson: a page (GK chapter, exam syllabus page, career page) or a quiz.
create table if not exists public.course_items (
  id uuid primary key default gen_random_uuid(),
  course_id uuid not null references public.courses (id) on delete cascade,
  position int not null default 0,
  content_id uuid references public.content (id) on delete cascade,
  set_id uuid references public.question_sets (id) on delete cascade,
  -- Optional lesson name; empty means "use the page or quiz title".
  title_as text,
  title_en text,
  created_at timestamptz not null default now(),
  check ((content_id is null) <> (set_id is null))
);

create index if not exists course_items_course_idx on public.course_items (course_id, position);
create index if not exists course_items_content_idx on public.course_items (content_id);
create index if not exists course_items_set_idx on public.course_items (set_id);

alter table public.courses enable row level security;
alter table public.course_items enable row level security;

drop policy if exists "read published courses" on public.courses;
create policy "read published courses" on public.courses
  for select using (is_published or (select public.is_admin()));
drop policy if exists "admins write courses" on public.courses;
create policy "admins write courses" on public.courses
  for all using ((select public.is_admin())) with check ((select public.is_admin()));

drop policy if exists "read items of published courses" on public.course_items;
create policy "read items of published courses" on public.course_items
  for select using (
    (select public.is_admin())
    or exists (select 1 from public.courses c where c.id = course_id and c.is_published)
  );
drop policy if exists "admins write course items" on public.course_items;
create policy "admins write course items" on public.course_items
  for all using ((select public.is_admin())) with check ((select public.is_admin()));

grant select on public.courses, public.course_items to anon, authenticated;
grant insert, update, delete on public.courses, public.course_items to authenticated;

-- ---------- Which lessons readers see, in order (a lesson is hidden until its page or quiz is published) ----------
create or replace function public.course_visible_items(cid uuid)
returns table (id uuid, rn bigint)
language sql
stable
security definer set search_path = ''
as $$
  select i.id, row_number() over (order by i.position, i.id)
  from public.course_items i
  join public.courses c on c.id = i.course_id and c.is_published
  where i.course_id = cid
    and (
      (i.content_id is not null and exists (
        select 1 from public.content_versions v where v.content_id = i.content_id and public.version_is_live(v)))
      or (i.set_id is not null and exists (
        select 1 from public.question_sets s where s.id = i.set_id and s.is_published))
    );
$$;

-- ---------- Free pages: the old rule, plus the first 3 lessons of any course ----------
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
      );
$$;

-- ---------- The lessons of one course, ready to show ----------
-- Titles come from the page or quiz unless the lesson has its own name.
create or replace function public.course_lessons(cid uuid)
returns table (
  id uuid,
  lesson_no bigint,
  content_id uuid,
  set_id uuid,
  kind text,
  title_as text,
  title_en text,
  is_free boolean
)
language sql
stable
security definer set search_path = ''
as $$
  select i.id,
         f.rn,
         i.content_id,
         i.set_id,
         case when i.set_id is not null then 'quiz' else coalesce(ct.kind, 'gk_chapter') end,
         coalesce(nullif(i.title_as, ''),
                  (select v.title from public.content_versions v
                   where v.content_id = i.content_id and v.lang = 'as' and public.version_is_live(v)),
                  s.title_as),
         coalesce(nullif(i.title_en, ''),
                  (select v.title from public.content_versions v
                   where v.content_id = i.content_id and v.lang = 'en' and public.version_is_live(v)),
                  s.title_en),
         f.rn <= 3
           or (i.content_id is not null and public.content_is_free(i.content_id))
           or (i.set_id is not null and public.question_set_is_free(i.set_id))
  from public.course_visible_items(cid) f
  join public.course_items i on i.id = f.id
  left join public.content ct on ct.id = i.content_id
  left join public.question_sets s on s.id = i.set_id
  order by f.rn;
$$;

grant execute on function public.course_visible_items(uuid) to anon, authenticated;
grant execute on function public.course_lessons(uuid) to anon, authenticated;

-- ---------- Starter courses ----------
-- Built only from pages already in the app. A page that is not in your
-- database yet is skipped; run this file again after importing it and the
-- missing lessons are added (lessons already there are left alone).
-- Each page is followed by any published quiz that belongs to it.
do $$
declare
  c record;
  cid uuid;
  slugs text[];
  n int;
begin
  for c in
    select * from (values
      (1, 'apsc-cce', 'APSC CCE: Assam and History', 'এ.পি.এছ.চি. চি.চি.ই.: অসম আৰু ইতিহাস',
       'Step-by-step path for the APSC Combined Competitive Exam: the History syllabus, then Assam history, culture, geography and polity.',
       'এ.পি.এছ.চি.ৰ সংযুক্ত প্ৰতিযোগিতামূলক পৰীক্ষাৰ বাবে ক্ৰমান্বয়ে পঢ়াৰ পথ: ইতিহাসৰ পাঠ্যক্ৰম, তাৰ পিছত অসমৰ ইতিহাস, সংস্কৃতি, ভূগোল আৰু ৰাজনীতি।',
       'gavel',
       array['apsc-cce-history-overview','apsc-cce-prelims-history','apsc-cce-mains-assam-history','apsc-cce-mains-gs1-history',
             'ancient-assam-kamarupa','ahom-kingdom','koch-kingdom','mughal-invasions-saraighat','burmese-invasions-yandabo',
             'assam-under-british-rule','assam-freedom-struggle','assam-movement-accord','sattriya-and-sattra','assamese-literature',
             'srimanta-sankardev','physical-divisions-of-assam','brahmaputra-river-system','governor-cm-ministers',
             'sixth-schedule-councils','tea-industry']),
      (2, 'adre', 'ADRE (Grade III and IV): Assam GK', 'এ.ডি.আৰ.ই. (তৃতীয় আৰু চতুৰ্থ বৰ্গ): অসমৰ সাধাৰণ জ্ঞান',
       'The Assam GK topics most asked in the Assam Direct Recruitment Exam, in a simple order: basics, geography, history, culture and famous people.',
       'অসম প্ৰত্যক্ষ নিযুক্তি পৰীক্ষাত সততে সোধা অসমৰ সাধাৰণ জ্ঞানৰ বিষয়, সহজ ক্ৰমত: মূল কথা, ভূগোল, ইতিহাস, সংস্কৃতি আৰু বিখ্যাত ব্যক্তি।',
       'flag',
       array['assam-at-a-glance','state-symbols-of-assam','location-and-boundaries','formation-of-assam','districts-of-assam-overview',
             'physical-divisions-of-assam','brahmaputra-river-system','climate-and-floods','national-parks-of-assam',
             'one-horned-rhinoceros','ahom-kingdom','mughal-invasions-saraighat','assam-movement-accord','bihu','silk-and-handloom',
             'srimanta-sankardev','lachit-borphukan','bhupen-hazarika','governor-cm-ministers','population-census-2011',
             'major-bridges-of-assam','kamakhya-temple','majuli']),
      (3, 'assam-police', 'Assam Police (SI and Constable): Assam GK', 'অসম আৰক্ষী (এছ.আই. আৰু কনিষ্টবল): অসমৰ সাধাৰণ জ্ঞান',
       'Assam GK for the Assam Police recruitment exams: the state, its government and courts, history, people and places.',
       'অসম আৰক্ষীৰ নিযুক্তি পৰীক্ষাৰ বাবে অসমৰ সাধাৰণ জ্ঞান: ৰাজ্য, চৰকাৰ আৰু ন্যায়ালয়, ইতিহাস, জনসাধাৰণ আৰু ঠাই।',
       'shield',
       array['assam-at-a-glance','state-symbols-of-assam','districts-of-assam-overview','formation-of-assam','ahom-kingdom',
             'assam-freedom-struggle','assam-movement-accord','governor-cm-ministers','assam-legislative-assembly',
             'gauhati-high-court','sixth-schedule-councils','communities-of-assam','languages-of-assam',
             'national-parks-of-assam','bihu','kanaklata-barua','gopinath-bordoloi','tezpur','sivasagar-monuments'])
    ) as t(pos, slug, title_en, title_as, desc_en, desc_as, icon, slugs)
  loop
    insert into public.courses (slug, position, title_en, title_as, description_en, description_as, icon, is_published)
    values (c.slug, c.pos, c.title_en, c.title_as, c.desc_en, c.desc_as, c.icon, true)
    on conflict (slug) do nothing;
    select id into cid from public.courses where slug = c.slug;
    slugs := c.slugs;
    for n in 1 .. array_length(slugs, 1) loop
      insert into public.course_items (course_id, position, content_id)
      select cid, n * 10, ct.id from public.content ct
      where ct.slug = slugs[n]
        and not exists (select 1 from public.course_items x where x.course_id = cid and x.content_id = ct.id);
      insert into public.course_items (course_id, position, set_id)
      select cid, n * 10 + 1 + (row_number() over (order by s.position, s.id))::int, s.id
      from public.question_sets s join public.content ct on ct.id = s.content_id
      where ct.slug = slugs[n] and s.is_published and s.kind <> 'daily'
        and not exists (select 1 from public.course_items x where x.course_id = cid and x.set_id = s.id);
    end loop;
  end loop;
end $$;
