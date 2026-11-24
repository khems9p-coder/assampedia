-- ASSAMPEDIA Phase 4: exam syllabus library and government career profiles.
-- Run once in SQL Editor (New query), on its own. Safe to run again.

-- Which tab a category belongs to: GK encyclopedia, Exams, or Careers.
alter table public.categories
  add column if not exists section text not null default 'gk';
alter table public.categories drop constraint if exists categories_section_check;
alter table public.categories
  add constraint categories_section_check check (section in ('gk', 'exam', 'job'));

-- Official links and the version/date the information applies to.
alter table public.content add column if not exists official_url text;
alter table public.content add column if not exists notification_url text;
alter table public.content add column if not exists applies_to text; -- e.g. "Syllabus 2025" or "Pay scale as of 1 April 2025"

-- New box style for suggested preparation tips (clearly not official).
alter table public.content_blocks drop constraint if exists content_blocks_style_check;
alter table public.content_blocks add constraint content_blocks_style_check
  check (style in ('normal', 'definition', 'verified_fact', 'event', 'personality',
                   'exam_fact', 'geography', 'heritage', 'suggested'));

-- Starting groups (names only; each exam or career page is added by the admin).
insert into public.categories (slug, section, position, icon, name_en, name_as, is_published) values
  ('exams-assam', 'exam', 1, 'account_balance', 'Assam Government Examinations', 'অসম চৰকাৰৰ পৰীক্ষা', true),
  ('exams-northeast', 'exam', 2, 'map', 'Northeast State Examinations', 'উত্তৰ-পূৰ্বাঞ্চলৰ ৰাজ্যিক পৰীক্ষা', true),
  ('exams-other-states', 'exam', 3, 'location_city', 'Other State Examinations', 'অন্যান্য ৰাজ্যৰ পৰীক্ষা', true),
  ('exams-national', 'exam', 4, 'flag', 'National-Level Examinations', 'ৰাষ্ট্ৰীয় পৰ্যায়ৰ পৰীক্ষা', true),
  ('careers-administrative', 'job', 1, 'gavel', 'Administrative Services', 'প্ৰশাসনিক সেৱা', true),
  ('careers-police', 'job', 2, 'shield', 'Police and Security', 'আৰক্ষী আৰু সুৰক্ষা', true),
  ('careers-other', 'job', 3, 'work', 'Other Government Services', 'অন্যান্য চৰকাৰী সেৱা', true)
on conflict (slug) do nothing;
