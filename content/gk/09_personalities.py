"""Group 9: Important Personalities (বিশিষ্ট ব্যক্তিসকল).

Block format: (block_key, block_type, style, body). Keys must match in both languages.
"""

CATEGORY_SLUG = "personalities"
CATEGORY_NAME = "Important Personalities"
LAST_CHECKED = "2026-11-24"

EXISTING_TERMS = {"borphukan", "ankiya-naat", "borgeet", "sattra", "neo-vaishnavism", "jonaki-era",
                  "quit-india-movement", "mrityu-bahini", "dewan", "cabinet-mission"}

W = "https://en.wikipedia.org/wiki/"

TERMS = [
    dict(slug="maidam", en="Maidam", **{"as": "মৈদাম"},
         meaning_en="A burial mound of the Ahom royals and nobles. The Charaideo Maidams are the best known.",
         meaning_as="আহোম ৰজা আৰু বিষয়াসকলৰ সমাধিস্থল। চৰাইদেউৰ মৈদামসমূহ আটাইতকৈ জনাজাত।"),
    dict(slug="rasaraj", en="Rasaraj", **{"as": "ৰসৰাজ"},
         meaning_en="'King of humour', the title given to Lakshminath Bezbaroa.",
         meaning_as="'হাস্যৰসৰ ৰজা', লক্ষ্মীনাথ বেজবৰুৱাক দিয়া উপাধি।"),
    dict(slug="rupkonwar", en="Rupkonwar", **{"as": "ৰূপকোঁৱৰ"},
         meaning_en="'Prince of beauty', the title by which Jyoti Prasad Agarwala is known.",
         meaning_as="'সৌন্দৰ্যৰ কোঁৱৰ', জ্যোতিপ্ৰসাদ আগৰৱালাক জনা উপাধি।"),
    dict(slug="shilpi-divas", en="Shilpi Divas", **{"as": "শিল্পী দিৱস"},
         meaning_en="Artists' Day, observed in Assam on 17 January, the death anniversary of Jyoti Prasad Agarwala.",
         meaning_as="জ্যোতিপ্ৰসাদ আগৰৱালাৰ মৃত্যু দিৱস ১৭ জানুৱাৰীত অসমত পালন কৰা শিল্পী দিৱস।"),
    dict(slug="sudhakantha", en="Sudhakantha", **{"as": "সুধাকণ্ঠ"},
         meaning_en="'Nectar-voiced', the title by which Bhupen Hazarika is known.",
         meaning_as="'অমৃতকণ্ঠ', ড° ভূপেন হাজৰিকাক জনা উপাধি।"),
    dict(slug="bharat-ratna", en="Bharat Ratna", **{"as": "ভাৰতৰত্ন"},
         meaning_en="India's highest civilian award.",
         meaning_as="ভাৰতৰ সৰ্বোচ্চ অসামৰিক সন্মান।"),
    dict(slug="dadasaheb-phalke-award", en="Dadasaheb Phalke Award", **{"as": "দাদাচাহেব ফাল্কে বঁটা"},
         meaning_en="India's highest award in cinema.",
         meaning_as="চলচ্চিত্ৰৰ ক্ষেত্ৰত ভাৰতৰ সৰ্বোচ্চ বঁটা।"),
    dict(slug="lachit-divas", en="Lachit Divas", **{"as": "লাচিত দিৱস"},
         meaning_en="24 November, the birth anniversary of Lachit Borphukan, celebrated in Assam.",
         meaning_as="লাচিত বৰফুকনৰ জন্মদিন ২৪ নৱেম্বৰ, যিটো অসমত পালন কৰা হয়।"),
]


def person(slug, pos, name, summary, sources, en, as_):
    return dict(slug=slug, position=pos, title=name, summary=summary, sources=sources, blocks={"en": en, "as": as_})


CHAPTERS = [
    person("srimanta-sankardev", 1,
           {"en": "Srimanta Sankardev", "as": "শ্ৰীমন্ত শংকৰদেৱ"},
           {"en": "Saint, poet, playwright and social reformer who founded Neo-Vaishnavism in Assam.",
            "as": "অসমত নৱ-বৈষ্ণৱ ধৰ্ম প্ৰৱৰ্তন কৰা সন্ত, কবি, নাট্যকাৰ আৰু সমাজ সংস্কাৰক।"},
           f"Sankardev, Wikipedia: {W}Sankardev",
           [
               ("p1", "paragraph", "personality",
                "Srimanta Sankardev was a saint, poet, playwright, musician and social reformer. He was born at Bordowa in present-day Nagaon district. "
                "By tradition he was born in 1449; some historians suggest a later year. He died in 1568 at Bheladonga, in present-day Cooch Behar."),
               ("p2", "paragraph", "normal",
                "He founded {{term:neo-vaishnavism|Ekasarana Dharma (Neo-Vaishnavism)}}, which teaches devotion to one God through prayer and singing. "
                "He set up the {{term:sattra|Sattra}} and namghar system."),
               ("l1", "list", "heritage",
                "Greatest work: Kirtan Ghosha\nOther works: Gunamala, Rukmini Haran, Parijat Haran, Keli Gopal\n"
                "Created: {{term:borgeet|Borgeet}}, {{term:ankiya-naat|Ankiya Naat}} and Sattriya dance\n"
                "His play Chihna Yatra is one of the earliest open-air performances; its text is lost"),
               ("p3", "paragraph", "normal",
                "At Dhuwahat in Majuli he met Madhavdev, who became his chief disciple. Later he lived in the Koch kingdom under King Nara Narayan."),
               ("exam1", "fact_box", "exam_fact",
                "Remember for exams: born at Bordowa (Nagaon); greatest work Kirtan Ghosha; chief disciple Madhavdev."),
           ],
           [
               ("p1", "paragraph", "personality",
                "শ্ৰীমন্ত শংকৰদেৱ আছিল এগৰাকী সন্ত, কবি, নাট্যকাৰ, সংগীতজ্ঞ আৰু সমাজ সংস্কাৰক। তেওঁৰ জন্ম বৰ্তমানৰ নগাঁও জিলাৰ বৰদোৱাত। "
                "পৰম্পৰা অনুসৰি তেওঁৰ জন্ম ১৪৪৯ চনত; কিছুমান ইতিহাসবিদে পিছৰ বছৰৰ কথা কয়। ১৫৬৮ চনত বৰ্তমানৰ কোচবিহাৰৰ ভেলাদুঙাত তেওঁৰ মৃত্যু হয়।"),
               ("p2", "paragraph", "normal",
                "তেওঁ {{term:neo-vaishnavism|একশৰণ নামধৰ্ম (নৱ-বৈষ্ণৱ ধৰ্ম)}} প্ৰৱৰ্তন কৰে, যিয়ে নাম-প্ৰাৰ্থনাৰ জৰিয়তে এক ঈশ্বৰৰ ভক্তি শিকায়। "
                "তেওঁ {{term:sattra|সত্ৰ}} আৰু নামঘৰৰ ব্যৱস্থা গঢ়ি তোলে।"),
               ("l1", "list", "heritage",
                "শ্ৰেষ্ঠ গ্ৰন্থ: কীৰ্তন ঘোষা\nআন গ্ৰন্থ: গুণমালা, ৰুক্মিণী হৰণ, পাৰিজাত হৰণ, কেলি গোপাল\n"
                "সৃষ্টি: {{term:borgeet|বৰগীত}}, {{term:ankiya-naat|অংকীয়া নাট}} আৰু সত্ৰীয়া নৃত্য\n"
                "তেওঁৰ 'চিহ্নযাত্ৰা' আটাইতকৈ পুৰণি মুকলি মঞ্চৰ পৰিৱেশনসমূহৰ এটা; ইয়াৰ পাঠ পোৱা নাযায়"),
               ("p3", "paragraph", "normal",
                "মাজুলীৰ ধুৱাহাটত তেওঁ মাধৱদেৱক লগ পায়, যিজন তেওঁৰ প্ৰধান শিষ্য হয়। পিছলৈ তেওঁ ৰজা নৰনাৰায়ণৰ কোচ ৰাজ্যত বাস কৰে।"),
               ("exam1", "fact_box", "exam_fact",
                "পৰীক্ষাৰ বাবে মনত ৰাখক: জন্ম বৰদোৱাত (নগাঁও); শ্ৰেষ্ঠ গ্ৰন্থ কীৰ্তন ঘোষা; প্ৰধান শিষ্য মাধৱদেৱ।"),
           ]),
    person("lachit-borphukan", 2,
           {"en": "Lachit Borphukan", "as": "লাচিত বৰফুকন"},
           {"en": "The Ahom general who defeated the Mughals at Saraighat in 1671.",
            "as": "১৬৭১ চনত শৰাইঘাটত মোগলক পৰাস্ত কৰা আহোম সেনাপতি।"},
           f"Lachit Borphukan, Wikipedia: {W}Lachit_Borphukan",
           [
               ("p1", "paragraph", "personality",
                "Lachit Borphukan was born on 24 November 1622. His father was Momai Tamuli Borbarua, a senior Ahom officer. "
                "As {{term:borphukan|Borphukan}}, Lachit was the commander of the Ahom army in the west."),
               ("p2", "paragraph", "event",
                "In 1671 he led the Ahoms to a famous naval victory over the Mughal army of Ram Singh I in the Battle of Saraighat, "
                "even though he was ill at the time."),
               ("p3", "paragraph", "normal",
                "He died in April 1672. His {{term:maidam}} is at Holongapar, near Teok in Jorhat district."),
               ("p4", "paragraph", "normal",
                "His birthday, 24 November, is celebrated in Assam as {{term:lachit-divas|Lachit Divas}}. "
                "The best passing-out cadet of the National Defence Academy receives a gold medal named after him."),
               ("exam1", "fact_box", "exam_fact",
                "Remember for exams: born 24 November 1622; Saraighat 1671; Lachit Divas 24 November."),
           ],
           [
               ("p1", "paragraph", "personality",
                "লাচিত বৰফুকনৰ জন্ম ১৬২২ চনৰ ২৪ নৱেম্বৰত। তেওঁৰ পিতৃ মোমাই তামুলী বৰবৰুৱা আছিল এগৰাকী জ্যেষ্ঠ আহোম বিষয়া। "
                "{{term:borphukan|বৰফুকন}} হিচাপে লাচিত পশ্চিমত আহোম সেনাৰ সেনাপতি আছিল।"),
               ("p2", "paragraph", "event",
                "১৬৭১ চনত শৰাইঘাটৰ যুদ্ধত তেওঁ অসুস্থ হৈ থকা অৱস্থাতো আহোম সেনাক নেতৃত্ব দি ৰামসিংহৰ মোগল বাহিনীৰ বিৰুদ্ধে "
                "এক বিখ্যাত নৌ-যুদ্ধত জয়লাভ কৰে।"),
               ("p3", "paragraph", "normal",
                "১৬৭২ চনৰ এপ্ৰিলত তেওঁৰ মৃত্যু হয়। তেওঁৰ {{term:maidam|মৈদাম}} যোৰহাট জিলাৰ টিয়কৰ ওচৰৰ হোলোঙাপাৰত আছে।"),
               ("p4", "paragraph", "normal",
                "তেওঁৰ জন্মদিন ২৪ নৱেম্বৰ অসমত {{term:lachit-divas|লাচিত দিৱস}} হিচাপে পালন কৰা হয়। "
                "ৰাষ্ট্ৰীয় প্ৰতিৰক্ষা অকাডেমীৰ শ্ৰেষ্ঠ কেডেটক তেওঁৰ নামত এটা সোণৰ পদক দিয়া হয়।"),
               ("exam1", "fact_box", "exam_fact",
                "পৰীক্ষাৰ বাবে মনত ৰাখক: জন্ম ২৪ নৱেম্বৰ ১৬২২; শৰাইঘাট ১৬৭১; লাচিত দিৱস ২৪ নৱেম্বৰ।"),
           ]),
    person("lakshminath-bezbaroa", 3,
           {"en": "Lakshminath Bezbaroa", "as": "লক্ষ্মীনাথ বেজবৰুৱা"},
           {"en": "The father of the Assamese short story and writer of the state song.",
            "as": "অসমীয়া চুটিগল্পৰ জনক আৰু ৰাজ্যিক সংগীতৰ ৰচয়িতা।"},
           f"Lakshminath Bezbaroa, Wikipedia: {W}Lakshminath_Bezbaroa",
           [
               ("p1", "paragraph", "personality",
                "Lakshminath Bezbaroa (14 October 1864 to 26 March 1938) was one of the greatest writers of Assamese literature. "
                "He was a leading figure of the {{term:jonaki-era|Jonaki era}} and brought the short story into Assamese."),
               ("l1", "list", "heritage",
                "Wrote the state song 'O Mur Apunar Desh', published in his collection Kodomkoli (1913)\n"
                "Pen name: Kripabar Barbarua, used for his humorous writings\n"
                "Collected folk tales in Burhi Aair Sadhu\n"
                "President of the Asam Sahitya Sabha in 1924"),
               ("p2", "paragraph", "normal",
                "He was given the titles {{term:rasaraj|Rasaraj}} (king of humour) and Sahityarathi (charioteer of literature). He died in Dibrugarh."),
               ("exam1", "fact_box", "exam_fact",
                "Remember for exams: writer of 'O Mur Apunar Desh'; pen name Kripabar Barbarua; titles Rasaraj and Sahityarathi."),
           ],
           [
               ("p1", "paragraph", "personality",
                "লক্ষ্মীনাথ বেজবৰুৱা (১৪ অক্টোবৰ ১৮৬৪ ৰ পৰা ২৬ মাৰ্চ ১৯৩৮) অসমীয়া সাহিত্যৰ অন্যতম শ্ৰেষ্ঠ সাহিত্যিক। "
                "তেওঁ {{term:jonaki-era|জোনাকী যুগৰ}} এগৰাকী অগ্ৰণী ব্যক্তি আছিল আৰু অসমীয়া সাহিত্যত চুটিগল্পৰ প্ৰৱৰ্তন কৰে।"),
               ("l1", "list", "heritage",
                "ৰাজ্যিক সংগীত 'অ' মোৰ আপোনাৰ দেশ' ৰচনা কৰে, যিটো তেওঁৰ 'কদমকলি' (১৯১৩) সংকলনত প্ৰকাশ পায়\n"
                "ছদ্মনাম: কৃপাবৰ বৰবৰুৱা, হাস্যৰসাত্মক লেখাৰ বাবে ব্যৱহাৰ কৰে\n"
                "'বুঢ়ী আইৰ সাধু'ত সাধুকথা সংকলন কৰে\n"
                "১৯২৪ চনত অসম সাহিত্য সভাৰ সভাপতি"),
               ("p2", "paragraph", "normal",
                "তেওঁক {{term:rasaraj|ৰসৰাজ}} আৰু সাহিত্যৰথী উপাধি দিয়া হৈছিল। ডিব্ৰুগড়ত তেওঁৰ মৃত্যু হয়।"),
               ("exam1", "fact_box", "exam_fact",
                "পৰীক্ষাৰ বাবে মনত ৰাখক: 'অ' মোৰ আপোনাৰ দেশ'ৰ ৰচয়িতা; ছদ্মনাম কৃপাবৰ বৰবৰুৱা; উপাধি ৰসৰাজ আৰু সাহিত্যৰথী।"),
           ]),
    person("jyoti-prasad-agarwala", 4,
           {"en": "Jyoti Prasad Agarwala", "as": "জ্যোতিপ্ৰসাদ আগৰৱালা"},
           {"en": "Rupkonwar, maker of the first Assamese film Joymoti.",
            "as": "প্ৰথম অসমীয়া চলচ্চিত্ৰ জয়মতীৰ নিৰ্মাতা ৰূপকোঁৱৰ।"},
           f"Jyoti Prasad Agarwala, Wikipedia: {W}Jyoti_Prasad_Agarwala",
           [
               ("p1", "paragraph", "personality",
                "Jyoti Prasad Agarwala (17 June 1903 to 17 January 1951) was a playwright, poet, composer and filmmaker. "
                "He is known as the {{term:rupkonwar|Rupkonwar}} of Assamese culture."),
               ("p2", "paragraph", "event",
                "In 1935 he made Joymoti, the first Assamese film, based on a play by Lakshminath Bezbaroa. He is called the founder of Assamese cinema."),
               ("l1", "list", "heritage",
                "Plays: Sonit Konwari (1925), Karengar Ligiri (1930), Rupalim, Lobhita\nFilms: Joymoti (1935), Indramalati (1939)"),
               ("p3", "paragraph", "normal",
                "He was jailed for fifteen months in 1932 for joining the freedom struggle, and went underground during the "
                "{{term:quit-india-movement|Quit India Movement}}. He discovered the young Bhupen Hazarika in Tezpur."),
               ("p4", "paragraph", "normal",
                "He died in Tezpur. His death anniversary, 17 January, is observed as {{term:shilpi-divas|Shilpi Divas}} (Artists' Day)."),
               ("exam1", "fact_box", "exam_fact",
                "Remember for exams: first Assamese film Joymoti (1935); Shilpi Divas 17 January."),
           ],
           [
               ("p1", "paragraph", "personality",
                "জ্যোতিপ্ৰসাদ আগৰৱালা (১৭ জুন ১৯০৩ ৰ পৰা ১৭ জানুৱাৰী ১৯৫১) আছিল নাট্যকাৰ, কবি, সুৰকাৰ আৰু চলচ্চিত্ৰ নিৰ্মাতা। "
                "তেওঁ অসমীয়া সংস্কৃতিৰ {{term:rupkonwar|ৰূপকোঁৱৰ}} হিচাপে জনাজাত।"),
               ("p2", "paragraph", "event",
                "১৯৩৫ চনত তেওঁ লক্ষ্মীনাথ বেজবৰুৱাৰ নাটকৰ আধাৰত প্ৰথম অসমীয়া চলচ্চিত্ৰ 'জয়মতী' নিৰ্মাণ কৰে। তেওঁক অসমীয়া চলচ্চিত্ৰৰ জনক বুলি কোৱা হয়।"),
               ("l1", "list", "heritage",
                "নাটক: শোণিত কুঁৱৰী (১৯২৫), কাৰেঙৰ লিগিৰী (১৯৩০), ৰূপালীম, লভিতা\nচলচ্চিত্ৰ: জয়মতী (১৯৩৫), ইন্দ্ৰমালতী (১৯৩৯)"),
               ("p3", "paragraph", "normal",
                "স্বাধীনতা সংগ্ৰামত যোগ দিয়াৰ বাবে ১৯৩২ চনত তেওঁ পোন্ধৰ মাহ কাৰাবাস খাটে, আৰু "
                "{{term:quit-india-movement|ভাৰত ত্যাগ আন্দোলনৰ}} সময়ত আত্মগোপন কৰে। তেজপুৰত তেওঁ কিশোৰ ভূপেন হাজৰিকাক আৱিষ্কাৰ কৰে।"),
               ("p4", "paragraph", "normal",
                "তেজপুৰত তেওঁৰ মৃত্যু হয়। তেওঁৰ মৃত্যু দিৱস ১৭ জানুৱাৰী {{term:shilpi-divas|শিল্পী দিৱস}} হিচাপে পালন কৰা হয়।"),
               ("exam1", "fact_box", "exam_fact",
                "পৰীক্ষাৰ বাবে মনত ৰাখক: প্ৰথম অসমীয়া চলচ্চিত্ৰ জয়মতী (১৯৩৫); শিল্পী দিৱস ১৭ জানুৱাৰী।"),
           ]),
    person("gopinath-bordoloi", 5,
           {"en": "Gopinath Bordoloi", "as": "গোপীনাথ বৰদলৈ"},
           {"en": "The first Chief Minister of Assam, who helped keep Assam in India.",
            "as": "অসমক ভাৰতত ৰখাত সহায় কৰা অসমৰ প্ৰথম মুখ্যমন্ত্ৰী।"},
           "\n".join([f"Gopinath Bordoloi, Wikipedia: {W}Gopinath_Bordoloi", "TO VERIFY before publishing: the title Lokapriya in p4."]),
           [
               ("p1", "paragraph", "personality",
                "Gopinath Bordoloi was born on 6 June 1890 at Raha in Nagaon district and died on 5 August 1950 in Guwahati."),
               ("p2", "paragraph", "normal",
                "He became Premier of Assam in 1938 and was the first Chief Minister of Assam, from 11 February 1946 until his death."),
               ("p3", "paragraph", "event",
                "In 1946 the {{term:cabinet-mission|Cabinet Mission}} plan put Assam in a group with Bengal. Under Bordoloi, the Assam Congress opposed "
                "this grouping, which helped Assam remain part of India."),
               ("p4", "paragraph", "normal",
                "He was awarded the Bharat Ratna after his death, in 1999. He is remembered as Lokapriya (beloved of the people)."),
               ("exam1", "fact_box", "exam_fact",
                "Remember for exams: first Chief Minister of Assam; opposed the Grouping plan (1946); Bharat Ratna 1999."),
           ],
           [
               ("p1", "paragraph", "personality",
                "গোপীনাথ বৰদলৈৰ জন্ম ১৮৯০ চনৰ ৬ জুনত নগাঁও জিলাৰ ৰহাত আৰু মৃত্যু ১৯৫০ চনৰ ৫ আগষ্টত গুৱাহাটীত।"),
               ("p2", "paragraph", "normal",
                "১৯৩৮ চনত তেওঁ অসমৰ প্ৰধানমন্ত্ৰী হয় আৰু ১৯৪৬ চনৰ ১১ ফেব্ৰুৱাৰীৰ পৰা মৃত্যুলৈকে অসমৰ প্ৰথম মুখ্যমন্ত্ৰী আছিল।"),
               ("p3", "paragraph", "event",
                "১৯৪৬ চনত {{term:cabinet-mission|কেবিনেট মিছনৰ}} পৰিকল্পনাত অসমক বংগৰ সৈতে একেটা গোটত ৰখা হৈছিল। বৰদলৈৰ নেতৃত্বত অসম কংগ্ৰেছে "
                "এই গোটকৰণৰ বিৰোধিতা কৰে, যাৰ ফলত অসম ভাৰতৰ অংশ হৈ থাকিল।"),
               ("p4", "paragraph", "normal",
                "মৃত্যুৰ পিছত ১৯৯৯ চনত তেওঁক ভাৰতৰত্ন প্ৰদান কৰা হয়। তেওঁক লোকপ্ৰিয় বুলি সোঁৱৰা হয়।"),
               ("exam1", "fact_box", "exam_fact",
                "পৰীক্ষাৰ বাবে মনত ৰাখক: অসমৰ প্ৰথম মুখ্যমন্ত্ৰী; গোটকৰণ পৰিকল্পনাৰ বিৰোধিতা (১৯৪৬); ভাৰতৰত্ন ১৯৯৯।"),
           ]),
    person("bhupen-hazarika", 6,
           {"en": "Bhupen Hazarika", "as": "ড° ভূপেন হাজৰিকা"},
           {"en": "Sudhakantha, the bard of the Brahmaputra and Bharat Ratna awardee.",
            "as": "সুধাকণ্ঠ, ব্ৰহ্মপুত্ৰৰ কবি আৰু ভাৰতৰত্ন বঁটা প্ৰাপক।"},
           f"Bhupen Hazarika, Wikipedia: {W}Bhupen_Hazarika",
           [
               ("p1", "paragraph", "personality",
                "Bhupen Hazarika was born on 8 September 1926 at Sadiya and died on 5 November 2011 in Mumbai. He was a singer, composer, poet and filmmaker, "
                "known as {{term:sudhakantha|Sudhakantha}} and the bard of the Brahmaputra."),
               ("p2", "paragraph", "normal",
                "He earned a PhD from Columbia University, New York, in 1952. His famous songs include 'Bistirno Parore' and 'Manuhe Manuhor Babe'."),
               ("l1", "list", "verified_fact",
                "Sangeet Natak Akademi Award: 1987\n{{term:dadasaheb-phalke-award|Dadasaheb Phalke Award}}: 1992\n"
                "Padma Vibhushan: 2012 (after his death)\n{{term:bharat-ratna|Bharat Ratna}}: 2019 (after his death)"),
               ("p3", "paragraph", "normal",
                "His film Shakuntala (1961) won the National Award for the best Assamese film. The Dhola-Sadiya bridge over the Lohit is named after him."),
               ("exam1", "fact_box", "exam_fact",
                "Remember for exams: born at Sadiya; Dadasaheb Phalke 1992; Bharat Ratna 2019; Dhola-Sadiya bridge named after him."),
           ],
           [
               ("p1", "paragraph", "personality",
                "ভূপেন হাজৰিকাৰ জন্ম ১৯২৬ চনৰ ৮ ছেপ্টেম্বৰত শদিয়াত আৰু মৃত্যু ২০১১ চনৰ ৫ নৱেম্বৰত মুম্বাইত। তেওঁ আছিল গায়ক, সুৰকাৰ, কবি আৰু চলচ্চিত্ৰ নিৰ্মাতা, "
                "{{term:sudhakantha|সুধাকণ্ঠ}} আৰু ব্ৰহ্মপুত্ৰৰ কবি হিচাপে জনাজাত।"),
               ("p2", "paragraph", "normal",
                "১৯৫২ চনত তেওঁ নিউয়ৰ্কৰ কলম্বিয়া বিশ্ববিদ্যালয়ৰ পৰা পি এইচ ডি লাভ কৰে। তেওঁৰ বিখ্যাত গীতৰ ভিতৰত আছে 'বিস্তীৰ্ণ পাৰৰে' আৰু 'মানুহে মানুহৰ বাবে'।"),
               ("l1", "list", "verified_fact",
                "সংগীত নাটক অকাডেমী বঁটা: ১৯৮৭\n{{term:dadasaheb-phalke-award|দাদাচাহেব ফাল্কে বঁটা}}: ১৯৯২\n"
                "পদ্মবিভূষণ: ২০১২ (মৃত্যুৰ পিছত)\n{{term:bharat-ratna|ভাৰতৰত্ন}}: ২০১৯ (মৃত্যুৰ পিছত)"),
               ("p3", "paragraph", "normal",
                "তেওঁৰ চলচ্চিত্ৰ 'শকুন্তলা' (১৯৬১)ই শ্ৰেষ্ঠ অসমীয়া চলচ্চিত্ৰৰ ৰাষ্ট্ৰীয় বঁটা লাভ কৰে। লুইতৰ ওপৰৰ ঢোলা-শদিয়া দলং তেওঁৰ নামেৰে নামকৰণ কৰা হৈছে।"),
               ("exam1", "fact_box", "exam_fact",
                "পৰীক্ষাৰ বাবে মনত ৰাখক: জন্ম শদিয়াত; দাদাচাহেব ফাল্কে ১৯৯২; ভাৰতৰত্ন ২০১৯; ঢোলা-শদিয়া দলং তেওঁৰ নামত।"),
           ]),
    person("maniram-dewan", 7,
           {"en": "Maniram Dewan", "as": "মণিৰাম দেৱান"},
           {"en": "Tea pioneer and martyr of 1857 in Assam.",
            "as": "চাহ উদ্যোগৰ অগ্ৰদূত আৰু অসমত ১৮৫৭ চনৰ শ্বহীদ।"},
           "\n".join([f"Maniram Dewan, Wikipedia: {W}Maniram_Dewan", f"Assam tea, Wikipedia: {W}Assam_tea", "TO VERIFY before publishing: his full name Maniram Dutta Barua (p1)."]),
           [
               ("p1", "paragraph", "personality",
                "Maniram Dutta Barua, known as Maniram Dewan, was a nobleman who first worked with the British and later turned against them."),
               ("p2", "paragraph", "normal",
                "He guided Robert Bruce to the Singpho chief Bessa Gam, which led to the discovery of Assam tea. In 1839 he became the {{term:dewan|Dewan}} "
                "of the Assam Tea Company at Nazira. He later started his own garden at Cinnamara, becoming the first Indian to grow tea commercially in Assam."),
               ("p3", "paragraph", "event",
                "During the revolt of 1857 he planned a rising to bring back Ahom rule. The plot was discovered, and he was hanged at Jorhat jail on "
                "26 February 1858, along with Piyali Barua."),
               ("exam1", "fact_box", "exam_fact",
                "Remember for exams: first Indian tea planter in Assam; hanged at Jorhat on 26 February 1858 with Piyali Barua."),
           ],
           [
               ("p1", "paragraph", "personality",
                "মণিৰাম দত্ত বৰুৱা, যাক মণিৰাম দেৱান বুলি জনা যায়, এগৰাকী অভিজাত ব্যক্তি আছিল, যিয়ে প্ৰথমে ব্ৰিটিছৰ সৈতে কাম কৰিছিল আৰু পিছত তেওঁলোকৰ বিৰোধী হৈ পৰে।"),
               ("p2", "paragraph", "normal",
                "তেওঁ ৰবাৰ্ট ব্ৰুছক চিংফৌ মুখিয়াল বিছা গামৰ ওচৰলৈ লৈ যায়, যাৰ ফলত অসমৰ চাহ আৱিষ্কাৰ হয়। ১৮৩৯ চনত তেওঁ নাজিৰাৰ আসাম টি কোম্পানীৰ "
                "{{term:dewan|দেৱান}} হয়। পিছত চিনামৰাত নিজৰ বাগিচা আৰম্ভ কৰি তেওঁ অসমত বাণিজ্যিকভাৱে চাহ খেতি কৰা প্ৰথম ভাৰতীয় হয়।"),
               ("p3", "paragraph", "event",
                "১৮৫৭ চনৰ বিদ্ৰোহৰ সময়ত তেওঁ আহোম শাসন ঘূৰাই আনিবলৈ বিদ্ৰোহৰ পৰিকল্পনা কৰে। ষড়যন্ত্ৰ ধৰা পৰে আৰু ১৮৫৮ চনৰ ২৬ ফেব্ৰুৱাৰীত "
                "পিয়লি বৰুৱাৰ সৈতে যোৰহাট কাৰাগাৰত তেওঁক ফাঁচি দিয়া হয়।"),
               ("exam1", "fact_box", "exam_fact",
                "পৰীক্ষাৰ বাবে মনত ৰাখক: অসমৰ প্ৰথম ভাৰতীয় চাহ খেতিয়ক; ২৬ ফেব্ৰুৱাৰী ১৮৫৮ত পিয়লি বৰুৱাৰ সৈতে যোৰহাটত ফাঁচি।"),
           ]),
    person("kanaklata-barua", 8,
           {"en": "Kanaklata Barua", "as": "কনকলতা বৰুৱা"},
           {"en": "The 17-year-old martyr of Gohpur in the Quit India Movement.",
            "as": "ভাৰত ত্যাগ আন্দোলনত গহপুৰৰ ১৭ বছৰীয়া শ্বহীদ।"},
           "\n".join([f"Kanaklata Barua, Wikipedia: {W}Kanaklata_Barua", "TO VERIFY before publishing: 'towards the Gohpur police station' (p2) and the name Birbala (p3)."]),
           [
               ("p1", "paragraph", "personality",
                "Kanaklata Barua was born on 22 December 1924 at Borangabari, Gohpur, in the old Darrang district."),
               ("p2", "paragraph", "event",
                "During the {{term:quit-india-movement|Quit India Movement}} she joined the {{term:mrityu-bahini|Mrityu Bahini}}. On 20 September 1942 she "
                "led a procession carrying the national flag towards the Gohpur police station and was shot dead by the police. She was 17 years old."),
               ("p3", "paragraph", "normal",
                "She is remembered as one of the youngest martyrs of India's freedom struggle, and is also called Birbala."),
               ("exam1", "fact_box", "exam_fact",
                "Remember for exams: martyred at Gohpur on 20 September 1942, aged 17; member of the Mrityu Bahini."),
           ],
           [
               ("p1", "paragraph", "personality",
                "কনকলতা বৰুৱাৰ জন্ম ১৯২৪ চনৰ ২২ ডিচেম্বৰত পুৰণি দৰং জিলাৰ গহপুৰৰ বৰঙাবাৰীত।"),
               ("p2", "paragraph", "event",
                "{{term:quit-india-movement|ভাৰত ত্যাগ আন্দোলনৰ}} সময়ত তেওঁ {{term:mrityu-bahini|মৃত্যু বাহিনীত}} যোগ দিয়ে। ১৯৪২ চনৰ ২০ ছেপ্টেম্বৰত তেওঁ "
                "ৰাষ্ট্ৰীয় পতাকা লৈ গহপুৰ থানালৈ এক শোভাযাত্ৰাৰ নেতৃত্ব দিয়ে আৰু আৰক্ষীৰ গুলীত শ্বহীদ হয়। তেতিয়া তেওঁৰ বয়স আছিল ১৭ বছৰ।"),
               ("p3", "paragraph", "normal",
                "ভাৰতৰ স্বাধীনতা সংগ্ৰামৰ আটাইতকৈ কম বয়সীয়া শ্বহীদসকলৰ এগৰাকী হিচাপে তেওঁক সোঁৱৰা হয়, আৰু তেওঁক বীৰবালা বুলিও কোৱা হয়।"),
               ("exam1", "fact_box", "exam_fact",
                "পৰীক্ষাৰ বাবে মনত ৰাখক: ২০ ছেপ্টেম্বৰ ১৯৪২ত গহপুৰত ১৭ বছৰ বয়সত শ্বহীদ; মৃত্যু বাহিনীৰ সদস্য।"),
           ]),
]
