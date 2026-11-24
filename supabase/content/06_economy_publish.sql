-- ASSAMPEDIA: publish Economy of Assam (both languages).
-- Run this ONLY after you have checked the drafts in Admin.
update public.content_versions set status = 'published', updated_at = now()
where content_id in (select id from public.content where slug in ($t$agriculture-and-crops$t$, $t$tea-industry$t$, $t$oil-and-natural-gas$t$, $t$industries-and-sericulture$t$));
