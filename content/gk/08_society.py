"""Group 8: Society and Demography (সমাজ আৰু জনগাঁথনি).

Block format: (block_key, block_type, style, body). Keys must match in both languages.
"""

CATEGORY_SLUG = "society"
CATEGORY_NAME = "Society and Demography"
LAST_CHECKED = "2026-11-24"

EXISTING_TERMS = {"census", "sex-ratio", "literacy-rate", "population-density", "sixth-schedule"}

W = "https://en.wikipedia.org/wiki/"
SRC_DEMO = f"Demographics of Assam, Wikipedia: {W}Demographics_of_Assam"
SRC_LANG = f"Languages of Assam, Wikipedia: {W}Languages_of_Assam"
SRC_EDU = f"List of institutions of higher education in Assam, Wikipedia: {W}List_of_institutions_of_higher_education_in_Assam"
SRC_GLANCE = ("Assam at a Glance 2025, Directorate of Economics and Statistics, Government of Assam: "
              "https://des.assam.gov.in/sites/default/files/swf_utility_folder/departments/ecostat_medhassu_in_oid_3/this_comm/assam_at_a_glance_-_2025.pdf")

TERMS = [
    dict(slug="scheduled-tribe", en="Scheduled Tribe (ST)", **{"as": "অনুসূচীত জনজাতি"},
         meaning_en="A tribal community listed in the Constitution for special protection and reservation.",
         meaning_as="বিশেষ সুৰক্ষা আৰু সংৰক্ষণৰ বাবে সংবিধানত তালিকাভুক্ত জনজাতীয় সম্প্ৰদায়।"),
    dict(slug="scheduled-caste", en="Scheduled Caste (SC)", **{"as": "অনুসূচীত জাতি"},
         meaning_en="A community listed in the Constitution that faced social discrimination in the past and gets special protection and reservation.",
         meaning_as="অতীতত সামাজিক বৈষম্যৰ সন্মুখীন হোৱা, সংবিধানত তালিকাভুক্ত আৰু বিশেষ সুৰক্ষা আৰু সংৰক্ষণ পোৱা সম্প্ৰদায়।"),
    dict(slug="mother-tongue", en="Mother tongue", **{"as": "মাতৃভাষা"},
         meaning_en="The first language a person learns at home as a child.",
         meaning_as="শৈশৱতে ঘৰত প্ৰথমে শিকা ভাষা।"),
    dict(slug="official-language", en="Official language", **{"as": "চৰকাৰী ভাষা"},
         meaning_en="A language that the government uses for its work, laws and records.",
         meaning_as="চৰকাৰে নিজৰ কাম-কাজ, আইন আৰু নথি-পত্ৰত ব্যৱহাৰ কৰা ভাষা।"),
    dict(slug="central-university", en="Central university", **{"as": "কেন্দ্ৰীয় বিশ্ববিদ্যালয়"},
         meaning_en="A university set up and funded by the Government of India through an Act of Parliament.",
         meaning_as="সংসদৰ আইনৰ জৰিয়তে ভাৰত চৰকাৰে স্থাপন আৰু পুঁজিৰ যোগান ধৰা বিশ্ববিদ্যালয়।"),
    dict(slug="state-university", en="State university", **{"as": "ৰাজ্যিক বিশ্ববিদ্যালয়"},
         meaning_en="A university set up and funded by the state government.",
         meaning_as="ৰাজ্য চৰকাৰে স্থাপন আৰু পুঁজিৰ যোগান ধৰা বিশ্ববিদ্যালয়।"),
]

CHAPTERS = [
    # ------------------------------------------------------------------ 1
    dict(
        slug="population-census-2011", position=1,
        title={"en": "Population (Census 2011)", "as": "জনসংখ্যা (লোকপিয়ল ২০১১)"},
        summary={"en": "How many people live in Assam, and the religious make-up of the state.",
                 "as": "অসমত কিমান মানুহ বাস কৰে, আৰু ৰাজ্যখনৰ ধৰ্মীয় গাঁথনি।"},
        sources="\n".join([SRC_GLANCE, SRC_DEMO,
                           "TO VERIFY before publishing: the ST (12.45%) and SC (7.15%) shares in p3."]),
        blocks={
            "en": [
                ("p1", "paragraph", "verified_fact",
                 "According to the {{term:census}} of 2011, Assam has 3,12,05,576 people, with a {{term:population-density|density}} of 398 per sq km, "
                 "a {{term:sex-ratio|sex ratio}} of 958 and a {{term:literacy-rate|literacy rate}} of 72.19%. About 86 percent of people live in villages."),
                ("h1", "heading", "normal", "Religion (Census 2011)"),
                ("l1", "list", "verified_fact",
                 "Hindu: 61.47% (1,91,80,759 people)\nMuslim: 34.22% (1,06,79,345)\nChristian: 3.74% (11,65,867)\n"
                 "Buddhist: 0.18%; Jain: 0.08%; Sikh: 0.07%"),
                ("img1", "image", "normal",
                 "Chart: religions in Assam by share of people (Census of India 2011).",
                 "charts/religion-2011.png"),
                ("p2", "paragraph", "normal",
                 "Christians in Assam are found mostly among the tribal communities."),
                ("p3", "paragraph", "normal",
                 "{{term:scheduled-tribe|Scheduled Tribes}} make up about 12.45% and {{term:scheduled-caste|Scheduled Castes}} about 7.15% of the population."),
                ("exam1", "fact_box", "exam_fact",
                 "Remember for exams: population 3,12,05,576; Hindus 61.47%, Muslims 34.22% (Census 2011)."),
            ],
            "as": [
                ("p1", "paragraph", "verified_fact",
                 "২০১১ চনৰ {{term:census|লোকপিয়ল}} অনুসৰি অসমৰ জনসংখ্যা ৩,১২,০৫,৫৭৬; {{term:population-density|জনসংখ্যাৰ ঘনত্ব}} প্ৰতি বৰ্গ কিমিত ৩৯৮, "
                 "{{term:sex-ratio|লিংগ অনুপাত}} ৯৫৮ আৰু {{term:literacy-rate|সাক্ষৰতাৰ হাৰ}} ৭২.১৯%। প্ৰায় ৮৬ শতাংশ মানুহ গাঁৱত বাস কৰে।"),
                ("h1", "heading", "normal", "ধৰ্ম (লোকপিয়ল ২০১১)"),
                ("l1", "list", "verified_fact",
                 "হিন্দু: ৬১.৪৭% (১,৯১,৮০,৭৫৯ জন)\nমুছলমান: ৩৪.২২% (১,০৬,৭৯,৩৪৫)\nখ্ৰীষ্টান: ৩.৭৪% (১১,৬৫,৮৬৭)\n"
                 "বৌদ্ধ: ০.১৮%; জৈন: ০.০৮%; শিখ: ০.০৭%"),
                ("img1", "image", "normal",
                 "চিত্ৰ: অসমৰ ধৰ্ম অনুসৰি জনসংখ্যাৰ অংশ (ভাৰতৰ লোকপিয়ল ২০১১)।",
                 "charts/religion-2011.png"),
                ("p2", "paragraph", "normal",
                 "অসমৰ খ্ৰীষ্টানসকল বেছিভাগেই জনজাতীয় সম্প্ৰদায়ৰ মাজত আছে।"),
                ("p3", "paragraph", "normal",
                 "জনসংখ্যাৰ প্ৰায় ১২.৪৫% {{term:scheduled-tribe|অনুসূচীত জনজাতি}} আৰু প্ৰায় ৭.১৫% {{term:scheduled-caste|অনুসূচীত জাতি}}।"),
                ("exam1", "fact_box", "exam_fact",
                 "পৰীক্ষাৰ বাবে মনত ৰাখক: জনসংখ্যা ৩,১২,০৫,৫৭৬; হিন্দু ৬১.৪৭%, মুছলমান ৩৪.২২% (লোকপিয়ল ২০১১)।"),
            ],
        },
    ),
    # ------------------------------------------------------------------ 2
    dict(
        slug="communities-of-assam", position=2,
        title={"en": "Communities and tribes of Assam", "as": "অসমৰ জনগোষ্ঠী আৰু জনজাতিসমূহ"},
        summary={"en": "The many peoples of Assam, in the plains and the hills.",
                 "as": "সমভূমি আৰু পাহাৰৰ অসমৰ বহুতো জনগোষ্ঠী।"},
        sources="\n".join([SRC_DEMO, f"Sixth Schedule to the Constitution of India, Wikipedia: {W}Sixth_Schedule_to_the_Constitution_of_India",
                           "TO VERIFY before publishing: p2 (Tiwa and Sonowal Kachari in the list, and Bodos as the largest plains tribe)."]),
        blocks={
            "en": [
                ("p1", "paragraph", "normal",
                 "Assam is home to many communities with their own languages, festivals and dress. This is why it is often called a meeting place of cultures."),
                ("h1", "heading", "normal", "Tribal communities"),
                ("p2", "paragraph", "normal",
                 "Major {{term:scheduled-tribe|tribal communities}} include the Bodo, Mising, Karbi, Rabha, Dimasa, Tiwa, Deori and Sonowal Kachari. "
                 "The Bodos are the largest plains tribe, and the Karbis and Dimasas live mainly in the hill districts."),
                ("p3", "paragraph", "normal",
                 "Tribal areas in the hills and in Bodoland have self-government under the {{term:sixth-schedule|Sixth Schedule}}."),
                ("h2", "heading", "normal", "Other communities"),
                ("p4", "paragraph", "normal",
                 "Other important groups include the Ahoms, the Koch-Rajbongshis, the Tea tribes (Adivasi) who came to work in the tea gardens, "
                 "the Assamese Muslims, and the Bengali-speaking people of the Barak Valley."),
                ("exam1", "fact_box", "exam_fact",
                 "Remember for exams: the Bodos are the largest plains tribe of Assam; Karbis and Dimasas live mainly in the hills."),
            ],
            "as": [
                ("p1", "paragraph", "normal",
                 "অসম নিজা ভাষা, উৎসৱ আৰু সাজ-পাৰ থকা বহুতো জনগোষ্ঠীৰ ঘৰ। সেইবাবেই ইয়াক প্ৰায়ে বিভিন্ন সংস্কৃতিৰ মিলনভূমি বুলি কোৱা হয়।"),
                ("h1", "heading", "normal", "জনজাতীয় সম্প্ৰদায়"),
                ("p2", "paragraph", "normal",
                 "প্ৰধান {{term:scheduled-tribe|জনজাতীয় সম্প্ৰদায়ৰ}} ভিতৰত আছে বড়ো, মিচিং, কাৰ্বি, ৰাভা, ডিমাচা, তিৱা, দেউৰী আৰু সোণোৱাল কছাৰী। "
                 "বড়োসকল আটাইতকৈ ডাঙৰ সমভূমিৰ জনজাতি, আৰু কাৰ্বি আৰু ডিমাচাসকল মূলতঃ পাহাৰীয়া জিলাত বাস কৰে।"),
                ("p3", "paragraph", "normal",
                 "পাহাৰ আৰু বড়োলেণ্ডৰ জনজাতীয় অঞ্চলসমূহে {{term:sixth-schedule|ষষ্ঠ অনুসূচীৰ}} অধীনত স্বায়ত্তশাসন লাভ কৰিছে।"),
                ("h2", "heading", "normal", "অন্যান্য জনগোষ্ঠী"),
                ("p4", "paragraph", "normal",
                 "আন গুৰুত্বপূৰ্ণ গোটসমূহৰ ভিতৰত আছে আহোম, কোচ-ৰাজবংশী, চাহ বাগিচাত কাম কৰিবলৈ অহা চাহ জনগোষ্ঠী (আদিবাসী), "
                 "অসমীয়া মুছলমান, আৰু বৰাক উপত্যকাৰ বাংলাভাষী লোকসকল।"),
                ("exam1", "fact_box", "exam_fact",
                 "পৰীক্ষাৰ বাবে মনত ৰাখক: বড়োসকল অসমৰ আটাইতকৈ ডাঙৰ সমভূমিৰ জনজাতি; কাৰ্বি আৰু ডিমাচাসকল মূলতঃ পাহাৰত থাকে।"),
            ],
        },
    ),
    # ------------------------------------------------------------------ 3
    dict(
        slug="languages-of-assam", position=3,
        title={"en": "Languages of Assam", "as": "অসমৰ ভাষাসমূহ"},
        summary={"en": "The official languages of Assam and how many people speak each language.",
                 "as": "অসমৰ চৰকাৰী ভাষা আৰু কোনটো ভাষা কিমান মানুহে কয়।"},
        sources="\n".join([SRC_LANG, SRC_DEMO,
                           "TO VERIFY before publishing: p2 (Assam Official Language Act, 1960)."]),
        blocks={
            "en": [
                ("p1", "paragraph", "normal",
                 "Assamese is the main language of Assam. Assamese and Bodo are {{term:official-language|official languages}} of the state, "
                 "and Bengali is an official language in the districts of the Barak Valley."),
                ("p2", "paragraph", "normal",
                 "Assamese was made the official language by the Assam Official Language Act of 1960."),
                ("h1", "heading", "normal", "Mother tongues (Census 2011)"),
                ("l1", "list", "verified_fact",
                 "Assamese: 1,50,97,257 people (48.38%)\nBengali: 90,24,652\nBodo: 14,07,371\nOther languages: 22,34,319"),
                ("p3", "paragraph", "normal",
                 "Counting people who speak it as a second language, more than 71 percent of the people of Assam speak Assamese. "
                 "Assamese is written in the Assamese script."),
                ("exam1", "fact_box", "exam_fact",
                 "Remember for exams: Assamese is the {{term:mother-tongue|mother tongue}} of 48.38% of people (2011); Bodo is also an official language."),
            ],
            "as": [
                ("p1", "paragraph", "normal",
                 "অসমীয়া অসমৰ প্ৰধান ভাষা। অসমীয়া আৰু বড়ো ৰাজ্যখনৰ {{term:official-language|চৰকাৰী ভাষা}}, "
                 "আৰু বৰাক উপত্যকাৰ জিলাসমূহত বাংলা চৰকাৰী ভাষা।"),
                ("p2", "paragraph", "normal",
                 "১৯৬০ চনৰ অসম ৰাজ্যিক ভাষা আইনৰ দ্বাৰা অসমীয়াক চৰকাৰী ভাষাৰ মৰ্যাদা দিয়া হয়।"),
                ("h1", "heading", "normal", "মাতৃভাষা (লোকপিয়ল ২০১১)"),
                ("l1", "list", "verified_fact",
                 "অসমীয়া: ১,৫০,৯৭,২৫৭ জন (৪৮.৩৮%)\nবাংলা: ৯০,২৪,৬৫২\nবড়ো: ১৪,০৭,৩৭১\nঅন্যান্য ভাষা: ২২,৩৪,৩১৯"),
                ("p3", "paragraph", "normal",
                 "দ্বিতীয় ভাষা হিচাপে কোৱাসকলক ধৰিলে অসমৰ ৭১ শতাংশতকৈ অধিক মানুহে অসমীয়া কয়। "
                 "অসমীয়া ভাষা অসমীয়া লিপিত লিখা হয়।"),
                ("exam1", "fact_box", "exam_fact",
                 "পৰীক্ষাৰ বাবে মনত ৰাখক: ৪৮.৩৮% মানুহৰ {{term:mother-tongue|মাতৃভাষা}} অসমীয়া (২০১১); বড়োও চৰকাৰী ভাষা।"),
            ],
        },
    ),
    # ------------------------------------------------------------------ 4
    dict(
        slug="education-institutions", position=4,
        title={"en": "Education: universities and institutions", "as": "শিক্ষা: বিশ্ববিদ্যালয় আৰু অনুষ্ঠান"},
        summary={"en": "The main universities and institutes of Assam, with the year each was founded.",
                 "as": "অসমৰ প্ৰধান বিশ্ববিদ্যালয় আৰু অনুষ্ঠানসমূহ, আৰু প্ৰতিখন প্ৰতিষ্ঠাৰ বছৰ।"},
        sources=SRC_EDU,
        blocks={
            "en": [
                ("p1", "paragraph", "normal",
                 "Assam has a mix of {{term:state-university|state universities}}, {{term:central-university|central universities}} and national institutes. "
                 "These are the ones most often asked about, with their founding year:"),
                ("l1", "list", "verified_fact",
                 "Cotton College (now Cotton University), Guwahati: 1901\n"
                 "Gauhati University, Guwahati: 1948\n"
                 "Dibrugarh University, Dibrugarh: 1965\n"
                 "Assam Agricultural University, Jorhat: 1969\n"
                 "Tezpur University (central), Tezpur: 1994\n"
                 "Assam University (central), Silchar: 1994\n"
                 "IIT Guwahati: 1994\n"
                 "Krishna Kanta Handiqui State Open University, Guwahati: 2007\n"
                 "AIIMS Guwahati: 2021"),
                ("p2", "paragraph", "normal",
                 "Assam's two central universities are Tezpur University and Assam University, Silchar, both set up in 1994."),
                ("exam1", "fact_box", "exam_fact",
                 "Remember for exams: Gauhati University 1948; central universities Tezpur and Silchar (1994); IIT Guwahati 1994."),
            ],
            "as": [
                ("p1", "paragraph", "normal",
                 "অসমত {{term:state-university|ৰাজ্যিক বিশ্ববিদ্যালয়}}, {{term:central-university|কেন্দ্ৰীয় বিশ্ববিদ্যালয়}} আৰু ৰাষ্ট্ৰীয় প্ৰতিষ্ঠান আছে। "
                 "পৰীক্ষাত সঘনাই সোধা কেইখনমান, প্ৰতিষ্ঠাৰ বছৰৰ সৈতে:"),
                ("l1", "list", "verified_fact",
                 "কটন কলেজ (বৰ্তমান কটন বিশ্ববিদ্যালয়), গুৱাহাটী: ১৯০১\n"
                 "গুৱাহাটী বিশ্ববিদ্যালয়, গুৱাহাটী: ১৯৪৮\n"
                 "ডিব্ৰুগড় বিশ্ববিদ্যালয়, ডিব্ৰুগড়: ১৯৬৫\n"
                 "অসম কৃষি বিশ্ববিদ্যালয়, যোৰহাট: ১৯৬৯\n"
                 "তেজপুৰ বিশ্ববিদ্যালয় (কেন্দ্ৰীয়), তেজপুৰ: ১৯৯৪\n"
                 "আসাম বিশ্ববিদ্যালয় (কেন্দ্ৰীয়), শিলচৰ: ১৯৯৪\n"
                 "আই আই টি গুৱাহাটী: ১৯৯৪\n"
                 "কৃষ্ণকান্ত সন্দিকৈ ৰাজ্যিক মুক্ত বিশ্ববিদ্যালয়, গুৱাহাটী: ২০০৭\n"
                 "এইমছ গুৱাহাটী: ২০২১"),
                ("p2", "paragraph", "normal",
                 "অসমৰ দুখন কেন্দ্ৰীয় বিশ্ববিদ্যালয় হ'ল তেজপুৰ বিশ্ববিদ্যালয় আৰু শিলচৰৰ আসাম বিশ্ববিদ্যালয়, দুয়োখন ১৯৯৪ চনত স্থাপিত।"),
                ("exam1", "fact_box", "exam_fact",
                 "পৰীক্ষাৰ বাবে মনত ৰাখক: গুৱাহাটী বিশ্ববিদ্যালয় ১৯৪৮; কেন্দ্ৰীয় বিশ্ববিদ্যালয় তেজপুৰ আৰু শিলচৰ (১৯৯৪); আই আই টি গুৱাহাটী ১৯৯৪।"),
            ],
        },
    ),
]
