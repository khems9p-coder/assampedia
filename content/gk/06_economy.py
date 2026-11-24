"""Group 6: Economy of Assam (অসমৰ অৰ্থনীতি).

Block format: (block_key, block_type, style, body). Keys must match in both languages.
"""

CATEGORY_SLUG = "economy"
CATEGORY_NAME = "Economy of Assam"
LAST_CHECKED = "2026-11-24"

EXISTING_TERMS = {"dewan", "muga-silk", "tertiary-coal"}

W = "https://en.wikipedia.org/wiki/"
SRC_ECO = f"Economy of Assam, Wikipedia: {W}Economy_of_Assam"
SRC_TEA = f"Assam tea, Wikipedia: {W}Assam_tea"
SRC_DIG = f"Digboi Refinery, Wikipedia: {W}Digboi_Refinery"
SRC_NUM = f"Numaligarh Refinery, Wikipedia: {W}Numaligarh_Refinery"
SRC_GEO = f"Geography of Assam, Wikipedia: {W}Geography_of_Assam"

TERMS = [
    dict(slug="gsdp", en="GSDP", **{"as": "জি এছ ডি পি"},
         meaning_en="Gross State Domestic Product: the total value of all goods and services produced in a state in a year.",
         meaning_as="মুঠ ৰাজ্যিক ঘৰুৱা উৎপাদন: এবছৰত এখন ৰাজ্যত উৎপাদিত সকলো সামগ্ৰী আৰু সেৱাৰ মুঠ মূল্য।"),
    dict(slug="agrarian-economy", en="Agrarian economy", **{"as": "কৃষিভিত্তিক অৰ্থনীতি"},
         meaning_en="An economy in which most people earn their living from farming.",
         meaning_as="যি অৰ্থনীতিত বেছিভাগ মানুহে কৃষিৰ পৰা জীৱিকা উলিয়ায়।"),
    dict(slug="staple-food", en="Staple food", **{"as": "প্ৰধান খাদ্য"},
         meaning_en="The main food that people eat every day. In Assam it is rice.",
         meaning_as="মানুহে প্ৰতিদিনে খোৱা মূল খাদ্য। অসমত ই ভাত।"),
    dict(slug="camellia-assamica", en="Camellia sinensis var. assamica", **{"as": "কেমেলিয়া চিনেনচিছ ভেৰ. আছামিকা"},
         meaning_en="The scientific name of the Assam tea plant, a variety native to Assam.",
         meaning_as="অসমৰ চাহ গছৰ বৈজ্ঞানিক নাম, অসমৰ নিজা এবিধ জাত।"),
    dict(slug="refinery", en="Refinery", **{"as": "শোধনাগাৰ"},
         meaning_en="A factory where crude oil is cleaned and turned into petrol, diesel, kerosene and other products.",
         meaning_as="খাৰুৱা তেল শোধন কৰি পেট্ৰ'ল, ডিজেল, কেৰাচিন আদি সামগ্ৰী উৎপাদন কৰা কাৰখানা।"),
    dict(slug="crude-oil", en="Crude oil", **{"as": "খাৰুৱা তেল"},
         meaning_en="Petroleum as it comes out of the ground, before it is refined.",
         meaning_as="শোধন কৰাৰ আগতে মাটিৰ তলৰ পৰা উলিওৱা পেট্ৰ'লিয়াম।"),
    dict(slug="sericulture", en="Sericulture", **{"as": "পলুপোহা"},
         meaning_en="Rearing silkworms to produce silk.",
         meaning_as="পাট উৎপাদনৰ বাবে পলু পোহা।"),
]

CHAPTERS = [
    # ------------------------------------------------------------------ 1
    dict(
        slug="agriculture-and-crops", position=1,
        title={"en": "Agriculture and main crops", "as": "কৃষি আৰু প্ৰধান শস্য"},
        summary={"en": "How farming supports Assam, the share of each sector, and the main crops.",
                 "as": "কৃষিয়ে অসমক কেনেকৈ চলাই ৰাখিছে, প্ৰতিটো খণ্ডৰ অংশ আৰু প্ৰধান শস্যসমূহ।"},
        sources="\n".join([SRC_ECO, "TO VERIFY before publishing: the three paddy seasons (Ahu, Sali, Boro) in l1."]),
        blocks={
            "en": [
                ("p1", "paragraph", "normal",
                 "Assam has a largely {{term:agrarian-economy|agrarian economy}}. Farming gives work to most of its people."),
                ("p2", "paragraph", "verified_fact",
                 "In 2021-22, agriculture made up about 25 percent of Assam's economy, industry about 30 percent and services about 45 percent."),
                ("h1", "heading", "normal", "Main crops"),
                ("p3", "paragraph", "normal",
                 "Rice is the {{term:staple-food|staple food}} of Assam and its main crop. It is grown in three seasons:"),
                ("l1", "list", "geography",
                 "Ahu: the autumn paddy\nSali: the winter paddy, the main rice crop\nBoro: the summer paddy"),
                ("p4", "paragraph", "normal",
                 "Tea is the most important cash crop. Other crops include jute, mustard, pulses, sugarcane, vegetables and fruits."),
                ("exam1", "fact_box", "exam_fact",
                 "Remember for exams: sector shares 2021-22: agriculture 25%, industry 30%, services 45%."),
            ],
            "as": [
                ("p1", "paragraph", "normal",
                 "অসমৰ অৰ্থনীতি মূলতঃ {{term:agrarian-economy|কৃষিভিত্তিক}}। কৃষিয়ে ইয়াৰ বেছিভাগ মানুহক সংস্থাপন দিয়ে।"),
                ("p2", "paragraph", "verified_fact",
                 "২০২১-২২ চনত অসমৰ অৰ্থনীতিত কৃষিৰ অংশ প্ৰায় ২৫ শতাংশ, উদ্যোগৰ প্ৰায় ৩০ শতাংশ আৰু সেৱা খণ্ডৰ প্ৰায় ৪৫ শতাংশ আছিল।"),
                ("h1", "heading", "normal", "প্ৰধান শস্য"),
                ("p3", "paragraph", "normal",
                 "ধান অসমৰ {{term:staple-food|প্ৰধান খাদ্য}} আৰু প্ৰধান শস্য। তিনিটা বতৰত ধান খেতি কৰা হয়:"),
                ("l1", "list", "geography",
                 "আহু: শৰৎকালীন ধান\nশালি: শীতকালীন ধান, মূল ধান খেতি\nবাও/বোৰো: গ্ৰীষ্মকালীন ধান"),
                ("p4", "paragraph", "normal",
                 "চাহ আটাইতকৈ গুৰুত্বপূৰ্ণ বাণিজ্যিক শস্য। আন শস্যৰ ভিতৰত আছে মৰাপাট, সৰিয়হ, মাহজাতীয় শস্য, কুঁহিয়াৰ, শাক-পাচলি আৰু ফল-মূল।"),
                ("exam1", "fact_box", "exam_fact",
                 "পৰীক্ষাৰ বাবে মনত ৰাখক: ২০২১-২২ত খণ্ডসমূহৰ অংশ: কৃষি ২৫%, উদ্যোগ ৩০%, সেৱা ৪৫%।"),
            ],
        },
    ),
    # ------------------------------------------------------------------ 2
    dict(
        slug="tea-industry", position=2,
        title={"en": "The tea industry", "as": "চাহ উদ্যোগ"},
        summary={"en": "How Assam tea was found, the Assam Company, and Assam's place in tea today.",
                 "as": "অসমৰ চাহ কেনেকৈ পোৱা গ'ল, আসাম কোম্পানী, আৰু আজিৰ চাহ উদ্যোগত অসমৰ স্থান।"},
        sources="\n".join([SRC_TEA, SRC_ECO, f"Maniram Dewan, Wikipedia: {W}Maniram_Dewan",
                           "TO VERIFY before publishing: p4 (Tocklai Tea Research Institute, Jorhat, 1911)."]),
        blocks={
            "en": [
                ("p1", "paragraph", "normal",
                 "Assam is the world's largest tea-growing region by production. It grows about 680 million kg of tea a year, and in 2015 "
                 "it produced about 60 percent of India's tea."),
                ("h1", "heading", "normal", "How Assam tea was found"),
                ("p2", "paragraph", "event",
                 "In 1823 a Scottish trader, Robert Bruce, came across the tea plant in Assam. Maniram Dewan directed him to the Singpho chief Bessa Gam, "
                 "whose people used the plant. The Assam tea plant is a local variety, {{term:camellia-assamica|Camellia sinensis var. assamica}}."),
                ("p3", "paragraph", "event",
                 "The first Assam tea was shipped to London in 1838 and auctioned in January 1839. In 1839 the Assam Company was formed, and "
                 "Maniram became its {{term:dewan|Dewan}} at Nazira."),
                ("p4", "paragraph", "normal",
                 "The Tocklai Tea Research Institute at Jorhat, set up in 1911, is one of the oldest tea research centres in the world."),
                ("exam1", "fact_box", "exam_fact",
                 "Remember for exams: Robert Bruce found Assam tea in 1823; Assam Company formed in 1839."),
            ],
            "as": [
                ("p1", "paragraph", "normal",
                 "উৎপাদনৰ হিচাপত অসম পৃথিৱীৰ বৃহত্তম চাহ উৎপাদনকাৰী অঞ্চল। ইয়াত বছৰি প্ৰায় ৬৮ কোটি কিলোগ্ৰাম চাহ উৎপাদন হয়, আৰু ২০১৫ চনত "
                 "ভাৰতৰ মুঠ চাহৰ প্ৰায় ৬০ শতাংশ অসমত উৎপাদন হৈছিল।"),
                ("h1", "heading", "normal", "অসমৰ চাহ কেনেকৈ পোৱা গ'ল"),
                ("p2", "paragraph", "event",
                 "১৮২৩ চনত স্কটলেণ্ডৰ বেপাৰী ৰবাৰ্ট ব্ৰুছে অসমত চাহ গছ দেখা পায়। মণিৰাম দেৱানে তেওঁক চিংফৌ মুখিয়াল বিছা গামৰ ওচৰলৈ পঠায়, "
                 "যাৰ লোকসকলে এই গছ ব্যৱহাৰ কৰিছিল। অসমৰ চাহ গছ এবিধ স্থানীয় জাত, {{term:camellia-assamica|কেমেলিয়া চিনেনচিছ ভেৰ. আছামিকা}}।"),
                ("p3", "paragraph", "event",
                 "১৮৩৮ চনত প্ৰথম অসমৰ চাহ লণ্ডনলৈ পঠোৱা হয় আৰু ১৮৩৯ চনৰ জানুৱাৰীত নিলাম হয়। ১৮৩৯ চনত আসাম কোম্পানী গঠন হয়, আৰু "
                 "মণিৰাম নাজিৰাত ইয়াৰ {{term:dewan|দেৱান}} হয়।"),
                ("p4", "paragraph", "normal",
                 "১৯১১ চনত স্থাপিত যোৰহাটৰ টোকলাই চাহ গৱেষণা প্ৰতিষ্ঠান পৃথিৱীৰ আটাইতকৈ পুৰণি চাহ গৱেষণা কেন্দ্ৰসমূহৰ এটা।"),
                ("exam1", "fact_box", "exam_fact",
                 "পৰীক্ষাৰ বাবে মনত ৰাখক: ১৮২৩ চনত ৰবাৰ্ট ব্ৰুছে অসমৰ চাহ পায়; ১৮৩৯ চনত আসাম কোম্পানী গঠন।"),
            ],
        },
    ),
    # ------------------------------------------------------------------ 3
    dict(
        slug="oil-and-natural-gas", position=3,
        title={"en": "Oil and natural gas", "as": "খাৰুৱা তেল আৰু প্ৰাকৃতিক গেছ"},
        summary={"en": "Digboi, Asia's first refinery, and the four refineries of Assam.",
                 "as": "এছিয়াৰ প্ৰথম শোধনাগাৰ ডিগবৈ, আৰু অসমৰ চাৰিটা শোধনাগাৰ।"},
        sources="\n".join([SRC_DIG, SRC_NUM, SRC_ECO, SRC_GEO]),
        blocks={
            "en": [
                ("p1", "paragraph", "normal",
                 "Oil was first found by accident in the Digboi area in 1867, while a railway line was being laid. Drilling for oil began in 1889."),
                ("p2", "paragraph", "event",
                 "The Digboi {{term:refinery}} was started by the Assam Oil Company and commissioned on 11 December 1901. It is Asia's first refinery "
                 "and India's oldest refinery still working."),
                ("h1", "heading", "normal", "Refineries of Assam"),
                ("l1", "list", "verified_fact",
                 "Digboi (Tinsukia district), 1901\nGuwahati\nBongaigaon\nNumaligarh (Golaghat district): commercial production from 1 October 2000"),
                ("p3", "paragraph", "normal",
                 "Together the four refineries can process about 7 million tonnes of {{term:crude-oil|crude oil}} a year. "
                 "The oil and gas fields are in the districts of Upper Assam."),
                ("exam1", "fact_box", "exam_fact",
                 "Remember for exams: Digboi refinery, 1901, Asia's first; drilling began 1889; Assam has 4 refineries."),
            ],
            "as": [
                ("p1", "paragraph", "normal",
                 "১৮৬৭ চনত ৰেলপথ নিৰ্মাণৰ সময়ত ডিগবৈ অঞ্চলত আকস্মিকভাৱে প্ৰথম তেল পোৱা যায়। ১৮৮৯ চনত তেলৰ বাবে খনন আৰম্ভ হয়।"),
                ("p2", "paragraph", "event",
                 "আসাম অইল কোম্পানীয়ে আৰম্ভ কৰা ডিগবৈ {{term:refinery|শোধনাগাৰ}} ১৯০১ চনৰ ১১ ডিচেম্বৰত চালু হয়। ই এছিয়াৰ প্ৰথম শোধনাগাৰ "
                 "আৰু এতিয়াও চলি থকা ভাৰতৰ আটাইতকৈ পুৰণি শোধনাগাৰ।"),
                ("h1", "heading", "normal", "অসমৰ শোধনাগাৰসমূহ"),
                ("l1", "list", "verified_fact",
                 "ডিগবৈ (তিনিচুকীয়া জিলা), ১৯০১\nগুৱাহাটী\nবঙাইগাঁও\nনুমলীগড় (গোলাঘাট জিলা): ১ অক্টোবৰ ২০০০ৰ পৰা বাণিজ্যিক উৎপাদন"),
                ("p3", "paragraph", "normal",
                 "চাৰিওটা শোধনাগাৰে একেলগে বছৰি প্ৰায় ৭০ লাখ টন {{term:crude-oil|খাৰুৱা তেল}} শোধন কৰিব পাৰে। "
                 "তেল আৰু গেছৰ ক্ষেত্ৰসমূহ উজনি অসমৰ জিলাসমূহত আছে।"),
                ("exam1", "fact_box", "exam_fact",
                 "পৰীক্ষাৰ বাবে মনত ৰাখক: ডিগবৈ শোধনাগাৰ, ১৯০১, এছিয়াৰ প্ৰথম; খনন আৰম্ভ ১৮৮৯; অসমত ৪ টা শোধনাগাৰ।"),
            ],
        },
    ),
    # ------------------------------------------------------------------ 4
    dict(
        slug="industries-and-sericulture", position=4,
        title={"en": "Industries and sericulture", "as": "উদ্যোগ আৰু পলুপোহা"},
        summary={"en": "Fertiliser, paper, coal and silk: the other industries of Assam.",
                 "as": "সাৰ, কাগজ, কয়লা আৰু পাট-মুগা: অসমৰ অন্যান্য উদ্যোগ।"},
        sources="\n".join([SRC_ECO, SRC_GEO, f"Muga silk, Wikipedia: {W}Muga_silk"]),
        blocks={
            "en": [
                ("p1", "paragraph", "normal",
                 "Apart from tea and oil, Assam has several other industries:"),
                ("l1", "list", "normal",
                 "Fertiliser: a chemical fertiliser plant at Namrup.\n"
                 "Paper: paper mills at Jagiroad, Panchgram and Jogighopa.\n"
                 "Coal: mined in the {{term:tertiary-coal|Tertiary coal}} belt of Upper Assam and the hill districts.\n"
                 "Textiles: silk, jute and yarn mills, and household handlooms."),
                ("h1", "heading", "normal", "Sericulture"),
                ("p2", "paragraph", "heritage",
                 "{{term:sericulture|Sericulture}} is a major rural occupation. Assam rears Muga, Eri and Pat silkworms. "
                 "{{term:muga-silk|Muga silk}} is produced only in Assam."),
                ("p3", "paragraph", "normal",
                 "The economy of Assam grew at about 7 percent a year between 2016 and 2025 (at constant 2011-12 prices), measured by its {{term:gsdp|GSDP}}."),
                ("exam1", "fact_box", "exam_fact",
                 "Remember for exams: fertiliser plant at Namrup; paper mills at Jagiroad, Panchgram and Jogighopa."),
            ],
            "as": [
                ("p1", "paragraph", "normal",
                 "চাহ আৰু তেলৰ উপৰিও অসমত আন কেইবাটাও উদ্যোগ আছে:"),
                ("l1", "list", "normal",
                 "সাৰ: নামৰূপত ৰাসায়নিক সাৰৰ কাৰখানা।\n"
                 "কাগজ: জাগীৰোড, পাঁচগ্ৰাম আৰু যোগীঘোপাত কাগজ কল।\n"
                 "কয়লা: উজনি অসম আৰু পাহাৰীয়া জিলাসমূহৰ {{term:tertiary-coal|টাৰ্চিয়াৰী কয়লাৰ}} বলয়ৰ পৰা উত্তোলন কৰা হয়।\n"
                 "বস্ত্ৰ: পাট, মৰাপাট আৰু সূতা কল, আৰু ঘৰুৱা তাঁতশাল।"),
                ("h1", "heading", "normal", "পলুপোহা"),
                ("p2", "paragraph", "heritage",
                 "{{term:sericulture|পলুপোহা}} এক প্ৰধান গ্ৰাম্য বৃত্তি। অসমত মুগা, এৰী আৰু পাট পলু পোহা হয়। "
                 "{{term:muga-silk|মুগা}} কেৱল অসমতহে উৎপাদন হয়।"),
                ("p3", "paragraph", "normal",
                 "{{term:gsdp|জি এছ ডি পি}}ৰ হিচাপত ২০১৬ ৰ পৰা ২০২৫ চনৰ ভিতৰত অসমৰ অৰ্থনীতি বছৰি প্ৰায় ৭ শতাংশ হাৰত (২০১১-১২ৰ স্থিৰ মূল্যত) বৃদ্ধি পাইছিল।"),
                ("exam1", "fact_box", "exam_fact",
                 "পৰীক্ষাৰ বাবে মনত ৰাখক: নামৰূপত সাৰৰ কাৰখানা; জাগীৰোড, পাঁচগ্ৰাম আৰু যোগীঘোপাত কাগজ কল।"),
            ],
        },
    ),
]
