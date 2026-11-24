-- Run after the migrations (pgtest.sh). Checks the security question functions.
insert into auth.users (id, email, encrypted_password) values ('22222222-2222-2222-2222-222222222222', 'Student@Example.in', 'old');
set request.jwt.claim.sub = '22222222-2222-2222-2222-222222222222';
set role authenticated;
select public.set_security_question('school', '  Don   Bosco ');
select public.my_security_question() as mine;
-- Students cannot read the answers table.
do $$ begin perform * from public.security_answers; raise exception 'should not read'; exception when insufficient_privilege then null; end $$;
reset role;
set request.jwt.claim.sub = '';
set role anon;
select public.security_question_for('student@example.in') as q;
select public.reset_password_with_answer('student@example.in', 'wrong', 'Assam@2026') as r1;
select public.reset_password_with_answer('student@example.in', 'don bosco', 'weakpass') as r2;
select public.reset_password_with_answer('student@example.in', 'DON BOSCO', 'Assam@2026') as r3;
reset role;
select encrypted_password = extensions.crypt('Assam@2026', encrypted_password) as new_password_works from auth.users where email = 'Student@Example.in';
set role anon;
select public.reset_password_with_answer('student@example.in', 'x', 'Assam@2026') from generate_series(1, 5);
select public.reset_password_with_answer('student@example.in', 'don bosco', 'Assam@2027') as after_lock;
