"""Group 3: Geography of Assam (অসমৰ ভূগোল).

Block format: (block_key, block_type, style, body). Keys must match in both languages.
"""

CATEGORY_SLUG = "geography"
CATEGORY_NAME = "Geography of Assam"
LAST_CHECKED = "2026-11-24"

EXISTING_TERMS = set()

W = "https://en.wikipedia.org/wiki/"
SRC_GEO = f"Geography of Assam, Wikipedia: {W}Geography_of_Assam"
SRC_BRAH = f"Brahmaputra River, Wikipedia: {W}Brahmaputra_River"
SRC_BARAK = f"Barak River, Wikipedia: {W}Barak_River"
SRC_CM = "State Profile, Office of the Chief Minister of Assam: https://cm.assam.gov.in/state-profile"

TERMS = [
    dict(slug="physiography", en="Physiography", **{"as": "প্ৰাকৃতিক গঠন"},
         meaning_en="The natural shape of the land: its plains, hills, plateaus and valleys.",
         meaning_as="ভূমিৰ প্ৰাকৃতিক গঠন: ইয়াৰ সমভূমি, পাহাৰ, মালভূমি আৰু উপত্যকা।"),
    dict(slug="valley", en="Valley", **{"as": "উপত্যকা"},
         meaning_en="Low land between hills or mountains, usually with a river flowing through it.",
         meaning_as="পাহাৰ বা পৰ্বতৰ মাজৰ নিম্নভূমি, য'ৰ মাজেৰে সাধাৰণতে নদী বৈ যায়।"),
    dict(slug="plateau", en="Plateau", **{"as": "মালভূমি"},
         meaning_en="A raised area of land that is fairly flat on top.",
         meaning_as="ওপৰভাগ প্ৰায় সমান থকা ওখ ভূমি।"),
    dict(slug="tributary", en="Tributary", **{"as": "উপনৈ"},
         meaning_en="A smaller river that flows into a bigger river.",
         meaning_as="ডাঙৰ নদীত আহি মিলি যোৱা সৰু নদী।"),
    dict(slug="braided-river", en="Braided river", **{"as": "বেণীবদ্ধ নদী"},
         meaning_en="A river that splits into many channels around sandbanks and islands, like a braid of hair.",
         meaning_as="চাপৰি আৰু দ্বীপৰ চাৰিওফালে বহু সুঁতিত বিভক্ত হৈ চুলিৰ বেণীৰ দৰে বোৱা নদী।"),
    dict(slug="river-island", en="River island", **{"as": "নদী দ্বীপ"},
         meaning_en="Land surrounded by the channels of a river. Majuli is the best-known river island of Assam.",
         meaning_as="নদীৰ সুঁতিৰে আগুৰা ভূমি। মাজুলী অসমৰ আটাইতকৈ জনাজাত নদী দ্বীপ।"),
    dict(slug="confluence", en="Confluence", **{"as": "সংগম"},
         meaning_en="The place where two or more rivers meet.",
         meaning_as="দুখন বা তাতোকৈ বেছি নদী মিলিত হোৱা ঠাই।"),
    dict(slug="monsoon", en="Monsoon", **{"as": "মৌচুমী"},
         meaning_en="The season of strong rain-bearing winds. In Assam the monsoon rains are heaviest in summer.",
         meaning_as="বৰষুণ কঢ়িয়াই অনা প্ৰবল বতাহৰ ঋতু। অসমত গ্ৰীষ্মকালত মৌচুমী বৰষুণ আটাইতকৈ বেছি হয়।"),
    dict(slug="bordoisila", en="Bordoisila", **{"as": "বৰদৈচিলা"},
         meaning_en="The strong afternoon thunderstorms of the Bohag Bihu season (spring) in Assam.",
         meaning_as="অসমত বহাগ বিহুৰ সময়ত (বসন্তকালত) আবেলি হোৱা প্ৰবল ধুমুহা-বৰষুণ।"),
    dict(slug="alluvial-soil", en="Alluvial soil", **{"as": "পলসুৱা মাটি"},
         meaning_en="Fertile soil made of silt and sand laid down by rivers, especially after floods.",
         meaning_as="নদীয়ে বিশেষকৈ বানপানীৰ পিছত পেলাই থৈ যোৱা পলস আৰু বালিৰে গঠিত উৰ্বৰ মাটি।"),
    dict(slug="tertiary-coal", en="Tertiary coal", **{"as": "টাৰ্চিয়াৰী কয়লা"},
         meaning_en="Younger coal formed in the Tertiary period of the earth's history. Assam's coal is of this kind.",
         meaning_as="পৃথিৱীৰ ইতিহাসৰ টাৰ্চিয়াৰী যুগত গঠন হোৱা তুলনামূলকভাৱে নতুন কয়লা। অসমৰ কয়লা এই প্ৰকাৰৰ।"),
]

CHAPTERS = [
    # ------------------------------------------------------------------ 1
    dict(
        slug="physical-divisions-of-assam", position=1,
        title={"en": "Physical divisions of Assam", "as": "অসমৰ প্ৰাকৃতিক বিভাগ"},
        summary={"en": "The Brahmaputra Valley, the Barak Valley and the hills of Karbi Anglong and Dima Hasao.",
                 "as": "ব্ৰহ্মপুত্ৰ উপত্যকা, বৰাক উপত্যকা আৰু কাৰ্বি আংলং আৰু ডিমা হাছাওৰ পাহাৰ।"},
        sources="\n".join([SRC_GEO, SRC_CM]),
        blocks={
            "en": [
                ("p1", "paragraph", "normal",
                 "By its {{term:physiography}}, Assam can be divided into three parts:"),
                ("l1", "list", "geography",
                 "The Brahmaputra Valley: about 80 to 100 km wide and almost 1,000 km long. It covers most of the state.\n"
                 "The Barak Valley: a small {{term:valley}} in the south, about 40 to 50 km in average width and length.\n"
                 "The Karbi Anglong and Dima Hasao (North Cachar) hills: they lie between the two valleys, with an average height of 300 to 400 metres, "
                 "rising to almost 2,000 metres."),
                ("p2", "paragraph", "normal",
                 "The Karbi Anglong hills are part of the Deccan {{term:plateau}}, which shows how old this land is."),
                ("p3", "paragraph", "normal",
                 "Assam lies in a zone of strong earthquakes. The great earthquakes of 1897 and 1950 measured 8.3 and 8.6 in magnitude."),
                ("exam1", "fact_box", "exam_fact",
                 "Remember for exams: three divisions: Brahmaputra Valley, Barak Valley, and the Karbi Anglong and Dima Hasao hills. "
                 "Earthquakes of 1897 (8.3) and 1950 (8.6)."),
            ],
            "as": [
                ("p1", "paragraph", "normal",
                 "{{term:physiography|প্ৰাকৃতিক গঠন}} অনুসৰি অসমক তিনিটা ভাগত ভগাব পাৰি:"),
                ("l1", "list", "geography",
                 "ব্ৰহ্মপুত্ৰ উপত্যকা: প্ৰায় ৮০ ৰ পৰা ১০০ কিমি বহল আৰু প্ৰায় ১,০০০ কিমি দীঘল। ৰাজ্যখনৰ বেছিভাগ অংশ ইয়াৰ ভিতৰত পৰে।\n"
                 "বৰাক উপত্যকা: দক্ষিণত থকা এটা সৰু {{term:valley|উপত্যকা}}, যাৰ গড় দৈৰ্ঘ্য আৰু প্ৰস্থ প্ৰায় ৪০ ৰ পৰা ৫০ কিমি।\n"
                 "কাৰ্বি আংলং আৰু ডিমা হাছাও (উত্তৰ কাছাৰ) পাহাৰ: দুয়োটা উপত্যকাৰ মাজত অৱস্থিত; গড় উচ্চতা ৩০০ ৰ পৰা ৪০০ মিটাৰ, "
                 "সৰ্বোচ্চ প্ৰায় ২,০০০ মিটাৰ।"),
                ("p2", "paragraph", "normal",
                 "কাৰ্বি আংলঙৰ পাহাৰবোৰ দাক্ষিণাত্য {{term:plateau|মালভূমিৰ}} অংশ, যিয়ে এই ভূমিৰ প্ৰাচীনত্ব দেখুৱায়।"),
                ("p3", "paragraph", "normal",
                 "অসম প্ৰবল ভূমিকম্পৰ অঞ্চলত অৱস্থিত। ১৮৯৭ আৰু ১৯৫০ চনৰ বৰ ভূমিকম্পৰ মাত্ৰা আছিল ক্ৰমে ৮.৩ আৰু ৮.৬।"),
                ("exam1", "fact_box", "exam_fact",
                 "পৰীক্ষাৰ বাবে মনত ৰাখক: তিনিটা বিভাগ: ব্ৰহ্মপুত্ৰ উপত্যকা, বৰাক উপত্যকা, আৰু কাৰ্বি আংলং আৰু ডিমা হাছাওৰ পাহাৰ। "
                 "১৮৯৭ (৮.৩) আৰু ১৯৫০ (৮.৬) চনৰ ভূমিকম্প।"),
            ],
        },
    ),
    # ------------------------------------------------------------------ 2
    dict(
        slug="brahmaputra-river-system", position=2,
        title={"en": "The Brahmaputra river system", "as": "ব্ৰহ্মপুত্ৰ নদী প্ৰণালী"},
        summary={"en": "Where the Brahmaputra comes from, its names, its tributaries in Assam, and Majuli.",
                 "as": "ব্ৰহ্মপুত্ৰৰ উৎস, ইয়াৰ বিভিন্ন নাম, অসমত ইয়াৰ উপনৈসমূহ আৰু মাজুলী।"},
        sources=SRC_BRAH,
        blocks={
            "en": [
                ("p1", "paragraph", "normal",
                 "The Brahmaputra rises in Tibet, in the region of Lake Manasarovar. It is about 3,000 km long, though different "
                 "sources give figures between 2,880 and 3,080 km."),
                ("l1", "list", "geography",
                 "In Tibet: Yarlung Tsangpo\n"
                 "In Arunachal Pradesh: Siang, and Dihang in the plains\n"
                 "In Assam: Brahmaputra\n"
                 "In Bangladesh: Jamuna"),
                ("p2", "paragraph", "normal",
                 "Just west of Sadiya, the Dihang is joined by the Lohit and the Dibang. Below this {{term:confluence}} the river is called "
                 "the Brahmaputra. It then flows about 700 km through Assam as a wide {{term:braided-river|braided river}}."),
                ("h1", "heading", "normal", "Main tributaries in Assam"),
                ("l2", "list", "geography",
                 "From the north (Himalayan side): Subansiri, Kameng (Jia Bharali), Dhansiri, Manas, Champamati, Saralbhanga and Sankosh\n"
                 "From the south (hills and plateau): Burhi Dihing, Disang, Dikhow and Kopili"),
                ("p3", "paragraph", "normal",
                 "Each of these is a {{term:tributary}} of the Brahmaputra. Between Dibrugarh and Lakhimpur the river splits into two channels that "
                 "join again about 100 km downstream, forming Majuli, often called the largest {{term:river-island|river island}} in the world."),
                ("p4", "paragraph", "normal",
                 "In Bangladesh the Jamuna joins the Ganga, and the combined river, the Padma, later meets the Meghna and flows into the Bay of Bengal."),
                ("exam1", "fact_box", "exam_fact",
                 "Remember for exams: Tsangpo (Tibet), Siang/Dihang (Arunachal), Brahmaputra (Assam), Jamuna (Bangladesh). "
                 "Dihang, Lohit and Dibang meet near Sadiya."),
            ],
            "as": [
                ("p1", "paragraph", "normal",
                 "ব্ৰহ্মপুত্ৰৰ উৎপত্তি তিব্বতৰ মানসৰোবৰ হ্ৰদৰ অঞ্চলত। ইয়াৰ দৈৰ্ঘ্য প্ৰায় ৩,০০০ কিমি, যদিও বিভিন্ন উৎসত "
                 "২,৮৮০ ৰ পৰা ৩,০৮০ কিমিৰ ভিতৰৰ বেলেগ বেলেগ হিচাপ পোৱা যায়।"),
                ("l1", "list", "geography",
                 "তিব্বতত: ইয়াৰলুং চাংপো\n"
                 "অৰুণাচল প্ৰদেশত: চিয়াং, আৰু সমভূমিত ডিহাং\n"
                 "অসমত: ব্ৰহ্মপুত্ৰ\n"
                 "বাংলাদেশত: যমুনা"),
                ("p2", "paragraph", "normal",
                 "শদিয়াৰ ঠিক পশ্চিমে ডিহাঙৰ সৈতে লুইত আৰু দিবাং মিলিত হয়। এই {{term:confluence|সংগমৰ}} তলৰ পৰা নদীখনক "
                 "ব্ৰহ্মপুত্ৰ বোলা হয়। তাৰ পিছত ই এখন বহল {{term:braided-river|বেণীবদ্ধ নদী}} হিচাপে অসমৰ মাজেৰে প্ৰায় ৭০০ কিমি বৈ যায়।"),
                ("h1", "heading", "normal", "অসমত মূল উপনৈসমূহ"),
                ("l2", "list", "geography",
                 "উত্তৰৰ পৰা (হিমালয়ৰ ফালৰ): সোৱণশিৰি, কামেং (জীয়াভৰলী), ধনশিৰি, মানাহ, চম্পাৱতী, সৰলভাংগা আৰু সংকোষ\n"
                 "দক্ষিণৰ পৰা (পাহাৰ আৰু মালভূমিৰ): বুঢ়ীদিহিং, দিচাং, দিখৌ আৰু কপিলী"),
                ("p3", "paragraph", "normal",
                 "এইবোৰ প্ৰতিখনেই ব্ৰহ্মপুত্ৰৰ {{term:tributary|উপনৈ}}। ডিব্ৰুগড় আৰু লখিমপুৰৰ মাজত নদীখন দুটা সুঁতিত ভাগ হৈ "
                 "প্ৰায় ১০০ কিমি তলত পুনৰ লগ লাগে আৰু মাজুলীৰ সৃষ্টি কৰে, যাক প্ৰায়ে পৃথিৱীৰ বৃহত্তম {{term:river-island|নদী দ্বীপ}} বুলি কোৱা হয়।"),
                ("p4", "paragraph", "normal",
                 "বাংলাদেশত যমুনা গংগাৰ সৈতে মিলিত হয়, আৰু এই মিলিত নদী পদ্মাই পিছত মেঘনাৰ সৈতে লগ লাগি বংগোপসাগৰত পৰে।"),
                ("exam1", "fact_box", "exam_fact",
                 "পৰীক্ষাৰ বাবে মনত ৰাখক: চাংপো (তিব্বত), চিয়াং/ডিহাং (অৰুণাচল), ব্ৰহ্মপুত্ৰ (অসম), যমুনা (বাংলাদেশ)। "
                 "ডিহাং, লুইত আৰু দিবাং শদিয়াৰ ওচৰত মিলিত হয়।"),
            ],
        },
    ),
    # ------------------------------------------------------------------ 3
    dict(
        slug="barak-river-system", position=3,
        title={"en": "The Barak river system", "as": "বৰাক নদী প্ৰণালী"},
        summary={"en": "The Barak river, its course through southern Assam and its tributaries.",
                 "as": "বৰাক নদী, দক্ষিণ অসমৰ মাজেৰে ইয়াৰ গতিপথ আৰু ইয়াৰ উপনৈসমূহ।"},
        sources=SRC_BARAK,
        blocks={
            "en": [
                ("p1", "paragraph", "normal",
                 "The Barak is the main river of southern Assam. It rises near Liyai Khullen village in Senapati district, Manipur, "
                 "at a height of about 987 metres."),
                ("p2", "paragraph", "normal",
                 "From Manipur it flows to Tipaimukh, turns north to Jirimukh and then flows west into Cachar district of Assam, "
                 "and on through Sribhumi (Karimganj) district."),
                ("p3", "paragraph", "normal",
                 "It enters Bangladesh at Bhanga Bazar, where it splits into two rivers, the Surma and the Kushiyara. These later join to form the Meghna."),
                ("h1", "heading", "normal", "Tributaries of the Barak"),
                ("p4", "paragraph", "geography",
                 "Its main {{term:tributary|tributaries}} include the Jiri, Sonai, Dhaleswari, Jatinga, Longai and Madhura."),
                ("p5", "paragraph", "normal",
                 "The Barak is about 900 km long. Its basin covers about 52,000 sq km, of which 41,723 sq km is in India."),
                ("exam1", "fact_box", "exam_fact",
                 "Remember for exams: the Barak rises in Manipur and splits into the Surma and the Kushiyara in Bangladesh."),
            ],
            "as": [
                ("p1", "paragraph", "normal",
                 "বৰাক দক্ষিণ অসমৰ প্ৰধান নদী। ইয়াৰ উৎপত্তি মণিপুৰৰ চেনাপতি জিলাৰ লিয়াই খুলেন গাঁৱৰ ওচৰত, "
                 "প্ৰায় ৯৮৭ মিটাৰ উচ্চতাত।"),
                ("p2", "paragraph", "normal",
                 "মণিপুৰৰ পৰা ই টিপাইমুখলৈ বৈ যায়, তাৰ পৰা উত্তৰে জিৰিমুখলৈ ঘূৰি পশ্চিমমুৱাকৈ অসমৰ কাছাৰ জিলাত সোমায়, "
                 "আৰু শ্ৰীভূমি (কৰিমগঞ্জ) জিলাৰ মাজেৰে আগবাঢ়ে।"),
                ("p3", "paragraph", "normal",
                 "ভাঙা বজাৰত ই বাংলাদেশত প্ৰৱেশ কৰে আৰু তাত সুৰমা আৰু কুশিয়াৰা নামৰ দুখন নদীত বিভক্ত হয়। পিছত এই দুখন লগ লাগি মেঘনা হয়।"),
                ("h1", "heading", "normal", "বৰাকৰ উপনৈসমূহ"),
                ("p4", "paragraph", "geography",
                 "ইয়াৰ মূল {{term:tributary|উপনৈসমূহৰ}} ভিতৰত আছে জিৰি, সোণাই, ধলেশ্বৰী, জাটিংগা, লংগাই আৰু মধুৰা।"),
                ("p5", "paragraph", "normal",
                 "বৰাকৰ দৈৰ্ঘ্য প্ৰায় ৯০০ কিমি। ইয়াৰ অৱবাহিকাৰ আয়তন প্ৰায় ৫২,০০০ বৰ্গ কিমি, যাৰ ৪১,৭২৩ বৰ্গ কিমি ভাৰতত।"),
                ("exam1", "fact_box", "exam_fact",
                 "পৰীক্ষাৰ বাবে মনত ৰাখক: বৰাকৰ উৎপত্তি মণিপুৰত আৰু বাংলাদেশত ই সুৰমা আৰু কুশিয়াৰাত বিভক্ত হয়।"),
            ],
        },
    ),
    # ------------------------------------------------------------------ 4
    dict(
        slug="climate-and-floods", position=4,
        title={"en": "Climate and floods", "as": "জলবায়ু আৰু বানপানী"},
        summary={"en": "Assam's seasons, monsoon rains, Bordoisila storms and the yearly floods.",
                 "as": "অসমৰ ঋতু, মৌচুমী বৰষুণ, বৰদৈচিলা আৰু বছৰেকীয়া বানপানী।"},
        sources=SRC_GEO,
        blocks={
            "en": [
                ("p1", "paragraph", "normal",
                 "Assam has a tropical {{term:monsoon}} climate, with heavy rain and high humidity."),
                ("l1", "list", "geography",
                 "Winter: from late October to late February. Nights are foggy, and the lowest temperature is about 6 to 8 °C.\n"
                 "Summer: from mid-May. The highest temperature reaches about 35 to 38 °C, and the monsoon rains peak in June.\n"
                 "Spring (Bihu season): afternoons often bring {{term:bordoisila|Bordoisila}} thunderstorms."),
                ("h1", "heading", "normal", "Floods"),
                ("p2", "paragraph", "normal",
                 "Floods come almost every year in Assam. Heavy rainfall and the cutting of forests make them worse. "
                 "They cause loss of life, homes, crops and livelihoods."),
                ("p3", "paragraph", "normal",
                 "Floods also lay down fresh silt on the plains, which keeps the soil fertile."),
                ("exam1", "fact_box", "exam_fact",
                 "Remember for exams: Assam's climate is tropical monsoon; Bordoisila is the spring thunderstorm."),
            ],
            "as": [
                ("p1", "paragraph", "normal",
                 "অসমৰ জলবায়ু ক্ৰান্তীয় {{term:monsoon|মৌচুমী}} প্ৰকৃতিৰ, য'ত প্ৰচুৰ বৰষুণ আৰু অধিক আৰ্দ্ৰতা থাকে।"),
                ("l1", "list", "geography",
                 "শীতকাল: অক্টোবৰৰ শেষৰ পৰা ফেব্ৰুৱাৰীৰ শেষলৈ। ৰাতি কুঁৱলী পৰে আৰু সৰ্বনিম্ন উষ্ণতা প্ৰায় ৬ ৰ পৰা ৮ °C।\n"
                 "গ্ৰীষ্মকাল: মে' মাহৰ মাজভাগৰ পৰা। সৰ্বোচ্চ উষ্ণতা প্ৰায় ৩৫ ৰ পৰা ৩৮ °C, আৰু জুন মাহত মৌচুমী বৰষুণ আটাইতকৈ বেছি হয়।\n"
                 "বসন্তকাল (বিহুৰ সময়): আবেলি প্ৰায়ে {{term:bordoisila|বৰদৈচিলা}} ধুমুহা আহে।"),
                ("h1", "heading", "normal", "বানপানী"),
                ("p2", "paragraph", "normal",
                 "অসমত প্ৰায় প্ৰতি বছৰে বানপানী হয়। অধিক বৰষুণ আৰু হাবি-বন নিধনে ইয়াক অধিক ভয়াবহ কৰে। "
                 "ইয়াৰ ফলত প্ৰাণ, ঘৰ-দুৱাৰ, শস্য আৰু জীৱিকাৰ ক্ষতি হয়।"),
                ("p3", "paragraph", "normal",
                 "বানপানীয়ে সমভূমিত নতুন পলস পেলাই থৈ যায়, যিয়ে মাটি উৰ্বৰ কৰি ৰাখে।"),
                ("exam1", "fact_box", "exam_fact",
                 "পৰীক্ষাৰ বাবে মনত ৰাখক: অসমৰ জলবায়ু ক্ৰান্তীয় মৌচুমী; বৰদৈচিলা বসন্তকালৰ ধুমুহা।"),
            ],
        },
    ),
    # ------------------------------------------------------------------ 5
    dict(
        slug="soils-minerals-forests", position=5,
        title={"en": "Soils, minerals and forests", "as": "মাটি, খনিজ আৰু অৰণ্য"},
        summary={"en": "Fertile river soils, oil, gas, coal and limestone, and where they are found.",
                 "as": "উৰ্বৰ পলসুৱা মাটি, তেল, গেছ, কয়লা আৰু চূণশিল, আৰু সেইবোৰ ক'ত পোৱা যায়।"},
        sources="\n".join([SRC_GEO, SRC_BRAH]),
        blocks={
            "en": [
                ("p1", "paragraph", "normal",
                 "The plains of the Brahmaputra and Barak valleys have fertile {{term:alluvial-soil|alluvial soil}}, renewed by the rivers. "
                 "This is why farming is the main occupation in Assam."),
                ("h1", "heading", "normal", "Minerals"),
                ("l1", "list", "geography",
                 "Petroleum and natural gas: found in the districts of Upper Assam. Petroleum was discovered in Assam in 1889.\n"
                 "Coal: a {{term:tertiary-coal|Tertiary coal}} belt in Tinsukia, Dibrugarh, Sivasagar, Karbi Anglong and Dima Hasao.\n"
                 "Limestone: in Dima Hasao and Karbi Anglong, with large deposits near Umrangso in Dima Hasao.\n"
                 "Other minerals: quartzite (Nagaon), kaolin (Karbi Anglong and Lakhimpur) and sillimanite (Karbi Anglong)."),
                ("h2", "heading", "normal", "Forests"),
                ("p2", "paragraph", "normal",
                 "Assam has rich tropical forests. Kaziranga and Manas, two of its protected forests, are UNESCO World Heritage Sites."),
                ("exam1", "fact_box", "exam_fact",
                 "Remember for exams: petroleum found in Assam in 1889; coal belt of Upper Assam is Tertiary; limestone at Umrangso."),
            ],
            "as": [
                ("p1", "paragraph", "normal",
                 "ব্ৰহ্মপুত্ৰ আৰু বৰাক উপত্যকাৰ সমভূমিত নদীয়ে নৱীকৰণ কৰি ৰখা উৰ্বৰ {{term:alluvial-soil|পলসুৱা মাটি}} আছে। "
                 "সেইবাবেই কৃষি অসমৰ মূল বৃত্তি।"),
                ("h1", "heading", "normal", "খনিজ সম্পদ"),
                ("l1", "list", "geography",
                 "খাৰুৱা তেল আৰু প্ৰাকৃতিক গেছ: উজনি অসমৰ জিলাসমূহত পোৱা যায়। ১৮৮৯ চনত অসমত খাৰুৱা তেল আৱিষ্কাৰ হয়।\n"
                 "কয়লা: তিনিচুকীয়া, ডিব্ৰুগড়, শিৱসাগৰ, কাৰ্বি আংলং আৰু ডিমা হাছাওত {{term:tertiary-coal|টাৰ্চিয়াৰী কয়লাৰ}} বলয়।\n"
                 "চূণশিল: ডিমা হাছাও আৰু কাৰ্বি আংলঙত; ডিমা হাছাওৰ উমৰাংছুৰ ওচৰত বৃহৎ ভাণ্ডাৰ আছে।\n"
                 "অন্যান্য খনিজ: কোৱাৰ্টজাইট (নগাঁও), কেওলিন (কাৰ্বি আংলং আৰু লখিমপুৰ) আৰু চিলিমেনাইট (কাৰ্বি আংলং)।"),
                ("h2", "heading", "normal", "অৰণ্য"),
                ("p2", "paragraph", "normal",
                 "অসমত চহকী ক্ৰান্তীয় অৰণ্য আছে। ইয়াৰ দুখন সংৰক্ষিত বনাঞ্চল কাজিৰঙা আৰু মানাহ ইউনেস্কোৰ বিশ্ব ঐতিহ্য ক্ষেত্ৰ।"),
                ("exam1", "fact_box", "exam_fact",
                 "পৰীক্ষাৰ বাবে মনত ৰাখক: ১৮৮৯ চনত অসমত খাৰুৱা তেল পোৱা যায়; উজনি অসমৰ কয়লা টাৰ্চিয়াৰী; উমৰাংছুত চূণশিল।"),
            ],
        },
    ),
]
