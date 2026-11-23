-- ASSAMPEDIA content database (Phase 2)
-- One content ID links the Assamese ('as') and English ('en') versions.
-- Paragraph keys are shared by both languages so switching keeps your place.

-- ---------- Users and roles ----------
create table public.profiles (
  id uuid primary key references auth.users (id) on delete cascade,
  display_name text,
  preferred_lang text not null default 'as' check (preferred_lang in ('as', 'en')),
  role text not null default 'reader' check (role in ('reader', 'admin')),
  created_at timestamptz not null default now()
);

-- Create a profile automatically when someone signs up.
create function public.handle_new_user()
returns trigger
language plpgsql
security definer set search_path = ''
as $$
begin
  insert into public.profiles (id, display_name)
  values (new.id, coalesce(new.raw_user_meta_data ->> 'full_name', new.email));
  return new;
end;
$$;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

-- True when the signed-in user is an admin.
create function public.is_admin()
returns boolean
language sql
stable
security definer set search_path = ''
as $$
  select exists (
    select 1 from public.profiles
    where id = (select auth.uid()) and role = 'admin'
  );
$$;

-- ---------- Categories (category > chapter group tree) ----------
create table public.categories (
  id uuid primary key default gen_random_uuid(),
  slug text not null unique,
  parent_id uuid references public.categories (id) on delete restrict,
  position int not null default 0,
  icon text,
  name_as text not null,
  name_en text not null,
  is_published boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- ---------- Content: one row per article, shared by both languages ----------
create table public.content (
  id uuid primary key default gen_random_uuid(),
  slug text not null unique,
  kind text not null default 'gk_chapter'
    check (kind in ('gk_chapter', 'district', 'personality', 'place', 'exam', 'job_profile', 'current_affairs')),
  category_id uuid references public.categories (id) on delete set null,
  position int not null default 0,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- One row per language per article. Each language is published on its own.
create table public.content_versions (
  content_id uuid not null references public.content (id) on delete cascade,
  lang text not null check (lang in ('as', 'en')),
  title text not null,
  summary text,
  status text not null default 'draft' check (status in ('draft', 'published')),
  publish_at timestamptz,            -- optional scheduled publishing
  sources text,                      -- references and source links
  last_checked date,                 -- when facts were last verified
  updated_at timestamptz not null default now(),
  primary key (content_id, lang)
);

-- Paragraphs and boxes. block_key (p1, p2, fact1...) is the same in both languages.
create table public.content_blocks (
  id uuid primary key default gen_random_uuid(),
  content_id uuid not null references public.content (id) on delete cascade,
  lang text not null check (lang in ('as', 'en')),
  block_key text not null,
  position int not null,
  block_type text not null default 'paragraph'
    check (block_type in ('heading', 'paragraph', 'fact_box', 'list', 'image')),
  style text not null default 'normal'
    check (style in ('normal', 'definition', 'verified_fact', 'event', 'personality', 'exam_fact', 'geography', 'heritage')),
  body text not null default '',
  image_url text,
  updated_at timestamptz not null default now(),
  unique (content_id, lang, block_key)
);

create index content_category_idx on public.content (category_id, position);
create index content_blocks_order_idx on public.content_blocks (content_id, lang, position);

-- A language version is visible to readers once published and its time has come.
create function public.version_is_live(v public.content_versions)
returns boolean
language sql
stable
as $$
  select v.status = 'published' and (v.publish_at is null or v.publish_at <= now());
$$;

-- ---------- Security: readers read published content; only admins write ----------
alter table public.profiles enable row level security;
alter table public.categories enable row level security;
alter table public.content enable row level security;
alter table public.content_versions enable row level security;
alter table public.content_blocks enable row level security;

create policy "read own profile" on public.profiles
  for select using ((select auth.uid()) = id or (select public.is_admin()));
create policy "update own profile" on public.profiles
  for update using ((select auth.uid()) = id)
  with check ((select auth.uid()) = id);

-- Only an admin can change anyone's role (readers cannot make themselves admin).
create function public.protect_role()
returns trigger
language plpgsql
security definer set search_path = ''
as $$
begin
  -- Requests with no signed-in user (the Supabase SQL editor) may set roles,
  -- which is how you make yourself the first admin.
  if new.role is distinct from old.role
     and (select auth.uid()) is not null
     and not public.is_admin() then
    raise exception 'Only an admin can change roles';
  end if;
  return new;
end;
$$;

create trigger profiles_protect_role
  before update on public.profiles
  for each row execute function public.protect_role();

create policy "read published categories" on public.categories
  for select using (is_published or (select public.is_admin()));
create policy "admins write categories" on public.categories
  for all using ((select public.is_admin())) with check ((select public.is_admin()));

create policy "read content" on public.content
  for select using (true);
create policy "admins write content" on public.content
  for all using ((select public.is_admin())) with check ((select public.is_admin()));

create policy "read live versions" on public.content_versions
  for select using (public.version_is_live(content_versions) or (select public.is_admin()));
create policy "admins write versions" on public.content_versions
  for all using ((select public.is_admin())) with check ((select public.is_admin()));

create policy "read live blocks" on public.content_blocks
  for select using (
    (select public.is_admin()) or exists (
      select 1 from public.content_versions v
      where v.content_id = content_blocks.content_id
        and v.lang = content_blocks.lang
        and public.version_is_live(v)
    )
  );
create policy "admins write blocks" on public.content_blocks
  for all using ((select public.is_admin())) with check ((select public.is_admin()));

-- ---------- Storage bucket for images and maps ----------
insert into storage.buckets (id, name, public) values ('media', 'media', true)
  on conflict (id) do nothing;
create policy "admins upload media" on storage.objects
  for insert with check (bucket_id = 'media' and (select public.is_admin()));
create policy "admins change media" on storage.objects
  for update using (bucket_id = 'media' and (select public.is_admin()));
create policy "admins delete media" on storage.objects
  for delete using (bucket_id = 'media' and (select public.is_admin()));

-- ---------- Starting categories (names only; chapters are added by the admin) ----------
insert into public.categories (slug, position, icon, name_en, name_as, is_published) values
  ('introduction', 1, 'map', 'Introduction to Assam', 'অসমৰ পৰিচয়', true),
  ('history', 2, 'history', 'History of Assam', 'অসমৰ ইতিহাস', true),
  ('geography', 3, 'terrain', 'Geography of Assam', 'অসমৰ ভূগোল', true),
  ('culture', 4, 'theater', 'Art, Culture and Heritage', 'কলা, সংস্কৃতি আৰু ঐতিহ্য', true),
  ('wildlife', 5, 'pets', 'Wildlife and Environment', 'বন্যপ্ৰাণী আৰু পৰিৱেশ', true),
  ('economy', 6, 'payments', 'Economy of Assam', 'অসমৰ অৰ্থনীতি', true),
  ('polity', 7, 'account_balance', 'Polity and Administration', 'ৰাজনীতি আৰু প্ৰশাসন', true),
  ('society', 8, 'groups', 'Society and Demography', 'সমাজ আৰু জনগাঁথনি', true),
  ('personalities', 9, 'person', 'Important Personalities', 'বিশিষ্ট ব্যক্তিসকল', true),
  ('development', 10, 'trending_up', 'Assam Current Development', 'অসমৰ সাম্প্ৰতিক উন্নয়ন', true),
  ('districts', 11, 'location_city', 'District-wise Assam GK', 'জিলাভিত্তিক অসমৰ সাধাৰণ জ্ঞান', true),
  ('places', 12, 'place', 'Important Places and Tourism', 'গুৰুত্বপূৰ্ণ স্থান আৰু পৰ্যটন', true);
