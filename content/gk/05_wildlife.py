"""Group 5: Wildlife and Environment (বন্যপ্ৰাণী আৰু পৰিৱেশ).

Block format: (block_key, block_type, style, body). Keys must match in both languages.
"""

CATEGORY_SLUG = "wildlife"
CATEGORY_NAME = "Wildlife and Environment"
LAST_CHECKED = "2026-11-24"

EXISTING_TERMS = {"one-horned-rhinoceros"}

W = "https://en.wikipedia.org/wiki/"
SRC_LIST = f"List of protected areas of Assam, Wikipedia: {W}List_of_protected_areas_of_Assam"
SRC_KAZ = f"Kaziranga National Park, Wikipedia: {W}Kaziranga_National_Park"
SRC_MANAS = f"Manas National Park, Wikipedia: {W}Manas_National_Park"
SRC_RHINO = f"Indian rhinoceros, Wikipedia: {W}Indian_rhinoceros"
SRC_RAMSAR = f"List of Ramsar sites in India, Wikipedia: {W}List_of_Ramsar_sites_in_India"
SRC_POB = f"Pobitora Wildlife Sanctuary, Wikipedia: {W}Pobitora_Wildlife_Sanctuary"

TERMS = [
    dict(slug="national-park", en="National park", **{"as": "ৰাষ্ট্ৰীয় উদ্যান"},
         meaning_en="A protected area where wildlife and nature are fully protected by law. People may not live, graze cattle or cut trees inside.",
         meaning_as="আইনৰ দ্বাৰা বন্যপ্ৰাণী আৰু প্ৰকৃতি সম্পূৰ্ণৰূপে সুৰক্ষিত এলেকা। ইয়াৰ ভিতৰত বসতি, গৰু চৰোৱা বা গছ কটা নিষেধ।"),
    dict(slug="wildlife-sanctuary", en="Wildlife sanctuary", **{"as": "বন্যপ্ৰাণী অভয়াৰণ্য"},
         meaning_en="A protected area for wildlife where some limited human activities may be allowed.",
         meaning_as="বন্যপ্ৰাণীৰ বাবে সংৰক্ষিত এলেকা, য'ত কিছু সীমিত মানৱীয় কাম-কাজৰ অনুমতি থাকিব পাৰে।"),
    dict(slug="world-heritage-site", en="World Heritage Site", **{"as": "বিশ্ব ঐতিহ্য ক্ষেত্ৰ"},
         meaning_en="A place listed by UNESCO for its outstanding value to all humanity.",
         meaning_as="সমগ্ৰ মানৱজাতিৰ বাবে অসাধাৰণ মূল্যৰ বাবে ইউনেস্কোৱে তালিকাভুক্ত কৰা স্থান।"),
    dict(slug="iucn-vulnerable", en="Vulnerable (IUCN)", **{"as": "বিপদাপন্ন (আই ইউ চি এন)"},
         meaning_en="A category in the IUCN Red List for species facing a high risk of dying out in the wild.",
         meaning_as="আই ইউ চি এনৰ ৰঙা তালিকাৰ এটা শ্ৰেণী, য'ত বনত লুপ্ত হোৱাৰ উচ্চ আশংকা থকা প্ৰজাতিক ৰখা হয়।"),
    dict(slug="poaching", en="Poaching", **{"as": "চোৰাং চিকাৰ"},
         meaning_en="Illegal hunting or killing of wild animals, often for body parts such as rhino horn.",
         meaning_as="বন্যপ্ৰাণীৰ অবৈধ চিকাৰ বা হত্যা, প্ৰায়ে গঁড়ৰ খড়গৰ দৰে অংগৰ বাবে।"),
    dict(slug="pygmy-hog", en="Pygmy hog", **{"as": "নল গাহৰি"},
         meaning_en="The smallest wild pig in the world, found in the grasslands of Manas.",
         meaning_as="পৃথিৱীৰ আটাইতকৈ সৰু বনৰীয়া গাহৰি, যিটো মানাহৰ তৃণভূমিত পোৱা যায়।"),
    dict(slug="golden-langur", en="Golden langur", **{"as": "সোণালী বান্দৰ"},
         meaning_en="A rare golden-coloured monkey found only in western Assam and Bhutan.",
         meaning_as="কেৱল পশ্চিম অসম আৰু ভূটানত পোৱা এবিধ বিৰল সোণালী বৰণৰ বান্দৰ।"),
    dict(slug="hoolock-gibbon", en="Hoolock gibbon", **{"as": "হলৌ বান্দৰ"},
         meaning_en="The only ape found in India. It lives in the forests of Northeast India.",
         meaning_as="ভাৰতত পোৱা একমাত্ৰ এপ (নেজহীন বান্দৰ)। ই উত্তৰ-পূব ভাৰতৰ অৰণ্যত বাস কৰে।"),
    dict(slug="tiger-reserve", en="Tiger reserve", **{"as": "ব্যাঘ্ৰ প্ৰকল্প"},
         meaning_en="A protected area set up under Project Tiger to save tigers and their habitat.",
         meaning_as="বাঘ আৰু সিহঁতৰ বাসস্থান ৰক্ষাৰ বাবে প্ৰজেক্ট টাইগাৰৰ অধীনত গঠন কৰা সংৰক্ষিত এলেকা।"),
    dict(slug="biosphere-reserve", en="Biosphere reserve", **{"as": "জৈৱমণ্ডল সংৰক্ষিত ক্ষেত্ৰ"},
         meaning_en="A large protected area that conserves nature while allowing people around it to live and work sustainably.",
         meaning_as="প্ৰকৃতি সংৰক্ষণৰ লগতে চাৰিওফালৰ মানুহক বহনক্ষমভাৱে জীয়াই থাকিবলৈ দিয়া এক বৃহৎ সংৰক্ষিত এলেকা।"),
    dict(slug="ramsar-site", en="Ramsar site", **{"as": "ৰামচাৰ ক্ষেত্ৰ"},
         meaning_en="A wetland of international importance, listed under the Ramsar Convention of 1971.",
         meaning_as="১৯৭১ চনৰ ৰামচাৰ চুক্তিৰ অধীনত তালিকাভুক্ত আন্তঃৰাষ্ট্ৰীয় গুৰুত্বৰ জলাভূমি।"),
    dict(slug="wetland", en="Wetland", **{"as": "জলাভূমি"},
         meaning_en="Land covered by water for all or part of the year, such as a beel or marsh.",
         meaning_as="বছৰৰ সকলো বা কিছু সময় পানীৰে ঢাক খাই থকা ভূমি, যেনে বিল বা দলনি।"),
]

CHAPTERS = [
    # ------------------------------------------------------------------ 1
    dict(
        slug="national-parks-of-assam", position=1,
        title={"en": "National parks of Assam", "as": "অসমৰ ৰাষ্ট্ৰীয় উদ্যানসমূহ"},
        summary={"en": "Assam's eight national parks, from Kaziranga to Sikna Jwhwlao, with the year each was declared.",
                 "as": "কাজিৰঙাৰ পৰা চিকনা ঝাওলাওলৈ অসমৰ আঠখন ৰাষ্ট্ৰীয় উদ্যান আৰু সেইবোৰ ঘোষণাৰ বছৰ।"},
        sources="\n".join([SRC_LIST, SRC_KAZ, SRC_MANAS]),
        blocks={
            "en": [
                ("p1", "paragraph", "normal",
                 "Assam has eight {{term:national-park|national parks}}. These are listed with the year each became a national park:"),
                ("l1", "list", "geography",
                 "Kaziranga: 1974\nManas: 1990\nNameri: 1999\nDibru-Saikhowa: 1999\nOrang: 1999\n"
                 "Raimona: 2021\nDehing Patkai: 2021\nSikna Jwhwlao: 2024 (15 August 2024)"),
                ("h1", "heading", "normal", "Kaziranga National Park"),
                ("p2", "paragraph", "verified_fact",
                 "Kaziranga lies mainly in Golaghat and Nagaon districts. In 1904 Mary Curzon, wife of the Viceroy, visited it but could not see a rhino, "
                 "and urged her husband to protect it. It became a reserve forest on 1 June 1905 and a national park on 11 February 1974. "
                 "UNESCO declared it a {{term:world-heritage-site|World Heritage Site}} in 1985."),
                ("h2", "heading", "normal", "Manas National Park"),
                ("p3", "paragraph", "verified_fact",
                 "Manas, named after the Manas river, lies on the border with Bhutan, next to Bhutan's Royal Manas National Park. "
                 "It became a sanctuary on 1 October 1928, a biosphere reserve in 1989 and a World Heritage Site in 1985. "
                 "UNESCO listed it as 'in danger' in 1992 and removed it from that list on 21 June 2011."),
                ("p4", "paragraph", "normal",
                 "Manas is home to the {{term:pygmy-hog|pygmy hog}}, the smallest wild pig in the world, and the {{term:golden-langur|golden langur}}."),
                ("exam1", "fact_box", "exam_fact",
                 "Remember for exams: Kaziranga and Manas are both World Heritage Sites (1985). Newest national park: Sikna Jwhwlao (2024)."),
            ],
            "as": [
                ("p1", "paragraph", "normal",
                 "অসমত আঠখন {{term:national-park|ৰাষ্ট্ৰীয় উদ্যান}} আছে। প্ৰতিখন ৰাষ্ট্ৰীয় উদ্যান হিচাপে ঘোষিত হোৱাৰ বছৰৰ সৈতে তালিকাখন এনেধৰণৰ:"),
                ("l1", "list", "geography",
                 "কাজিৰঙা: ১৯৭৪\nমানাহ: ১৯৯০\nনামেৰি: ১৯৯৯\nডিব্ৰু-চৈখোৱা: ১৯৯৯\nওৰাং: ১৯৯৯\n"
                 "ৰায়মনা: ২০২১\nদেহিং পাটকাই: ২০২১\nচিকনা ঝাওলাও: ২০২৪ (১৫ আগষ্ট ২০২৪)"),
                ("h1", "heading", "normal", "কাজিৰঙা ৰাষ্ট্ৰীয় উদ্যান"),
                ("p2", "paragraph", "verified_fact",
                 "কাজিৰঙা মূলতঃ গোলাঘাট আৰু নগাঁও জিলাত অৱস্থিত। ১৯০৪ চনত ভাইচৰয়ৰ পত্নী মেৰী কাৰ্জনে ইয়ালৈ আহি গঁড় দেখা নাপালে, "
                 "আৰু ইয়াক সুৰক্ষা দিবলৈ স্বামীক অনুৰোধ কৰে। ১৯০৫ চনৰ ১ জুনত ই সংৰক্ষিত বনাঞ্চল আৰু ১৯৭৪ চনৰ ১১ ফেব্ৰুৱাৰীত ৰাষ্ট্ৰীয় উদ্যান হয়। "
                 "১৯৮৫ চনত ইউনেস্কোৱে ইয়াক {{term:world-heritage-site|বিশ্ব ঐতিহ্য ক্ষেত্ৰ}} ঘোষণা কৰে।"),
                ("h2", "heading", "normal", "মানাহ ৰাষ্ট্ৰীয় উদ্যান"),
                ("p3", "paragraph", "verified_fact",
                 "মানাহ নদীৰ নামেৰে নামকৰণ কৰা মানাহ ভূটানৰ সীমাত, ভূটানৰ ৰয়েল মানাহ ৰাষ্ট্ৰীয় উদ্যানৰ কাষত অৱস্থিত। "
                 "১৯২৮ চনৰ ১ অক্টোবৰত ই অভয়াৰণ্য, ১৯৮৯ চনত জৈৱমণ্ডল সংৰক্ষিত ক্ষেত্ৰ আৰু ১৯৮৫ চনত বিশ্ব ঐতিহ্য ক্ষেত্ৰ হয়। "
                 "১৯৯২ চনত ইউনেস্কোৱে ইয়াক 'বিপদগ্ৰস্ত' তালিকাত ৰাখে আৰু ২০১১ চনৰ ২১ জুনত সেই তালিকাৰ পৰা আঁতৰায়।"),
                ("p4", "paragraph", "normal",
                 "মানাহত পৃথিৱীৰ আটাইতকৈ সৰু বনৰীয়া গাহৰি {{term:pygmy-hog|নল গাহৰি}} আৰু {{term:golden-langur|সোণালী বান্দৰ}} পোৱা যায়।"),
                ("exam1", "fact_box", "exam_fact",
                 "পৰীক্ষাৰ বাবে মনত ৰাখক: কাজিৰঙা আৰু মানাহ দুয়োখন বিশ্ব ঐতিহ্য ক্ষেত্ৰ (১৯৮৫)। আটাইতকৈ নতুন ৰাষ্ট্ৰীয় উদ্যান: চিকনা ঝাওলাও (২০২৪)।"),
            ],
        },
    ),
    # ------------------------------------------------------------------ 2
    dict(
        slug="one-horned-rhinoceros", position=2,
        title={"en": "The one-horned rhinoceros", "as": "এশিঙীয়া গঁড়"},
        summary={"en": "Assam's state animal: how many there are, where they live and what threatens them.",
                 "as": "অসমৰ ৰাজ্যিক জন্তু: সংখ্যা কিমান, ক'ত থাকে আৰু কি বিপদৰ সন্মুখীন।"},
        sources="\n".join([SRC_RHINO, SRC_POB]),
        blocks={
            "en": [
                ("p1", "paragraph", "normal",
                 "The {{term:one-horned-rhinoceros|one-horned rhinoceros}} (scientific name Rhinoceros unicornis) is the state animal of Assam. "
                 "The IUCN lists it as {{term:iucn-vulnerable|Vulnerable}}."),
                ("p2", "paragraph", "verified_fact",
                 "A census in March 2025 counted 4,075 wild rhinos: 3,323 in India and 752 in Nepal. In 2006 there were only 2,577."),
                ("img1", "image", "normal",
                 "Chart: wild one-horned rhinos in India and Nepal together, 2006 and 2025.",
                 "charts/rhino-count.png"),
                ("p3", "paragraph", "normal",
                 "More than 70 percent of all one-horned rhinos live in a single place, Kaziranga National Park. "
                 "Pobitora Wildlife Sanctuary in Morigaon district has one of the largest rhino populations in Assam in a small area of about 38.8 sq km."),
                ("h1", "heading", "normal", "Threats"),
                ("p4", "paragraph", "normal",
                 "The main threat is {{term:poaching}} for the horn, which is used in traditional Chinese medicine. Floods, loss of grassland "
                 "and invasive plants are other threats."),
                ("p5", "paragraph", "normal",
                 "Under the Indian Rhino Vision 2020 programme, rhinos from Kaziranga were moved to other parks such as Manas to build new populations."),
                ("exam1", "fact_box", "exam_fact",
                 "Remember for exams: Rhinoceros unicornis; IUCN status Vulnerable; over 70% live in Kaziranga."),
            ],
            "as": [
                ("p1", "paragraph", "normal",
                 "{{term:one-horned-rhinoceros|এশিঙীয়া গঁড়}} (বৈজ্ঞানিক নাম Rhinoceros unicornis) অসমৰ ৰাজ্যিক জন্তু। "
                 "আই ইউ চি এনে ইয়াক {{term:iucn-vulnerable|বিপদাপন্ন}} প্ৰজাতি হিচাপে তালিকাভুক্ত কৰিছে।"),
                ("p2", "paragraph", "verified_fact",
                 "২০২৫ চনৰ মাৰ্চ মাহৰ লোকপিয়লত বনত ৪,০৭৫ টা গঁড় গণনা কৰা হয়: ভাৰতত ৩,৩২৩ আৰু নেপালত ৭৫২। ২০০৬ চনত মাত্ৰ ২,৫৭৭ টা আছিল।"),
                ("img1", "image", "normal",
                 "চিত্ৰ: ভাৰত আৰু নেপালত মুঠ বনৰীয়া এশিঙীয়া গঁড়ৰ সংখ্যা, ২০০৬ আৰু ২০২৫।",
                 "charts/rhino-count.png"),
                ("p3", "paragraph", "normal",
                 "সকলো এশিঙীয়া গঁড়ৰ ৭০ শতাংশতকৈ বেছি একেটা ঠাইতে থাকে, সেয়া হ'ল কাজিৰঙা ৰাষ্ট্ৰীয় উদ্যান। "
                 "মৰিগাঁও জিলাৰ পবিতৰা বন্যপ্ৰাণী অভয়াৰণ্যত প্ৰায় ৩৮.৮ বৰ্গ কিমিৰ সৰু এলেকাত অসমৰ আটাইতকৈ ডাঙৰ গঁড়ৰ সমষ্টিসমূহৰ এটা আছে।"),
                ("h1", "heading", "normal", "বিপদসমূহ"),
                ("p4", "paragraph", "normal",
                 "মূল বিপদ হৈছে খড়গৰ বাবে {{term:poaching|চোৰাং চিকাৰ}}; খড়গ পৰম্পৰাগত চীনা ঔষধত ব্যৱহাৰ হয়। বানপানী, তৃণভূমিৰ ক্ষয় "
                 "আৰু আগ্ৰাসী উদ্ভিদো আন বিপদ।"),
                ("p5", "paragraph", "normal",
                 "ইণ্ডিয়ান ৰাইন' ভিজন ২০২০ কাৰ্যসূচীৰ অধীনত কাজিৰঙাৰ পৰা গঁড় মানাহৰ দৰে আন উদ্যানলৈ স্থানান্তৰ কৰি নতুন সমষ্টি গঢ়া হয়।"),
                ("exam1", "fact_box", "exam_fact",
                 "পৰীক্ষাৰ বাবে মনত ৰাখক: Rhinoceros unicornis; আই ইউ চি এন স্থিতি বিপদাপন্ন; ৭০%তকৈ বেছি কাজিৰঙাত থাকে।"),
            ],
        },
    ),
    # ------------------------------------------------------------------ 3
    dict(
        slug="wildlife-sanctuaries-of-assam", position=3,
        title={"en": "Wildlife sanctuaries", "as": "বন্যপ্ৰাণী অভয়াৰণ্যসমূহ"},
        summary={"en": "Assam's 17 wildlife sanctuaries, and the best known among them.",
                 "as": "অসমৰ ১৭ খন বন্যপ্ৰাণী অভয়াৰণ্য, আৰু তাৰে আটাইতকৈ জনাজাতবোৰ।"},
        sources="\n".join([SRC_LIST, SRC_POB]),
        blocks={
            "en": [
                ("p1", "paragraph", "normal",
                 "Assam has 17 {{term:wildlife-sanctuary|wildlife sanctuaries}}. These are some of the best known:"),
                ("l1", "list", "geography",
                 "Pobitora (Morigaon, 1987): famous for one-horned rhinos.\n"
                 "Hoollongapar Gibbon (Jorhat, 1997): named after the {{term:hoolock-gibbon|hoolock gibbon}}, India's only ape.\n"
                 "Deepor Beel (Kamrup Metro, 1989): a wetland sanctuary near Guwahati.\n"
                 "Bornadi (1980), Sonai Rupai (1998), Laokhowa, Burachapori, Chakrashila, Garampani, Amchang, Borail and Marat Longri."),
                ("p2", "paragraph", "normal",
                 "The other sanctuaries are Panidihing Bird Sanctuary, Bherjan-Borajan-Padumoni, Nambor, Nambor-Doigrung and East Karbi Anglong."),
                ("exam1", "fact_box", "exam_fact",
                 "Remember for exams: Assam has 17 wildlife sanctuaries; Hoollongapar is the gibbon sanctuary; Pobitora is a rhino sanctuary."),
            ],
            "as": [
                ("p1", "paragraph", "normal",
                 "অসমত ১৭ খন {{term:wildlife-sanctuary|বন্যপ্ৰাণী অভয়াৰণ্য}} আছে। তাৰে কেইখনমান জনাজাত অভয়াৰণ্য:"),
                ("l1", "list", "geography",
                 "পবিতৰা (মৰিগাঁও, ১৯৮৭): এশিঙীয়া গঁড়ৰ বাবে বিখ্যাত।\n"
                 "হোলোঙাপাৰ গিবন (যোৰহাট, ১৯৯৭): ভাৰতৰ একমাত্ৰ এপ {{term:hoolock-gibbon|হলৌ বান্দৰৰ}} নামেৰে নামকৰণ কৰা।\n"
                 "দীপৰ বিল (কামৰূপ মহানগৰ, ১৯৮৯): গুৱাহাটীৰ ওচৰৰ এক জলাভূমি অভয়াৰণ্য।\n"
                 "বৰনদী (১৯৮০), সোণাই-ৰূপাই (১৯৯৮), লাওখোৱা, বুঢ়াচাপৰি, চক্ৰশিলা, গৰমপানী, আমচাং, বৰাইল আৰু মাৰাত লংৰি।"),
                ("p2", "paragraph", "normal",
                 "বাকী অভয়াৰণ্যকেইখন হ'ল পানীদিহিং পক্ষী অভয়াৰণ্য, ভেৰজান-বৰজান-পদুমণি, নামবৰ, নামবৰ-দৈগ্ৰুং আৰু পূব কাৰ্বি আংলং।"),
                ("exam1", "fact_box", "exam_fact",
                 "পৰীক্ষাৰ বাবে মনত ৰাখক: অসমত ১৭ খন বন্যপ্ৰাণী অভয়াৰণ্য; হোলোঙাপাৰ হলৌ বান্দৰৰ অভয়াৰণ্য; পবিতৰা গঁড়ৰ অভয়াৰণ্য।"),
            ],
        },
    ),
    # ------------------------------------------------------------------ 4
    dict(
        slug="reserves-and-wetlands", position=4,
        title={"en": "Tiger reserves, biosphere reserves and wetlands", "as": "ব্যাঘ্ৰ প্ৰকল্প, জৈৱমণ্ডল সংৰক্ষিত ক্ষেত্ৰ আৰু জলাভূমি"},
        summary={"en": "Assam's tiger reserves, its biosphere reserves, and Deepor Beel, its Ramsar site.",
                 "as": "অসমৰ ব্যাঘ্ৰ প্ৰকল্প, জৈৱমণ্ডল সংৰক্ষিত ক্ষেত্ৰ আৰু ৰামচাৰ ক্ষেত্ৰ দীপৰ বিল।"},
        sources="\n".join([SRC_MANAS, SRC_KAZ, SRC_RAMSAR,
                           "TO VERIFY before publishing: l1 (the list of tiger reserves) and the Dibru-Saikhowa biosphere reserve line in p2."]),
        blocks={
            "en": [
                ("h1", "heading", "normal", "Tiger reserves"),
                ("p1", "paragraph", "normal",
                 "Several parks of Assam are also {{term:tiger-reserve|tiger reserves}} under Project Tiger:"),
                ("l1", "list", "geography",
                 "Manas Tiger Reserve\nKaziranga Tiger Reserve (declared in 2006 to 2007)\nNameri Tiger Reserve\nOrang Tiger Reserve"),
                ("h2", "heading", "normal", "Biosphere reserves"),
                ("p2", "paragraph", "normal",
                 "Manas was declared a {{term:biosphere-reserve|biosphere reserve}} in 1989. Dibru-Saikhowa is Assam's other biosphere reserve."),
                ("h3", "heading", "normal", "Wetlands"),
                ("p3", "paragraph", "verified_fact",
                 "Deepor Beel, a large {{term:wetland}} on the edge of Guwahati, is Assam's {{term:ramsar-site|Ramsar site}}. "
                 "It was listed on 19 August 2002 and covers about 30 sq km."),
                ("p4", "paragraph", "normal",
                 "Beels (wetlands) across Assam give food, fish and homes to many birds, and help to hold flood water."),
                ("exam1", "fact_box", "exam_fact",
                 "Remember for exams: Deepor Beel is Assam's Ramsar site (2002); Manas biosphere reserve 1989."),
            ],
            "as": [
                ("h1", "heading", "normal", "ব্যাঘ্ৰ প্ৰকল্প"),
                ("p1", "paragraph", "normal",
                 "অসমৰ কেইবাখনো উদ্যান প্ৰজেক্ট টাইগাৰৰ অধীনত {{term:tiger-reserve|ব্যাঘ্ৰ প্ৰকল্পও}}:"),
                ("l1", "list", "geography",
                 "মানাহ ব্যাঘ্ৰ প্ৰকল্প\nকাজিৰঙা ব্যাঘ্ৰ প্ৰকল্প (২০০৬-০৭ চনত ঘোষিত)\nনামেৰি ব্যাঘ্ৰ প্ৰকল্প\nওৰাং ব্যাঘ্ৰ প্ৰকল্প"),
                ("h2", "heading", "normal", "জৈৱমণ্ডল সংৰক্ষিত ক্ষেত্ৰ"),
                ("p2", "paragraph", "normal",
                 "১৯৮৯ চনত মানাহক {{term:biosphere-reserve|জৈৱমণ্ডল সংৰক্ষিত ক্ষেত্ৰ}} ঘোষণা কৰা হয়। ডিব্ৰু-চৈখোৱা অসমৰ আনখন জৈৱমণ্ডল সংৰক্ষিত ক্ষেত্ৰ।"),
                ("h3", "heading", "normal", "জলাভূমি"),
                ("p3", "paragraph", "verified_fact",
                 "গুৱাহাটীৰ দাঁতিত থকা বৃহৎ {{term:wetland|জলাভূমি}} দীপৰ বিল অসমৰ {{term:ramsar-site|ৰামচাৰ ক্ষেত্ৰ}}। "
                 "২০০২ চনৰ ১৯ আগষ্টত ইয়াক তালিকাভুক্ত কৰা হয় আৰু ইয়াৰ আয়তন প্ৰায় ৩০ বৰ্গ কিমি।"),
                ("p4", "paragraph", "normal",
                 "অসমৰ বিলসমূহে বহুতো চৰাইক খাদ্য, মাছ আৰু বাসস্থান দিয়ে, আৰু বানপানী ধৰি ৰাখাত সহায় কৰে।"),
                ("exam1", "fact_box", "exam_fact",
                 "পৰীক্ষাৰ বাবে মনত ৰাখক: দীপৰ বিল অসমৰ ৰামচাৰ ক্ষেত্ৰ (২০০২); মানাহ জৈৱমণ্ডল সংৰক্ষিত ক্ষেত্ৰ ১৯৮৯।"),
            ],
        },
    ),
]
