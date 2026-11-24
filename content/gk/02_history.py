"""Group 2: History of Assam (অসমৰ ইতিহাস).

Block format: (block_key, block_type, style, body). Keys must match in both languages.
"""

CATEGORY_SLUG = "history"
CATEGORY_NAME = "History of Assam"
LAST_CHECKED = "2026-11-24"

# Terms already added by group 1 that these chapters reuse.
EXISTING_TERMS = {"ahom", "treaty-of-yandabo", "kamarupa", "pragjyotisha", "referendum"}

W = "https://en.wikipedia.org/wiki/"

TERMS = [
    dict(slug="dynasty", en="Dynasty", **{"as": "ৰাজবংশ"},
         meaning_en="A line of rulers from the same family, where power passes from one generation to the next.",
         meaning_as="একেটা পৰিয়ালৰ শাসকসকলৰ ধাৰা, য'ত ক্ষমতা এক প্ৰজন্মৰ পৰা আন প্ৰজন্মলৈ যায়।"),
    dict(slug="allahabad-pillar-inscription", en="Allahabad Pillar Inscription", **{"as": "এলাহাবাদ স্তম্ভলিপি"},
         meaning_en="A 4th-century inscription praising the Gupta emperor Samudragupta. It is the first record to name Kamarupa.",
         meaning_as="গুপ্ত সম্ৰাট সমুদ্ৰগুপ্তৰ প্ৰশংসা কৰা চতুৰ্থ শতিকাৰ শিলালিপি। ইয়াতেই প্ৰথমবাৰৰ বাবে কামৰূপৰ নাম পোৱা যায়।"),
    dict(slug="xuanzang", en="Xuanzang (Hiuen Tsang)", **{"as": "হিউৱেন চাং"},
         meaning_en="A Chinese Buddhist monk and traveller of the 7th century who visited India and wrote about Kamarupa.",
         meaning_as="সপ্তম শতিকাৰ এগৰাকী চীনা বৌদ্ধ ভিক্ষু আৰু পৰিব্ৰাজক, যিয়ে ভাৰত ভ্ৰমণ কৰি কামৰূপৰ বিষয়ে লিখি গৈছিল।"),
    dict(slug="swargadeo", en="Swargadeo", **{"as": "স্বৰ্গদেউ"},
         meaning_en="The title of the Ahom kings, meaning 'lord of heaven'. It was first taken by Suhungmung.",
         meaning_as="আহোম ৰজাসকলৰ উপাধি, যাৰ অৰ্থ 'স্বৰ্গৰ দেৱতা'। চুহুংমুঙে প্ৰথমে এই উপাধি গ্ৰহণ কৰিছিল।"),
    dict(slug="paik-system", en="Paik system", **{"as": "পাইক প্ৰথা"},
         meaning_en="The Ahom system in which adult men (paiks) gave labour or military service to the state in turn, in return for land.",
         meaning_as="আহোম যুগৰ ব্যৱস্থা, য'ত প্ৰাপ্তবয়স্ক পুৰুষসকলে (পাইক) মাটিৰ বিনিময়ত পাল পাতি ৰাজ্যক শ্ৰম বা সামৰিক সেৱা আগবঢ়াইছিল।"),
    dict(slug="borphukan", en="Borphukan", **{"as": "বৰফুকন"},
         meaning_en="A high Ahom office: the governor of Lower Assam and commander in the west, based in Guwahati.",
         meaning_as="আহোম ৰাজ্যৰ এক উচ্চ পদ: গুৱাহাটীত থাকি নামনি অসম শাসন কৰা আৰু পশ্চিমৰ সেনাপতি।"),
    dict(slug="moamoria-rebellion", en="Moamoria rebellion", **{"as": "মোৱামৰীয়া বিদ্ৰোহ"},
         meaning_en="A long uprising against the Ahom kings that began in 1769. It badly weakened the kingdom.",
         meaning_as="১৭৬৯ চনত আৰম্ভ হোৱা আহোম ৰজাসকলৰ বিৰুদ্ধে এক দীঘলীয়া বিদ্ৰোহ। ই ৰাজ্যখনক বহুত দুৰ্বল কৰি পেলাইছিল।"),
    dict(slug="neo-vaishnavism", en="Neo-Vaishnavism (Ekasarana Dharma)", **{"as": "নৱ-বৈষ্ণৱ ধৰ্ম (একশৰণ নামধৰ্ম)"},
         meaning_en="The devotional faith founded by Srimanta Sankardev, centred on prayer to one god (Krishna) through singing his name.",
         meaning_as="শ্ৰীমন্ত শংকৰদেৱে প্ৰতিষ্ঠা কৰা ভক্তিধৰ্ম, য'ত নাম-কীৰ্তনৰ জৰিয়তে এক ঈশ্বৰ (কৃষ্ণ)ৰ শৰণ লোৱা হয়।"),
    dict(slug="mughal", en="Mughals", **{"as": "মোগল"},
         meaning_en="The empire that ruled most of North India from Delhi and Agra from the 16th to the 18th century.",
         meaning_as="ষোড়শৰ পৰা অষ্টাদশ শতিকালৈ দিল্লী আৰু আগ্ৰাৰ পৰা উত্তৰ ভাৰতৰ বেছিভাগ অঞ্চল শাসন কৰা সাম্ৰাজ্য।"),
    dict(slug="maan", en="Maan (Burmese)", **{"as": "মান"},
         meaning_en="The Assamese name for the Burmese, who invaded Assam three times between 1817 and 1826.",
         meaning_as="বৰ্মীসকলৰ অসমীয়া নাম। তেওঁলোকে ১৮১৭ ৰ পৰা ১৮২৬ চনৰ ভিতৰত তিনিবাৰ অসম আক্ৰমণ কৰিছিল।"),
    dict(slug="dewan", en="Dewan", **{"as": "দেৱান"},
         meaning_en="A chief officer or manager. Maniram Dewan got this title as an officer of the Assam Tea Company.",
         meaning_as="মুখ্য বিষয়া বা পৰিচালক। আসাম টি কোম্পানীৰ বিষয়া হিচাপে মণিৰামে এই উপাধি পাইছিল।"),
    dict(slug="quit-india-movement", en="Quit India Movement", **{"as": "ভাৰত ত্যাগ আন্দোলন"},
         meaning_en="The 1942 movement led by Mahatma Gandhi demanding that the British leave India at once.",
         meaning_as="ব্ৰিটিছক তৎক্ষণাত ভাৰত এৰি যাবলৈ দাবী জনাই মহাত্মা গান্ধীৰ নেতৃত্বত ১৯৪২ চনত হোৱা আন্দোলন।"),
    dict(slug="mrityu-bahini", en="Mrityu Bahini", **{"as": "মৃত্যু বাহিনী"},
         meaning_en="A 'death squad' of young volunteers from Gohpur who were ready to die for freedom during the Quit India Movement.",
         meaning_as="ভাৰত ত্যাগ আন্দোলনৰ সময়ত স্বাধীনতাৰ বাবে প্ৰাণ দিবলৈ সাজু থকা গহপুৰৰ যুৱ স্বেচ্ছাসেৱকৰ দল।"),
    dict(slug="cabinet-mission", en="Cabinet Mission (1946)", **{"as": "কেবিনেট মিছন (১৯৪৬)"},
         meaning_en="A team of British ministers sent to India in 1946 to plan the transfer of power. Its plan grouped Assam with Bengal.",
         meaning_as="ক্ষমতা হস্তান্তৰৰ পৰিকল্পনা কৰিবলৈ ১৯৪৬ চনত ভাৰতলৈ পঠোৱা ব্ৰিটিছ মন্ত্ৰীৰ দল। ইয়াৰ পৰিকল্পনাত অসমক বংগৰ সৈতে একেটা গোটত ৰখা হৈছিল।"),
    dict(slug="assam-accord", en="Assam Accord", **{"as": "অসম চুক্তি"},
         meaning_en="The agreement signed on 15 August 1985 between the Government of India and the leaders of the Assam Movement.",
         meaning_as="১৯৮৫ চনৰ ১৫ আগষ্টত ভাৰত চৰকাৰ আৰু অসম আন্দোলনৰ নেতাসকলৰ মাজত স্বাক্ষৰিত চুক্তি।"),
    dict(slug="aasu", en="AASU", **{"as": "আছু"},
         meaning_en="All Assam Students' Union, the students' body that led the Assam Movement.",
         meaning_as="সদৌ অসম ছাত্ৰ সন্থা, যিয়ে অসম আন্দোলনৰ নেতৃত্ব দিছিল।"),
    dict(slug="cut-off-date", en="Cut-off date", **{"as": "ভিত্তি তাৰিখ"},
         meaning_en="A fixed date used as a dividing line. In the Assam Accord it decides which migrants are to be detected.",
         meaning_as="বিভাজন ৰেখা হিচাপে লোৱা এটা নিৰ্দিষ্ট তাৰিখ। অসম চুক্তিত কোনবোৰ প্ৰব্ৰজনকাৰী চিনাক্ত কৰা হ'ব, সেয়া ইয়াৰ দ্বাৰা নিৰ্ধাৰণ হয়।"),
]

CHAPTERS = [
    # ------------------------------------------------------------------ 1
    dict(
        slug="ancient-assam-kamarupa", position=1,
        title={"en": "Ancient Assam: Pragjyotisha and Kamarupa", "as": "প্ৰাচীন অসম: প্ৰাগজ্যোতিষ আৰু কামৰূপ"},
        summary={"en": "The kingdom of Kamarupa (350 to 1140 CE) and its three dynasties.",
                 "as": "কামৰূপ ৰাজ্য (৩৫০ ৰ পৰা ১১৪০ খ্ৰীষ্টাব্দ) আৰু ইয়াৰ তিনিটা ৰাজবংশ।"},
        sources=f"Kamarupa, Wikipedia: {W}Kamarupa",
        blocks={
            "en": [
                ("p1", "paragraph", "normal",
                 "In ancient times the land of Assam was known as {{term:pragjyotisha|Pragjyotisha}} and {{term:kamarupa|Kamarupa}}. "
                 "The historical kingdom of Kamarupa lasted from about 350 to 1140 CE."),
                ("p2", "paragraph", "normal",
                 "The first record that names Kamarupa is the 4th-century {{term:allahabad-pillar-inscription|Allahabad Pillar Inscription}} "
                 "of the Gupta emperor Samudragupta. It calls the rulers of Kamarupa 'frontier rulers'."),
                ("h1", "heading", "normal", "Three dynasties of Kamarupa"),
                ("l1", "list", "event",
                 "Varman {{term:dynasty}}: founded by Pushyavarman (350 to 374 CE).\n"
                 "Mlechchha dynasty: founded by Salasthambha (ruled 655 to 670 CE). Capital: Haruppeswara, near present-day Tezpur.\n"
                 "Pala dynasty: began with Brahma Pala (ruled 900 to 920 CE). Ratna Pala moved the capital to Durjaya."),
                ("h2", "heading", "normal", "Bhaskaravarman"),
                ("p3", "paragraph", "personality",
                 "Bhaskaravarman (ruled 600 to 650 CE) was the most famous Varman king. In 606 CE he made an alliance with "
                 "Harshavardhana of Kanauj. The Chinese traveller {{term:xuanzang|Xuanzang}} wrote about his kingdom."),
                ("p4", "paragraph", "normal",
                 "The kingdom of Kamarupa broke up by the 12th to 13th century, and smaller kingdoms took its place."),
                ("exam1", "fact_box", "exam_fact",
                 "Remember for exams: Kamarupa is first named in the Allahabad Pillar Inscription. "
                 "Dynasties in order: Varman, Mlechchha, Pala. Most famous king: Bhaskaravarman."),
            ],
            "as": [
                ("p1", "paragraph", "normal",
                 "প্ৰাচীন কালত অসমৰ ভূমি {{term:pragjyotisha|প্ৰাগজ্যোতিষ}} আৰু {{term:kamarupa|কামৰূপ}} নামেৰে জনাজাত আছিল। "
                 "ঐতিহাসিক কামৰূপ ৰাজ্য প্ৰায় ৩৫০ ৰ পৰা ১১৪০ খ্ৰীষ্টাব্দলৈ আছিল।"),
                ("p2", "paragraph", "normal",
                 "কামৰূপৰ নাম প্ৰথমে পোৱা যায় গুপ্ত সম্ৰাট সমুদ্ৰগুপ্তৰ চতুৰ্থ শতিকাৰ {{term:allahabad-pillar-inscription|এলাহাবাদ স্তম্ভলিপিত}}। "
                 "ইয়াত কামৰূপৰ শাসকসকলক 'সীমান্তৰ ৰজা' বুলি কোৱা হৈছে।"),
                ("h1", "heading", "normal", "কামৰূপৰ তিনিটা ৰাজবংশ"),
                ("l1", "list", "event",
                 "বৰ্মন {{term:dynasty|ৰাজবংশ}}: প্ৰতিষ্ঠাপক পুষ্যবৰ্মন (৩৫০ ৰ পৰা ৩৭৪ খ্ৰীষ্টাব্দ)।\n"
                 "ম্লেচ্ছ ৰাজবংশ: প্ৰতিষ্ঠাপক শালস্তম্ভ (৬৫৫ ৰ পৰা ৬৭০ খ্ৰীষ্টাব্দ)। ৰাজধানী: বৰ্তমানৰ তেজপুৰৰ ওচৰৰ হাৰুপ্পেশ্বৰ।\n"
                 "পাল ৰাজবংশ: ব্ৰহ্মপালৰ পৰা আৰম্ভ (৯০০ ৰ পৰা ৯২০ খ্ৰীষ্টাব্দ)। ৰত্নপালে ৰাজধানী দুৰ্জয়ালৈ স্থানান্তৰ কৰে।"),
                ("h2", "heading", "normal", "ভাস্কৰবৰ্মন"),
                ("p3", "paragraph", "personality",
                 "ভাস্কৰবৰ্মন (৬০০ ৰ পৰা ৬৫০ খ্ৰীষ্টাব্দ) বৰ্মন বংশৰ আটাইতকৈ বিখ্যাত ৰজা আছিল। ৬০৬ খ্ৰীষ্টাব্দত তেওঁ কনৌজৰ "
                 "হৰ্ষবৰ্ধনৰ সৈতে মিত্ৰতা গঢ়ে। চীনা পৰিব্ৰাজক {{term:xuanzang|হিউৱেন চাঙে}} তেওঁৰ ৰাজ্যৰ বিষয়ে লিখি গৈছে।"),
                ("p4", "paragraph", "normal",
                 "দ্বাদশৰ পৰা ত্ৰয়োদশ শতিকাৰ ভিতৰত কামৰূপ ৰাজ্য ভাগি পৰে আৰু তাৰ ঠাইত সৰু সৰু ৰাজ্যৰ উদ্ভৱ হয়।"),
                ("exam1", "fact_box", "exam_fact",
                 "পৰীক্ষাৰ বাবে মনত ৰাখক: কামৰূপৰ নাম প্ৰথমে এলাহাবাদ স্তম্ভলিপিত পোৱা যায়। "
                 "ৰাজবংশৰ ক্ৰম: বৰ্মন, ম্লেচ্ছ, পাল। আটাইতকৈ বিখ্যাত ৰজা: ভাস্কৰবৰ্মন।"),
            ],
        },
    ),
    # ------------------------------------------------------------------ 2
    dict(
        slug="ahom-kingdom", position=2,
        title={"en": "The Ahom kingdom (1228 to 1826)", "as": "আহোম ৰাজ্য (১২২৮ ৰ পৰা ১৮২৬)"},
        summary={"en": "Sukaphaa, the capitals, the great kings and the fall of the Ahom kingdom.",
                 "as": "চুকাফা, ৰাজধানীসমূহ, প্ৰসিদ্ধ ৰজাসকল আৰু আহোম ৰাজ্যৰ পতন।"},
        sources=f"Ahom kingdom, Wikipedia: {W}Ahom_kingdom",
        blocks={
            "en": [
                ("p1", "paragraph", "normal",
                 "The {{term:ahom|Ahom}} kingdom ruled the Brahmaputra Valley for about 598 years, from 1228 to 1826. "
                 "It was founded by Sukaphaa, a Tai prince from Mong Mao, who crossed the Patkai hills and entered the valley in 1228."),
                ("h1", "heading", "normal", "Capitals of the Ahom kingdom"),
                ("l1", "list", "heritage",
                 "Charaideo (from 1253), the first capital\n"
                 "Garhgaon (1540 to 1707)\n"
                 "Rangpur (1707 to 1794)\n"
                 "Jorhat (1794 to 1826)"),
                ("p2", "paragraph", "normal",
                 "The kingdom was organised on the {{term:paik-system|Paik system}}, under which men served the state in turn."),
                ("h2", "heading", "normal", "Important kings"),
                ("l2", "list", "personality",
                 "Suhungmung, the Dihingia Raja (1497 to 1539): took the title {{term:swargadeo|Swargadeo}}; annexed the Chutia kingdom in 1523.\n"
                 "Pratap Singha (1603 to 1641): reorganised the Paik system and created the offices of {{term:borphukan|Borphukan}} and Borbarua.\n"
                 "Rudra Singha (1696 to 1714): the kingdom reached its peak under him.\n"
                 "Pramatta Singha (1744 to 1751): built the Rang Ghar with masonry."),
                ("p3", "paragraph", "normal",
                 "The {{term:moamoria-rebellion|Moamoria rebellion}}, which began in 1769, weakened the kingdom. "
                 "The Burmese invasions followed, and in 1826 Assam passed to the British."),
                ("exam1", "fact_box", "exam_fact",
                 "Remember for exams: founder Sukaphaa (1228); first capital Charaideo; first king to be called Swargadeo: Suhungmung."),
            ],
            "as": [
                ("p1", "paragraph", "normal",
                 "{{term:ahom|আহোম}} ৰাজ্যই ১২২৮ ৰ পৰা ১৮২৬ চনলৈ প্ৰায় ৫৯৮ বছৰ ব্ৰহ্মপুত্ৰ উপত্যকা শাসন কৰিছিল। "
                 "মং মাওৰ টাই ৰাজকুমাৰ চুকাফাই ১২২৮ চনত পাটকাই পাহাৰ পাৰ হৈ উপত্যকালৈ আহি এই ৰাজ্য প্ৰতিষ্ঠা কৰে।"),
                ("h1", "heading", "normal", "আহোম ৰাজ্যৰ ৰাজধানীসমূহ"),
                ("l1", "list", "heritage",
                 "চৰাইদেউ (১২৫৩ চনৰ পৰা), প্ৰথম ৰাজধানী\n"
                 "গড়গাঁও (১৫৪০ ৰ পৰা ১৭০৭)\n"
                 "ৰংপুৰ (১৭০৭ ৰ পৰা ১৭৯৪)\n"
                 "যোৰহাট (১৭৯৪ ৰ পৰা ১৮২৬)"),
                ("p2", "paragraph", "normal",
                 "ৰাজ্যখন {{term:paik-system|পাইক প্ৰথাৰ}} ওপৰত গঢ় লৈ উঠিছিল, য'ত পুৰুষসকলে পাল পাতি ৰাজ্যৰ সেৱা কৰিছিল।"),
                ("h2", "heading", "normal", "প্ৰসিদ্ধ ৰজাসকল"),
                ("l2", "list", "personality",
                 "চুহুংমুং, দিহিঙীয়া ৰজা (১৪৯৭ ৰ পৰা ১৫৩৯): {{term:swargadeo|স্বৰ্গদেউ}} উপাধি লয়; ১৫২৩ চনত চুতীয়া ৰাজ্য অধিকাৰ কৰে।\n"
                 "প্ৰতাপ সিংহ (১৬০৩ ৰ পৰা ১৬৪১): পাইক প্ৰথা পুনৰ গঠন কৰে আৰু {{term:borphukan|বৰফুকন}} আৰু বৰবৰুৱাৰ পদ সৃষ্টি কৰে।\n"
                 "ৰুদ্ৰ সিংহ (১৬৯৬ ৰ পৰা ১৭১৪): তেওঁৰ দিনত ৰাজ্যখন উন্নতিৰ শিখৰত উঠে।\n"
                 "প্ৰমত্ত সিংহ (১৭৪৪ ৰ পৰা ১৭৫১): ইটাৰে ৰংঘৰ নিৰ্মাণ কৰে।"),
                ("p3", "paragraph", "normal",
                 "১৭৬৯ চনত আৰম্ভ হোৱা {{term:moamoria-rebellion|মোৱামৰীয়া বিদ্ৰোহে}} ৰাজ্যখন দুৰ্বল কৰে। "
                 "তাৰ পিছত মানৰ আক্ৰমণ হয় আৰু ১৮২৬ চনত অসম ব্ৰিটিছৰ হাতলৈ যায়।"),
                ("exam1", "fact_box", "exam_fact",
                 "পৰীক্ষাৰ বাবে মনত ৰাখক: প্ৰতিষ্ঠাপক চুকাফা (১২২৮); প্ৰথম ৰাজধানী চৰাইদেউ; প্ৰথম স্বৰ্গদেউ উপাধি লোৱা ৰজা: চুহুংমুং।"),
            ],
        },
    ),
    # ------------------------------------------------------------------ 3
    dict(
        slug="koch-kingdom", position=3,
        title={"en": "The Koch kingdom", "as": "কোচ ৰাজ্য"},
        summary={"en": "Biswa Singha, Nara Narayan and Chilarai, and the split into Koch Bihar and Koch Hajo.",
                 "as": "বিশ্ব সিংহ, নৰনাৰায়ণ আৰু চিলাৰায়, আৰু কোচ বিহাৰ আৰু কোচ হাজোলৈ বিভাজন।"},
        sources=f"Koch dynasty, Wikipedia: {W}Koch_dynasty",
        blocks={
            "en": [
                ("p1", "paragraph", "normal",
                 "The Koch {{term:dynasty}} rose in western Assam and North Bengal. Biswa Singha established its power in 1515 "
                 "and ruled until 1540."),
                ("p2", "paragraph", "personality",
                 "Under his son Nara Narayan (ruled 1540 to 1586), the kingdom reached its height. His brother Chilarai "
                 "(Shukladhwaj) was the commander of the army; in 1562 he took the Barak Valley from the Tripura kingdom."),
                ("p3", "paragraph", "heritage",
                 "Srimanta Sankardev and his disciples Madhavdev and Damodardev spread {{term:neo-vaishnavism|Neo-Vaishnavism}} in the Koch kingdom, "
                 "and the Koch rulers supported the Sattras they founded."),
                ("p4", "paragraph", "normal",
                 "After Nara Narayan, Chilarai's son Raghudev, governor of Koch Hajo, declared independence. In 1587 the kingdom was "
                 "divided into Koch Bihar in the west and Koch Hajo in the east."),
                ("exam1", "fact_box", "exam_fact",
                 "Remember for exams: founder Biswa Singha (1515); greatest king Nara Narayan; general Chilarai; split in 1587."),
            ],
            "as": [
                ("p1", "paragraph", "normal",
                 "কোচ {{term:dynasty|ৰাজবংশ}} পশ্চিম অসম আৰু উত্তৰ বংগত গঢ় লৈ উঠে। বিশ্ব সিংহই ১৫১৫ চনত ইয়াৰ শাসন প্ৰতিষ্ঠা কৰে "
                 "আৰু ১৫৪০ চনলৈ ৰাজত্ব কৰে।"),
                ("p2", "paragraph", "personality",
                 "তেওঁৰ পুত্ৰ নৰনাৰায়ণৰ (১৫৪০ ৰ পৰা ১৫৮৬) দিনত ৰাজ্যখন উন্নতিৰ শিখৰত উঠে। তেওঁৰ ভাতৃ চিলাৰায় "
                 "(শুক্লধ্বজ) সেনাপতি আছিল; ১৫৬২ চনত তেওঁ ত্ৰিপুৰা ৰাজ্যৰ পৰা বৰাক উপত্যকা অধিকাৰ কৰে।"),
                ("p3", "paragraph", "heritage",
                 "শ্ৰীমন্ত শংকৰদেৱ আৰু তেওঁৰ শিষ্য মাধৱদেৱ আৰু দামোদৰদেৱে কোচ ৰাজ্যত {{term:neo-vaishnavism|নৱ-বৈষ্ণৱ ধৰ্ম}} প্ৰচাৰ কৰে, "
                 "আৰু কোচ ৰজাসকলে তেওঁলোকে প্ৰতিষ্ঠা কৰা সত্ৰসমূহক পৃষ্ঠপোষকতা কৰে।"),
                ("p4", "paragraph", "normal",
                 "নৰনাৰায়ণৰ পিছত কোচ হাজোৰ শাসনকৰ্তা চিলাৰায়ৰ পুত্ৰ ৰঘুদেৱে স্বাধীনতা ঘোষণা কৰে। ১৫৮৭ চনত ৰাজ্যখন "
                 "পশ্চিমত কোচ বিহাৰ আৰু পূবত কোচ হাজো, এই দুভাগত বিভক্ত হয়।"),
                ("exam1", "fact_box", "exam_fact",
                 "পৰীক্ষাৰ বাবে মনত ৰাখক: প্ৰতিষ্ঠাপক বিশ্ব সিংহ (১৫১৫); শ্ৰেষ্ঠ ৰজা নৰনাৰায়ণ; সেনাপতি চিলাৰায়; বিভাজন ১৫৮৭ চনত।"),
            ],
        },
    ),
    # ------------------------------------------------------------------ 4
    dict(
        slug="mughal-invasions-saraighat", position=4,
        title={"en": "Mughal invasions and the Battle of Saraighat", "as": "মোগল আক্ৰমণ আৰু শৰাইঘাটৰ যুদ্ধ"},
        summary={"en": "How the Ahoms under Lachit Borphukan stopped the Mughals at Saraighat in 1671.",
                 "as": "১৬৭১ চনত লাচিত বৰফুকনৰ নেতৃত্বত আহোমসকলে কেনেকৈ শৰাইঘাটত মোগলক ৰুধিছিল।"},
        sources="\n".join([f"Battle of Saraighat, Wikipedia: {W}Battle_of_Saraighat", f"Ahom kingdom, Wikipedia: {W}Ahom_kingdom"]),
        blocks={
            "en": [
                ("p1", "paragraph", "normal",
                 "The {{term:mughal|Mughals}} attacked the Ahom kingdom several times in the 17th century. In 1662 to 1663 the Mughal "
                 "general Mir Jumla invaded, and the war ended with the Treaty of Ghilajharighat in January 1663."),
                ("p2", "paragraph", "normal",
                 "The Ahoms later won back Guwahati. The Mughals sent a large army under Ram Singh I, the Kachwaha raja of Amber. "
                 "The Battle of Alaboi was fought around 5 August 1669."),
                ("h1", "heading", "normal", "The Battle of Saraighat (1671)"),
                ("p3", "paragraph", "event",
                 "In the middle of March 1671, the Ahom army led by {{term:borphukan|Borphukan}} Lachit fought the Mughal fleet on the "
                 "Brahmaputra at Saraighat, in present-day Guwahati. The Ahoms won, and the Mughal admiral Munnawar Khan was killed."),
                ("p4", "paragraph", "normal",
                 "At the start of the campaign the Ahom king was Chakradhwaj Singha; after his death his brother Udayaditya Singha became king."),
                ("p5", "paragraph", "normal",
                 "In 1682, at the Battle of Itakhuli, the Ahoms defeated the Mughals again, and the Manas river became the western boundary of the kingdom."),
                ("exam1", "fact_box", "exam_fact",
                 "Remember for exams: Saraighat, 1671; Lachit Borphukan against Ram Singh I; Itakhuli, 1682."),
            ],
            "as": [
                ("p1", "paragraph", "normal",
                 "সপ্তদশ শতিকাত {{term:mughal|মোগলসকলে}} কেইবাবাৰো আহোম ৰাজ্য আক্ৰমণ কৰিছিল। ১৬৬২-৬৩ চনত মোগল "
                 "সেনাপতি মীৰজুমলাই আক্ৰমণ কৰে, আৰু ১৬৬৩ চনৰ জানুৱাৰীত ঘিলাঝাৰিঘাটৰ সন্ধিৰে সেই যুদ্ধৰ অন্ত পৰে।"),
                ("p2", "paragraph", "normal",
                 "পিছত আহোমসকলে গুৱাহাটী পুনৰ দখল কৰে। মোগলে অম্বৰৰ কাছোৱা ৰজা প্ৰথম ৰামসিংহৰ নেতৃত্বত এক বিশাল বাহিনী পঠায়। "
                 "১৬৬৯ চনৰ প্ৰায় ৫ আগষ্টত আলাবৈৰ যুদ্ধ হয়।"),
                ("h1", "heading", "normal", "শৰাইঘাটৰ যুদ্ধ (১৬৭১)"),
                ("p3", "paragraph", "event",
                 "১৬৭১ চনৰ মাৰ্চ মাহৰ মাজভাগত {{term:borphukan|বৰফুকন}} লাচিতৰ নেতৃত্বত আহোম সেনাই বৰ্তমানৰ গুৱাহাটীৰ শৰাইঘাটত "
                 "ব্ৰহ্মপুত্ৰৰ বুকুত মোগল নৌবাহিনীৰ সৈতে যুদ্ধ কৰে। আহোমসকল জয়ী হয় আৰু মোগল নৌ-সেনাপতি মুন্নাৱৰ খান নিহত হয়।"),
                ("p4", "paragraph", "normal",
                 "অভিযানৰ আৰম্ভণিতে আহোম ৰজা আছিল চক্ৰধ্বজ সিংহ; তেওঁৰ মৃত্যুৰ পিছত তেওঁৰ ভাতৃ উদয়াদিত্য সিংহ ৰজা হয়।"),
                ("p5", "paragraph", "normal",
                 "১৬৮২ চনত ইটাখুলিৰ যুদ্ধত আহোমসকলে পুনৰ মোগলক পৰাস্ত কৰে আৰু মানস নদী ৰাজ্যৰ পশ্চিম সীমা হয়।"),
                ("exam1", "fact_box", "exam_fact",
                 "পৰীক্ষাৰ বাবে মনত ৰাখক: শৰাইঘাট, ১৬৭১; লাচিত বৰফুকন বনাম প্ৰথম ৰামসিংহ; ইটাখুলি, ১৬৮২।"),
            ],
        },
    ),
    # ------------------------------------------------------------------ 5
    dict(
        slug="burmese-invasions-yandabo", position=5,
        title={"en": "Burmese invasions and the Treaty of Yandabo", "as": "মানৰ আক্ৰমণ আৰু ইয়াণ্ডাবুৰ সন্ধি"},
        summary={"en": "The three Burmese invasions (1817 to 1826) and how Assam passed to the British.",
                 "as": "মানৰ তিনিটা আক্ৰমণ (১৮১৭ ৰ পৰা ১৮২৬) আৰু অসম কেনেকৈ ব্ৰিটিছৰ হাতলৈ গ'ল।"},
        sources=f"Burmese invasions of Assam, Wikipedia: {W}Burmese_invasions_of_Assam",
        blocks={
            "en": [
                ("p1", "paragraph", "normal",
                 "Between 1817 and 1826 the {{term:maan|Burmese (Maan)}} invaded Assam three times. Quarrels among Ahom nobles opened the way: "
                 "Badan Chandra Borphukan, governor of Guwahati, had asked the Burmese king Bodawpaya for help in 1816."),
                ("l1", "list", "event",
                 "First invasion (1817): the Burmese army entered in January 1817. Chandrakanta Singha was the Ahom king.\n"
                 "Second invasion (1819): a Burmese army of about 30,000 won the battle of Phulpanisiga on 15 February 1819.\n"
                 "Third invasion (1821 to 1822): the Burmese defeated Chandrakanta in 1822 and took control of Assam."),
                ("p2", "paragraph", "normal",
                 "Burmese rule (1821 to 1825) is remembered as a time of great suffering. The British then fought the Burmese in the "
                 "First Anglo-Burmese War."),
                ("p3", "paragraph", "event",
                 "The war ended with the {{term:treaty-of-yandabo|Treaty of Yandabo}} in 1826. Burmese rule in Assam ended and British rule began."),
                ("exam1", "fact_box", "exam_fact",
                 "Remember for exams: Burmese invasions 1817, 1819 and 1821; Treaty of Yandabo 1826."),
            ],
            "as": [
                ("p1", "paragraph", "normal",
                 "১৮১৭ ৰ পৰা ১৮২৬ চনৰ ভিতৰত {{term:maan|মানে}} তিনিবাৰ অসম আক্ৰমণ কৰে। আহোম বিষয়াসকলৰ ভিতৰুৱা কাজিয়াই ইয়াৰ বাট মুকলি কৰে: "
                 "গুৱাহাটীৰ শাসনকৰ্তা বদনচন্দ্ৰ বৰফুকনে ১৮১৬ চনত মান ৰজা বদ'পায়াৰ সহায় বিচাৰিছিল।"),
                ("l1", "list", "event",
                 "প্ৰথম আক্ৰমণ (১৮১৭): ১৮১৭ চনৰ জানুৱাৰীত মান সেনা প্ৰৱেশ কৰে। তেতিয়া আহোম ৰজা আছিল চন্দ্ৰকান্ত সিংহ।\n"
                 "দ্বিতীয় আক্ৰমণ (১৮১৯): প্ৰায় ৩০,০০০ মান সেনাই ১৮১৯ চনৰ ১৫ ফেব্ৰুৱাৰীত ফুলপানীচিগাৰ যুদ্ধত জয়লাভ কৰে।\n"
                 "তৃতীয় আক্ৰমণ (১৮২১-২২): মানে ১৮২২ চনত চন্দ্ৰকান্তক পৰাস্ত কৰি অসম দখল কৰে।"),
                ("p2", "paragraph", "normal",
                 "মানৰ শাসনকাল (১৮২১ ৰ পৰা ১৮২৫) অসমৰ বাবে অতি দুখৰ সময় হিচাপে স্মৰণীয়। তাৰ পিছত ব্ৰিটিছে "
                 "প্ৰথম ইংগ-বৰ্মী যুদ্ধত মানৰ বিৰুদ্ধে যুঁজ দিয়ে।"),
                ("p3", "paragraph", "event",
                 "১৮২৬ চনত {{term:treaty-of-yandabo|ইয়াণ্ডাবুৰ সন্ধিৰে}} যুদ্ধৰ অন্ত পৰে। অসমত মানৰ শাসন শেষ হয় আৰু ব্ৰিটিছৰ শাসন আৰম্ভ হয়।"),
                ("exam1", "fact_box", "exam_fact",
                 "পৰীক্ষাৰ বাবে মনত ৰাখক: মানৰ আক্ৰমণ ১৮১৭, ১৮১৯ আৰু ১৮২১; ইয়াণ্ডাবুৰ সন্ধি ১৮২৬।"),
            ],
        },
    ),
    # ------------------------------------------------------------------ 6
    dict(
        slug="assam-under-british-rule", position=6,
        title={"en": "Assam under British rule", "as": "ব্ৰিটিছ শাসনত অসম"},
        summary={"en": "Early British rule, tea, and the first revolts: Gomdhar Konwar, Maniram Dewan and Phulaguri.",
                 "as": "প্ৰাৰম্ভিক ব্ৰিটিছ শাসন, চাহ, আৰু প্ৰথম বিদ্ৰোহ: গোমধৰ কোঁৱৰ, মণিৰাম দেৱান আৰু ফুলগুৰি।"},
        sources="\n".join([f"Assam, Wikipedia: {W}Assam", f"Gomdhar Konwar, Wikipedia: {W}Gomdhar_Konwar",
                           f"Maniram Dewan, Wikipedia: {W}Maniram_Dewan", f"Phulaguri Dhawa, Wikipedia: {W}Phulaguri_Dhewa"]),
        blocks={
            "en": [
                ("p1", "paragraph", "normal",
                 "After the {{term:treaty-of-yandabo|Treaty of Yandabo}} (1826), the East India Company took Lower Assam. In 1833 it made "
                 "Purandar Singha king of Upper Assam, but this lasted only until 1838, after which the British took over the whole region."),
                ("h1", "heading", "normal", "Early revolts"),
                ("l1", "list", "event",
                 "Gomdhar Konwar, an Ahom prince, was declared king at Toratoli near Jorhat and rose against the British. "
                 "He was defeated, sentenced to death, and the sentence was changed to seven years' banishment.\n"
                 "In 1857, Maniram Dewan planned a rising to bring back Ahom rule. The plot was discovered, and he was hanged with Piyali Barua "
                 "at Jorhat jail on 26 February 1858.\n"
                 "The Phulaguri Dhewa (1861): farmers at Phulaguri, near Nagaon, rose against new taxes, including a tax on betel leaf and areca nut. "
                 "Lieutenant Singer, a British officer, was killed on 18 October 1861."),
                ("h2", "heading", "normal", "Tea comes to Assam"),
                ("p2", "paragraph", "normal",
                 "In 1839, Maniram became the {{term:dewan|Dewan}} of the Assam Tea Company at Nazira. He later started his own tea garden at Cinnamara "
                 "and is called the first Indian tea planter to grow tea commercially in Assam."),
                ("exam1", "fact_box", "exam_fact",
                 "Remember for exams: Maniram Dewan and Piyali Barua hanged 26 February 1858; Phulaguri Dhewa 1861."),
            ],
            "as": [
                ("p1", "paragraph", "normal",
                 "{{term:treaty-of-yandabo|ইয়াণ্ডাবুৰ সন্ধিৰ}} (১৮২৬) পিছত ইষ্ট ইণ্ডিয়া কোম্পানীয়ে নামনি অসম অধিকাৰ কৰে। ১৮৩৩ চনত কোম্পানীয়ে "
                 "পুৰন্দৰ সিংহক উজনি অসমৰ ৰজা পাতে, কিন্তু সেয়া ১৮৩৮ চনলৈহে থাকে; তাৰ পিছত ব্ৰিটিছে গোটেই অঞ্চল অধিকাৰ কৰে।"),
                ("h1", "heading", "normal", "প্ৰথম বিদ্ৰোহসমূহ"),
                ("l1", "list", "event",
                 "আহোম ৰাজকুমাৰ গোমধৰ কোঁৱৰক যোৰহাটৰ ওচৰৰ টৰাটলিত ৰজা ঘোষণা কৰা হয় আৰু তেওঁ ব্ৰিটিছৰ বিৰুদ্ধে বিদ্ৰোহ কৰে। "
                 "তেওঁ পৰাস্ত হয়, মৃত্যুদণ্ড বিহা হয়, পিছত সেই দণ্ড সাত বছৰৰ নিৰ্বাসনলৈ সলনি কৰা হয়।\n"
                 "১৮৫৭ চনত মণিৰাম দেৱানে আহোম শাসন ঘূৰাই আনিবলৈ বিদ্ৰোহৰ পৰিকল্পনা কৰে। ষড়যন্ত্ৰ ধৰা পৰে আৰু ১৮৫৮ চনৰ ২৬ ফেব্ৰুৱাৰীত "
                 "যোৰহাট কাৰাগাৰত পিয়লি বৰুৱাৰ সৈতে তেওঁক ফাঁচি দিয়া হয়।\n"
                 "ফুলগুৰি ধেৱা (১৮৬১): নগাঁৱৰ ওচৰৰ ফুলগুৰিৰ খেতিয়কসকলে পাণ আৰু তামোলৰ ওপৰত কৰকে ধৰি নতুন কৰৰ বিৰুদ্ধে বিদ্ৰোহ কৰে। "
                 "১৮৬১ চনৰ ১৮ অক্টোবৰত ব্ৰিটিছ বিষয়া লেফটেনেণ্ট চিংগাৰ নিহত হয়।"),
                ("h2", "heading", "normal", "অসমলৈ চাহৰ আগমন"),
                ("p2", "paragraph", "normal",
                 "১৮৩৯ চনত মণিৰাম নাজিৰাৰ আসাম টি কোম্পানীৰ {{term:dewan|দেৱান}} হয়। পিছত তেওঁ চিনামৰাত নিজৰ চাহ বাগিচা আৰম্ভ কৰে "
                 "আৰু অসমত বাণিজ্যিকভাৱে চাহ খেতি কৰা প্ৰথম ভাৰতীয় চাহ খেতিয়ক বুলি তেওঁক কোৱা হয়।"),
                ("exam1", "fact_box", "exam_fact",
                 "পৰীক্ষাৰ বাবে মনত ৰাখক: মণিৰাম দেৱান আৰু পিয়লি বৰুৱাৰ ফাঁচি ২৬ ফেব্ৰুৱাৰী ১৮৫৮; ফুলগুৰি ধেৱা ১৮৬১।"),
            ],
        },
    ),
    # ------------------------------------------------------------------ 7
    dict(
        slug="assam-freedom-struggle", position=7,
        title={"en": "Assam in the freedom struggle", "as": "স্বাধীনতা সংগ্ৰামত অসম"},
        summary={"en": "Kanaklata Barua and the Quit India Movement, and how Gopinath Bordoloi kept Assam in India.",
                 "as": "কনকলতা বৰুৱা আৰু ভাৰত ত্যাগ আন্দোলন, আৰু গোপীনাথ বৰদলৈয়ে কেনেকৈ অসমক ভাৰতত ৰাখিলে।"},
        sources="\n".join([f"Kanaklata Barua, Wikipedia: {W}Kanaklata_Barua", f"Gopinath Bordoloi, Wikipedia: {W}Gopinath_Bordoloi"]),
        blocks={
            "en": [
                ("p1", "paragraph", "normal",
                 "People from every part of Assam took part in India's struggle for freedom. Two names stand out in exam questions: "
                 "Kanaklata Barua and Gopinath Bordoloi."),
                ("h1", "heading", "normal", "Kanaklata Barua and the Quit India Movement"),
                ("p2", "paragraph", "personality",
                 "During the {{term:quit-india-movement|Quit India Movement}} of 1942, Kanaklata Barua of Borangabari, Gohpur, joined the "
                 "{{term:mrityu-bahini|Mrityu Bahini}}. On 20 September 1942 she was shot dead by the police while leading a procession "
                 "carrying the national flag. She was 17 years old."),
                ("h2", "heading", "normal", "Gopinath Bordoloi"),
                ("p3", "paragraph", "personality",
                 "Gopinath Bordoloi (6 June 1890 to 5 August 1950) became Premier of Assam in 1938. In 1946 the "
                 "{{term:cabinet-mission|Cabinet Mission}} plan placed Assam in a group with Bengal. The Assam Congress, under Bordoloi, "
                 "opposed this grouping, which helped Assam stay in India."),
                ("p4", "paragraph", "normal",
                 "He was the first Chief Minister of Assam, from 11 February 1946 until his death on 5 August 1950. He was given the "
                 "Bharat Ratna after his death, in 1999."),
                ("exam1", "fact_box", "exam_fact",
                 "Remember for exams: Kanaklata Barua, martyred at Gohpur on 20 September 1942; Gopinath Bordoloi, first Chief Minister, Bharat Ratna 1999."),
            ],
            "as": [
                ("p1", "paragraph", "normal",
                 "ভাৰতৰ স্বাধীনতা সংগ্ৰামত অসমৰ সকলো প্ৰান্তৰ মানুহে অংশ লৈছিল। পৰীক্ষাৰ প্ৰশ্নত দুটা নাম বিশেষভাৱে আহে: "
                 "কনকলতা বৰুৱা আৰু গোপীনাথ বৰদলৈ।"),
                ("h1", "heading", "normal", "কনকলতা বৰুৱা আৰু ভাৰত ত্যাগ আন্দোলন"),
                ("p2", "paragraph", "personality",
                 "১৯৪২ চনৰ {{term:quit-india-movement|ভাৰত ত্যাগ আন্দোলনৰ}} সময়ত গহপুৰৰ বৰঙাবাৰীৰ কনকলতা বৰুৱা "
                 "{{term:mrityu-bahini|মৃত্যু বাহিনীত}} যোগ দিয়ে। ১৯৪২ চনৰ ২০ ছেপ্টেম্বৰত ৰাষ্ট্ৰীয় পতাকা লৈ এক শোভাযাত্ৰাৰ নেতৃত্ব দি থাকোঁতে "
                 "আৰক্ষীৰ গুলীত তেওঁ শ্বহীদ হয়। তেতিয়া তেওঁৰ বয়স আছিল ১৭ বছৰ।"),
                ("h2", "heading", "normal", "গোপীনাথ বৰদলৈ"),
                ("p3", "paragraph", "personality",
                 "গোপীনাথ বৰদলৈ (৬ জুন ১৮৯০ ৰ পৰা ৫ আগষ্ট ১৯৫০) ১৯৩৮ চনত অসমৰ প্ৰধানমন্ত্ৰী হয়। ১৯৪৬ চনত "
                 "{{term:cabinet-mission|কেবিনেট মিছনৰ}} পৰিকল্পনাত অসমক বংগৰ সৈতে একেটা গোটত ৰখা হৈছিল। বৰদলৈৰ নেতৃত্বত অসম কংগ্ৰেছে "
                 "এই গোটকৰণৰ বিৰোধিতা কৰে, যাৰ ফলত অসম ভাৰততে থাকিবলৈ সক্ষম হয়।"),
                ("p4", "paragraph", "normal",
                 "তেওঁ ১৯৪৬ চনৰ ১১ ফেব্ৰুৱাৰীৰ পৰা ১৯৫০ চনৰ ৫ আগষ্টত মৃত্যু হোৱালৈকে অসমৰ প্ৰথম মুখ্যমন্ত্ৰী আছিল। মৃত্যুৰ পিছত "
                 "১৯৯৯ চনত তেওঁক ভাৰতৰত্ন প্ৰদান কৰা হয়।"),
                ("exam1", "fact_box", "exam_fact",
                 "পৰীক্ষাৰ বাবে মনত ৰাখক: কনকলতা বৰুৱা, ২০ ছেপ্টেম্বৰ ১৯৪২ত গহপুৰত শ্বহীদ; গোপীনাথ বৰদলৈ, প্ৰথম মুখ্যমন্ত্ৰী, ভাৰতৰত্ন ১৯৯৯।"),
            ],
        },
    ),
    # ------------------------------------------------------------------ 8
    dict(
        slug="assam-movement-accord", position=8,
        title={"en": "The Assam Movement and the Assam Accord", "as": "অসম আন্দোলন আৰু অসম চুক্তি"},
        summary={"en": "The six-year movement (1979 to 1985) and the Assam Accord of 15 August 1985.",
                 "as": "ছবছৰীয়া আন্দোলন (১৯৭৯ ৰ পৰা ১৯৮৫) আৰু ১৯৮৫ চনৰ ১৫ আগষ্টৰ অসম চুক্তি।"},
        sources="\n".join([f"Assam Movement, Wikipedia: {W}Assam_Movement", f"Assam Accord, Wikipedia: {W}Assam_Accord",
                           "TO VERIFY before publishing: p5 (AGP formed after the Accord and Prafulla Kumar Mahanta became Chief Minister in 1985)."]),
        blocks={
            "en": [
                ("p1", "paragraph", "normal",
                 "The Assam Movement (1979 to 1985) was a mass movement against illegal immigration into Assam. It was led by the "
                 "{{term:aasu|All Assam Students' Union (AASU)}} and the All Assam Gana Sangram Parishad (AAGSP)."),
                ("p2", "paragraph", "normal",
                 "The immediate trigger was the by-election in Mangaldoi in 1979, when a large number of names on the voters' list were questioned. "
                 "AASU's 12-hour general strike on 8 June 1979 is taken as the start of the movement."),
                ("h1", "heading", "normal", "The Assam Accord (1985)"),
                ("p3", "paragraph", "event",
                 "The {{term:assam-accord|Assam Accord}} was signed on 15 August 1985 in New Delhi, in the presence of Prime Minister Rajiv Gandhi. "
                 "Prafulla Kumar Mahanta and Bhrigu Kumar Phukan of AASU and Biraj Kumar Sarma of AAGSP signed for the movement."),
                ("l1", "list", "verified_fact",
                 "People who came to Assam before 1 January 1966 are accepted as citizens.\n"
                 "People who came after 25 March 1971 (the {{term:cut-off-date|cut-off date}}) are to be detected and expelled.\n"
                 "The border is to be fenced and guarded.\n"
                 "Clause 6 promises protection for the Assamese people."),
                ("p4", "paragraph", "normal",
                 "Over 855 people lost their lives during the movement."),
                ("p5", "paragraph", "normal",
                 "After the Accord, the movement's leaders formed a political party, the Asom Gana Parishad (AGP), which won the election, "
                 "and Prafulla Kumar Mahanta became Chief Minister in 1985."),
                ("exam1", "fact_box", "exam_fact",
                 "Remember for exams: Assam Accord signed 15 August 1985; cut-off date 25 March 1971; Clause 6 protects the Assamese people."),
            ],
            "as": [
                ("p1", "paragraph", "normal",
                 "অসম আন্দোলন (১৯৭৯ ৰ পৰা ১৯৮৫) অসমলৈ হোৱা অবৈধ প্ৰব্ৰজনৰ বিৰুদ্ধে এক গণ আন্দোলন আছিল। ইয়াৰ নেতৃত্ব দিছিল "
                 "{{term:aasu|সদৌ অসম ছাত্ৰ সন্থা (আছু)}} আৰু সদৌ অসম গণ সংগ্ৰাম পৰিষদে।"),
                ("p2", "paragraph", "normal",
                 "১৯৭৯ চনৰ মঙলদৈৰ উপ-নিৰ্বাচনত ভোটাৰ তালিকাৰ বহুতো নাম সন্দেহৰ আওতালৈ অহাটোৱেই ইয়াৰ তাৎক্ষণিক কাৰণ আছিল। "
                 "১৯৭৯ চনৰ ৮ জুনত আছুৱে আহ্বান কৰা ১২ ঘণ্টীয়া বন্ধক আন্দোলনৰ আৰম্ভণি বুলি ধৰা হয়।"),
                ("h1", "heading", "normal", "অসম চুক্তি (১৯৮৫)"),
                ("p3", "paragraph", "event",
                 "১৯৮৫ চনৰ ১৫ আগষ্টত নতুন দিল্লীত প্ৰধানমন্ত্ৰী ৰাজীৱ গান্ধীৰ উপস্থিতিত {{term:assam-accord|অসম চুক্তি}} স্বাক্ষৰিত হয়। "
                 "আন্দোলনৰ হৈ আছুৰ প্ৰফুল্ল কুমাৰ মহন্ত আৰু ভৃগু কুমাৰ ফুকন আৰু গণ সংগ্ৰাম পৰিষদৰ বিৰাজ কুমাৰ শৰ্মাই স্বাক্ষৰ কৰে।"),
                ("l1", "list", "verified_fact",
                 "১৯৬৬ চনৰ ১ জানুৱাৰীৰ আগতে অসমলৈ অহা লোকসকলক নাগৰিক হিচাপে গ্ৰহণ কৰা হ'ব।\n"
                 "১৯৭১ চনৰ ২৫ মাৰ্চৰ ({{term:cut-off-date|ভিত্তি তাৰিখ}}) পিছত অহা লোকসকলক চিনাক্ত কৰি বহিষ্কাৰ কৰা হ'ব।\n"
                 "সীমান্তত কাঁইটীয়া তাঁৰৰ বেৰ দি সুৰক্ষা দিয়া হ'ব।\n"
                 "৬ নং দফাত অসমীয়া জনগণৰ সুৰক্ষাৰ প্ৰতিশ্ৰুতি দিয়া হৈছে।"),
                ("p4", "paragraph", "normal",
                 "আন্দোলনৰ সময়ত ৮৫৫ জনতকৈ অধিক লোকে প্ৰাণ আহুতি দিয়ে।"),
                ("p5", "paragraph", "normal",
                 "চুক্তিৰ পিছত আন্দোলনৰ নেতাসকলে অসম গণ পৰিষদ (অগপ) নামৰ ৰাজনৈতিক দল গঠন কৰে, যিয়ে নিৰ্বাচনত জয়লাভ কৰে, "
                 "আৰু ১৯৮৫ চনত প্ৰফুল্ল কুমাৰ মহন্ত মুখ্যমন্ত্ৰী হয়।"),
                ("exam1", "fact_box", "exam_fact",
                 "পৰীক্ষাৰ বাবে মনত ৰাখক: অসম চুক্তি ১৫ আগষ্ট ১৯৮৫; ভিত্তি তাৰিখ ২৫ মাৰ্চ ১৯৭১; ৬ নং দফাই অসমীয়া জনগণক সুৰক্ষা দিয়ে।"),
            ],
        },
    ),
]
