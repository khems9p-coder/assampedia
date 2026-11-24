-- ASSAMPEDIA: publish Wildlife and Environment (both languages).
-- Run this ONLY after you have checked the drafts in Admin.
update public.content_versions set status = 'published', updated_at = now()
where content_id in (select id from public.content where slug in ($t$national-parks-of-assam$t$, $t$one-horned-rhinoceros$t$, $t$wildlife-sanctuaries-of-assam$t$, $t$reserves-and-wetlands$t$));
