-- Premium lock checks (run on a local copy after all migrations). Expected:
-- free reader and anon read blocks of chapters 1-3 only; premium reader reads all 5;
-- expired premium is back to 3; quizzes: 3 of 4 topic quizzes free, daily always free;
-- question_count is visible for locked quizzes; a reader cannot give themselves Premium.
insert into auth.users (id, email) values
  ('11111111-1111-1111-1111-111111111111','admin@x'),
  ('22222222-2222-2222-2222-222222222222','free@x'),
  ('33333333-3333-3333-3333-333333333333','paid@x') on conflict do nothing;
insert into profiles (id, role) values ('11111111-1111-1111-1111-111111111111','admin')
  on conflict (id) do update set role = 'admin';
insert into categories (id, slug, name_as, name_en, is_published)
  values ('aaaaaaaa-0000-0000-0000-000000000001','grp','গোট','Group',true);
insert into content (id, slug, category_id, position)
  select ('cccccccc-0000-0000-0000-00000000000' || n)::uuid, 'ch' || n, 'aaaaaaaa-0000-0000-0000-000000000001', n
  from generate_series(1,5) n;
insert into content_versions (content_id, lang, title, status)
  select id, 'en', slug, 'published' from content where slug like 'ch%';
insert into content_blocks (content_id, lang, block_key, position, body)
  select id, 'en', 'p1', 1, 'body of ' || slug from content where slug like 'ch%';
insert into premium_access (user_id, expires_at) values ('33333333-3333-3333-3333-333333333333', now() + interval '30 days');

insert into question_sets (id, kind, title_en, position, is_published)
  select ('dddddddd-0000-0000-0000-00000000000' || n)::uuid, 'topic', 'quiz' || n, n, true from generate_series(1,4) n;
insert into question_sets (id, kind, title_en, position, is_published)
  values ('dddddddd-0000-0000-0000-000000000009', 'daily', 'daily', 9, true);
insert into questions (set_id, question_en, options_en, correct_index)
  select id, 'Q ' || title_en, array['a','b'], 0 from question_sets;

set role anon;
select 'anon blocks', string_agg(body, ',' order by body) from content_blocks;
reset role;
set role authenticated; set request.jwt.claim.sub = '22222222-2222-2222-2222-222222222222';
select 'free blocks', count(*) from content_blocks;
select 'free titles', count(*) from content_versions;
select 'free questions', string_agg(question_en, ',' order by question_en) from questions;
select 'counts visible', string_agg(question_count::text, ',') from question_sets;
select 'free has premium', public.has_premium();
reset role;
set role authenticated; set request.jwt.claim.sub = '33333333-3333-3333-3333-333333333333';
select 'paid blocks', count(*) from content_blocks;
select 'paid questions', count(*) from questions;
select 'paid has premium', public.has_premium();
reset role;
update premium_access set expires_at = now() - interval '1 day';
set role authenticated; set request.jwt.claim.sub = '33333333-3333-3333-3333-333333333333';
select 'expired blocks', count(*) from content_blocks;
reset role;
set role authenticated; set request.jwt.claim.sub = '22222222-2222-2222-2222-222222222222';
\set ON_ERROR_STOP 0
insert into premium_access (user_id, expires_at) values ('22222222-2222-2222-2222-222222222222', now() + interval '1 year');
reset role;
