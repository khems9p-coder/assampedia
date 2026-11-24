-- ASSAMPEDIA Phase 5: current affairs and government job vacancies.
-- Run once in SQL Editor (New query), on its own. Safe to run again.

-- Current affairs groups live in a fourth section, 'ca'.
alter table public.categories drop constraint if exists categories_section_check;
alter table public.categories
  add constraint categories_section_check check (section in ('gk', 'exam', 'job', 'ca'));

insert into public.categories (slug, section, position, icon, name_en, name_as, is_published) values
  ('ca-assam', 'ca', 1, 'account_balance', 'Assam Current Affairs', 'অসমৰ সাম্প্ৰতিক ঘটনা', true),
  ('ca-northeast', 'ca', 2, 'map', 'Northeast India Current Affairs', 'উত্তৰ-পূৰ্ব ভাৰতৰ সাম্প্ৰতিক ঘটনা', true),
  ('ca-national', 'ca', 3, 'flag', 'National Current Affairs', 'ৰাষ্ট্ৰীয় সাম্প্ৰতিক ঘটনা', true),
  ('ca-international', 'ca', 4, 'public', 'International Current Affairs', 'আন্তঃৰাষ্ট্ৰীয় সাম্প্ৰতিক ঘটনা', true)
on conflict (slug) do nothing;

-- The day a current-affairs item happened (used for daily/weekly/monthly views).
alter table public.content add column if not exists event_date date;
create index if not exists content_event_date_idx on public.content (kind, event_date desc);

-- ---------- Job vacancies ----------
-- Every vacancy must have an official notification link, a closing date and
-- the date someone last checked it against the official source.
create table if not exists public.vacancies (
  id uuid primary key default gen_random_uuid(),
  category text not null default 'assam'
    check (category in ('assam', 'northeast', 'other_state', 'central', 'police_defence', 'teaching',
                        'banking', 'railways', 'engineering', 'medical', 'administrative', 'other')),
  post_as text,
  post_en text,
  organisation_as text,
  organisation_en text,
  department_as text,
  department_en text,
  state text,                         -- e.g. Assam
  location text,
  vacancies_count int check (vacancies_count is null or vacancies_count >= 0),
  qualification_as text,
  qualification_en text,
  age_limit_as text,
  age_limit_en text,
  pay_as text,
  pay_en text,
  fee_as text,
  fee_en text,
  selection_as text,
  selection_en text,
  notes_as text,
  notes_en text,
  start_date date,
  closing_date date not null,
  stage text not null default 'notification'
    check (stage in ('notification', 'admit_card', 'exam_scheduled', 'result')),
  notification_url text not null check (notification_url ~ '^https?://'),
  apply_url text check (apply_url is null or apply_url ~ '^https?://'),
  syllabus_content_id uuid references public.content (id) on delete set null,
  last_verified date not null,
  is_published boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  check (coalesce(post_as, post_en) is not null),
  check (start_date is null or start_date <= closing_date)
);

create index if not exists vacancies_closing_idx on public.vacancies (closing_date);

alter table public.vacancies enable row level security;

drop policy if exists "read published vacancies" on public.vacancies;
create policy "read published vacancies" on public.vacancies
  for select using (is_published or (select public.is_admin()));
drop policy if exists "admins write vacancies" on public.vacancies;
create policy "admins write vacancies" on public.vacancies
  for all using ((select public.is_admin())) with check ((select public.is_admin()));

-- Newer Supabase projects need explicit access for the app.
grant select on public.vacancies to anon, authenticated;
grant insert, update, delete on public.vacancies to authenticated;
