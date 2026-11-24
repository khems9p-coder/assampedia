-- ASSAMPEDIA: publish Art, Culture and Heritage (both languages).
-- Run this ONLY after you have checked the drafts in Admin.
update public.content_versions set status = 'published', updated_at = now()
where content_id in (select id from public.content where slug in ($t$bihu$t$, $t$sattriya-and-sattra$t$, $t$folk-dances-and-music$t$, $t$silk-and-handloom$t$, $t$assamese-literature$t$));
