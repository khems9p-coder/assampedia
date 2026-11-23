-- ASSAMPEDIA Phase 3: dictionary terms.
-- Run this once in Supabase SQL Editor (New query), on its own.

create table public.terms (
  id uuid primary key default gen_random_uuid(),
  slug text not null unique check (slug ~ '^[a-z0-9]+(-[a-z0-9]+)*$'),
  term_as text,
  term_en text,
  meaning_as text,
  meaning_en text,
  is_published boolean not null default true,
  updated_at timestamptz not null default now(),
  check (coalesce(term_as, term_en) is not null)
);

alter table public.terms enable row level security;

create policy "read published terms" on public.terms
  for select using (is_published or (select public.is_admin()));
create policy "admins write terms" on public.terms
  for all using ((select public.is_admin())) with check ((select public.is_admin()));

-- Faster "contains" search on chapter text and titles.
create extension if not exists pg_trgm with schema extensions;
create index content_blocks_body_trgm on public.content_blocks
  using gin (body extensions.gin_trgm_ops);
create index content_versions_title_trgm on public.content_versions
  using gin (title extensions.gin_trgm_ops);
