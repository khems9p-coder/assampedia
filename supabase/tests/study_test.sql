-- Study Material checks (run on a local copy after all migrations). Expected:
-- free reader: free section items all free; premium section items 1-3 free, 4 locked unless marked free;
-- locked video link hidden; draft sub-section hidden; free reader can open free files only;
-- a premium reader opens every file; a reader cannot write sections; a page marked free in a
-- study section becomes readable.
insert into auth.users (id, email) values
  ('11111111-1111-1111-1111-111111111111','admin@x'),
  ('22222222-2222-2222-2222-222222222222','free@x'),
  ('33333333-3333-3333-3333-333333333333','paid@x') on conflict do nothing;
insert into profiles (id, role) values ('11111111-1111-1111-1111-111111111111','admin')
  on conflict (id) do update set role = 'admin';
insert into premium_access (user_id, expires_at) values ('33333333-3333-3333-3333-333333333333', now() + interval '30 days')
  on conflict do nothing;
insert into categories (id, slug, name_as, name_en, is_published)
  values ('aaaaaaaa-0000-0000-0000-000000000009','grp9','গোট','Group',true);
insert into content (id, slug, category_id, position)
  select ('cccccccc-0000-0000-0000-00000000009' || n)::uuid, 'pg' || n, 'aaaaaaaa-0000-0000-0000-000000000009', n
  from generate_series(1,5) n;
insert into content_versions (content_id, lang, title, status)
  select id, 'en', slug, 'published' from content where slug like 'pg%';
insert into content_blocks (content_id, lang, block_key, position, body)
  select id, 'en', 'p1', 1, 'body of ' || slug from content where slug like 'pg%';

insert into study_sections (id, tier, title_en, is_published) values
  ('f0000000-0000-0000-0000-000000000001', 'free', 'Free stuff', true),
  ('f0000000-0000-0000-0000-000000000002', 'premium', 'Paid stuff', true);
insert into study_sections (id, parent_id, tier, title_en, is_published) values
  ('f0000000-0000-0000-0000-000000000003', 'f0000000-0000-0000-0000-000000000002', 'premium', 'Draft sub', false),
  ('f0000000-0000-0000-0000-000000000004', 'f0000000-0000-0000-0000-000000000003', 'premium', 'Under draft', true);
insert into study_items (section_id, position, item_type, title_en, file_path, video_url, content_id, is_free) values
  ('f0000000-0000-0000-0000-000000000001', 1, 'pdf', 'free1', 'free/a.pdf', null, null, false),
  ('f0000000-0000-0000-0000-000000000001', 2, 'pdf', 'free2', 'free/b.pdf', null, null, false),
  ('f0000000-0000-0000-0000-000000000001', 3, 'pdf', 'free3', 'free/c.pdf', null, null, false),
  ('f0000000-0000-0000-0000-000000000001', 4, 'pdf', 'free4', 'free/d.pdf', null, null, false),
  ('f0000000-0000-0000-0000-000000000002', 1, 'pdf', 'paid1', 'paid/a.pdf', null, null, false),
  ('f0000000-0000-0000-0000-000000000002', 2, 'image', 'paid2', 'paid/b.jpg', null, null, false),
  ('f0000000-0000-0000-0000-000000000002', 3, 'video', 'paid3', null, 'https://youtu.be/x3', null, false),
  ('f0000000-0000-0000-0000-000000000002', 4, 'video', 'paid4', null, 'https://youtu.be/x4', null, false),
  ('f0000000-0000-0000-0000-000000000002', 5, 'pdf', 'paid5', 'paid/e.pdf', null, null, false),
  ('f0000000-0000-0000-0000-000000000002', 6, 'pdf', 'paid6 marked free', 'paid/f.pdf', null, null, true),
  ('f0000000-0000-0000-0000-000000000002', 7, 'page', null, null, null, 'cccccccc-0000-0000-0000-000000000095', true);
grant select on storage.objects to anon, authenticated; -- as on Supabase
insert into storage.objects (bucket_id, name)
  select 'study', file_path from study_items where file_path is not null;

set role authenticated; set request.jwt.claim.sub = '22222222-2222-2222-2222-222222222222';
select 'free sections seen', string_agg(title_en, ',' order by title_en) from study_sections;
select 'free section', string_agg(title_en || ':' || is_free, ' ' order by item_position) from study_section_items('f0000000-0000-0000-0000-000000000001');
select 'paid section', string_agg(title_en || ':' || is_free || ':' || coalesce(video_url, '-'), ' ' order by item_position) from study_section_items('f0000000-0000-0000-0000-000000000002');
select 'free files', string_agg(name, ',' order by name) from storage.objects where bucket_id = 'study';
select 'pg5 readable', count(*) from content_blocks where body = 'body of pg5';
select 'pg4 readable', count(*) from content_blocks where body = 'body of pg4';
\set ON_ERROR_STOP 0
insert into study_sections (tier, title_en) values ('free', 'hack');
\set ON_ERROR_STOP 1
reset role;
set role authenticated; set request.jwt.claim.sub = '33333333-3333-3333-3333-333333333333';
select 'paid files', count(*) from storage.objects where bucket_id = 'study';
select 'paid video4', video_url from study_section_items('f0000000-0000-0000-0000-000000000002') where title_en = 'paid4';
reset role;

-- Course content: a published course's own section is visible; a draft course's is not.
insert into courses (id, slug, title_en, is_published) values
  ('eeeeeeee-0000-0000-0000-0000000000c1', 'pub-course', 'Pub', true),
  ('eeeeeeee-0000-0000-0000-0000000000c2', 'draft-course2', 'Draft', false);
insert into study_sections (id, course_id, tier, title_en, is_published) values
  ('f0000000-0000-0000-0000-0000000000c1', 'eeeeeeee-0000-0000-0000-0000000000c1', 'premium', 'Pub course content', true),
  ('f0000000-0000-0000-0000-0000000000c2', 'eeeeeeee-0000-0000-0000-0000000000c2', 'premium', 'Draft course content', true);
insert into study_sections (parent_id, tier, title_en, is_published) values
  ('f0000000-0000-0000-0000-0000000000c1', 'premium', 'Pub subject', true),
  ('f0000000-0000-0000-0000-0000000000c2', 'premium', 'Draft subject', true);
set role authenticated; set request.jwt.claim.sub = '22222222-2222-2222-2222-222222222222';
select 'course sections seen', string_agg(title_en, ',' order by title_en) from study_sections where title_en like '%course content' or title_en like '%subject';
reset role;
