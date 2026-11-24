"""Group 12: Important Places and Tourism (গুৰুত্বপূৰ্ণ স্থান আৰু পৰ্যটন)."""

CATEGORY_SLUG = "places"
CATEGORY_NAME = "Important Places and Tourism"
LAST_CHECKED = "2026-11-24"

EXISTING_TERMS = {"river-island", "sattra", "rasaraj"}

W = "https://en.wikipedia.org/wiki/"

TERMS = [
    dict(slug="shakti-peetha", en="Shakti Peetha", **{"as": "শক্তিপীঠ"},
         meaning_en="A holy site of the goddess Shakti. Kamakhya is one of the most important of them.",
         meaning_as="শক্তি দেৱীৰ পবিত্ৰ তীৰ্থস্থান। কামাখ্যা তাৰে অন্যতম গুৰুত্বপূৰ্ণ।"),
    dict(slug="ambubachi-mela", en="Ambubachi Mela", **{"as": "অম্বুবাচী মেলা"},
         meaning_en="The yearly festival at Kamakhya Temple, attended by large numbers of pilgrims.",
         meaning_as="কামাখ্যা মন্দিৰত প্ৰতি বছৰে হোৱা মেলা, য'ত বহুসংখ্যক তীৰ্থযাত্ৰী সমাগম হয়।"),
    dict(slug="erosion", en="Erosion", **{"as": "খহনীয়া"},
         meaning_en="The wearing away of land by river water. It has made Majuli much smaller.",
         meaning_as="নদীৰ পানীয়ে মাটি খহাই নিয়া প্ৰক্ৰিয়া। ইয়াৰ ফলত মাজুলী বহুত সৰু হৈছে।"),
    dict(slug="dol", en="Dol", **{"as": "দ'ল"},
         meaning_en="A temple built in the Ahom period, such as the Shiva Dol at Sivasagar.",
         meaning_as="আহোম যুগত নিৰ্মিত মন্দিৰ, যেনে শিৱসাগৰৰ শিৱদ'ল।"),
    dict(slug="pilgrimage", en="Pilgrimage", **{"as": "তীৰ্থযাত্ৰা"},
         meaning_en="A journey to a holy place for religious reasons.",
         meaning_as="ধৰ্মীয় কাৰণত পবিত্ৰ স্থানলৈ কৰা যাত্ৰা।"),
]

CHAPTERS = [
    dict(
        slug="kamakhya-temple", position=1,
        title={"en": "Kamakhya Temple", "as": "কামাখ্যা মন্দিৰ"},
        summary={"en": "The famous Shakti temple on Nilachal Hill in Guwahati.",
                 "as": "গুৱাহাটীৰ নীলাচল পাহাৰৰ বিখ্যাত শক্তি মন্দিৰ।"},
        sources=f"Kamakhya Temple, Wikipedia: {W}Kamakhya_Temple",
        blocks={
            "en": [
                ("p1", "paragraph", "heritage",
                 "The Kamakhya Temple stands on Nilachal Hill in Guwahati. It is one of the oldest and most important {{term:shakti-peetha|Shakti Peethas}} "
                 "in India, and a centre of Tantric worship."),
                ("p2", "paragraph", "event",
                 "The temple was rebuilt by the Koch king Nara Narayan, who completed the work in 1565; his brother Chilarai supervised the main temple."),
                ("p3", "paragraph", "normal",
                 "Its style, with a rounded dome on a cross-shaped base, is called the Nilachal type."),
                ("p4", "paragraph", "normal",
                 "Every year the {{term:ambubachi-mela|Ambubachi Mela}} draws pilgrims from all over India."),
                ("exam1", "fact_box", "exam_fact",
                 "Remember for exams: Kamakhya on Nilachal Hill; rebuilt by Nara Narayan in 1565; Ambubachi Mela."),
            ],
            "as": [
                ("p1", "paragraph", "heritage",
                 "কামাখ্যা মন্দিৰ গুৱাহাটীৰ নীলাচল পাহাৰত অৱস্থিত। ই ভাৰতৰ আটাইতকৈ পুৰণি আৰু গুৰুত্বপূৰ্ণ {{term:shakti-peetha|শক্তিপীঠসমূহৰ}} "
                 "এটা, আৰু তান্ত্ৰিক উপাসনাৰ কেন্দ্ৰ।"),
                ("p2", "paragraph", "event",
                 "কোচ ৰজা নৰনাৰায়ণে মন্দিৰটো পুনৰ নিৰ্মাণ কৰে আৰু ১৫৬৫ চনত কাম সম্পূৰ্ণ কৰে; তেওঁৰ ভাতৃ চিলাৰায়ে মূল মন্দিৰৰ কামৰ তত্ত্বাৱধান কৰে।"),
                ("p3", "paragraph", "normal",
                 "ক্ৰছ আকৃতিৰ ভেটিৰ ওপৰত গোলাকাৰ গম্বুজ থকা ইয়াৰ স্থাপত্য শৈলীক নীলাচল শৈলী বোলা হয়।"),
                ("p4", "paragraph", "normal",
                 "প্ৰতি বছৰে {{term:ambubachi-mela|অম্বুবাচী মেলাই}} সমগ্ৰ ভাৰতৰ পৰা তীৰ্থযাত্ৰী আকৰ্ষণ কৰে।"),
                ("exam1", "fact_box", "exam_fact",
                 "পৰীক্ষাৰ বাবে মনত ৰাখক: কামাখ্যা নীলাচল পাহাৰত; ১৫৬৫ চনত নৰনাৰায়ণে পুনৰ নিৰ্মাণ কৰে; অম্বুবাচী মেলা।"),
            ],
        },
    ),
    dict(
        slug="majuli", position=2,
        title={"en": "Majuli", "as": "মাজুলী"},
        summary={"en": "The river island of the Brahmaputra, home of the Sattras.",
                 "as": "সত্ৰৰ ঘৰ, ব্ৰহ্মপুত্ৰৰ নদী দ্বীপ।"},
        sources=f"Majuli, Wikipedia: {W}Majuli",
        blocks={
            "en": [
                ("p1", "paragraph", "geography",
                 "Majuli is a {{term:river-island|river island}} in the Brahmaputra. It is often called the largest river island in the world. "
                 "In 2016 it became the first island in India to be made a district."),
                ("p2", "paragraph", "normal",
                 "Because of {{term:erosion}}, Majuli has shrunk from about 1,255 sq km in the early 20th century to about 880 sq km in 2024."),
                ("p3", "paragraph", "heritage",
                 "Majuli is the main centre of the {{term:sattra|Sattra}} tradition started by Sankardev. Of the 65 Sattras once here, 23 are still active, "
                 "including the Garamur Sattra."),
                ("p4", "paragraph", "normal",
                 "The Mising people are the largest community on the island, making up about 41 percent of its population."),
                ("exam1", "fact_box", "exam_fact",
                 "Remember for exams: Majuli became a district in 2016, India's first island district."),
            ],
            "as": [
                ("p1", "paragraph", "geography",
                 "মাজুলী ব্ৰহ্মপুত্ৰৰ এখন {{term:river-island|নদী দ্বীপ}}। ইয়াক প্ৰায়ে পৃথিৱীৰ বৃহত্তম নদী দ্বীপ বুলি কোৱা হয়। "
                 "২০১৬ চনত ই ভাৰতৰ প্ৰথম দ্বীপ জিলা হয়।"),
                ("p2", "paragraph", "normal",
                 "{{term:erosion|খহনীয়াৰ}} ফলত বিংশ শতিকাৰ আৰম্ভণিৰ প্ৰায় ১,২৫৫ বৰ্গ কিমিৰ পৰা ২০২৪ চনত মাজুলী প্ৰায় ৮৮০ বৰ্গ কিমিলৈ সৰু হৈছে।"),
                ("p3", "paragraph", "heritage",
                 "মাজুলী শংকৰদেৱে আৰম্ভ কৰা {{term:sattra|সত্ৰ}} পৰম্পৰাৰ মূল কেন্দ্ৰ। এসময়ত ইয়াত থকা ৬৫ খন সত্ৰৰ ২৩ খন এতিয়াও সক্ৰিয়, "
                 "তাৰ ভিতৰত গড়মূৰ সত্ৰ অন্যতম।"),
                ("p4", "paragraph", "normal",
                 "মিচিং লোকসকল দ্বীপটোৰ আটাইতকৈ ডাঙৰ জনগোষ্ঠী, যিসকল ইয়াৰ জনসংখ্যাৰ প্ৰায় ৪১ শতাংশ।"),
                ("exam1", "fact_box", "exam_fact",
                 "পৰীক্ষাৰ বাবে মনত ৰাখক: ২০১৬ চনত মাজুলী জিলা হয়, ভাৰতৰ প্ৰথম দ্বীপ জিলা।"),
            ],
        },
    ),
    dict(
        slug="sivasagar-monuments", position=3,
        title={"en": "Sivasagar and its monuments", "as": "শিৱসাগৰ আৰু ইয়াৰ কীৰ্তিচিহ্নসমূহ"},
        summary={"en": "The old Ahom capital Rangpur, the great tank and the Shiva Dol.",
                 "as": "আহোমৰ পুৰণি ৰাজধানী ৰংপুৰ, বৰপুখুৰী আৰু শিৱদ'ল।"},
        sources="\n".join([f"Sivasagar, Wikipedia: {W}Sivasagar", f"Ahom kingdom, Wikipedia: {W}Ahom_kingdom", "TO VERIFY before publishing: the description of the Rang Ghar in p3 (two storeys, used to watch games)."]),
        blocks={
            "en": [
                ("p1", "paragraph", "normal",
                 "Sivasagar was once Rangpur, a capital of the Ahom kingdom in the 18th century. It is well known for its Ahom palaces and monuments."),
                ("p2", "paragraph", "heritage",
                 "The great tank of Sivasagar (Borpukhuri) was dug in 1733 by the Ahom queen Ambika Devi and covers 257 acres. "
                 "The Shiva {{term:dol}} stands on its bank, and the town takes its name from it."),
                ("p3", "paragraph", "heritage",
                 "The Rang Ghar, a two-storeyed pavilion from which Ahom kings watched games and sports, was built of brick by King Pramatta Singha (1744 to 1751)."),
                ("exam1", "fact_box", "exam_fact",
                 "Remember for exams: Sivasagar tank dug in 1733 by Queen Ambika Devi; Rang Ghar built by Pramatta Singha."),
            ],
            "as": [
                ("p1", "paragraph", "normal",
                 "শিৱসাগৰ এসময়ত ৰংপুৰ আছিল, অষ্টাদশ শতিকাত আহোম ৰাজ্যৰ এখন ৰাজধানী। ই আহোম ৰাজকাৰেং আৰু কীৰ্তিচিহ্নৰ বাবে জনাজাত।"),
                ("p2", "paragraph", "heritage",
                 "শিৱসাগৰৰ বৰপুখুৰী ১৭৩৩ চনত আহোম ৰাণী অম্বিকা দেৱীয়ে খান্দিছিল আৰু ইয়াৰ আয়তন ২৫৭ একৰ। "
                 "ইয়াৰ পাৰত শিৱ{{term:dol|দ'ল}} আছে, আৰু নগৰখনৰ নাম ইয়াৰ পৰাই আহিছে।"),
                ("p3", "paragraph", "heritage",
                 "আহোম ৰজাসকলে খেল-ধেমালি চোৱা দুমহলীয়া ৰংঘৰ ৰজা প্ৰমত্ত সিংহই (১৭৪৪ ৰ পৰা ১৭৫১) ইটাৰে নিৰ্মাণ কৰিছিল।"),
                ("exam1", "fact_box", "exam_fact",
                 "পৰীক্ষাৰ বাবে মনত ৰাখক: ১৭৩৩ চনত ৰাণী অম্বিকা দেৱীয়ে শিৱসাগৰ পুখুৰী খান্দে; প্ৰমত্ত সিংহই ৰংঘৰ নিৰ্মাণ কৰে।"),
            ],
        },
    ),
    dict(
        slug="hajo", position=4,
        title={"en": "Hajo", "as": "হাজো"},
        summary={"en": "A pilgrimage town sacred to Hindus, Buddhists and Muslims.",
                 "as": "হিন্দু, বৌদ্ধ আৰু মুছলমানৰ পবিত্ৰ তীৰ্থস্থান।"},
        sources="\n".join([f"Hajo, Wikipedia: {W}Hajo", "TO VERIFY before publishing: the 'quarter of a Mecca pilgrimage' belief in l1."]),
        blocks={
            "en": [
                ("p1", "paragraph", "normal",
                 "Hajo is a town in Kamrup district, about 25 km northwest of Guwahati on the Brahmaputra. It is a meeting point of Hindus, Buddhists and Muslims, "
                 "and an important place of {{term:pilgrimage}}."),
                ("l1", "list", "heritage",
                 "Hayagriva Madhava Temple, on Monikut hill: the present temple was built by King Raghudev Narayan in 1583. Buddhists also visit it.\n"
                 "Poa Mecca, on Garurachal hill: holds the tomb of Giyasuddin Aulia. Muslims believe a visit here gives a quarter (poa) of the blessing of a pilgrimage to Mecca."),
                ("exam1", "fact_box", "exam_fact",
                 "Remember for exams: Hajo, Kamrup district; Hayagriva Madhava Temple (1583); Poa Mecca."),
            ],
            "as": [
                ("p1", "paragraph", "normal",
                 "হাজো কামৰূপ জিলাৰ এখন নগৰ, ব্ৰহ্মপুত্ৰৰ পাৰত গুৱাহাটীৰ প্ৰায় ২৫ কিমি উত্তৰ-পশ্চিমে। ই হিন্দু, বৌদ্ধ আৰু মুছলমানৰ মিলনস্থল, "
                 "আৰু এক গুৰুত্বপূৰ্ণ {{term:pilgrimage|তীৰ্থস্থান}}।"),
                ("l1", "list", "heritage",
                 "মণিকূট পাহাৰৰ হয়গ্ৰীৱ মাধৱ মন্দিৰ: বৰ্তমানৰ মন্দিৰটো ১৫৮৩ চনত ৰজা ৰঘুদেৱ নাৰায়ণে নিৰ্মাণ কৰে। বৌদ্ধসকলেও ইয়ালৈ আহে।\n"
                 "গৰুড়াচল পাহাৰৰ পোৱামক্কা: ইয়াত গিয়াছুদ্দিন আউলিয়াৰ মাজাৰ আছে। মুছলমানসকলে বিশ্বাস কৰে যে ইয়ালৈ অহাৰ ফলত মক্কা যাত্ৰাৰ এক পোৱা পুণ্য লাভ হয়।"),
                ("exam1", "fact_box", "exam_fact",
                 "পৰীক্ষাৰ বাবে মনত ৰাখক: হাজো, কামৰূপ জিলা; হয়গ্ৰীৱ মাধৱ মন্দিৰ (১৫৮৩); পোৱামক্কা।"),
            ],
        },
    ),
    dict(
        slug="tezpur", position=5,
        title={"en": "Tezpur", "as": "তেজপুৰ"},
        summary={"en": "The city of Usha and Aniruddha, with Agnigarh and the Da Parbatia temple ruins.",
                 "as": "উষা আৰু অনিৰুদ্ধৰ নগৰ, অগ্নিগড় আৰু দহপৰ্বতীয়াৰ মন্দিৰৰ ধ্বংসাৱশেষ।"},
        sources="\n".join([f"Tezpur, Wikipedia: {W}Tezpur",
                           "TO VERIFY before publishing: the meaning 'city of blood' in p1, and 'one of the oldest pieces of sculpture in Assam' in p3."]),
        blocks={
            "en": [
                ("p1", "paragraph", "normal",
                 "Tezpur is a city in Sonitpur district on the north bank of the Brahmaputra, about 175 km northeast of Guwahati. "
                 "Its name is often explained as 'city of blood', from a legend about a great battle here."),
                ("p2", "paragraph", "heritage",
                 "The legend tells of Usha, daughter of the Asura king Banasura, and her love for Aniruddha, grandson of Krishna. "
                 "Agnigarh, a hillock on the river bank, is said to be where Usha was kept, surrounded by fire."),
                ("p3", "paragraph", "heritage",
                 "At Da Parbatia, near Tezpur, a stone door frame from a temple of about the 6th century was dug up in 1924. It is one of the oldest pieces of sculpture in Assam."),
                ("p4", "paragraph", "normal",
                 "Jyoti Prasad Agarwala lived and died in Tezpur. The Kolia Bhomora Setu links Tezpur with the south bank."),
                ("exam1", "fact_box", "exam_fact",
                 "Remember for exams: Tezpur, Agnigarh (Usha-Aniruddha legend); Da Parbatia door frame (6th century)."),
            ],
            "as": [
                ("p1", "paragraph", "normal",
                 "তেজপুৰ ব্ৰহ্মপুত্ৰৰ উত্তৰ পাৰৰ শোণিতপুৰ জিলাৰ এখন নগৰ, গুৱাহাটীৰ প্ৰায় ১৭৫ কিমি উত্তৰ-পূবে। "
                 "ইয়াত হোৱা এক ভয়ংকৰ যুদ্ধৰ কাহিনীৰ পৰা ইয়াৰ নামৰ অৰ্থ প্ৰায়ে 'তেজৰ নগৰ' বুলি ব্যাখ্যা কৰা হয়।"),
                ("p2", "paragraph", "heritage",
                 "কাহিনীটো অসুৰ ৰজা বাণাসুৰৰ কন্যা উষা আৰু কৃষ্ণৰ নাতি অনিৰুদ্ধৰ প্ৰেমৰ। "
                 "নদীৰ পাৰৰ টিলা অগ্নিগড়তে জুইৰে আগুৰি উষাক ৰখা হৈছিল বুলি কোৱা হয়।"),
                ("p3", "paragraph", "heritage",
                 "তেজপুৰৰ ওচৰৰ দহপৰ্বতীয়াত ১৯২৪ চনত প্ৰায় ষষ্ঠ শতিকাৰ এটা মন্দিৰৰ শিলৰ দুৱাৰমুখ খান্দি উলিওৱা হয়। ই অসমৰ আটাইতকৈ পুৰণি ভাস্কৰ্যসমূহৰ এটা।"),
                ("p4", "paragraph", "normal",
                 "জ্যোতিপ্ৰসাদ আগৰৱালাই তেজপুৰত বাস কৰিছিল আৰু তাতেই তেওঁৰ মৃত্যু হয়। কলীয়াভোমোৰা সেতুৱে তেজপুৰক দক্ষিণ পাৰৰ সৈতে সংযোগ কৰে।"),
                ("exam1", "fact_box", "exam_fact",
                 "পৰীক্ষাৰ বাবে মনত ৰাখক: তেজপুৰ, অগ্নিগড় (উষা-অনিৰুদ্ধৰ কাহিনী); দহপৰ্বতীয়াৰ দুৱাৰমুখ (ষষ্ঠ শতিকা)।"),
            ],
        },
    ),
]
