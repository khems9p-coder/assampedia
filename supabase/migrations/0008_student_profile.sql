-- Student profile: filled in once after the first sign-in, editable from the Me tab.
-- Readers can already read and update their own row (0001 policies, 0003 grants);
-- the protect_role trigger still stops them from changing their role.

alter table public.profiles add column if not exists full_name text
  check (full_name is null or char_length(full_name) between 1 and 80);
alter table public.profiles add column if not exists education text
  check (education is null or education in ('class10', 'class12', 'graduate', 'postgraduate', 'other'));
alter table public.profiles add column if not exists exams text[] not null default '{}'
  check (cardinality(exams) <= 20);
alter table public.profiles add column if not exists district text
  check (district is null or char_length(district) <= 60);
alter table public.profiles add column if not exists updated_at timestamptz not null default now();
