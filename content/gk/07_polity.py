"""Group 7: Polity and Administration (ৰাজনীতি আৰু প্ৰশাসন).

Block format: (block_key, block_type, style, body). Keys must match in both languages.
"""

CATEGORY_SLUG = "polity"
CATEGORY_NAME = "Polity and Administration"
LAST_CHECKED = "2026-11-24"

EXISTING_TERMS = {"dispur"}

W = "https://en.wikipedia.org/wiki/"
SRC_ASM = f"Assam Legislative Assembly, Wikipedia: {W}Assam_Legislative_Assembly"
SRC_CM = f"List of chief ministers of Assam, Wikipedia: {W}List_of_chief_ministers_of_Assam"
SRC_GOV = f"List of governors of Assam, Wikipedia: {W}List_of_governors_of_Assam"
SRC_HC = f"Gauhati High Court, Wikipedia: {W}Gauhati_High_Court"
SRC_6S = f"Sixth Schedule to the Constitution of India, Wikipedia: {W}Sixth_Schedule_to_the_Constitution_of_India"
SRC_BTR = f"Bodoland Territorial Region, Wikipedia: {W}Bodoland_Territorial_Region"
SRC_KAAC = f"Karbi Anglong Autonomous Council, Wikipedia: {W}Karbi_Anglong_Autonomous_Council"
CHANGES = "NOTE: names of office holders change; check them again before every publish."

TERMS = [
    dict(slug="governor", en="Governor", **{"as": "ৰাজ্যপাল"},
         meaning_en="The constitutional head of a state, appointed by the President of India.",
         meaning_as="ভাৰতৰ ৰাষ্ট্ৰপতিয়ে নিযুক্তি দিয়া ৰাজ্যৰ সাংবিধানিক মুৰব্বী।"),
    dict(slug="chief-minister", en="Chief Minister", **{"as": "মুখ্যমন্ত্ৰী"},
         meaning_en="The head of the state government, usually the leader of the party with a majority in the Assembly.",
         meaning_as="ৰাজ্য চৰকাৰৰ মুৰব্বী, সাধাৰণতে বিধানসভাত সংখ্যাগৰিষ্ঠ দলৰ নেতা।"),
    dict(slug="council-of-ministers", en="Council of Ministers", **{"as": "মন্ত্ৰিপৰিষদ"},
         meaning_en="The team of ministers, led by the Chief Minister, that runs the state government.",
         meaning_as="মুখ্যমন্ত্ৰীৰ নেতৃত্বত ৰাজ্য চৰকাৰ চলোৱা মন্ত্ৰীসকলৰ দল।"),
    dict(slug="unicameral", en="Unicameral", **{"as": "এক সদনীয়"},
         meaning_en="A legislature with only one house. Assam has only a Legislative Assembly, no Legislative Council.",
         meaning_as="এটা মাত্ৰ সদন থকা বিধানমণ্ডল। অসমত কেৱল বিধানসভা আছে, বিধান পৰিষদ নাই।"),
    dict(slug="speaker", en="Speaker", **{"as": "অধ্যক্ষ"},
         meaning_en="The member who runs the meetings of the Assembly and keeps order in the House.",
         meaning_as="বিধানসভাৰ অধিৱেশন পৰিচালনা কৰা আৰু সদনত শৃংখলা ৰক্ষা কৰা সদস্য।"),
    dict(slug="high-court", en="High Court", **{"as": "উচ্চ ন্যায়ালয়"},
         meaning_en="The highest court in a state (or group of states), below the Supreme Court of India.",
         meaning_as="ভাৰতৰ উচ্চতম ন্যায়ালয়ৰ তলত, এখন ৰাজ্যৰ (বা কেইবাখনো ৰাজ্যৰ) সৰ্বোচ্চ ন্যায়ালয়।"),
    dict(slug="bench", en="Bench (of a court)", **{"as": "ন্যায়পীঠ"},
         meaning_en="A branch of a court that sits in another city so that people there need not travel far.",
         meaning_as="আন এখন চহৰত বহা ন্যায়ালয়ৰ শাখা, যাতে তাৰ মানুহে দূৰলৈ যাব নালাগে।"),
    dict(slug="sixth-schedule", en="Sixth Schedule", **{"as": "ষষ্ঠ অনুসূচী"},
         meaning_en="A part of the Constitution of India that lets tribal areas of Assam, Meghalaya, Tripura and Mizoram govern themselves through autonomous councils.",
         meaning_as="ভাৰতীয় সংবিধানৰ এটা অংশ, যিয়ে অসম, মেঘালয়, ত্ৰিপুৰা আৰু মিজোৰামৰ জনজাতীয় অঞ্চলক স্বায়ত্তশাসিত পৰিষদৰ জৰিয়তে নিজকে শাসন কৰাৰ অধিকাৰ দিয়ে।"),
    dict(slug="autonomous-council", en="Autonomous council", **{"as": "স্বায়ত্তশাসিত পৰিষদ"},
         meaning_en="An elected body that makes laws and runs local matters such as land, forests and customs in a tribal area.",
         meaning_as="জনজাতীয় অঞ্চলৰ মাটি, অৰণ্য, ৰীতি-নীতি আদি স্থানীয় বিষয়ত আইন প্ৰণয়ন আৰু প্ৰশাসন চলোৱা নিৰ্বাচিত অনুষ্ঠান।"),
    dict(slug="memorandum-of-settlement", en="Memorandum of Settlement", **{"as": "বুজাবুজিৰ চুক্তি"},
         meaning_en="A written peace agreement between the government and a group, setting out what each side agrees to.",
         meaning_as="চৰকাৰ আৰু কোনো গোটৰ মাজত কোনে কি মানি ল'ব তাক লিখিতভাৱে উল্লেখ কৰা শান্তি চুক্তি।"),
]

CHAPTERS = [
    # ------------------------------------------------------------------ 1
    dict(
        slug="governor-cm-ministers", position=1,
        title={"en": "The Governor, Chief Minister and Council of Ministers", "as": "ৰাজ্যপাল, মুখ্যমন্ত্ৰী আৰু মন্ত্ৰিপৰিষদ"},
        summary={"en": "Who runs the government of Assam, with key firsts for exams.",
                 "as": "অসম চৰকাৰ কোনে চলায়, আৰু পৰীক্ষাৰ বাবে গুৰুত্বপূৰ্ণ 'প্ৰথম'সমূহ।"},
        sources="\n".join([SRC_GOV, SRC_CM, SRC_ASM, CHANGES]),
        blocks={
            "en": [
                ("p1", "paragraph", "normal",
                 "The {{term:governor}} is the constitutional head of Assam, appointed by the President of India. The real work of government is done "
                 "by the {{term:chief-minister|Chief Minister}} and the {{term:council-of-ministers|Council of Ministers}}, who answer to the Assembly. "
                 "The seat of government is {{term:dispur|Dispur}}."),
                ("h1", "heading", "normal", "Office holders (as of November 2026)"),
                ("l1", "list", "verified_fact",
                 "Governor: Lakshman Prasad Acharya (since 30 July 2024)\n"
                 "Chief Minister: Himanta Biswa Sarma (first sworn in on 10 May 2021; continued after the BJP won the 2026 election)"),
                ("h2", "heading", "normal", "Firsts and records"),
                ("l2", "list", "personality",
                 "First Governor: Sir Muhammad Saleh Akbar Hydari (from 4 May 1947)\n"
                 "First Chief Minister: Gopinath Bordoloi\n"
                 "First woman Chief Minister: Syeda Anwara Taimur (1980), India's first woman Muslim Chief Minister\n"
                 "Longest-serving Chief Minister: Tarun Gogoi, 15 years (2001 to 2016)"),
                ("exam1", "fact_box", "exam_fact",
                 "Remember for exams: first CM Gopinath Bordoloi; first woman CM Anwara Taimur; longest-serving CM Tarun Gogoi."),
            ],
            "as": [
                ("p1", "paragraph", "normal",
                 "{{term:governor|ৰাজ্যপাল}} অসমৰ সাংবিধানিক মুৰব্বী, যাক ভাৰতৰ ৰাষ্ট্ৰপতিয়ে নিযুক্তি দিয়ে। চৰকাৰৰ প্ৰকৃত কাম "
                 "{{term:chief-minister|মুখ্যমন্ত্ৰী}} আৰু {{term:council-of-ministers|মন্ত্ৰিপৰিষদে}} কৰে, যিসকল বিধানসভাৰ ওচৰত দায়বদ্ধ। "
                 "চৰকাৰৰ আসন {{term:dispur|দিশপুৰ}}।"),
                ("h1", "heading", "normal", "পদাধিকাৰীসকল (২০২৬ চনৰ নৱেম্বৰলৈ)"),
                ("l1", "list", "verified_fact",
                 "ৰাজ্যপাল: লক্ষ্মণ প্ৰসাদ আচাৰ্য (৩০ জুলাই ২০২৪ৰ পৰা)\n"
                 "মুখ্যমন্ত্ৰী: হিমন্ত বিশ্ব শৰ্মা (প্ৰথমবাৰ ১০ মে' ২০২১ত শপত; ২০২৬ৰ নিৰ্বাচনত বিজেপি জয়ী হোৱাৰ পিছতো পদত বহাল)"),
                ("h2", "heading", "normal", "প্ৰথম আৰু অভিলেখসমূহ"),
                ("l2", "list", "personality",
                 "প্ৰথম ৰাজ্যপাল: চাৰ মহম্মদ চালেহ আকবৰ হায়দাৰী (৪ মে' ১৯৪৭ৰ পৰা)\n"
                 "প্ৰথম মুখ্যমন্ত্ৰী: গোপীনাথ বৰদলৈ\n"
                 "প্ৰথম মহিলা মুখ্যমন্ত্ৰী: ছৈয়দা আনোৱাৰা তৈমুৰ (১৯৮০), ভাৰতৰ প্ৰথম মুছলমান মহিলা মুখ্যমন্ত্ৰী\n"
                 "আটাইতকৈ দীৰ্ঘকালীন মুখ্যমন্ত্ৰী: তৰুণ গগৈ, ১৫ বছৰ (২০০১ ৰ পৰা ২০১৬)"),
                ("exam1", "fact_box", "exam_fact",
                 "পৰীক্ষাৰ বাবে মনত ৰাখক: প্ৰথম মুখ্যমন্ত্ৰী গোপীনাথ বৰদলৈ; প্ৰথম মহিলা মুখ্যমন্ত্ৰী আনোৱাৰা তৈমুৰ; দীৰ্ঘকালীন মুখ্যমন্ত্ৰী তৰুণ গগৈ।"),
            ],
        },
    ),
    # ------------------------------------------------------------------ 2
    dict(
        slug="assam-legislative-assembly", position=2,
        title={"en": "The Assam Legislative Assembly", "as": "অসম বিধানসভা"},
        summary={"en": "126 seats, one house, and its history from Shillong in 1937 to Dispur.",
                 "as": "১২৬ টা আসন, এটা সদন, আৰু ১৯৩৭ চনৰ শ্বিলঙৰ পৰা দিশপুৰলৈ ইয়াৰ ইতিহাস।"},
        sources="\n".join([SRC_ASM, CHANGES]),
        blocks={
            "en": [
                ("p1", "paragraph", "normal",
                 "The Assam Legislative Assembly has 126 members, each elected from one constituency for five years. It meets in the Assembly complex at Dispur."),
                ("p2", "paragraph", "normal",
                 "Assam's legislature is {{term:unicameral}}: the Legislative Council was abolished in 1952, so only the Assembly remains."),
                ("h1", "heading", "normal", "History"),
                ("l1", "list", "event",
                 "7 April 1937: first sitting of the Assam Assembly, in Shillong, with 108 members.\n"
                 "1952: the first Assembly after independence is elected; the Legislative Council is abolished.\n"
                 "2026: election to the 16th Assembly. The BJP won 82 of the 126 seats."),
                ("p3", "paragraph", "verified_fact",
                 "The {{term:speaker}} of the 16th Assembly is Ranjeet Kumar Dass (since 21 May 2026)."),
                ("exam1", "fact_box", "exam_fact",
                 "Remember for exams: 126 seats; unicameral; first sitting 7 April 1937 at Shillong."),
            ],
            "as": [
                ("p1", "paragraph", "normal",
                 "অসম বিধানসভাৰ সদস্য ১২৬ গৰাকী, প্ৰতিগৰাকী এটা সমষ্টিৰ পৰা পাঁচ বছৰৰ বাবে নিৰ্বাচিত। ইয়াৰ অধিৱেশন দিশপুৰৰ বিধানসভা চৌহদত বহে।"),
                ("p2", "paragraph", "normal",
                 "অসমৰ বিধানমণ্ডল {{term:unicameral|এক সদনীয়}}: ১৯৫২ চনত বিধান পৰিষদ উঠাই দিয়া হয়, সেয়েহে কেৱল বিধানসভা আছে।"),
                ("h1", "heading", "normal", "ইতিহাস"),
                ("l1", "list", "event",
                 "৭ এপ্ৰিল ১৯৩৭: শ্বিলঙত ১০৮ জন সদস্যৰে অসম বিধানসভাৰ প্ৰথম অধিৱেশন।\n"
                 "১৯৫২: স্বাধীনতাৰ পিছৰ প্ৰথম বিধানসভা নিৰ্বাচিত হয়; বিধান পৰিষদ উঠাই দিয়া হয়।\n"
                 "২০২৬: ষোড়শ বিধানসভাৰ নিৰ্বাচন। ১২৬ টা আসনৰ ৮২ টাত বিজেপি জয়ী হয়।"),
                ("p3", "paragraph", "verified_fact",
                 "ষোড়শ বিধানসভাৰ {{term:speaker|অধ্যক্ষ}} ৰঞ্জিত কুমাৰ দাস (২১ মে' ২০২৬ৰ পৰা)।"),
                ("exam1", "fact_box", "exam_fact",
                 "পৰীক্ষাৰ বাবে মনত ৰাখক: ১২৬ টা আসন; এক সদনীয়; প্ৰথম অধিৱেশন ৭ এপ্ৰিল ১৯৩৭, শ্বিলঙত।"),
            ],
        },
    ),
    # ------------------------------------------------------------------ 3
    dict(
        slug="gauhati-high-court", position=3,
        title={"en": "The Gauhati High Court", "as": "গুৱাহাটী উচ্চ ন্যায়ালয়"},
        summary={"en": "The High Court for four Northeast states, its benches and its history.",
                 "as": "উত্তৰ-পূবৰ চাৰিখন ৰাজ্যৰ উচ্চ ন্যায়ালয়, ইয়াৰ ন্যায়পীঠ আৰু ইতিহাস।"},
        sources="\n".join([SRC_HC, CHANGES]),
        blocks={
            "en": [
                ("p1", "paragraph", "normal",
                 "The Gauhati {{term:high-court|High Court}} is the High Court for four states: Assam, Arunachal Pradesh, Nagaland and Mizoram. "
                 "Its principal seat is in Guwahati."),
                ("p2", "paragraph", "normal",
                 "It has three permanent {{term:bench|benches}}: Kohima (Nagaland), Aizawl (Mizoram) and Itanagar (Arunachal Pradesh)."),
                ("h1", "heading", "normal", "History"),
                ("l1", "list", "event",
                 "1 March 1948: the Assam High Court Order is issued.\n"
                 "5 April 1948: the High Court of Assam is inaugurated.\n"
                 "1 December 1963: renamed the High Court of Assam and Nagaland.\n"
                 "1971: renamed the Gauhati High Court."),
                ("p3", "paragraph", "verified_fact",
                 "The Chief Justice is Ashutosh Kumar (since 21 July 2025)."),
                ("exam1", "fact_box", "exam_fact",
                 "Remember for exams: Gauhati High Court started on 5 April 1948; benches at Kohima, Aizawl and Itanagar."),
            ],
            "as": [
                ("p1", "paragraph", "normal",
                 "গুৱাহাটী {{term:high-court|উচ্চ ন্যায়ালয়}} চাৰিখন ৰাজ্যৰ উচ্চ ন্যায়ালয়: অসম, অৰুণাচল প্ৰদেশ, নাগালেণ্ড আৰু মিজোৰাম। "
                 "ইয়াৰ মুখ্য আসন গুৱাহাটীত।"),
                ("p2", "paragraph", "normal",
                 "ইয়াৰ তিনিখন স্থায়ী {{term:bench|ন্যায়পীঠ}} আছে: কোহিমা (নাগালেণ্ড), আইজল (মিজোৰাম) আৰু ইটানগৰ (অৰুণাচল প্ৰদেশ)।"),
                ("h1", "heading", "normal", "ইতিহাস"),
                ("l1", "list", "event",
                 "১ মাৰ্চ ১৯৪৮: অসম উচ্চ ন্যায়ালয় আদেশ জাৰি।\n"
                 "৫ এপ্ৰিল ১৯৪৮: অসম উচ্চ ন্যায়ালয়ৰ উদ্বোধন।\n"
                 "১ ডিচেম্বৰ ১৯৬৩: নাম সলনি কৰি অসম আৰু নাগালেণ্ড উচ্চ ন্যায়ালয় কৰা হয়।\n"
                 "১৯৭১: নাম সলনি কৰি গুৱাহাটী উচ্চ ন্যায়ালয় কৰা হয়।"),
                ("p3", "paragraph", "verified_fact",
                 "মুখ্য ন্যায়াধীশ আশুতোষ কুমাৰ (২১ জুলাই ২০২৫ৰ পৰা)।"),
                ("exam1", "fact_box", "exam_fact",
                 "পৰীক্ষাৰ বাবে মনত ৰাখক: গুৱাহাটী উচ্চ ন্যায়ালয় ৫ এপ্ৰিল ১৯৪৮ত আৰম্ভ; কোহিমা, আইজল আৰু ইটানগৰত ন্যায়পীঠ।"),
            ],
        },
    ),
    # ------------------------------------------------------------------ 4
    dict(
        slug="sixth-schedule-councils", position=4,
        title={"en": "Sixth Schedule and autonomous councils", "as": "ষষ্ঠ অনুসূচী আৰু স্বায়ত্তশাসিত পৰিষদ"},
        summary={"en": "Assam's three Sixth Schedule councils: Bodoland, Karbi Anglong and Dima Hasao.",
                 "as": "অসমৰ তিনিখন ষষ্ঠ অনুসূচীভুক্ত পৰিষদ: বড়োলেণ্ড, কাৰ্বি আংলং আৰু ডিমা হাছাও।"},
        sources="\n".join([SRC_6S, SRC_BTR, SRC_KAAC]),
        blocks={
            "en": [
                ("p1", "paragraph", "normal",
                 "The {{term:sixth-schedule|Sixth Schedule}} of the Constitution applies to tribal areas in four states: Assam, Meghalaya, Tripura and Mizoram. "
                 "These areas are governed by elected {{term:autonomous-council|autonomous councils}}."),
                ("h1", "heading", "normal", "The three councils of Assam"),
                ("l1", "list", "verified_fact",
                 "Bodoland Territorial Council (2003), headquarters Kokrajhar\n"
                 "North Cachar Hills (Dima Hasao) Autonomous Council (1951), headquarters Haflong\n"
                 "Karbi Anglong Autonomous Council (1952), headquarters Diphu"),
                ("h2", "heading", "normal", "Bodoland Territorial Region (BTR)"),
                ("p2", "paragraph", "normal",
                 "The Bodoland Territorial Council was created by a {{term:memorandum-of-settlement|Memorandum of Settlement}} dated 10 February 2003. "
                 "A peace agreement signed on 27 January 2020 formed the Bodoland Territorial Region with more powers."),
                ("p3", "paragraph", "normal",
                 "BTR has five districts: Kokrajhar, Chirang, Baksa, Udalguri and Tamulpur. Its council has 46 members: 40 elected and 6 nominated by the Governor."),
                ("h3", "heading", "normal", "Karbi Anglong Autonomous Council"),
                ("p4", "paragraph", "normal",
                 "It began as a district council on 17 November 1951 and became the Karbi Anglong Autonomous Council on 23 June 1952. It has 26 members."),
                ("exam1", "fact_box", "exam_fact",
                 "Remember for exams: 3 Sixth Schedule councils in Assam; BTR formed by the Bodo Accord of 27 January 2020; BTR HQ Kokrajhar."),
            ],
            "as": [
                ("p1", "paragraph", "normal",
                 "সংবিধানৰ {{term:sixth-schedule|ষষ্ঠ অনুসূচী}} চাৰিখন ৰাজ্যৰ জনজাতীয় অঞ্চলত প্ৰযোজ্য: অসম, মেঘালয়, ত্ৰিপুৰা আৰু মিজোৰাম। "
                 "এই অঞ্চলসমূহ নিৰ্বাচিত {{term:autonomous-council|স্বায়ত্তশাসিত পৰিষদে}} শাসন কৰে।"),
                ("h1", "heading", "normal", "অসমৰ তিনিখন পৰিষদ"),
                ("l1", "list", "verified_fact",
                 "বড়োলেণ্ড আঞ্চলিক পৰিষদ (২০০৩), মুখ্য কাৰ্যালয় কোকৰাঝাৰ\n"
                 "উত্তৰ কাছাৰ পাহাৰ (ডিমা হাছাও) স্বায়ত্তশাসিত পৰিষদ (১৯৫১), মুখ্য কাৰ্যালয় হাফলং\n"
                 "কাৰ্বি আংলং স্বায়ত্তশাসিত পৰিষদ (১৯৫২), মুখ্য কাৰ্যালয় ডিফু"),
                ("h2", "heading", "normal", "বড়োলেণ্ড আঞ্চলিক অঞ্চল (বি টি আৰ)"),
                ("p2", "paragraph", "normal",
                 "২০০৩ চনৰ ১০ ফেব্ৰুৱাৰীৰ {{term:memorandum-of-settlement|বুজাবুজিৰ চুক্তিৰে}} বড়োলেণ্ড আঞ্চলিক পৰিষদ গঠন হয়। "
                 "২০২০ চনৰ ২৭ জানুৱাৰীত স্বাক্ষৰিত শান্তি চুক্তিয়ে অধিক ক্ষমতাৰে বড়োলেণ্ড আঞ্চলিক অঞ্চল গঠন কৰে।"),
                ("p3", "paragraph", "normal",
                 "বি টি আৰত পাঁচখন জিলা আছে: কোকৰাঝাৰ, চিৰাং, বাক্সা, ওদালগুৰি আৰু তামুলপুৰ। ইয়াৰ পৰিষদত ৪৬ জন সদস্য: ৪০ জন নিৰ্বাচিত আৰু ৬ জন ৰাজ্যপালৰ দ্বাৰা মনোনীত।"),
                ("h3", "heading", "normal", "কাৰ্বি আংলং স্বায়ত্তশাসিত পৰিষদ"),
                ("p4", "paragraph", "normal",
                 "১৯৫১ চনৰ ১৭ নৱেম্বৰত ই জিলা পৰিষদ হিচাপে আৰম্ভ হয় আৰু ১৯৫২ চনৰ ২৩ জুনত কাৰ্বি আংলং স্বায়ত্তশাসিত পৰিষদ হয়। ইয়াৰ সদস্য ২৬ জন।"),
                ("exam1", "fact_box", "exam_fact",
                 "পৰীক্ষাৰ বাবে মনত ৰাখক: অসমত ৩ খন ষষ্ঠ অনুসূচীভুক্ত পৰিষদ; ২৭ জানুৱাৰী ২০২০ৰ বড়ো চুক্তিৰে বি টি আৰ গঠন; বি টি আৰৰ মুখ্য কাৰ্যালয় কোকৰাঝাৰ।"),
            ],
        },
    ),
]
