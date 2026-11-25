-- Course content: each course can have its own sections, subjects and topics
-- (study sections linked to the course) with PDFs, pictures, videos, note
-- pages and quizzes uploaded straight into them from Admin > Courses.
-- These sections show inside the course, not in Study > Free or Premium.
-- Safe to run more than once. Needs 0010_courses.sql and 0012_study_material.sql first.

alter table public.study_sections
  add column if not exists course_id uuid references public.courses (id) on delete cascade;

create index if not exists study_sections_course_idx on public.study_sections (course_id);

-- A course's own content is visible only while the course is published.
create or replace function public.study_section_visible(sid uuid)
returns boolean
language sql
stable
security definer set search_path = ''
as $$
  with recursive up as (
    select id, parent_id, is_published, course_id, 1 as depth from public.study_sections where id = sid
    union all
    select s.id, s.parent_id, s.is_published, s.course_id, up.depth + 1
    from public.study_sections s join up on s.id = up.parent_id
    where up.depth < 50
  )
  select exists (select 1 from up)
     and not exists (select 1 from up where not is_published)
     and not exists (
       select 1 from up join public.courses c on c.id = up.course_id where not c.is_published
     );
$$;
