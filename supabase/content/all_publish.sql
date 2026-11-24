-- ASSAMPEDIA: publish ALL GK chapters (groups 1 to 12). Run only after checking every draft.
update public.content_versions set status = 'published', updated_at = now()
where content_id in (select id from public.content where slug in ($t$assam-at-a-glance$t$, $t$name-of-assam$t$, $t$state-symbols-of-assam$t$, $t$location-and-boundaries$t$, $t$formation-of-assam$t$));
update public.content_versions set status = 'published', updated_at = now()
where content_id in (select id from public.content where slug in ($t$ancient-assam-kamarupa$t$, $t$ahom-kingdom$t$, $t$koch-kingdom$t$, $t$mughal-invasions-saraighat$t$, $t$burmese-invasions-yandabo$t$, $t$assam-under-british-rule$t$, $t$assam-freedom-struggle$t$, $t$assam-movement-accord$t$));
update public.content_versions set status = 'published', updated_at = now()
where content_id in (select id from public.content where slug in ($t$physical-divisions-of-assam$t$, $t$brahmaputra-river-system$t$, $t$barak-river-system$t$, $t$climate-and-floods$t$, $t$soils-minerals-forests$t$));
update public.content_versions set status = 'published', updated_at = now()
where content_id in (select id from public.content where slug in ($t$bihu$t$, $t$sattriya-and-sattra$t$, $t$folk-dances-and-music$t$, $t$silk-and-handloom$t$, $t$assamese-literature$t$));
update public.content_versions set status = 'published', updated_at = now()
where content_id in (select id from public.content where slug in ($t$national-parks-of-assam$t$, $t$one-horned-rhinoceros$t$, $t$wildlife-sanctuaries-of-assam$t$, $t$reserves-and-wetlands$t$));
update public.content_versions set status = 'published', updated_at = now()
where content_id in (select id from public.content where slug in ($t$agriculture-and-crops$t$, $t$tea-industry$t$, $t$oil-and-natural-gas$t$, $t$industries-and-sericulture$t$));
update public.content_versions set status = 'published', updated_at = now()
where content_id in (select id from public.content where slug in ($t$governor-cm-ministers$t$, $t$assam-legislative-assembly$t$, $t$gauhati-high-court$t$, $t$sixth-schedule-councils$t$));
update public.content_versions set status = 'published', updated_at = now()
where content_id in (select id from public.content where slug in ($t$population-census-2011$t$, $t$communities-of-assam$t$, $t$languages-of-assam$t$, $t$education-institutions$t$));
update public.content_versions set status = 'published', updated_at = now()
where content_id in (select id from public.content where slug in ($t$srimanta-sankardev$t$, $t$lachit-borphukan$t$, $t$lakshminath-bezbaroa$t$, $t$jyoti-prasad-agarwala$t$, $t$gopinath-bordoloi$t$, $t$bhupen-hazarika$t$, $t$maniram-dewan$t$, $t$kanaklata-barua$t$));
update public.content_versions set status = 'published', updated_at = now()
where content_id in (select id from public.content where slug in ($t$major-bridges-of-assam$t$));
update public.content_versions set status = 'published', updated_at = now()
where content_id in (select id from public.content where slug in ($t$districts-of-assam-overview$t$));
update public.content_versions set status = 'published', updated_at = now()
where content_id in (select id from public.content where slug in ($t$kamakhya-temple$t$, $t$majuli$t$, $t$sivasagar-monuments$t$, $t$hajo$t$, $t$tezpur$t$));
