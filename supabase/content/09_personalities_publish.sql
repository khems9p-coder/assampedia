-- ASSAMPEDIA: publish Important Personalities (both languages).
-- Run this ONLY after you have checked the drafts in Admin.
update public.content_versions set status = 'published', updated_at = now()
where content_id in (select id from public.content where slug in ($t$srimanta-sankardev$t$, $t$lachit-borphukan$t$, $t$lakshminath-bezbaroa$t$, $t$jyoti-prasad-agarwala$t$, $t$gopinath-bordoloi$t$, $t$bhupen-hazarika$t$, $t$maniram-dewan$t$, $t$kanaklata-barua$t$));
