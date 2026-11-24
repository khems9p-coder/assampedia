-- Security question: each student picks one question and an answer.
-- It lets a student set a new password without an email code
-- ("Forgot password?" in the app). Answers are stored only as a one-way hash.

create extension if not exists pgcrypto with schema extensions;

create table if not exists public.security_answers (
  user_id uuid primary key references auth.users (id) on delete cascade,
  question text not null check (question in ('school', 'teacher', 'friend', 'birthplace', 'food')),
  answer_hash text not null,
  failed_attempts int not null default 0,
  locked_until timestamptz,
  updated_at timestamptz not null default now()
);

-- Nobody reads or writes this table directly; only the functions below do.
alter table public.security_answers enable row level security;
revoke all on public.security_answers from anon, authenticated;

-- Answers are compared in lower case with spaces tidied, so "Don Bosco" = "don  bosco ".
create or replace function public.normalize_answer(a text)
returns text
language sql
immutable
set search_path = ''
as $$ select regexp_replace(lower(trim(coalesce(a, ''))), '\s+', ' ', 'g') $$;

-- The signed-in student sets (or changes) their question and answer.
create or replace function public.set_security_question(q text, answer text)
returns void
language plpgsql
security definer set search_path = ''
as $$
declare
  a text := public.normalize_answer(answer);
begin
  if (select auth.uid()) is null then
    raise exception 'Please sign in first';
  end if;
  if char_length(a) < 2 then
    raise exception 'The answer is too short';
  end if;
  insert into public.security_answers (user_id, question, answer_hash)
  values ((select auth.uid()), q, extensions.crypt(a, extensions.gen_salt('bf')))
  on conflict (user_id) do update
    set question = excluded.question, answer_hash = excluded.answer_hash,
        failed_attempts = 0, locked_until = null, updated_at = now();
end;
$$;

-- Which question the signed-in student chose (null if none yet).
create or replace function public.my_security_question()
returns text
language sql
stable
security definer set search_path = ''
as $$ select question from public.security_answers where user_id = (select auth.uid()) $$;

-- The question for an email address, shown on "Forgot password?".
create or replace function public.security_question_for(email text)
returns text
language sql
stable
security definer set search_path = ''
as $$
  select s.question
  from auth.users u join public.security_answers s on s.user_id = u.id
  where lower(u.email) = lower(trim(security_question_for.email))
$$;

-- Sets a new password when the answer is right.
-- Returns 'ok', 'wrong', 'locked' (5 wrong answers: wait 1 hour), 'weak' or 'none'.
create or replace function public.reset_password_with_answer(email text, answer text, new_password text)
returns text
language plpgsql
security definer set search_path = ''
as $$
declare
  uid uuid;
  rec public.security_answers;
begin
  select u.id into uid from auth.users u where lower(u.email) = lower(trim(reset_password_with_answer.email));
  if uid is null then
    return 'none';
  end if;
  select * into rec from public.security_answers where user_id = uid for update;
  if not found then
    return 'none';
  end if;
  if rec.locked_until is not null and rec.locked_until > now() then
    return 'locked';
  end if;
  if rec.answer_hash <> extensions.crypt(public.normalize_answer(answer), rec.answer_hash) then
    update public.security_answers
      set failed_attempts = case when rec.failed_attempts + 1 >= 5 then 0 else rec.failed_attempts + 1 end,
          locked_until = case when rec.failed_attempts + 1 >= 5 then now() + interval '1 hour' else null end
      where user_id = uid;
    return case when rec.failed_attempts + 1 >= 5 then 'locked' else 'wrong' end;
  end if;
  -- Same rule as the app: 8+ characters with letters, numbers and a special character.
  if char_length(new_password) < 8 or new_password !~ '[A-Za-z]' or new_password !~ '[0-9]'
     or new_password !~ '[^A-Za-z0-9]' then
    return 'weak';
  end if;
  update auth.users
    set encrypted_password = extensions.crypt(new_password, extensions.gen_salt('bf')), updated_at = now()
    where id = uid;
  update public.security_answers set failed_attempts = 0, locked_until = null where user_id = uid;
  return 'ok';
end;
$$;

revoke all on function public.set_security_question(text, text) from public;
revoke all on function public.my_security_question() from public;
revoke all on function public.security_question_for(text) from public;
revoke all on function public.reset_password_with_answer(text, text, text) from public;
grant execute on function public.set_security_question(text, text) to authenticated;
grant execute on function public.my_security_question() to authenticated;
grant execute on function public.security_question_for(text) to anon, authenticated;
grant execute on function public.reset_password_with_answer(text, text, text) to anon, authenticated;
