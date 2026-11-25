-- Mock tests that work like a real exam: marks for each right answer,
-- optional negative marking, the admin's own instructions, and a topic on
-- each question for the topic-wise analysis after the test.
-- Safe to run more than once.

alter table public.question_sets
  -- Marks for each right answer, e.g. 1 or 2.
  add column if not exists marks_per_question numeric(5, 2) not null default 1,
  -- Marks taken away for each wrong answer, e.g. 0.25. 0 means no negative marking.
  add column if not exists negative_marks numeric(5, 2) not null default 0,
  -- Extra instructions shown before the test starts (one per line).
  add column if not exists instructions_as text,
  add column if not exists instructions_en text,
  -- A short fixed name, e.g. 'assam-gk-mock-1'. Ready-made tests use it so
  -- they are never imported twice, and courses can point to a test by it.
  add column if not exists slug text;

alter table public.question_sets drop constraint if exists question_sets_marks_check;
alter table public.question_sets add constraint question_sets_marks_check
  check (marks_per_question > 0 and negative_marks >= 0 and negative_marks <= marks_per_question);

create unique index if not exists question_sets_slug_idx on public.question_sets (slug) where slug is not null;

-- The topic of a question (e.g. History, Polity), for the topic-wise analysis.
alter table public.questions
  add column if not exists topic_as text,
  add column if not exists topic_en text;

-- The app reads and writes these through the existing table grants.
grant select on public.question_sets, public.questions to anon, authenticated;
grant insert, update, delete on public.question_sets, public.questions to authenticated;
