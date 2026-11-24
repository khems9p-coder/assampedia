-- Dictionary rule checks (run after rls_test.sql setup lines). Expected:
-- admin adds 2 terms; reader and anon see only the published one; reader cannot add.
grant select, insert, update, delete on all tables in schema public to anon, authenticated;
insert into auth.users (id, email) values ('11111111-1111-1111-1111-111111111111','admin@x'),('22222222-2222-2222-2222-222222222222','reader@x') on conflict do nothing;
update profiles set role='admin' where id='11111111-1111-1111-1111-111111111111';
set role authenticated; set request.jwt.claim.sub = '11111111-1111-1111-1111-111111111111';
insert into terms (slug, term_en, meaning_en) values ('shown-term','Shown','Visible'), ('hidden-term','Hidden','Draft');
update terms set is_published = false where slug = 'hidden-term';
select 'admin sees terms', count(*) from terms;
reset role;
set role authenticated; set request.jwt.claim.sub = '22222222-2222-2222-2222-222222222222';
select 'reader sees terms', string_agg(slug, ',') from terms;
insert into terms (slug, term_en) values ('reader-term','Nope');
