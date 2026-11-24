"""Group 4: Art, Culture and Heritage (কলা, সংস্কৃতি আৰু ঐতিহ্য).

Block format: (block_key, block_type, style, body). Keys must match in both languages.
"""

CATEGORY_SLUG = "culture"
CATEGORY_NAME = "Art, Culture and Heritage"
LAST_CHECKED = "2026-11-24"

EXISTING_TERMS = {"muga-silk", "neo-vaishnavism"}

W = "https://en.wikipedia.org/wiki/"

TERMS = [
    dict(slug="uruka", en="Uruka", **{"as": "উৰুকা"},
         meaning_en="The night before Magh (Bhogali) Bihu, spent feasting and staying awake around a bonfire.",
         meaning_as="মাঘ (ভোগালী) বিহুৰ আগৰ নিশা, যিটো ভোজ-ভাত খাই আৰু মেজিৰ কাষত সাৰে থাকি পাৰ কৰা হয়।"),
    dict(slug="meji", en="Meji", **{"as": "মেজি"},
         meaning_en="The bonfire built for Magh Bihu and burnt early on the morning of the festival.",
         meaning_as="মাঘ বিহুৰ বাবে সজা জুইৰ ঘৰ, যিটো বিহুৰ দিনা ৰাতিপুৱা জ্বলোৱা হয়।"),
    dict(slug="bhelaghar", en="Bhelaghar", **{"as": "ভেলাঘৰ"},
         meaning_en="A temporary hut of straw and bamboo built by young people for the Uruka night feast.",
         meaning_as="উৰুকাৰ ভোজৰ বাবে ডেকা-গাভৰুৱে খেৰ আৰু বাঁহেৰে সজা অস্থায়ী ঘৰ।"),
    dict(slug="husori", en="Husori", **{"as": "হুচৰি"},
         meaning_en="Groups who go from house to house during Bohag Bihu singing songs and blessing each family.",
         meaning_as="বহাগ বিহুৰ সময়ত ঘৰে ঘৰে গৈ গীত গাই প্ৰতিটো পৰিয়ালক আশীৰ্বাদ দিয়া দল।"),
    dict(slug="bihuwan", en="Bihuwan", **{"as": "বিহুৱান"},
         meaning_en="A gift, usually a gamosa, given to elders and loved ones at Bohag Bihu.",
         meaning_as="বহাগ বিহুত ডাঙৰ আৰু মৰমৰ মানুহক দিয়া উপহাৰ, সাধাৰণতে এখন গামোচা।"),
    dict(slug="sattra", en="Sattra", **{"as": "সত্ৰ"},
         meaning_en="A monastery-like centre of Sankardev's Neo-Vaishnavite faith, for prayer, music, dance and learning.",
         meaning_as="শংকৰদেৱৰ নৱ-বৈষ্ণৱ ধৰ্মৰ উপাসনা, গীত-মাত, নৃত্য আৰু শিক্ষাৰ মঠসদৃশ কেন্দ্ৰ।"),
    dict(slug="namghar", en="Namghar", **{"as": "নামঘৰ"},
         meaning_en="A prayer hall where people gather to sing and pray. Every Sattra has one, and most Assamese villages too.",
         meaning_as="মানুহ গোট খাই নাম-প্ৰসংগ কৰা উপাসনা গৃহ। প্ৰতিখন সত্ৰত আৰু বেছিভাগ অসমীয়া গাঁৱতো নামঘৰ থাকে।"),
    dict(slug="satradhikar", en="Satradhikar", **{"as": "সত্ৰাধিকাৰ"},
         meaning_en="The head of a Sattra.",
         meaning_as="সত্ৰৰ মুৰব্বী।"),
    dict(slug="ankiya-naat", en="Ankiya Naat", **{"as": "অংকীয়া নাট"},
         meaning_en="One-act plays created by Sankardev. Their stage performance is called Bhaona.",
         meaning_as="শংকৰদেৱে সৃষ্টি কৰা এক অংকৰ নাট। ইয়াৰ মঞ্চ পৰিৱেশনক ভাওনা বোলা হয়।"),
    dict(slug="borgeet", en="Borgeet", **{"as": "বৰগীত"},
         meaning_en="Devotional songs composed by Sankardev and Madhavdev.",
         meaning_as="শংকৰদেৱ আৰু মাধৱদেৱে ৰচনা কৰা ভক্তিমূলক গীত।"),
    dict(slug="classical-dance", en="Classical dance", **{"as": "শাস্ত্ৰীয় নৃত্য"},
         meaning_en="A dance form recognised by the Sangeet Natak Akademi for its old, rule-based tradition. Sattriya is one of them.",
         meaning_as="প্ৰাচীন আৰু নিয়মবদ্ধ পৰম্পৰাৰ বাবে সংগীত নাটক অকাডেমীয়ে স্বীকৃতি দিয়া নৃত্য। সত্ৰীয়া তাৰে এটা।"),
    dict(slug="geographical-indication", en="Geographical Indication (GI) tag", **{"as": "ভৌগোলিক সূচক (জি আই) চিহ্ন"},
         meaning_en="An official label showing that a product comes from a particular place and has qualities linked to it.",
         meaning_as="কোনো সামগ্ৰী এটা নিৰ্দিষ্ট ঠাইৰ আৰু তাৰ গুণ সেই ঠাইৰ সৈতে জড়িত বুলি দেখুওৱা চৰকাৰী স্বীকৃতি।"),
    dict(slug="charyapada", en="Charyapada", **{"as": "চৰ্যাপদ"},
         meaning_en="Buddhist songs of about the 8th to 10th century, taken as the earliest examples of Assamese literature.",
         meaning_as="প্ৰায় অষ্টমৰ পৰা দশম শতিকাৰ বৌদ্ধ গীত, যাক অসমীয়া সাহিত্যৰ আটাইতকৈ পুৰণি নিদৰ্শন বুলি ধৰা হয়।"),
    dict(slug="buranji", en="Buranji", **{"as": "বুৰঞ্জী"},
         meaning_en="Prose chronicles of the Ahom court that recorded events and history.",
         meaning_as="ঘটনা আৰু ইতিহাস লিপিবদ্ধ কৰা আহোম ৰাজসভাৰ গদ্য ইতিহাস গ্ৰন্থ।"),
    dict(slug="jonaki-era", en="Jonaki era", **{"as": "জোনাকী যুগ"},
         meaning_en="The start of modern Assamese literature, named after the magazine Jonaki (1889).",
         meaning_as="আধুনিক অসমীয়া সাহিত্যৰ আৰম্ভণি, জোনাকী (১৮৮৯) আলোচনীৰ নামেৰে নামকৰণ কৰা।"),
    dict(slug="jnanpith-award", en="Jnanpith Award", **{"as": "জ্ঞানপীঠ বঁটা"},
         meaning_en="India's highest literary award, given every year to a writer in an Indian language.",
         meaning_as="ভাৰতীয় ভাষাৰ এগৰাকী সাহিত্যিকক প্ৰতি বছৰে দিয়া দেশৰ সৰ্বোচ্চ সাহিত্য বঁটা।"),
]

CHAPTERS = [
    # ------------------------------------------------------------------ 1
    dict(
        slug="bihu", position=1,
        title={"en": "Bihu", "as": "বিহু"},
        summary={"en": "The three Bihus of Assam and the customs of each.",
                 "as": "অসমৰ তিনিটা বিহু আৰু প্ৰতিটোৰ ৰীতি-নীতি।"},
        sources=f"Bihu, Wikipedia: {W}Bihu",
        blocks={
            "en": [
                ("p1", "paragraph", "normal",
                 "Bihu is the main festival of Assam and its state festival. There are three Bihus in the year, linked to the farming cycle."),
                ("l1", "list", "heritage",
                 "Rongali or Bohag Bihu (April): the spring festival and the Assamese New Year. It is the most important Bihu.\n"
                 "Kongali or Kati Bihu (October or November): a quiet Bihu when lamps are lit near the tulsi plant, the granary and the paddy fields.\n"
                 "Bhogali or Magh Bihu (January): the harvest festival of feasting. 'Bhog' means eating and enjoyment."),
                ("h1", "heading", "normal", "Bohag Bihu"),
                ("p2", "paragraph", "normal",
                 "The first day, Goru Bihu (usually 14 April), is for cattle: they are washed and smeared with turmeric. The next day, Manuh Bihu, "
                 "is New Year's Day, when people give a {{term:bihuwan}} to elders. {{term:husori|Husori}} groups then go singing from house to house."),
                ("h2", "heading", "normal", "Magh Bihu"),
                ("p3", "paragraph", "normal",
                 "On {{term:uruka}} night, young people build a {{term:bhelaghar}} and a {{term:meji}}, and feast together. "
                 "The Meji is burnt the next morning."),
                ("p4", "paragraph", "normal",
                 "The Bihu dance is the state dance. It is played with the dhol, the pepa (buffalo-horn pipe) and the taal (cymbals)."),
                ("exam1", "fact_box", "exam_fact",
                 "Remember for exams: Rongali = Bohag (April), Kongali = Kati (Oct/Nov), Bhogali = Magh (January)."),
            ],
            "as": [
                ("p1", "paragraph", "normal",
                 "বিহু অসমৰ প্ৰধান উৎসৱ আৰু ৰাজ্যিক উৎসৱ। বছৰত তিনিটা বিহু হয়, যিবোৰ কৃষিচক্ৰৰ সৈতে জড়িত।"),
                ("l1", "list", "heritage",
                 "ৰঙালী বা বহাগ বিহু (এপ্ৰিল): বসন্তৰ উৎসৱ আৰু অসমীয়া নৱবৰ্ষ। ই আটাইতকৈ গুৰুত্বপূৰ্ণ বিহু।\n"
                 "কঙালী বা কাতি বিহু (অক্টোবৰ বা নৱেম্বৰ): তুলসীৰ তল, ভঁৰাল আৰু পথাৰত চাকি জ্বলোৱা এক শান্ত বিহু।\n"
                 "ভোগালী বা মাঘ বিহু (জানুৱাৰী): ভোজ-ভাতৰ শস্য চপোৱা উৎসৱ। 'ভোগ' মানে খোৱা-বোৱা আৰু আনন্দ।"),
                ("h1", "heading", "normal", "বহাগ বিহু"),
                ("p2", "paragraph", "normal",
                 "প্ৰথম দিনটো গৰু বিহু (সাধাৰণতে ১৪ এপ্ৰিল): গৰুক গা ধুৱাই হালধি-মাহ লগোৱা হয়। পিছদিনা মানুহ বিহু, "
                 "নৱবৰ্ষৰ দিন, যেতিয়া ডাঙৰসকলক {{term:bihuwan|বিহুৱান}} দিয়া হয়। তাৰ পিছত {{term:husori|হুচৰিৰ}} দলে ঘৰে ঘৰে গীত গাই ফুৰে।"),
                ("h2", "heading", "normal", "মাঘ বিহু"),
                ("p3", "paragraph", "normal",
                 "{{term:uruka|উৰুকাৰ}} নিশা ডেকা-গাভৰুৱে {{term:bhelaghar|ভেলাঘৰ}} আৰু {{term:meji|মেজি}} সাজি একেলগে ভোজ খায়। "
                 "পিছদিনা ৰাতিপুৱা মেজি জ্বলোৱা হয়।"),
                ("p4", "paragraph", "normal",
                 "বিহু নাচ ৰাজ্যিক নৃত্য। ইয়াত ঢোল, পেঁপা (ম'হৰ শিঙৰ বাদ্য) আৰু তাল বজোৱা হয়।"),
                ("exam1", "fact_box", "exam_fact",
                 "পৰীক্ষাৰ বাবে মনত ৰাখক: ৰঙালী = বহাগ (এপ্ৰিল), কঙালী = কাতি (অক্টো/নৱে), ভোগালী = মাঘ (জানুৱাৰী)।"),
            ],
        },
    ),
    # ------------------------------------------------------------------ 2
    dict(
        slug="sattriya-and-sattra", position=2,
        title={"en": "Sattriya dance and the Sattra institution", "as": "সত্ৰীয়া নৃত্য আৰু সত্ৰ অনুষ্ঠান"},
        summary={"en": "The Sattras founded in Sankardev's tradition, and the classical dance that grew in them.",
                 "as": "শংকৰদেৱৰ পৰম্পৰাত প্ৰতিষ্ঠিত সত্ৰ, আৰু তাত গঢ় লোৱা শাস্ত্ৰীয় নৃত্য।"},
        sources="\n".join([f"Satra, Wikipedia: {W}Sattra", f"Sattriya, Wikipedia: {W}Sattriya"]),
        blocks={
            "en": [
                ("p1", "paragraph", "normal",
                 "A {{term:sattra}} is a centre of the {{term:neo-vaishnavism|Neo-Vaishnavite}} faith started by Srimanta Sankardev. "
                 "Sankardev is said to have set up his first Sattra at Bordowa, his birthplace."),
                ("p2", "paragraph", "normal",
                 "Every Sattra has a {{term:namghar}} (also called kirtanghar), its prayer hall. Each Sattra is headed by a {{term:satradhikar}}. "
                 "The Asam Satra Mahasabha counts 862 Sattras in Assam and West Bengal."),
                ("p3", "paragraph", "heritage",
                 "Majuli became the main centre of the Sattra tradition. Well-known Sattras include Auniati, Dakhinpat, Garamur and Kamalabari in Majuli, "
                 "and the Barpeta Sattra, built by Madhavdev."),
                ("h1", "heading", "normal", "Sattriya dance"),
                ("p4", "paragraph", "normal",
                 "Sattriya dance was created by Sankardev as part of Bhaona, the stage performance of his {{term:ankiya-naat|Ankiya Naat}}. "
                 "It was kept alive in the Sattras for centuries."),
                ("p5", "paragraph", "event",
                 "On 15 November 2000, the Sangeet Natak Akademi recognised Sattriya as one of the eight {{term:classical-dance|classical dances}} of India."),
                ("exam1", "fact_box", "exam_fact",
                 "Remember for exams: first Sattra at Bordowa; Sattriya recognised as a classical dance on 15 November 2000."),
            ],
            "as": [
                ("p1", "paragraph", "normal",
                 "{{term:sattra|সত্ৰ}} শ্ৰীমন্ত শংকৰদেৱে প্ৰৱৰ্তন কৰা {{term:neo-vaishnavism|নৱ-বৈষ্ণৱ}} ধৰ্মৰ কেন্দ্ৰ। "
                 "কোৱা হয় যে শংকৰদেৱে তেওঁৰ জন্মস্থান বৰদোৱাত প্ৰথম সত্ৰ স্থাপন কৰিছিল।"),
                ("p2", "paragraph", "normal",
                 "প্ৰতিখন সত্ৰত এটা {{term:namghar|নামঘৰ}} (কীৰ্তনঘৰ বুলিও কোৱা হয়) থাকে। প্ৰতিখন সত্ৰৰ মুৰব্বী এগৰাকী {{term:satradhikar|সত্ৰাধিকাৰ}}। "
                 "অসম সত্ৰ মহাসভাৰ হিচাপমতে অসম আৰু পশ্চিমবংগত ৮৬২ খন সত্ৰ আছে।"),
                ("p3", "paragraph", "heritage",
                 "মাজুলী সত্ৰ পৰম্পৰাৰ মূল কেন্দ্ৰ হৈ পৰে। জনাজাত সত্ৰসমূহৰ ভিতৰত মাজুলীৰ আউনীআটী, দক্ষিণপাট, গড়মূৰ আৰু কমলাবাৰী, "
                 "আৰু মাধৱদেৱে নিৰ্মাণ কৰা বৰপেটা সত্ৰ উল্লেখযোগ্য।"),
                ("h1", "heading", "normal", "সত্ৰীয়া নৃত্য"),
                ("p4", "paragraph", "normal",
                 "শংকৰদেৱে তেওঁৰ {{term:ankiya-naat|অংকীয়া নাটৰ}} মঞ্চ পৰিৱেশন ভাওনাৰ অংশ হিচাপে সত্ৰীয়া নৃত্য সৃষ্টি কৰিছিল। "
                 "শতিকাজুৰি সত্ৰসমূহে ইয়াক জীয়াই ৰাখে।"),
                ("p5", "paragraph", "event",
                 "২০০০ চনৰ ১৫ নৱেম্বৰত সংগীত নাটক অকাডেমীয়ে সত্ৰীয়াক ভাৰতৰ আঠটা {{term:classical-dance|শাস্ত্ৰীয় নৃত্যৰ}} এটা হিচাপে স্বীকৃতি দিয়ে।"),
                ("exam1", "fact_box", "exam_fact",
                 "পৰীক্ষাৰ বাবে মনত ৰাখক: প্ৰথম সত্ৰ বৰদোৱাত; ১৫ নৱেম্বৰ ২০০০ত সত্ৰীয়াই শাস্ত্ৰীয় নৃত্যৰ স্বীকৃতি পায়।"),
            ],
        },
    ),
    # ------------------------------------------------------------------ 3
    dict(
        slug="folk-dances-and-music", position=3,
        title={"en": "Folk dances and music", "as": "লোকনৃত্য আৰু লোকসংগীত"},
        summary={"en": "Bagurumba, Ojapali, Borgeet and other dance and music traditions of Assam.",
                 "as": "বাগৰুম্বা, ওজাপালি, বৰগীত আৰু অসমৰ অন্যান্য নৃত্য-গীতৰ পৰম্পৰা।"},
        sources="\n".join([f"Bagurumba, Wikipedia: {W}Bagurumba", f"Ojapali, Wikipedia: {W}Ojapali",
                           f"Assamese literature, Wikipedia: {W}Assamese_literature"]),
        blocks={
            "en": [
                ("p1", "paragraph", "normal",
                 "Each community of Assam has its own dances and songs. These are the ones most often asked about:"),
                ("l1", "list", "heritage",
                 "Bihu dance: the state dance, performed at Bohag Bihu.\n"
                 "Bagurumba: a traditional dance of the Bodo (Boro) people, performed by women. It is called the butterfly dance because it copies the movements of butterflies and birds.\n"
                 "Ojapali: a story-telling song and dance led by an Oja (leader) with Palis (chorus). Darrang district is its historic home.\n"
                 "Sattriya: the classical dance of the Sattras."),
                ("h1", "heading", "normal", "Devotional music"),
                ("p2", "paragraph", "normal",
                 "{{term:borgeet|Borgeet}} are devotional songs composed by Sankardev and Madhavdev. Madhavdev alone wrote 191 Borgeets."),
                ("p3", "paragraph", "normal",
                 "Ojapali has several forms: Byah (Vyas) Ojapali based on the epics, Sukananni (Maroi) Ojapali linked to the goddess Manasa, "
                 "Ramayani Ojapali and Sattriya Ojapali."),
                ("exam1", "fact_box", "exam_fact",
                 "Remember for exams: Bagurumba = butterfly dance of the Bodos; Ojapali = Oja and Pali, home district Darrang."),
            ],
            "as": [
                ("p1", "paragraph", "normal",
                 "অসমৰ প্ৰতিটো জনগোষ্ঠীৰ নিজা নৃত্য আৰু গীত আছে। পৰীক্ষাত সঘনাই সোধা কেইটামান এনেধৰণৰ:"),
                ("l1", "list", "heritage",
                 "বিহু নাচ: ৰাজ্যিক নৃত্য, বহাগ বিহুত পৰিৱেশন কৰা হয়।\n"
                 "বাগৰুম্বা: বড়ো জনগোষ্ঠীৰ পৰম্পৰাগত নৃত্য, যিটো মহিলাসকলে পৰিৱেশন কৰে। পখিলা আৰু চৰাইৰ গতিৰ অনুকৰণ কৰা বাবে ইয়াক পখিলা নৃত্য বুলিও কোৱা হয়।\n"
                 "ওজাপালি: ওজা (মুখ্য গায়ক) আৰু পালিৰ (সহযোগী দল) কাহিনী কোৱা গীত-নৃত্য। দৰং জিলা ইয়াৰ ঐতিহাসিক কেন্দ্ৰ।\n"
                 "সত্ৰীয়া: সত্ৰৰ শাস্ত্ৰীয় নৃত্য।"),
                ("h1", "heading", "normal", "ভক্তিমূলক সংগীত"),
                ("p2", "paragraph", "normal",
                 "{{term:borgeet|বৰগীত}} শংকৰদেৱ আৰু মাধৱদেৱে ৰচনা কৰা ভক্তিমূলক গীত। মাধৱদেৱে অকলেই ১৯১ টা বৰগীত ৰচনা কৰিছিল।"),
                ("p3", "paragraph", "normal",
                 "ওজাপালিৰ কেইবাটাও ৰূপ আছে: মহাকাব্যভিত্তিক ব্যাহ (ব্যাস) ওজাপালি, মনসা দেৱীৰ সৈতে জড়িত সুকনান্নি (মাৰৈ) ওজাপালি, "
                 "ৰামায়ণী ওজাপালি আৰু সত্ৰীয়া ওজাপালি।"),
                ("exam1", "fact_box", "exam_fact",
                 "পৰীক্ষাৰ বাবে মনত ৰাখক: বাগৰুম্বা = বড়োসকলৰ পখিলা নৃত্য; ওজাপালি = ওজা আৰু পালি, কেন্দ্ৰ দৰং জিলা।"),
            ],
        },
    ),
    # ------------------------------------------------------------------ 4
    dict(
        slug="silk-and-handloom", position=4,
        title={"en": "Silk and handloom", "as": "পাট-মুগা আৰু তাঁতশাল"},
        summary={"en": "Muga, Eri and Pat silk, the gamosa, and Sualkuchi, the weaving town.",
                 "as": "মুগা, এৰী আৰু পাট, গামোচা, আৰু বোৱা-কটাৰ নগৰ শোৱালকুছি।"},
        sources="\n".join([f"Muga silk, Wikipedia: {W}Muga_silk", f"Gamosa, Wikipedia: {W}Gamosa", f"Sualkuchi, Wikipedia: {W}Sualkuchi"]),
        blocks={
            "en": [
                ("p1", "paragraph", "normal",
                 "Weaving is part of daily life in Assam, and the state is famous for three kinds of silk: Muga, Eri and Pat."),
                ("h1", "heading", "normal", "Muga, the golden silk"),
                ("p2", "paragraph", "heritage",
                 "{{term:muga-silk|Muga silk}} has a natural yellowish-golden shine and is produced only in Assam. It comes from the Muga silkworm "
                 "(Antheraea assamensis), which feeds on Som and Sualu leaves. Muga received a {{term:geographical-indication|GI tag}} in 2007."),
                ("h2", "heading", "normal", "The gamosa"),
                ("p3", "paragraph", "normal",
                 "The gamosa is a white cloth with red borders. The word means 'something to wipe the body with', but it is much more than a towel: "
                 "it is offered to guests, given as bihuwan, worn by Bihu dancers and used to cover the scriptures in the namghar. "
                 "The gamosa of Assam received a GI tag on 13 December 2022."),
                ("h3", "heading", "normal", "Sualkuchi"),
                ("p4", "paragraph", "normal",
                 "Sualkuchi, on the north bank of the Brahmaputra in Kamrup district, about 35 km from Guwahati, is a famous silk-weaving town. "
                 "It is known as the 'Manchester of Assam'."),
                ("exam1", "fact_box", "exam_fact",
                 "Remember for exams: Muga GI tag 2007; Gamosa GI tag 2022; Sualkuchi = Manchester of Assam."),
            ],
            "as": [
                ("p1", "paragraph", "normal",
                 "অসমত বোৱা-কটা দৈনন্দিন জীৱনৰ অংশ, আৰু ৰাজ্যখন তিনি প্ৰকাৰৰ পাটৰ বাবে বিখ্যাত: মুগা, এৰী আৰু পাট।"),
                ("h1", "heading", "normal", "মুগা, সোণালী পাট"),
                ("p2", "paragraph", "heritage",
                 "{{term:muga-silk|মুগাৰ}} এক প্ৰাকৃতিক সোণালী-হালধীয়া চিকমিকনি আছে আৰু ই কেৱল অসমতহে উৎপাদন হয়। ই মুগা পলুৰ "
                 "(Antheraea assamensis) পৰা পোৱা যায়, যিয়ে সোম আৰু চোৱালু পাত খায়। ২০০৭ চনত মুগাই {{term:geographical-indication|জি আই চিহ্ন}} লাভ কৰে।"),
                ("h2", "heading", "normal", "গামোচা"),
                ("p3", "paragraph", "normal",
                 "গামোচা ৰঙা আঁচুৰে বগা কাপোৰ। শব্দটোৰ অৰ্থ 'গা মচা বস্তু', কিন্তু ই কেৱল গা মচা কাপোৰ নহয়: "
                 "ইয়াৰে অতিথিক সন্মান জনোৱা হয়, বিহুৱান হিচাপে দিয়া হয়, বিহুৱতীয়ে পিন্ধে আৰু নামঘৰত পুথি ঢাকিবলৈ ব্যৱহাৰ কৰা হয়। "
                 "২০২২ চনৰ ১৩ ডিচেম্বৰত অসমৰ গামোচাই জি আই চিহ্ন লাভ কৰে।"),
                ("h3", "heading", "normal", "শোৱালকুছি"),
                ("p4", "paragraph", "normal",
                 "কামৰূপ জিলাত, ব্ৰহ্মপুত্ৰৰ উত্তৰ পাৰত, গুৱাহাটীৰ পৰা প্ৰায় ৩৫ কিমি দূৰত থকা শোৱালকুছি পাট-মুগা বোৱাৰ বাবে বিখ্যাত। "
                 "ইয়াক 'অসমৰ মেনচেষ্টাৰ' বুলি কোৱা হয়।"),
                ("exam1", "fact_box", "exam_fact",
                 "পৰীক্ষাৰ বাবে মনত ৰাখক: মুগাৰ জি আই ২০০৭; গামোচাৰ জি আই ২০২২; শোৱালকুছি = অসমৰ মেনচেষ্টাৰ।"),
            ],
        },
    ),
    # ------------------------------------------------------------------ 5
    dict(
        slug="assamese-literature", position=5,
        title={"en": "A short history of Assamese literature", "as": "অসমীয়া সাহিত্যৰ চমু ইতিহাস"},
        summary={"en": "From the Charyapada to the Jonaki era and Assam's Jnanpith winners.",
                 "as": "চৰ্যাপদৰ পৰা জোনাকী যুগ আৰু অসমৰ জ্ঞানপীঠ বঁটা বিজয়ীলৈ।"},
        sources="\n".join([f"Assamese literature, Wikipedia: {W}Assamese_literature", f"Jnanpith Award, Wikipedia: {W}Jnanpith_Award"]),
        blocks={
            "en": [
                ("p1", "paragraph", "normal",
                 "Assamese literature can be traced back to the {{term:charyapada|Charyapada}}, Buddhist songs of about the 8th to 10th century."),
                ("h1", "heading", "normal", "Early and Vaishnava period"),
                ("l1", "list", "event",
                 "Hema Saraswati (14th century): the earliest known Assamese writer; wrote Prahlad Charita.\n"
                 "Madhav Kandali (14th century): wrote the Saptakanda Ramayana, one of the earliest versions of the Ramayana in an Indo-Aryan language.\n"
                 "Srimanta Sankardev: his greatest work is the Kirtan Ghosha; he also created {{term:borgeet|Borgeet}} and {{term:ankiya-naat|Ankiya Naat}}.\n"
                 "Madhavdev: his greatest work is the Naam Ghosha, which has one thousand verses."),
                ("p2", "paragraph", "normal",
                 "From the 17th century, the Ahom court wrote many {{term:buranji|Buranjis}}, which are important early works of Assamese prose."),
                ("h2", "heading", "normal", "Modern period"),
                ("l2", "list", "event",
                 "1846: American Baptist missionaries start the monthly magazine Orunodoi.\n"
                 "1889: the magazine Jonaki begins the {{term:jonaki-era|Jonaki era}}; Lakshminath Bezbaroa introduces the short story.\n"
                 "1894: Mirijiyori by Rajanikanta Bordoloi, the first Assamese novel, is published.\n"
                 "1917: the Asam Sahitya Sabha is formed."),
                ("h3", "heading", "normal", "Jnanpith Award winners from Assam"),
                ("l3", "list", "verified_fact",
                 "Birendra Kumar Bhattacharya: 1979, for the novel Mrityunjay\n"
                 "Mamoni Raisom Goswami: 2000\n"
                 "Nilmani Phookan: 2020"),
                ("exam1", "fact_box", "exam_fact",
                 "Remember for exams: three Assamese writers have won the {{term:jnanpith-award|Jnanpith Award}}: Birendra Kumar Bhattacharya (1979), "
                 "Mamoni Raisom Goswami (2000) and Nilmani Phookan (2020)."),
            ],
            "as": [
                ("p1", "paragraph", "normal",
                 "অসমীয়া সাহিত্যৰ শিপা প্ৰায় অষ্টমৰ পৰা দশম শতিকাৰ বৌদ্ধ গীত {{term:charyapada|চৰ্যাপদলৈকে}} বিস্তৃত।"),
                ("h1", "heading", "normal", "প্ৰাচীন আৰু বৈষ্ণৱ যুগ"),
                ("l1", "list", "event",
                 "হেম সৰস্বতী (চতুৰ্দশ শতিকা): আটাইতকৈ পুৰণি জ্ঞাত অসমীয়া সাহিত্যিক; 'প্ৰহ্লাদ চৰিত' ৰচনা কৰে।\n"
                 "মাধৱ কন্দলি (চতুৰ্দশ শতিকা): 'সপ্তকাণ্ড ৰামায়ণ' ৰচনা কৰে, যিটো ইণ্ডো-আৰ্য ভাষাত ৰামায়ণৰ আটাইতকৈ পুৰণি ৰূপান্তৰসমূহৰ এটা।\n"
                 "শ্ৰীমন্ত শংকৰদেৱ: তেওঁৰ শ্ৰেষ্ঠ গ্ৰন্থ 'কীৰ্তন ঘোষা'; তেওঁ {{term:borgeet|বৰগীত}} আৰু {{term:ankiya-naat|অংকীয়া নাটো}} সৃষ্টি কৰে।\n"
                 "মাধৱদেৱ: তেওঁৰ শ্ৰেষ্ঠ গ্ৰন্থ 'নামঘোষা', যাত এহেজাৰ পদ আছে।"),
                ("p2", "paragraph", "normal",
                 "সপ্তদশ শতিকাৰ পৰা আহোম ৰাজসভাত বহুতো {{term:buranji|বুৰঞ্জী}} লিখা হয়, যিবোৰ অসমীয়া গদ্যৰ গুৰুত্বপূৰ্ণ প্ৰাচীন নিদৰ্শন।"),
                ("h2", "heading", "normal", "আধুনিক যুগ"),
                ("l2", "list", "event",
                 "১৮৪৬: আমেৰিকান বেপ্তিষ্ট মিছনেৰীসকলে মাহেকীয়া আলোচনী 'অৰুণোদই' আৰম্ভ কৰে।\n"
                 "১৮৮৯: 'জোনাকী' আলোচনীৰে {{term:jonaki-era|জোনাকী যুগৰ}} আৰম্ভণি; লক্ষ্মীনাথ বেজবৰুৱাই চুটিগল্পৰ প্ৰৱৰ্তন কৰে।\n"
                 "১৮৯৪: ৰজনীকান্ত বৰদলৈৰ 'মিৰিজীয়ৰী', প্ৰথম অসমীয়া উপন্যাস, প্ৰকাশ পায়।\n"
                 "১৯১৭: অসম সাহিত্য সভা গঠন হয়।"),
                ("h3", "heading", "normal", "অসমৰ জ্ঞানপীঠ বঁটা বিজয়ীসকল"),
                ("l3", "list", "verified_fact",
                 "বীৰেন্দ্ৰ কুমাৰ ভট্টাচাৰ্য: ১৯৭৯, 'মৃত্যুঞ্জয়' উপন্যাসৰ বাবে\n"
                 "মামণি ৰয়ছম গোস্বামী: ২০০০\n"
                 "নীলমণি ফুকন: ২০২০"),
                ("exam1", "fact_box", "exam_fact",
                 "পৰীক্ষাৰ বাবে মনত ৰাখক: তিনিগৰাকী অসমীয়া সাহিত্যিকে {{term:jnanpith-award|জ্ঞানপীঠ বঁটা}} পাইছে: বীৰেন্দ্ৰ কুমাৰ ভট্টাচাৰ্য (১৯৭৯), "
                 "মামণি ৰয়ছম গোস্বামী (২০০০) আৰু নীলমণি ফুকন (২০২০)।"),
            ],
        },
    ),
]
