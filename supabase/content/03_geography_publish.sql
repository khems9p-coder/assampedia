-- ASSAMPEDIA: publish Geography of Assam (both languages).
-- Run this ONLY after you have checked the drafts in Admin.
update public.content_versions set status = 'published', updated_at = now()
where content_id in (select id from public.content where slug in ($t$physical-divisions-of-assam$t$, $t$brahmaputra-river-system$t$, $t$barak-river-system$t$, $t$climate-and-floods$t$, $t$soils-minerals-forests$t$));
