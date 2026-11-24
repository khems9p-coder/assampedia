-- ASSAMPEDIA: publish Introduction to Assam (both languages).
-- Run this ONLY after you have checked the drafts in Admin.
update public.content_versions set status = 'published', updated_at = now()
where content_id in (select id from public.content where slug in ($t$assam-at-a-glance$t$, $t$name-of-assam$t$, $t$state-symbols-of-assam$t$, $t$location-and-boundaries$t$, $t$formation-of-assam$t$));
