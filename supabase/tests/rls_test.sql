-- Security rule checks. Expected: admin sees 2 blocks; reader and anon see only English (published);
-- reader cannot make themselves admin; anon cannot insert content.
grant select, insert, update, delete on all tables in schema public to anon, authenticated;
insert into auth.users (id, email) values ('11111111-1111-1111-1111-111111111111','admin@x'),('22222222-2222-2222-2222-222222222222','reader@x');
update profiles set role='admin' where id='11111111-1111-1111-1111-111111111111';
-- admin writes a chapter with English published, Assamese draft
set role authenticated; set request.jwt.claim.sub = '11111111-1111-1111-1111-111111111111';
insert into content (id, slug, category_id) select 'aaaaaaaa-0000-0000-0000-000000000001','test-ch', id from categories where slug='history';
insert into content_versions values ('aaaaaaaa-0000-0000-0000-000000000001','en','Test EN',null,'published'),('aaaaaaaa-0000-0000-0000-000000000001','as','Test AS',null,'draft');
insert into content_blocks (content_id, lang, block_key, position, body) values ('aaaaaaaa-0000-0000-0000-000000000001','en','p1',1,'EN p1'),('aaaaaaaa-0000-0000-0000-000000000001','as','p1',1,'AS p1');
select 'admin sees blocks', count(*) from content_blocks;
reset role;
-- reader
set role authenticated; set request.jwt.claim.sub = '22222222-2222-2222-2222-222222222222';
select 'reader sees versions', string_agg(lang, ',') from content_versions;
select 'reader sees blocks', string_agg(lang, ',') from content_blocks;
select 'reader categories', count(*) from categories;
update profiles set role='admin' where id='22222222-2222-2222-2222-222222222222';
select 'reader self-promote blocked', role from profiles where id='22222222-2222-2222-2222-222222222222';
update profiles set preferred_lang='en' where id='22222222-2222-2222-2222-222222222222';
select 'reader lang change', preferred_lang from profiles;
reset role;
-- anonymous
set role anon; set request.jwt.claim.sub = '';
select 'anon sees blocks', string_agg(lang, ',') from content_blocks;
insert into content (slug) values ('hack');
