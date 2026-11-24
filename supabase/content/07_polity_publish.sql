-- ASSAMPEDIA: publish Polity and Administration (both languages).
-- Run this ONLY after you have checked the drafts in Admin.
update public.content_versions set status = 'published', updated_at = now()
where content_id in (select id from public.content where slug in ($t$governor-cm-ministers$t$, $t$assam-legislative-assembly$t$, $t$gauhati-high-court$t$, $t$sixth-schedule-councils$t$));
