"""Group 1: Introduction to Assam (অসমৰ পৰিচয়).

Block format: (block_key, block_type, style, body). Keys must match in both languages.
Highlighted words use {{term:slug|shown words}}; every slug is defined in TERMS.
"""

CATEGORY_SLUG = "introduction"
CATEGORY_NAME = "Introduction to Assam"
LAST_CHECKED = "2026-11-24"

SRC_GLANCE = ("Assam at a Glance 2025, Directorate of Economics and Statistics, Government of Assam: "
              "https://des.assam.gov.in/sites/default/files/swf_utility_folder/departments/ecostat_medhassu_in_oid_3/this_comm/assam_at_a_glance_-_2025.pdf")
SRC_CM = "State Profile, Office of the Chief Minister of Assam: https://cm.assam.gov.in/state-profile"
SRC_SYMBOLS = ("Symbols of Assam, Government of Assam: https://assam.gov.in/node/389 ; "
               "Raj Bhavan Assam: https://rajbhavan.assam.gov.in/about-us/symbols-assam")
SRC_WIKI = "Assam, Wikipedia (history section): https://en.wikipedia.org/wiki/Assam"
SRC_DISTRICTS = "List of districts of Assam, Wikipedia: https://en.wikipedia.org/wiki/List_of_districts_of_Assam"

TERMS = [
    dict(slug="dispur", en="Dispur", **{"as": "দিশপুৰ"},
         meaning_en="The capital of Assam. It is a part of Guwahati city, where the state government's main offices are.",
         meaning_as="অসমৰ ৰাজধানী। ই গুৱাহাটী চহৰৰে এটা অংশ, য'ত ৰাজ্য চৰকাৰৰ মূল কাৰ্যালয়সমূহ আছে।"),
    dict(slug="census", en="Census", **{"as": "লোকপিয়ল"},
         meaning_en="The official count of all the people of the country, done by the Government of India. The last completed census was in 2011.",
         meaning_as="ভাৰত চৰকাৰে কৰা দেশৰ সকলো মানুহৰ চৰকাৰী গণনা। শেষবাৰ সম্পূৰ্ণ হোৱা লোকপিয়ল ২০১১ চনত হৈছিল।"),
    dict(slug="population-density", en="Population density", **{"as": "জনসংখ্যাৰ ঘনত্ব"},
         meaning_en="The average number of people living in one square kilometre of land.",
         meaning_as="এক বৰ্গ কিলোমিটাৰ মাটিত গড়ে বাস কৰা মানুহৰ সংখ্যা।"),
    dict(slug="sex-ratio", en="Sex ratio", **{"as": "লিংগ অনুপাত"},
         meaning_en="The number of females for every 1,000 males in the population.",
         meaning_as="জনসংখ্যাত প্ৰতি ১,০০০ জন পুৰুষৰ বিপৰীতে থকা মহিলাৰ সংখ্যা।"),
    dict(slug="literacy-rate", en="Literacy rate", **{"as": "সাক্ষৰতাৰ হাৰ"},
         meaning_en="The percentage of people aged 7 years and above who can read and write with understanding in any language.",
         meaning_as="৭ বছৰ আৰু তাতোকৈ বেছি বয়সৰ যিসকল মানুহে যিকোনো ভাষাত বুজি পঢ়িব আৰু লিখিব পাৰে, তেওঁলোকৰ শতাংশ।"),
    dict(slug="decadal-growth", en="Decadal growth rate", **{"as": "দশকীয় বৃদ্ধিৰ হাৰ"},
         meaning_en="How much the population grew, in percent, over ten years (from one census to the next).",
         meaning_as="দহ বছৰত (এটা লোকপিয়লৰ পৰা পৰৱৰ্তী লোকপিয়ললৈ) জনসংখ্যা কিমান শতাংশ বাঢ়িল।"),
    dict(slug="sub-division", en="Sub-division", **{"as": "মহকুমা"},
         meaning_en="A part of a district, run by an officer called the Sub-Divisional Officer (SDO).",
         meaning_as="এখন জিলাৰ এটা অংশ, যিটো মহকুমাধিপতি (SDO) নামৰ বিষয়াই চলায়।"),
    dict(slug="revenue-circle", en="Revenue circle", **{"as": "ৰাজহ চক্ৰ"},
         meaning_en="An area in which land records and land revenue are handled. It is headed by a Circle Officer.",
         meaning_as="মাটিৰ নথি আৰু মাটিৰ খাজনা চম্ভালা এলেকা। ইয়াৰ মুৰব্বী চক্ৰ বিষয়া।"),
    dict(slug="development-block", en="Development block", **{"as": "উন্নয়ন খণ্ড"},
         meaning_en="An area of a district in which rural development work and schemes are carried out. It is headed by a Block Development Officer (BDO).",
         meaning_as="জিলাৰ এটা এলেকা য'ত গ্ৰাম্য উন্নয়নৰ কাম আৰু আঁচনিসমূহ ৰূপায়ণ কৰা হয়। ইয়াৰ মুৰব্বী খণ্ড উন্নয়ন বিষয়া (BDO)।"),
    dict(slug="ahom", en="Ahom", **{"as": "আহোম"},
         meaning_en="The people, and the kingdom they founded, that ruled much of the Brahmaputra Valley from 1228 to 1826.",
         meaning_as="১২২৮ চনৰ পৰা ১৮২৬ চনলৈ ব্ৰহ্মপুত্ৰ উপত্যকাৰ বেছিভাগ অঞ্চল শাসন কৰা জনগোষ্ঠী আৰু তেওঁলোকে প্ৰতিষ্ঠা কৰা ৰাজ্য।"),
    dict(slug="treaty-of-yandabo", en="Treaty of Yandabo", **{"as": "ইয়াণ্ডাবুৰ সন্ধি"},
         meaning_en="The 1826 treaty that ended the First Anglo-Burmese War. Burma gave up Assam, and the British East India Company took control of it.",
         meaning_as="প্ৰথম ইংগ-বৰ্মী যুদ্ধৰ অন্ত পেলোৱা ১৮২৬ চনৰ সন্ধি। ইয়াৰ দ্বাৰা মানে (বৰ্মাই) অসম এৰি দিয়ে আৰু ব্ৰিটিছ ইষ্ট ইণ্ডিয়া কোম্পানীয়ে অসমৰ শাসনভাৰ লয়।"),
    dict(slug="kamarupa", en="Kamarupa", **{"as": "কামৰূপ"},
         meaning_en="The ancient name of the region, used from the classical period up to the 12th century. Today the name lives on in Kamrup district.",
         meaning_as="ধ্ৰুপদী যুগৰ পৰা দ্বাদশ শতিকালৈ এই অঞ্চলৰ প্ৰাচীন নাম। আজিও কামৰূপ জিলাৰ নামত এই নাম জীয়াই আছে।"),
    dict(slug="pragjyotisha", en="Pragjyotisha", **{"as": "প্ৰাগজ্যোতিষ"},
         meaning_en="Another ancient name for the region, used along with Kamarupa.",
         meaning_as="কামৰূপৰ লগতে ব্যৱহাৰ হোৱা এই অঞ্চলৰ আন এটা প্ৰাচীন নাম।"),
    dict(slug="one-horned-rhinoceros", en="One-horned rhinoceros", **{"as": "এশিঙীয়া গঁড়"},
         meaning_en="The Indian rhinoceros, which has a single horn. It is the state animal of Assam.",
         meaning_as="এটা মাত্ৰ শিং থকা ভাৰতীয় গঁড়। ই অসমৰ ৰাজ্যিক জন্তু।"),
    dict(slug="white-winged-wood-duck", en="White-winged wood duck", **{"as": "দেওহাঁহ"},
         meaning_en="A rare forest duck with white patches on its wings. It is the state bird of Assam.",
         meaning_as="ডেউকাত বগা দাগ থকা এবিধ বিৰল বনৰীয়া হাঁহ। ই অসমৰ ৰাজ্যিক পক্ষী।"),
    dict(slug="hollong", en="Hollong", **{"as": "হোলোং"},
         meaning_en="A tall evergreen tree (scientific name Dipterocarpus macrocarpus). It is the state tree of Assam.",
         meaning_as="এবিধ ওখ চিৰসেউজ গছ (বৈজ্ঞানিক নাম Dipterocarpus macrocarpus)। ই অসমৰ ৰাজ্যিক বৃক্ষ।"),
    dict(slug="foxtail-orchid", en="Foxtail orchid", **{"as": "কপৌ ফুল"},
         meaning_en="An orchid whose flowers hang in long bunches like a fox's tail. It blooms around Bohag Bihu and is the state flower of Assam.",
         meaning_as="শিয়ালৰ নেজৰ দৰে দীঘল থোপাত ওলমি থকা এবিধ অৰ্কিড ফুল। বহাগ বিহুৰ সময়ত ফুলে আৰু ই অসমৰ ৰাজ্যিক ফুল।"),
    dict(slug="muga-silk", en="Muga silk", **{"as": "মুগা পাট"},
         meaning_en="A natural golden silk made in Assam. It is the state fabric of Assam.",
         meaning_as="অসমত উৎপাদিত এবিধ প্ৰাকৃতিক সোণালী ৰঙৰ পাট। ই অসমৰ ৰাজ্যিক বস্ত্ৰ।"),
    dict(slug="kaji-nemu", en="Kaji nemu", **{"as": "কাজি নেমু"},
         meaning_en="The long Assam lemon. It is the state fruit of Assam.",
         meaning_as="দীঘলীয়া আকাৰৰ অসমৰ নেমু। ই অসমৰ ৰাজ্যিক ফল।"),
    dict(slug="international-border", en="International border", **{"as": "আন্তঃৰাষ্ট্ৰীয় সীমা"},
         meaning_en="The border between two countries.",
         meaning_as="দুখন দেশৰ মাজৰ সীমা।"),
    dict(slug="siliguri-corridor", en="Siliguri Corridor", **{"as": "শিলিগুৰি কৰিডৰ"},
         meaning_en="A narrow strip of land in West Bengal that connects Northeast India with the rest of India. It is also called the Chicken's Neck.",
         meaning_as="পশ্চিমবংগত থকা এক ঠেক ভূখণ্ড, যিয়ে উত্তৰ-পূব ভাৰতক দেশৰ বাকী অংশৰ সৈতে সংযোগ কৰে। ইয়াক 'চিকেনছ নেক' বুলিও কোৱা হয়।"),
    dict(slug="chief-commissioner-province", en="Chief Commissioner's province", **{"as": "চিফ কমিছনাৰৰ প্ৰদেশ"},
         meaning_en="A province in British India run directly by an officer called the Chief Commissioner, instead of a Governor.",
         meaning_as="ব্ৰিটিছ ভাৰতৰ এনে এখন প্ৰদেশ যাক গৱৰ্ণৰৰ সলনি চিফ কমিছনাৰ নামৰ বিষয়াই পোনপটীয়াকৈ চলাইছিল।"),
    dict(slug="referendum", en="Referendum", **{"as": "গণভোট"},
         meaning_en="A vote in which all the people of an area decide one important question directly.",
         meaning_as="এনে এক ভোটদান য'ত এটা অঞ্চলৰ জনসাধাৰণে এটা গুৰুত্বপূৰ্ণ প্ৰশ্নৰ বিষয়ে পোনপটীয়াকৈ সিদ্ধান্ত লয়।"),
    dict(slug="union-territory", en="Union Territory", **{"as": "কেন্দ্ৰীয় শাসিত অঞ্চল"},
         meaning_en="An area of India that is governed directly by the Central Government, not by a state government.",
         meaning_as="ৰাজ্য চৰকাৰৰ সলনি কেন্দ্ৰীয় চৰকাৰে পোনপটীয়াকৈ শাসন কৰা ভাৰতৰ এটা অঞ্চল।"),
]

CHAPTERS = [
    # ------------------------------------------------------------------ 1
    dict(
        slug="assam-at-a-glance", position=1,
        title={"en": "Assam at a glance", "as": "এনেকৈয়ে অসম: এক চমু পৰিচয়"},
        summary={"en": "Capital, area, districts, seats and population of Assam in one place.",
                 "as": "অসমৰ ৰাজধানী, আয়তন, জিলা, আসন আৰু জনসংখ্যা এক ঠাইতে।"},
        sources="\n".join([SRC_GLANCE, SRC_CM]),
        blocks={
            "en": [
                ("p1", "paragraph", "normal",
                 "Assam is a state in Northeast India. Its capital is {{term:dispur|Dispur}}, which is part of Guwahati. "
                 "Assam covers an area of 78,438 square kilometres."),
                ("fact1", "fact_box", "verified_fact",
                 "Capital: Dispur\nArea: 78,438 sq km\nDistricts: 35\nState language: Assamese\n"
                 "Lok Sabha seats: 14\nRajya Sabha seats: 7\nAssembly seats: 126"),
                ("h1", "heading", "normal", "How Assam is divided for administration"),
                ("p2", "paragraph", "normal",
                 "According to Assam at a Glance 2025, the state has 35 districts, 80 {{term:sub-division|sub-divisions}}, "
                 "154 {{term:revenue-circle|revenue circles}} and 219 {{term:development-block|development blocks}}."),
                ("p3", "paragraph", "normal",
                 "For rural local government there are 27 Zilla Parishads, 183 Anchalik Panchayats and 2,170 Gaon Panchayats."),
                ("h2", "heading", "normal", "Population (Census 2011)"),
                ("p4", "paragraph", "normal",
                 "The last completed {{term:census}} was held in 2011. These are the main figures for Assam:"),
                ("l1", "list", "normal",
                 "Total population: 3,12,05,576 (males 1,59,39,443; females 1,52,66,133)\n"
                 "Rural population: 2,68,07,034; urban population: 43,98,542\n"
                 "{{term:population-density|Population density}}: 398 people per sq km\n"
                 "{{term:sex-ratio|Sex ratio}}: 958 females per 1,000 males\n"
                 "{{term:literacy-rate|Literacy rate}}: 72.19% (males 77.85%, females 66.27%)\n"
                 "{{term:decadal-growth|Decadal growth}} 2001 to 2011: 17.07%"),
                ("p5", "paragraph", "normal",
                 "In 2011, Assam had 2.58 percent of India's population."),
                ("exam1", "fact_box", "exam_fact",
                 "Remember for exams: area 78,438 sq km, 35 districts, 126 Assembly seats, 14 Lok Sabha seats, "
                 "sex ratio 958 and literacy 72.19% (Census 2011)."),
            ],
            "as": [
                ("p1", "paragraph", "normal",
                 "অসম উত্তৰ-পূব ভাৰতৰ এখন ৰাজ্য। ইয়াৰ ৰাজধানী {{term:dispur|দিশপুৰ}}, যি গুৱাহাটীৰে এটা অংশ। "
                 "অসমৰ আয়তন ৭৮,৪৩৮ বৰ্গ কিলোমিটাৰ।"),
                ("fact1", "fact_box", "verified_fact",
                 "ৰাজধানী: দিশপুৰ\nআয়তন: ৭৮,৪৩৮ বৰ্গ কিমি\nজিলা: ৩৫ খন\nৰাজ্যিক ভাষা: অসমীয়া\n"
                 "লোকসভাৰ আসন: ১৪\nৰাজ্যসভাৰ আসন: ৭\nবিধানসভাৰ আসন: ১২৬"),
                ("h1", "heading", "normal", "প্ৰশাসনৰ বাবে অসমক কেনেকৈ ভগোৱা হৈছে"),
                ("p2", "paragraph", "normal",
                 "'অসম এট এ গ্লান্স ২০২৫' অনুসৰি ৰাজ্যখনত ৩৫ খন জিলা, ৮০ টা {{term:sub-division|মহকুমা}}, "
                 "১৫৪ টা {{term:revenue-circle|ৰাজহ চক্ৰ}} আৰু ২১৯ টা {{term:development-block|উন্নয়ন খণ্ড}} আছে।"),
                ("p3", "paragraph", "normal",
                 "গ্ৰাম্য স্থানীয় স্বায়ত্তশাসনৰ বাবে ২৭ খন জিলা পৰিষদ, ১৮৩ খন আঞ্চলিক পঞ্চায়ত আৰু ২,১৭০ খন গাঁও পঞ্চায়ত আছে।"),
                ("h2", "heading", "normal", "জনসংখ্যা (লোকপিয়ল ২০১১)"),
                ("p4", "paragraph", "normal",
                 "শেষবাৰ সম্পূৰ্ণ হোৱা {{term:census|লোকপিয়ল}} ২০১১ চনত হৈছিল। অসমৰ মূল তথ্যসমূহ এনেধৰণৰ:"),
                ("l1", "list", "normal",
                 "মুঠ জনসংখ্যা: ৩,১২,০৫,৫৭৬ (পুৰুষ ১,৫৯,৩৯,৪৪৩; মহিলা ১,৫২,৬৬,১৩৩)\n"
                 "গ্ৰাম্য জনসংখ্যা: ২,৬৮,০৭,০৩৪; নগৰীয়া জনসংখ্যা: ৪৩,৯৮,৫৪২\n"
                 "{{term:population-density|জনসংখ্যাৰ ঘনত্ব}}: প্ৰতি বৰ্গ কিমিত ৩৯৮ জন\n"
                 "{{term:sex-ratio|লিংগ অনুপাত}}: প্ৰতি ১,০০০ জন পুৰুষৰ বিপৰীতে ৯৫৮ গৰাকী মহিলা\n"
                 "{{term:literacy-rate|সাক্ষৰতাৰ হাৰ}}: ৭২.১৯% (পুৰুষ ৭৭.৮৫%, মহিলা ৬৬.২৭%)\n"
                 "২০০১ৰ পৰা ২০১১লৈ {{term:decadal-growth|দশকীয় বৃদ্ধি}}: ১৭.০৭%"),
                ("p5", "paragraph", "normal",
                 "২০১১ চনত ভাৰতৰ মুঠ জনসংখ্যাৰ ২.৫৮ শতাংশ অসমত আছিল।"),
                ("exam1", "fact_box", "exam_fact",
                 "পৰীক্ষাৰ বাবে মনত ৰাখক: আয়তন ৭৮,৪৩৮ বৰ্গ কিমি, ৩৫ খন জিলা, বিধানসভাৰ ১২৬ টা আসন, লোকসভাৰ ১৪ টা আসন, "
                 "লিংগ অনুপাত ৯৫৮ আৰু সাক্ষৰতাৰ হাৰ ৭২.১৯% (লোকপিয়ল ২০১১)।"),
            ],
        },
    ),
    # ------------------------------------------------------------------ 2
    dict(
        slug="name-of-assam", position=2,
        title={"en": "The name \"Assam\": where it comes from", "as": "'অসম' নামৰ উৎপত্তি"},
        summary={"en": "How the land got the name Assam, and its older names Kamarupa and Pragjyotisha.",
                 "as": "এই ভূমিয়ে কেনেকৈ 'অসম' নাম পালে, আৰু ইয়াৰ পুৰণি নাম কামৰূপ আৰু প্ৰাগজ্যোতিষ।"},
        sources="\n".join([SRC_WIKI,
                           "TO VERIFY before publishing: the 'asama (unequalled)' explanation in paragraph p3 is a popular "
                           "textbook view; please check it against your textbook."]),
        blocks={
            "en": [
                ("p1", "paragraph", "normal",
                 "Historians are not fully sure where the name Assam comes from. The name was first used by the British "
                 "in the {{term:treaty-of-yandabo|Treaty of Yandabo}} in 1826."),
                ("p2", "paragraph", "normal",
                 "Most historians link the name with the {{term:ahom|Ahom}} people, who ruled much of the Brahmaputra Valley "
                 "for about six hundred years. Their kingdom came to be called Assam; the Mughals wrote it as \"Asham\"."),
                ("p3", "paragraph", "normal",
                 "Another popular explanation links the name to the Sanskrit word \"asama\", meaning unequalled or "
                 "without equal. This is a view, not a settled fact."),
                ("h1", "heading", "normal", "Older names of the land"),
                ("p4", "paragraph", "normal",
                 "From the classical period up to the 12th century, the region was called {{term:kamarupa|Kamarupa}}, "
                 "and also {{term:pragjyotisha|Pragjyotisha}}. The name Kamarupa lives on today in the districts of "
                 "Kamrup and Kamrup Metropolitan."),
                ("p5", "paragraph", "normal",
                 "Even earlier, in the 2nd century, the Greek geographer Ptolemy called the region \"Kirrhadia\", "
                 "probably after the Kirata people."),
                ("exam1", "fact_box", "exam_fact",
                 "Remember for exams: the name Assam first appears in the Treaty of Yandabo (1826). "
                 "Ancient names: Kamarupa and Pragjyotisha."),
            ],
            "as": [
                ("p1", "paragraph", "normal",
                 "'অসম' নামটো ক'ৰ পৰা আহিল, সেই বিষয়ে ইতিহাসবিদসকল সম্পূৰ্ণ নিশ্চিত নহয়। ব্ৰিটিছসকলে ১৮২৬ চনৰ "
                 "{{term:treaty-of-yandabo|ইয়াণ্ডাবুৰ সন্ধিত}} প্ৰথমবাৰৰ বাবে এই নাম ব্যৱহাৰ কৰিছিল।"),
                ("p2", "paragraph", "normal",
                 "বেছিভাগ ইতিহাসবিদে এই নামটো {{term:ahom|আহোমসকলৰ}} সৈতে সংযোগ কৰে, যিসকলে প্ৰায় ছশ বছৰ ধৰি "
                 "ব্ৰহ্মপুত্ৰ উপত্যকাৰ বেছিভাগ অঞ্চল শাসন কৰিছিল। তেওঁলোকৰ ৰাজ্যখনক অসম বুলি কোৱা হ'ল; মোগলসকলে ইয়াক 'আছাম' বুলি লিখিছিল।"),
                ("p3", "paragraph", "normal",
                 "আন এটা জনপ্ৰিয় ব্যাখ্যা অনুসৰি নামটো সংস্কৃত শব্দ 'অসম'ৰ পৰা আহিছে, যাৰ অৰ্থ যাৰ সমান নাই বা অতুলনীয়। "
                 "এইটো এটা মত হে, প্ৰমাণিত তথ্য নহয়।"),
                ("h1", "heading", "normal", "এই ভূমিৰ পুৰণি নামসমূহ"),
                ("p4", "paragraph", "normal",
                 "ধ্ৰুপদী যুগৰ পৰা দ্বাদশ শতিকালৈ এই অঞ্চলক {{term:kamarupa|কামৰূপ}} আৰু {{term:pragjyotisha|প্ৰাগজ্যোতিষ}} "
                 "বুলি কোৱা হৈছিল। কামৰূপ নামটো আজিও কামৰূপ আৰু কামৰূপ মহানগৰ জিলাৰ নামত জীয়াই আছে।"),
                ("p5", "paragraph", "normal",
                 "তাতোকৈও আগতে, খ্ৰীষ্টীয় দ্বিতীয় শতিকাত গ্ৰীক ভূগোলবিদ টলেমীয়ে এই অঞ্চলক 'কিৰ্হাডিয়া' বুলি উল্লেখ কৰিছিল, "
                 "সম্ভৱতঃ কিৰাত জনগোষ্ঠীৰ নামেৰে।"),
                ("exam1", "fact_box", "exam_fact",
                 "পৰীক্ষাৰ বাবে মনত ৰাখক: 'অসম' নামটো প্ৰথমে ইয়াণ্ডাবুৰ সন্ধিত (১৮২৬) পোৱা যায়। "
                 "প্ৰাচীন নাম: কামৰূপ আৰু প্ৰাগজ্যোতিষ।"),
            ],
        },
    ),
    # ------------------------------------------------------------------ 3
    dict(
        slug="state-symbols-of-assam", position=3,
        title={"en": "State symbols of Assam", "as": "অসমৰ ৰাজ্যিক প্ৰতীকসমূহ"},
        summary={"en": "The official animal, bird, tree, flower, song and other symbols of Assam.",
                 "as": "অসমৰ চৰকাৰী জন্তু, পক্ষী, বৃক্ষ, ফুল, গীত আৰু অন্যান্য প্ৰতীক।"},
        sources="\n".join([SRC_SYMBOLS, SRC_GLANCE]),
        blocks={
            "en": [
                ("p1", "paragraph", "normal",
                 "Like every Indian state, Assam has official symbols that stand for its nature and culture. "
                 "These are the symbols listed by the Government of Assam:"),
                ("l1", "list", "verified_fact",
                 "State animal: {{term:one-horned-rhinoceros|One-horned rhinoceros}} (Gor)\n"
                 "State bird: {{term:white-winged-wood-duck|White-winged wood duck}} (Deohanh)\n"
                 "State tree: {{term:hollong|Hollong}}\n"
                 "State flower: {{term:foxtail-orchid|Foxtail orchid}} (Kopou phul)\n"
                 "State song: \"O Mur Apunar Desh\" (O my dearest country)\n"
                 "State motto: \"Joi Aai Axom\" (Hail Mother Assam)\n"
                 "State language: Assamese\n"
                 "State festival: Bihu; state dance: Bihu dance\n"
                 "State fabric: {{term:muga-silk|Muga silk}}\n"
                 "State beverage: Tea\n"
                 "State fruit: {{term:kaji-nemu|Kaji nemu}} (Assam lemon)"),
                ("p2", "paragraph", "normal",
                 "The state song \"O Mur Apunar Desh\" was written by Lakshminath Bezbaroa, one of the greatest writers of Assamese literature."),
                ("p3", "paragraph", "normal",
                 "The state's literary society is the Asam Sahitya Sabha."),
                ("exam1", "fact_box", "exam_fact",
                 "Common exam question: state bird = White-winged wood duck (Deohanh); state flower = Foxtail orchid (Kopou phul); "
                 "state tree = Hollong."),
            ],
            "as": [
                ("p1", "paragraph", "normal",
                 "ভাৰতৰ আন ৰাজ্যৰ দৰে অসমৰো প্ৰকৃতি আৰু সংস্কৃতিক প্ৰতিনিধিত্ব কৰা চৰকাৰী প্ৰতীক আছে। "
                 "অসম চৰকাৰে উল্লেখ কৰা প্ৰতীকসমূহ এনেধৰণৰ:"),
                ("l1", "list", "verified_fact",
                 "ৰাজ্যিক জন্তু: {{term:one-horned-rhinoceros|এশিঙীয়া গঁড়}}\n"
                 "ৰাজ্যিক পক্ষী: {{term:white-winged-wood-duck|দেওহাঁহ}}\n"
                 "ৰাজ্যিক বৃক্ষ: {{term:hollong|হোলোং}}\n"
                 "ৰাজ্যিক ফুল: {{term:foxtail-orchid|কপৌ ফুল}}\n"
                 "ৰাজ্যিক সংগীত: 'অ' মোৰ আপোনাৰ দেশ'\n"
                 "ৰাজ্যিক আদৰ্শবাণী: 'জয় আই অসম'\n"
                 "ৰাজ্যিক ভাষা: অসমীয়া\n"
                 "ৰাজ্যিক উৎসৱ: বিহু; ৰাজ্যিক নৃত্য: বিহু নাচ\n"
                 "ৰাজ্যিক বস্ত্ৰ: {{term:muga-silk|মুগা পাট}}\n"
                 "ৰাজ্যিক পানীয়: চাহ\n"
                 "ৰাজ্যিক ফল: {{term:kaji-nemu|কাজি নেমু}}"),
                ("p2", "paragraph", "normal",
                 "ৰাজ্যিক সংগীত 'অ' মোৰ আপোনাৰ দেশ' অসমীয়া সাহিত্যৰ অন্যতম শ্ৰেষ্ঠ সাহিত্যিক লক্ষ্মীনাথ বেজবৰুৱাই ৰচনা কৰিছিল।"),
                ("p3", "paragraph", "normal",
                 "ৰাজ্যখনৰ সাহিত্য সভা হৈছে অসম সাহিত্য সভা।"),
                ("exam1", "fact_box", "exam_fact",
                 "পৰীক্ষাত সঘনাই সোধা প্ৰশ্ন: ৰাজ্যিক পক্ষী = দেওহাঁহ; ৰাজ্যিক ফুল = কপৌ ফুল; ৰাজ্যিক বৃক্ষ = হোলোং।"),
            ],
        },
    ),
    # ------------------------------------------------------------------ 4
    dict(
        slug="location-and-boundaries", position=4,
        title={"en": "Location, boundaries and neighbours", "as": "অসমৰ অৱস্থান, সীমা আৰু চুবুৰীয়া"},
        summary={"en": "Where Assam lies on the map, and which countries and states border it.",
                 "as": "মানচিত্ৰত অসম ক'ত আছে, আৰু কোনবোৰ দেশ আৰু ৰাজ্যৰ সৈতে ইয়াৰ সীমা আছে।"},
        sources="\n".join([SRC_CM, SRC_GLANCE]),
        blocks={
            "en": [
                ("p1", "paragraph", "normal",
                 "Assam lies in Northeast India, roughly between 24° and 28° North latitude and between 90° and 96° East longitude."),
                ("h1", "heading", "normal", "Neighbours on every side"),
                ("l1", "list", "geography",
                 "North: Bhutan and Arunachal Pradesh\n"
                 "East: Nagaland and Manipur\n"
                 "South: Meghalaya, Tripura, Mizoram and Bangladesh\n"
                 "West: West Bengal"),
                ("p2", "paragraph", "normal",
                 "Assam shares an {{term:international-border|international border}} with two countries, Bhutan and Bangladesh, "
                 "and borders seven Indian states. It touches every other Northeast state except Sikkim."),
                ("p3", "paragraph", "normal",
                 "Assam and the rest of Northeast India are joined to the rest of the country by the "
                 "{{term:siliguri-corridor|Siliguri Corridor}}, a narrow strip of land in West Bengal."),
                ("p4", "paragraph", "normal",
                 "Three of India's six physical divisions are found in Assam: the Eastern Hills (part of the Himalayan system), "
                 "the Brahmaputra plain (part of the Northern Plains), and the Karbi Anglong hills (part of the Deccan Plateau)."),
                ("exam1", "fact_box", "exam_fact",
                 "Remember for exams: 2 neighbouring countries (Bhutan, Bangladesh) and 7 neighbouring states."),
            ],
            "as": [
                ("p1", "paragraph", "normal",
                 "অসম উত্তৰ-পূব ভাৰতত, প্ৰায় ২৪° ৰ পৰা ২৮° উত্তৰ অক্ষাংশ আৰু ৯০° ৰ পৰা ৯৬° পূব দ্ৰাঘিমাংশৰ মাজত অৱস্থিত।"),
                ("h1", "heading", "normal", "চাৰিওফালৰ চুবুৰীয়াসকল"),
                ("l1", "list", "geography",
                 "উত্তৰে: ভূটান আৰু অৰুণাচল প্ৰদেশ\n"
                 "পূবে: নাগালেণ্ড আৰু মণিপুৰ\n"
                 "দক্ষিণে: মেঘালয়, ত্ৰিপুৰা, মিজোৰাম আৰু বাংলাদেশ\n"
                 "পশ্চিমে: পশ্চিমবংগ"),
                ("p2", "paragraph", "normal",
                 "অসমৰ দুখন দেশৰ সৈতে {{term:international-border|আন্তঃৰাষ্ট্ৰীয় সীমা}} আছে, ভূটান আৰু বাংলাদেশ, "
                 "আৰু ভাৰতৰ সাতখন ৰাজ্যৰ সৈতে সীমা আছে। ছিকিমৰ বাহিৰে উত্তৰ-পূবৰ আন সকলো ৰাজ্যৰ সৈতে অসমৰ সীমা লাগি আছে।"),
                ("p3", "paragraph", "normal",
                 "পশ্চিমবংগৰ এক ঠেক ভূখণ্ড {{term:siliguri-corridor|শিলিগুৰি কৰিডৰৰ}} জৰিয়তে অসম আৰু উত্তৰ-পূব ভাৰত "
                 "দেশৰ বাকী অংশৰ সৈতে সংযুক্ত হৈ আছে।"),
                ("p4", "paragraph", "normal",
                 "ভাৰতৰ ছটা প্ৰাকৃতিক বিভাগৰ তিনিটা অসমত পোৱা যায়: পূবৰ পাহাৰীয়া অঞ্চল (হিমালয় প্ৰণালীৰ অংশ), "
                 "ব্ৰহ্মপুত্ৰৰ সমভূমি (উত্তৰৰ সমভূমিৰ অংশ), আৰু কাৰ্বি আংলঙৰ পাহাৰ (দাক্ষিণাত্য মালভূমিৰ অংশ)।"),
                ("exam1", "fact_box", "exam_fact",
                 "পৰীক্ষাৰ বাবে মনত ৰাখক: ২ খন চুবুৰীয়া দেশ (ভূটান, বাংলাদেশ) আৰু ৭ খন চুবুৰীয়া ৰাজ্য।"),
            ],
        },
    ),
    # ------------------------------------------------------------------ 5
    dict(
        slug="formation-of-assam", position=5,
        title={"en": "How the present state was formed", "as": "বৰ্তমানৰ অসম ৰাজ্য কেনেকৈ গঠন হ'ল"},
        summary={"en": "From the Treaty of Yandabo in 1826 to the new states carved out of Assam.",
                 "as": "১৮২৬ চনৰ ইয়াণ্ডাবুৰ সন্ধিৰ পৰা অসমৰ পৰা নতুন ৰাজ্য গঠনলৈ।"},
        sources="\n".join([SRC_WIKI,
                           "Mizoram, Wikipedia: https://en.wikipedia.org/wiki/Mizoram",
                           "Arunachal Pradesh, Wikipedia: https://en.wikipedia.org/wiki/Arunachal_Pradesh",
                           "Dispur, Wikipedia: https://en.wikipedia.org/wiki/Dispur",
                           "TO VERIFY before publishing: the timeline line saying Shillong was the capital from 1874."]),
        blocks={
            "en": [
                ("p1", "paragraph", "normal",
                 "The Burmese occupied Assam in the early 19th century. The {{term:treaty-of-yandabo|Treaty of Yandabo}} of 1826 "
                 "ended this, and the British East India Company took control of Assam. Over the following years the British "
                 "took over the whole region."),
                ("h1", "heading", "normal", "Timeline"),
                ("l1", "list", "event",
                 "1826: Treaty of Yandabo; Assam comes under British control.\n"
                 "1874: Assam is separated from Bengal and becomes a {{term:chief-commissioner-province|Chief Commissioner's province}}, with Shillong as its capital.\n"
                 "1905: After the Partition of Bengal, Assam becomes part of the new province of Eastern Bengal and Assam.\n"
                 "1912: Assam becomes a separate province again.\n"
                 "1937: The Assam Legislative Assembly is formed, in Shillong.\n"
                 "1947: At Partition, most of Sylhet district goes to East Pakistan after a {{term:referendum}}. The Karimganj sub-division stays in Assam.\n"
                 "1950: Assam becomes a state of the Republic of India (26 January 1950).\n"
                 "1963: The Naga Hills district becomes the state of Nagaland.\n"
                 "1970: Meghalaya becomes an autonomous state within Assam.\n"
                 "1972: Meghalaya becomes a full state (21 January 1972). Mizoram and Arunachal Pradesh (then NEFA) are separated as {{term:union-territory|Union Territories}}.\n"
                 "1973: The capital moves from Shillong to Dispur.\n"
                 "1987: Mizoram and Arunachal Pradesh become full states."),
                ("p2", "paragraph", "normal",
                 "So the four states of Nagaland, Meghalaya, Mizoram and Arunachal Pradesh were all once part of Assam."),
                ("exam1", "fact_box", "exam_fact",
                 "Remember for exams: 1874 separate province; 1963 Nagaland; 1972 Meghalaya; 1987 Mizoram and Arunachal Pradesh."),
            ],
            "as": [
                ("p1", "paragraph", "normal",
                 "ঊনবিংশ শতিকাৰ আৰম্ভণিতে মানে (বৰ্মীসকলে) অসম অধিকাৰ কৰিছিল। ১৮২৬ চনৰ {{term:treaty-of-yandabo|ইয়াণ্ডাবুৰ সন্ধিয়ে}} "
                 "ইয়াৰ অন্ত পেলায় আৰু ব্ৰিটিছ ইষ্ট ইণ্ডিয়া কোম্পানীয়ে অসমৰ শাসনভাৰ লয়। পৰৱৰ্তী বছৰবোৰত ব্ৰিটিছে গোটেই অঞ্চলটো দখল কৰে।"),
                ("h1", "heading", "normal", "সময়ৰেখা"),
                ("l1", "list", "event",
                 "১৮২৬: ইয়াণ্ডাবুৰ সন্ধি; অসম ব্ৰিটিছৰ অধীনলৈ আহে।\n"
                 "১৮৭৪: অসমক বংগৰ পৰা পৃথক কৰি শ্বিলঙক ৰাজধানী হিচাপে লৈ এখন {{term:chief-commissioner-province|চিফ কমিছনাৰৰ প্ৰদেশ}} গঠন কৰা হয়।\n"
                 "১৯০৫: বংগ বিভাজনৰ পিছত অসম নতুন 'পূব বংগ আৰু অসম' প্ৰদেশৰ অংশ হয়।\n"
                 "১৯১২: অসম পুনৰ পৃথক প্ৰদেশ হয়।\n"
                 "১৯৩৭: শ্বিলঙত অসম বিধানসভা গঠন হয়।\n"
                 "১৯৪৭: দেশ বিভাজনৰ সময়ত এখন {{term:referendum|গণভোটৰ}} পিছত শ্ৰীহট্ট (চিলেট) জিলাৰ বেছিভাগ অংশ পূব পাকিস্তানলৈ যায়। কৰিমগঞ্জ মহকুমা অসমতে থাকে।\n"
                 "১৯৫০: অসম ভাৰতীয় গণৰাজ্যৰ এখন ৰাজ্য হয় (২৬ জানুৱাৰী ১৯৫০)।\n"
                 "১৯৬৩: নগা পাহাৰ জিলা নাগালেণ্ড ৰাজ্য হয়।\n"
                 "১৯৭০: মেঘালয় অসমৰ ভিতৰত এখন স্বায়ত্তশাসিত ৰাজ্য হয়।\n"
                 "১৯৭২: মেঘালয় পূৰ্ণ ৰাজ্য হয় (২১ জানুৱাৰী ১৯৭২)। মিজোৰাম আৰু অৰুণাচল প্ৰদেশক (তেতিয়াৰ নেফা) {{term:union-territory|কেন্দ্ৰীয় শাসিত অঞ্চল}} হিচাপে পৃথক কৰা হয়।\n"
                 "১৯৭৩: ৰাজধানী শ্বিলঙৰ পৰা দিশপুৰলৈ স্থানান্তৰ হয়।\n"
                 "১৯৮৭: মিজোৰাম আৰু অৰুণাচল প্ৰদেশ পূৰ্ণ ৰাজ্য হয়।"),
                ("p2", "paragraph", "normal",
                 "এইদৰে নাগালেণ্ড, মেঘালয়, মিজোৰাম আৰু অৰুণাচল প্ৰদেশ, এই চাৰিখন ৰাজ্য এসময়ত অসমৰে অংশ আছিল।"),
                ("exam1", "fact_box", "exam_fact",
                 "পৰীক্ষাৰ বাবে মনত ৰাখক: ১৮৭৪ পৃথক প্ৰদেশ; ১৯৬৩ নাগালেণ্ড; ১৯৭২ মেঘালয়; ১৯৮৭ মিজোৰাম আৰু অৰুণাচল প্ৰদেশ।"),
            ],
        },
    ),
]
