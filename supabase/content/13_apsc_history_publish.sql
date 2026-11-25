-- ASSAMPEDIA: publish Assam Government Examinations (both languages).
-- Run this ONLY after you have checked the drafts in Admin.
update public.content_versions set status = 'published', updated_at = now()
where content_id in (select id from public.content where slug in ($t$apsc-cce-history-overview$t$, $t$apsc-cce-prelims-history$t$, $t$apsc-cce-mains-gs1-history$t$, $t$apsc-cce-mains-assam-history$t$));
