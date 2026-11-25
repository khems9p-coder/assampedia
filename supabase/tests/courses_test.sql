-- Course checks (run on a local copy after all migrations, then premium_test.sql's setup rows).
-- Expected: the free reader sees course lessons with the first 3 free; the course makes
-- page ch5 free (lesson 2), so the free reader can read 4 chapters' blocks (ch1-3 + ch5);
-- ch4 (lesson 5) stays locked; draft lessons are hidden; readers cannot write courses;
-- the starter courses exist but are empty here (none of their pages are in this test database).
insert into auth.users (id, email) values
  ('11111111-1111-1111-1111-111111111111','admin@x'),
  ('22222222-2222-2222-2222-222222222222','free@x') on conflict do nothing;
insert into profiles (id, role) values ('11111111-1111-1111-1111-111111111111','admin')
  on conflict (id) do update set role = 'admin';
insert into categories (id, slug, name_as, name_en, is_published)
  values ('aaaaaaaa-0000-0000-0000-000000000001','grp','গোট','Group',true) on conflict do nothing;
insert into content (id, slug, category_id, position)
  select ('cccccccc-0000-0000-0000-00000000000' || n)::uuid, 'ch' || n, 'aaaaaaaa-0000-0000-0000-000000000001', n
  from generate_series(1,6) n on conflict do nothing;
insert into content_versions (content_id, lang, title, status)
  select id, 'en', slug, case when slug = 'ch6' then 'draft' else 'published' end from content where slug like 'ch%'
  on conflict do nothing;
insert into content_blocks (content_id, lang, block_key, position, body)
  select id, 'en', 'p1', 1, 'body of ' || slug from content where slug like 'ch%' on conflict do nothing;
insert into question_sets (id, kind, title_en, position, is_published)
  select ('dddddddd-0000-0000-0000-00000000000' || n)::uuid, 'topic', 'quiz' || n, n, true from generate_series(1,4) n
  on conflict do nothing;

insert into courses (id, slug, title_en, is_published) values ('eeeeeeee-0000-0000-0000-000000000001', 'test-course', 'Test', true);
insert into course_items (course_id, position, content_id, set_id) values
  ('eeeeeeee-0000-0000-0000-000000000001', 1, 'cccccccc-0000-0000-0000-000000000006', null), -- draft page: hidden
  ('eeeeeeee-0000-0000-0000-000000000001', 2, 'cccccccc-0000-0000-0000-000000000001', null),
  ('eeeeeeee-0000-0000-0000-000000000001', 3, 'cccccccc-0000-0000-0000-000000000005', null),
  ('eeeeeeee-0000-0000-0000-000000000001', 4, null, 'dddddddd-0000-0000-0000-000000000004'),
  ('eeeeeeee-0000-0000-0000-000000000001', 5, 'cccccccc-0000-0000-0000-000000000004', null);
insert into courses (slug, title_en, is_published) values ('draft-course', 'Draft', false);

set role authenticated; set request.jwt.claim.sub = '22222222-2222-2222-2222-222222222222';
select 'courses seen', string_agg(slug, ',' order by slug) from courses;
select 'lessons', string_agg(lesson_no || ':' || kind || ':' || title_en || ':' || is_free, ' ' order by lesson_no)
  from course_lessons('eeeeeeee-0000-0000-0000-000000000001');
select 'free blocks', string_agg(body, ',' order by body) from content_blocks;
select 'quiz4 questions', count(*) from questions where set_id = 'dddddddd-0000-0000-0000-000000000004';
\set ON_ERROR_STOP 0
insert into courses (slug, title_en) values ('hack', 'Hack');
\set ON_ERROR_STOP 1
reset role;
set role anon;
select 'anon lessons', count(*) from course_lessons('eeeeeeee-0000-0000-0000-000000000001');
select 'anon draft course lessons', count(*) from course_lessons((select id from courses where slug = 'draft-course'));
reset role;
