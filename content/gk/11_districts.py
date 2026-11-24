"""Group 11: District-wise Assam GK (জিলাভিত্তিক অসমৰ সাধাৰণ জ্ঞান). Overview chapter; one page per district comes later."""

CATEGORY_SLUG = "districts"
CATEGORY_NAME = "District-wise Assam GK"
LAST_CHECKED = "2026-11-24"

EXISTING_TERMS = {"river-island", "sub-division"}

W = "https://en.wikipedia.org/wiki/"

TERMS = [
    dict(slug="district", en="District", **{"as": "জিলা"},
         meaning_en="The main unit of administration within a state, headed by a Deputy Commissioner in Assam.",
         meaning_as="ৰাজ্যৰ ভিতৰৰ প্ৰশাসনৰ মূল একক; অসমত ইয়াৰ মুৰব্বী উপায়ুক্ত।"),
    dict(slug="deputy-commissioner", en="Deputy Commissioner", **{"as": "উপায়ুক্ত"},
         meaning_en="The officer in charge of a district in Assam, responsible for law and order, revenue and development.",
         meaning_as="অসমত এখন জিলাৰ দায়িত্বত থকা বিষয়া, যি আইন-শৃংখলা, ৰাজহ আৰু উন্নয়নৰ বাবে দায়বদ্ধ।"),
    dict(slug="co-district", en="Co-district", **{"as": "সহ-জিলা"},
         meaning_en="An administrative unit inside a district that brings government services closer to people. It is not a separate district.",
         meaning_as="চৰকাৰী সেৱা মানুহৰ ওচৰলৈ নিবলৈ জিলাৰ ভিতৰত গঠন কৰা প্ৰশাসনিক একক। ই সুকীয়া জিলা নহয়।"),
]

DISTRICTS_EN = ("Bajali, Baksa, Barpeta, Biswanath, Bongaigaon, Cachar, Charaideo, Chirang, Darrang, Dhemaji, Dhubri, Dibrugarh, "
                "Dima Hasao, Goalpara, Golaghat, Hailakandi, Hojai, Jorhat, Kamrup, Kamrup Metropolitan, Karbi Anglong, Kokrajhar, "
                "Lakhimpur, Majuli, Morigaon, Nagaon, Nalbari, Sivasagar, Sonitpur, South Salmara-Mankachar, Sribhumi (Karimganj), "
                "Tamulpur, Tinsukia, Udalguri, West Karbi Anglong")
DISTRICTS_AS = ("বজালী, বাক্সা, বৰপেটা, বিশ্বনাথ, বঙাইগাঁও, কাছাৰ, চৰাইদেউ, চিৰাং, দৰং, ধেমাজি, ধুবুৰী, ডিব্ৰুগড়, "
                "ডিমা হাছাও, গোৱালপাৰা, গোলাঘাট, হাইলাকান্দি, হোজাই, যোৰহাট, কামৰূপ, কামৰূপ মহানগৰ, কাৰ্বি আংলং, কোকৰাঝাৰ, "
                "লখিমপুৰ, মাজুলী, মৰিগাঁও, নগাঁও, নলবাৰী, শিৱসাগৰ, শোণিতপুৰ, দক্ষিণ শালমাৰা-মানকাচৰ, শ্ৰীভূমি (কৰিমগঞ্জ), "
                "তামুলপুৰ, তিনিচুকীয়া, ওদালগুৰি, পশ্চিম কাৰ্বি আংলং")

CHAPTERS = [
    dict(
        slug="districts-of-assam-overview", position=1,
        title={"en": "Districts of Assam: overview", "as": "অসমৰ জিলাসমূহ: এক চমু আভাস"},
        summary={"en": "All 35 districts of Assam, and how the number grew over the years.",
                 "as": "অসমৰ ৩৫ খন জিলা, আৰু বছৰৰ পিছত বছৰ জিলাৰ সংখ্যা কেনেকৈ বাঢ়িল।"},
        sources="\n".join([f"List of districts of Assam, Wikipedia: {W}List_of_districts_of_Assam",
                           "Assam at a Glance 2025, Directorate of Economics and Statistics, Government of Assam: "
                           "https://des.assam.gov.in/sites/default/files/swf_utility_folder/departments/ecostat_medhassu_in_oid_3/this_comm/assam_at_a_glance_-_2025.pdf"]),
        blocks={
            "en": [
                ("p1", "paragraph", "normal",
                 "Assam has 35 {{term:district|districts}}. Each is headed by a {{term:deputy-commissioner|Deputy Commissioner}} and divided into "
                 "{{term:sub-division|sub-divisions}}."),
                ("h1", "heading", "normal", "The 35 districts (A to Z)"),
                ("p2", "paragraph", "geography", DISTRICTS_EN),
                ("h2", "heading", "normal", "How the number of districts grew"),
                ("l1", "list", "event",
                 "1983: Barpeta, Sonitpur, Jorhat, Dhubri, Kokrajhar and Karimganj districts are created.\n"
                 "1989: Hailakandi, Bongaigaon, Tinsukia, Dhemaji and Morigaon are created.\n"
                 "2003 to 2004: Kamrup Metropolitan, Baksa, Chirang and Udalguri are created.\n"
                 "15 August 2015: five new districts are announced (Biswanath, Charaideo, Hojai, South Salmara-Mankachar and West Karbi Anglong).\n"
                 "2016: Majuli becomes India's first {{term:river-island|river island}} district.\n"
                 "2020 to 2022: Bajali (34th) and Tamulpur (35th) become districts.\n"
                 "31 December 2022: four new districts are merged back temporarily; in August 2023 the government decides to recreate them, and the number returns to 35."),
                ("p3", "paragraph", "normal",
                 "Karimganj district has been renamed Sribhumi. Assam has also set up {{term:co-district|co-districts}} to bring offices closer to people; "
                 "these are not separate districts."),
                ("p4", "paragraph", "normal",
                 "A separate page for each district will be added later."),
                ("exam1", "fact_box", "exam_fact",
                 "Remember for exams: 35 districts; Majuli is the first river island district (2016); Tamulpur is the 35th district."),
            ],
            "as": [
                ("p1", "paragraph", "normal",
                 "অসমত ৩৫ খন {{term:district|জিলা}} আছে। প্ৰতিখন জিলাৰ মুৰব্বী এগৰাকী {{term:deputy-commissioner|উপায়ুক্ত}} আৰু প্ৰতিখন জিলা "
                 "কেইটামান {{term:sub-division|মহকুমাত}} বিভক্ত।"),
                ("h1", "heading", "normal", "৩৫ খন জিলা"),
                ("p2", "paragraph", "geography", DISTRICTS_AS),
                ("h2", "heading", "normal", "জিলাৰ সংখ্যা কেনেকৈ বাঢ়িল"),
                ("l1", "list", "event",
                 "১৯৮৩: বৰপেটা, শোণিতপুৰ, যোৰহাট, ধুবুৰী, কোকৰাঝাৰ আৰু কৰিমগঞ্জ জিলা গঠন হয়।\n"
                 "১৯৮৯: হাইলাকান্দি, বঙাইগাঁও, তিনিচুকীয়া, ধেমাজি আৰু মৰিগাঁও গঠন হয়।\n"
                 "২০০৩-০৪: কামৰূপ মহানগৰ, বাক্সা, চিৰাং আৰু ওদালগুৰি গঠন হয়।\n"
                 "১৫ আগষ্ট ২০১৫: পাঁচখন নতুন জিলা ঘোষণা (বিশ্বনাথ, চৰাইদেউ, হোজাই, দক্ষিণ শালমাৰা-মানকাচৰ আৰু পশ্চিম কাৰ্বি আংলং)।\n"
                 "২০১৬: মাজুলী ভাৰতৰ প্ৰথম {{term:river-island|নদী দ্বীপ}} জিলা হয়।\n"
                 "২০২০-২২: বজালী (৩৪ সংখ্যক) আৰু তামুলপুৰ (৩৫ সংখ্যক) জিলা হয়।\n"
                 "৩১ ডিচেম্বৰ ২০২২: চাৰিখন নতুন জিলা সাময়িকভাৱে পুনৰ একত্ৰিত কৰা হয়; ২০২৩ চনৰ আগষ্টত চৰকাৰে সেইবোৰ পুনৰ গঠনৰ সিদ্ধান্ত লয়, আৰু সংখ্যা পুনৰ ৩৫ হয়।"),
                ("p3", "paragraph", "normal",
                 "কৰিমগঞ্জ জিলাৰ নাম সলনি কৰি শ্ৰীভূমি কৰা হৈছে। কাৰ্যালয়সমূহ মানুহৰ ওচৰলৈ নিবলৈ অসমত {{term:co-district|সহ-জিলাও}} গঠন কৰা হৈছে; "
                 "এইবোৰ সুকীয়া জিলা নহয়।"),
                ("p4", "paragraph", "normal",
                 "প্ৰতিখন জিলাৰ বাবে সুকীয়া পৃষ্ঠা পিছত যোগ কৰা হ'ব।"),
                ("exam1", "fact_box", "exam_fact",
                 "পৰীক্ষাৰ বাবে মনত ৰাখক: ৩৫ খন জিলা; মাজুলী প্ৰথম নদী দ্বীপ জিলা (২০১৬); তামুলপুৰ ৩৫ সংখ্যক জিলা।"),
            ],
        },
    ),
]
