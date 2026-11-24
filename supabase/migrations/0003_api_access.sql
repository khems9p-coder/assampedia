-- ASSAMPEDIA: let the app reach the tables.
-- Newer Supabase projects no longer open new tables to the app automatically,
-- so this grants access explicitly. The security rules (row level security)
-- still decide WHAT each person can read or change: readers only see
-- published content, and only admins can write.
-- Run this once in SQL Editor (New query), on its own. Safe to run again.

grant usage on schema public to anon, authenticated;

grant select on public.categories, public.content, public.content_versions,
  public.content_blocks, public.terms to anon, authenticated;

grant insert, update, delete on public.categories, public.content,
  public.content_versions, public.content_blocks, public.terms to authenticated;

grant select, update on public.profiles to authenticated;

grant execute on function public.is_admin() to anon, authenticated;
grant execute on function public.version_is_live(public.content_versions) to anon, authenticated;
