-- ASSAMPEDIA: publish History of Assam (both languages).
-- Run this ONLY after you have checked the drafts in Admin.
update public.content_versions set status = 'published', updated_at = now()
where content_id in (select id from public.content where slug in ($t$ancient-assam-kamarupa$t$, $t$ahom-kingdom$t$, $t$koch-kingdom$t$, $t$mughal-invasions-saraighat$t$, $t$burmese-invasions-yandabo$t$, $t$assam-under-british-rule$t$, $t$assam-freedom-struggle$t$, $t$assam-movement-accord$t$));
