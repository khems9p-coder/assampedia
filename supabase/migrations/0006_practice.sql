-- Phase 6: Practice Zone (question sets and multiple-choice questions).
-- Every question is written by an admin from checked sources; the app never
-- makes up questions or answers. Scores are kept on the reader's phone.

create table if not exists public.question_sets (
  id uuid primary key default gen_random_uuid(),
  kind text not null default 'topic'
    check (kind in ('chapter', 'topic', 'district', 'assam_gk', 'history', 'geography',
                    'current_affairs', 'pyq', 'mock', 'daily', 'revision')),
  level text not null default 'beginner'
    check (level in ('beginner', 'intermediate', 'advanced', 'competitive')),
  title_as text,
  title_en text,
  description_as text,
  description_en text,
  -- Optional: the encyclopedia chapter this quiz is about ("Read the chapter").
  content_id uuid references public.content (id) on delete set null,
  -- Mock tests can have a time limit; practice quizzes leave it empty.
  time_limit_minutes int check (time_limit_minutes is null or time_limit_minutes between 1 and 300),
  position int not null default 0,
  is_published boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  check (coalesce(title_as, title_en) is not null)
);

create table if not exists public.questions (
  id uuid primary key default gen_random_uuid(),
  set_id uuid not null references public.question_sets (id) on delete cascade,
  position int not null default 0,
  question_as text,
  question_en text,
  options_as text[],
  options_en text[],
  -- Which option is right, counting from 0. The same for both languages.
  correct_index int not null check (correct_index >= 0),
  explanation_as text,
  explanation_en text,
  background_as text,
  background_en text,
  relevance_as text,
  relevance_en text,
  -- Where the question comes from, e.g. a previous-year paper and year.
  source text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  check (coalesce(question_as, question_en) is not null),
  check (question_as is null or (cardinality(options_as) between 2 and 6 and correct_index < cardinality(options_as))),
  check (question_en is null or (cardinality(options_en) between 2 and 6 and correct_index < cardinality(options_en))),
  check (options_as is null or options_en is null or cardinality(options_as) = cardinality(options_en))
);

create index if not exists questions_set_idx on public.questions (set_id, position);

alter table public.question_sets enable row level security;
alter table public.questions enable row level security;

drop policy if exists "read published sets" on public.question_sets;
create policy "read published sets" on public.question_sets
  for select using (is_published or (select public.is_admin()));
drop policy if exists "admins write sets" on public.question_sets;
create policy "admins write sets" on public.question_sets
  for all using ((select public.is_admin())) with check ((select public.is_admin()));

-- Readers see the questions of published sets only.
drop policy if exists "read questions of published sets" on public.questions;
create policy "read questions of published sets" on public.questions
  for select using (
    (select public.is_admin())
    or exists (select 1 from public.question_sets s where s.id = set_id and s.is_published)
  );
drop policy if exists "admins write questions" on public.questions;
create policy "admins write questions" on public.questions
  for all using ((select public.is_admin())) with check ((select public.is_admin()));

-- Newer Supabase projects need explicit access for the app.
grant select on public.question_sets, public.questions to anon, authenticated;
grant insert, update, delete on public.question_sets, public.questions to authenticated;
