"""Exams: APSC Combined Competitive Examination (CCE), the full History syllabus.

Goes into the Exams tab, group "Assam Government Examinations" (category exams-assam),
as exam pages (kind 'exam'), added as drafts.

Block format: (block_key, block_type, style, body). Keys must match in both languages.
Style 'exam_fact' = what APSC's syllabus says (in short). Style 'suggested' = our detailed
topic list under each official line (it is shown as "Suggestion: not official information").
"""

CATEGORY_SLUG = "exams-assam"
CATEGORY_NAME = "Assam Government Examinations"
GROUP_NAME = "APSC CCE: History syllabus (Exams)"
KIND = "exam"
LAST_CHECKED = "2026-11-24"

OFFICIAL = "https://apsc.nic.in/"
APPLIES = "APSC CCE scheme in use for CCE 2025 and 2026 (check against the latest APSC notification)"

EXISTING_TERMS = {
    "paik-system", "neo-vaishnavism", "buranji", "jonaki-era", "maidam", "quit-india-movement",
    "cabinet-mission", "assam-accord", "sixth-schedule", "jnanpith-award", "borgeet", "sattra",
    "namghar", "mrityu-bahini", "moamoria-rebellion", "treaty-of-yandabo", "charyapada",
    "kamarupa", "ahom", "referendum", "swargadeo", "borphukan", "chief-commissioner-province",
}

SOURCES = (
    "APSC official website (notifications and syllabus PDF): https://apsc.nic.in/ "
    "(could not be opened from our system, please compare with the latest notification).\n"
    "Copy of the APSC syllabus PDF: https://smartiasfoundation.com/wp-content/uploads/2025/01/SYLLABUS-FOR-APSC-PDF.pdf\n"
    "Exam pattern: https://www.drishtiias.com/state-pcs/apsc-exam-pattern\n"
    "Exam pattern and GS tables: https://spmiasacademy.com/apsc-cce-syllabus-prelims-mains/\n"
    "Old History optional (removed): https://www.assams.info/career/history-syllabus-apsc-mains-exam\n"
)

TERMS = [
    dict(slug="preliminary-exam", en="Preliminary examination (Prelims)", **{"as": "প্ৰাৰম্ভিক পৰীক্ষা (প্ৰিলিমছ)"},
         meaning_en="The first stage of a competitive exam, with objective (multiple choice) questions. It decides who may sit the Mains.",
         meaning_as="প্ৰতিযোগিতামূলক পৰীক্ষাৰ প্ৰথম পৰ্যায়, য'ত বহুবিকল্পী প্ৰশ্ন থাকে। মুখ্য পৰীক্ষাত কোন বহিব পাৰিব, ই তাক নিৰ্ধাৰণ কৰে।"),
    dict(slug="main-exam", en="Main examination (Mains)", **{"as": "মুখ্য পৰীক্ষা (মেইনছ)"},
         meaning_en="The second stage, with written (descriptive) answers. Its marks count for the final merit list.",
         meaning_as="দ্বিতীয় পৰ্যায়, য'ত লিখিত (বৰ্ণনামূলক) উত্তৰ দিব লাগে। ইয়াৰ নম্বৰ চূড়ান্ত মেধা তালিকাত গণ্য হয়।"),
    dict(slug="csat", en="CSAT", **{"as": "চিছেট (CSAT)"},
         meaning_en="Civil Services Aptitude Test: the second Prelims paper (reasoning, maths, comprehension). You only need to pass it.",
         meaning_as="চিভিল ছাৰ্ভিচেছ এপ্টিচিউড টেষ্ট: প্ৰাৰম্ভিক পৰীক্ষাৰ দ্বিতীয় কাকত (যুক্তি, গণিত, বুজাবুজি)। ইয়াত কেৱল উত্তীৰ্ণ হ'লেই হয়।"),
    dict(slug="negative-marking", en="Negative marking", **{"as": "ঋণাত্মক নম্বৰ"},
         meaning_en="Marks taken away for a wrong answer. In APSC Prelims, one quarter of the question's marks is cut for each wrong answer.",
         meaning_as="ভুল উত্তৰৰ বাবে নম্বৰ কটা যোৱা। এপিএছচিৰ প্ৰাৰম্ভিক পৰীক্ষাত প্ৰতিটো ভুল উত্তৰৰ বাবে সেই প্ৰশ্নৰ নম্বৰৰ এক চতুৰ্থাংশ কটা যায়।"),
    dict(slug="optional-subject", en="Optional subject", **{"as": "ঐচ্ছিক বিষয়"},
         meaning_en="A subject the candidate chooses (such as History) with its own papers. The APSC CCE Mains no longer has one.",
         meaning_as="প্ৰাৰ্থীয়ে নিজে বাছি লোৱা বিষয় (যেনে ইতিহাস), যাৰ নিজা কাকত থাকে। এপিএছচি চিচিইৰ মুখ্য পৰীক্ষাত এতিয়া এনে বিষয় নাই।"),
]

GK_HISTORY_EN = (
    "Ancient Assam: Pragjyotisha and Kamarupa\n"
    "The Ahom kingdom (1228 to 1826)\n"
    "The Koch kingdom\n"
    "Mughal invasions and the Battle of Saraighat\n"
    "Burmese invasions and the Treaty of Yandabo\n"
    "Assam under British rule\n"
    "Assam in the freedom struggle\n"
    "The Assam Movement and the Assam Accord"
)
GK_HISTORY_AS = (
    "প্ৰাচীন অসম: প্ৰাগজ্যোতিষ আৰু কামৰূপ\n"
    "আহোম ৰাজ্য (১২২৮ ৰ পৰা ১৮২৬)\n"
    "কোচ ৰাজ্য\n"
    "মোগল আক্ৰমণ আৰু শৰাইঘাটৰ যুদ্ধ\n"
    "মানৰ আক্ৰমণ আৰু ইয়াণ্ডাবুৰ সন্ধি\n"
    "ব্ৰিটিছ শাসনত অসম\n"
    "স্বাধীনতা সংগ্ৰামত অসম\n"
    "অসম আন্দোলন আৰু অসম চুক্তি"
)

CHAPTERS = [
    # ------------------------------------------------------------------ 1
    dict(
        slug="apsc-cce-history-overview", position=1,
        official_url=OFFICIAL, notification_url=OFFICIAL, applies_to=APPLIES,
        title={"en": "APSC CCE History: where it is asked and how many marks",
               "as": "এপিএছচি চিচিইত ইতিহাস: ক'ত সোধা হয় আৰু কিমান নম্বৰ"},
        summary={"en": "The exam scheme, and every place History appears in Prelims and Mains.",
                 "as": "পৰীক্ষাৰ আঁচনি, আৰু প্ৰাৰম্ভিক আৰু মুখ্য পৰীক্ষাত ইতিহাস থকা প্ৰতিটো ঠাই।"},
        sources=SOURCES + (
            "TO VERIFY before publishing: (1) negative marking of one quarter (given by Drishti and SPM, not in the syllabus PDF copy); "
            "(2) the year the History optional was removed (no source gave it); "
            "(3) the paper numbering of the Assam paper (Paper VI in Drishti, GS Paper V in SPM); "
            "(4) whether any qualifying language paper is also held in Mains."
        ),
        blocks={
            "en": [
                ("p1", "paragraph", "normal",
                 "The Assam Public Service Commission (APSC) holds the Combined Competitive Examination (CCE) to select officers "
                 "such as the Assam Civil Service (ACS) and Assam Police Service (APS). It has three stages: "
                 "the {{term:preliminary-exam|Preliminary examination}}, the {{term:main-exam|Main examination}} and the interview."),
                ("p2", "paragraph", "normal",
                 "History is not a separate paper any more. It comes inside the General Studies papers: "
                 "in Prelims Paper I, in Mains General Studies Paper I, and in the Mains paper on Assam."),
                ("h1", "heading", "normal", "Exam scheme"),
                ("l1", "list", "exam_fact",
                 "Prelims Paper I, General Studies: 200 marks, 100 questions, 2 hours. Its marks decide who goes to Mains.\n"
                 "Prelims Paper II, General Studies II ({{term:csat|CSAT}}): 200 marks, 80 questions, 2 hours. Qualifying only: you need 33% (66.66 marks).\n"
                 "{{term:negative-marking|Negative marking}} in Prelims: one quarter of the marks of a question for each wrong answer.\n"
                 "Mains: 6 written papers of 250 marks each, 3 hours each, 1500 marks in all: Essay, General Studies I, II, III, IV and the paper on Assam.\n"
                 "Interview: 180 marks. Final merit list = Mains + Interview = 1680 marks.\n"
                 "Mains answers may be written in English or Assamese."),
                ("h2", "heading", "normal", "Where History comes in"),
                ("l2", "list", "normal",
                 "Prelims, General Studies Paper I: History of India and the Indian National Movement. Coaching analyses say about 30 to 35% of this paper's questions are about Assam.\n"
                 "Mains, General Studies Paper I: Indian culture (art, literature, architecture), modern Indian history, the freedom struggle, and India after independence.\n"
                 "Mains, paper on Assam: history of Assam, its dynasties, freedom movement, monuments, arts, literature, festivals, religious movements and leading personalities.\n"
                 "Mains, General Studies Paper II: the historical background of the Indian Constitution."),
                ("f1", "fact_box", "verified_fact",
                 "There is no {{term:optional-subject|optional subject}} in the APSC CCE Mains now. "
                 "Older notices showed History as an optional with two papers (Indian history; and British, European and world history). "
                 "That optional is no longer part of the exam, so it is not included here."),
                ("h3", "heading", "normal", "Syllabus pages in this group"),
                ("l3", "list", "normal",
                 "Prelims: History of India and the National Movement\n"
                 "Mains General Studies I: Indian culture and modern Indian history\n"
                 "Mains paper on Assam: History, culture and heritage of Assam"),
                ("h4", "heading", "normal", "Official website"),
                ("p3", "paragraph", "normal",
                 "Always check the latest notification on the APSC website, apsc.nic.in, before the exam. "
                 "The scheme above is taken from the APSC syllabus as published for recent exams."),
            ],
            "as": [
                ("p1", "paragraph", "normal",
                 "অসম ৰাজ্যিক লোকসেৱা আয়োগে (এপিএছচি) অসম অসামৰিক সেৱা (এচিএছ) আৰু অসম আৰক্ষী সেৱা (এপিএছ)ৰ দৰে বিষয়া বাছনি কৰিবলৈ "
                 "সন্মিলিত প্ৰতিযোগিতামূলক পৰীক্ষা (চিচিই) লয়। ইয়াৰ তিনিটা পৰ্যায়: "
                 "{{term:preliminary-exam|প্ৰাৰম্ভিক পৰীক্ষা}}, {{term:main-exam|মুখ্য পৰীক্ষা}} আৰু সাক্ষাৎকাৰ।"),
                ("p2", "paragraph", "normal",
                 "ইতিহাস এতিয়া পৃথক কাকত নহয়। ই সাধাৰণ অধ্যয়নৰ কাকতবোৰৰ ভিতৰত আছে: "
                 "প্ৰাৰম্ভিক পৰীক্ষাৰ প্ৰথম কাকতত, মুখ্য পৰীক্ষাৰ সাধাৰণ অধ্যয়ন প্ৰথম কাকতত, আৰু মুখ্য পৰীক্ষাৰ অসম বিষয়ক কাকতত।"),
                ("h1", "heading", "normal", "পৰীক্ষাৰ আঁচনি"),
                ("l1", "list", "exam_fact",
                 "প্ৰাৰম্ভিক প্ৰথম কাকত, সাধাৰণ অধ্যয়ন: ২০০ নম্বৰ, ১০০টা প্ৰশ্ন, ২ ঘণ্টা। ইয়াৰ নম্বৰৰ ভিত্তিত মুখ্য পৰীক্ষালৈ বাছনি হয়।\n"
                 "প্ৰাৰম্ভিক দ্বিতীয় কাকত, সাধাৰণ অধ্যয়ন ২ ({{term:csat|চিছেট}}): ২০০ নম্বৰ, ৮০টা প্ৰশ্ন, ২ ঘণ্টা। কেৱল উত্তীৰ্ণ হ'ব লাগে: ৩৩% (৬৬.৬৬ নম্বৰ)।\n"
                 "প্ৰাৰম্ভিক পৰীক্ষাত {{term:negative-marking|ঋণাত্মক নম্বৰ}}: প্ৰতিটো ভুল উত্তৰৰ বাবে প্ৰশ্নটোৰ নম্বৰৰ এক চতুৰ্থাংশ কটা যায়।\n"
                 "মুখ্য পৰীক্ষা: প্ৰতিটো ২৫০ নম্বৰৰ ৬খন লিখিত কাকত, প্ৰতিখন ৩ ঘণ্টা, মুঠ ১৫০০ নম্বৰ: ৰচনা, সাধাৰণ অধ্যয়ন ১, ২, ৩, ৪ আৰু অসম বিষয়ক কাকত।\n"
                 "সাক্ষাৎকাৰ: ১৮০ নম্বৰ। চূড়ান্ত মেধা তালিকা = মুখ্য পৰীক্ষা + সাক্ষাৎকাৰ = ১৬৮০ নম্বৰ।\n"
                 "মুখ্য পৰীক্ষাৰ উত্তৰ ইংৰাজী বা অসমীয়াত লিখিব পাৰি।"),
                ("h2", "heading", "normal", "ইতিহাস ক'ত আছে"),
                ("l2", "list", "normal",
                 "প্ৰাৰম্ভিক, সাধাৰণ অধ্যয়ন প্ৰথম কাকত: ভাৰতৰ ইতিহাস আৰু ভাৰতীয় জাতীয় আন্দোলন। কোচিং বিশ্লেষণ অনুসৰি এই কাকতৰ প্ৰায় ৩০ ৰ পৰা ৩৫% প্ৰশ্ন অসম সম্পৰ্কীয়।\n"
                 "মুখ্য, সাধাৰণ অধ্যয়ন প্ৰথম কাকত: ভাৰতীয় সংস্কৃতি (কলা, সাহিত্য, স্থাপত্য), আধুনিক ভাৰতৰ ইতিহাস, স্বাধীনতা সংগ্ৰাম আৰু স্বাধীনতাৰ পিছৰ ভাৰত।\n"
                 "মুখ্য, অসম বিষয়ক কাকত: অসমৰ ইতিহাস, ৰাজবংশ, স্বাধীনতা আন্দোলন, কীৰ্তিচিহ্ন, কলা, সাহিত্য, উৎসৱ, ধৰ্মীয় আন্দোলন আৰু বিশিষ্ট ব্যক্তি।\n"
                 "মুখ্য, সাধাৰণ অধ্যয়ন দ্বিতীয় কাকত: ভাৰতীয় সংবিধানৰ ঐতিহাসিক পটভূমি।"),
                ("f1", "fact_box", "verified_fact",
                 "এপিএছচি চিচিইৰ মুখ্য পৰীক্ষাত এতিয়া কোনো {{term:optional-subject|ঐচ্ছিক বিষয়}} নাই। "
                 "পুৰণি জাননীত ইতিহাস দুখন কাকতৰ ঐচ্ছিক বিষয় আছিল (ভাৰতৰ ইতিহাস; আৰু ব্ৰিটেইন, ইউৰোপ আৰু বিশ্বৰ ইতিহাস)। "
                 "সেই ঐচ্ছিক বিষয় এতিয়া পৰীক্ষাত নাই, সেয়ে ইয়াত দিয়া হোৱা নাই।"),
                ("h3", "heading", "normal", "এই গোটৰ পাঠ্যক্ৰমৰ পৃষ্ঠাসমূহ"),
                ("l3", "list", "normal",
                 "প্ৰাৰম্ভিক: ভাৰতৰ ইতিহাস আৰু জাতীয় আন্দোলন\n"
                 "মুখ্য সাধাৰণ অধ্যয়ন ১: ভাৰতীয় সংস্কৃতি আৰু আধুনিক ভাৰতৰ ইতিহাস\n"
                 "মুখ্য অসম বিষয়ক কাকত: অসমৰ ইতিহাস, সংস্কৃতি আৰু ঐতিহ্য"),
                ("h4", "heading", "normal", "চৰকাৰী ৱেবছাইট"),
                ("p3", "paragraph", "normal",
                 "পৰীক্ষাৰ আগতে সদায় এপিএছচিৰ ৱেবছাইট apsc.nic.in ত শেহতীয়া জাননী চাওক। "
                 "ওপৰৰ আঁচনিখন শেহতীয়া পৰীক্ষাৰ বাবে প্ৰকাশিত এপিএছচিৰ পাঠ্যক্ৰমৰ পৰা লোৱা হৈছে।"),
            ],
        },
    ),
    # ------------------------------------------------------------------ 2
    dict(
        slug="apsc-cce-prelims-history", position=2,
        official_url=OFFICIAL, notification_url=OFFICIAL, applies_to=APPLIES,
        title={"en": "APSC Prelims: History of India and the National Movement",
               "as": "এপিএছচি প্ৰাৰম্ভিক: ভাৰতৰ ইতিহাস আৰু জাতীয় আন্দোলন"},
        summary={"en": "The official Prelims line, opened up into every period and topic to study.",
                 "as": "প্ৰাৰম্ভিক পৰীক্ষাৰ চৰকাৰী শাৰীটো, পঢ়িবলগীয়া প্ৰতিটো যুগ আৰু বিষয়লৈ বহলাই দিয়া হৈছে।"},
        sources=SOURCES + "The detailed topic lists are our study guide built on the official line; they are not APSC's words.",
        blocks={
            "en": [
                ("p1", "paragraph", "normal",
                 "In the {{term:preliminary-exam|Prelims}} General Studies Paper I (200 marks, 100 questions, 2 hours), "
                 "the syllabus gives History in one line. Questions come from ancient, medieval and modern India, "
                 "with special weight on the freedom struggle and on Assam."),
                ("f1", "fact_box", "exam_fact",
                 "APSC syllabus: History of India and Indian National Movement."),
                ("h1", "heading", "normal", "1. Ancient India"),
                ("l1", "list", "suggested",
                 "Sources of ancient history: literature, inscriptions, coins, foreign travellers\n"
                 "Stone Age and Chalcolithic cultures\n"
                 "Indus Valley (Harappan) civilisation: sites, town planning, seals, trade, decline\n"
                 "Vedic age: Early and Later Vedic society, polity, religion; the four Vedas\n"
                 "Sixteen Mahajanapadas and the rise of Magadha\n"
                 "Buddhism and Jainism: teachings, councils, spread\n"
                 "Persian and Greek invasions (Alexander, 326 BCE)\n"
                 "The Mauryas: Chandragupta, Ashoka and his dhamma, edicts, administration, decline\n"
                 "After the Mauryas: Sungas, Kanvas, Indo-Greeks, Kushanas (Kanishka), Satavahanas, Sangam age\n"
                 "The Guptas: Samudragupta (Allahabad Pillar Inscription names Kamarupa), Chandragupta II, art, science, literature\n"
                 "Harshavardhana, his ally Bhaskaravarman of Kamarupa, and the visit of Xuanzang\n"
                 "South India: Pallavas, Chalukyas, Rashtrakutas, Cholas"),
                ("h2", "heading", "normal", "2. Medieval India"),
                ("l2", "list", "suggested",
                 "Rajput kingdoms; Arab conquest of Sind (712); Ghaznavid and Ghurid invasions\n"
                 "Delhi Sultanate: Slave, Khalji, Tughlaq, Sayyid and Lodi dynasties; administration and economy\n"
                 "Bakhtiyar Khalji's failed attack on Kamarupa (1206)\n"
                 "Vijayanagara and Bahmani kingdoms\n"
                 "Bhakti and Sufi movements: Ramananda, Kabir, Chaitanya, Nanak, Mirabai, Sankardev\n"
                 "The Mughals: Babur to Aurangzeb, Sher Shah Sur, Akbar's administration (mansabdari) and religious policy\n"
                 "Mughal art, architecture and literature\n"
                 "Rise of the Marathas: Shivaji and the Peshwas\n"
                 "Regional kingdoms of the Northeast: Ahom, Koch, Chutia, Kachari, Jaintia; Mughal-Ahom wars and Saraighat (1671)"),
                ("h3", "heading", "normal", "3. Modern India"),
                ("l3", "list", "suggested",
                 "Coming of the Europeans: Portuguese, Dutch, English, French\n"
                 "British conquest: Plassey (1757), Buxar (1764), Anglo-Mysore, Anglo-Maratha and Anglo-Sikh wars\n"
                 "Governors-General and their policies: Hastings, Cornwallis, Wellesley (Subsidiary Alliance), Bentinck, Dalhousie (Doctrine of Lapse)\n"
                 "Land revenue systems: Permanent Settlement, Ryotwari, Mahalwari; drain of wealth\n"
                 "Anglo-Burmese war and the {{term:treaty-of-yandabo|Treaty of Yandabo}} (1826)\n"
                 "Socio-religious reform: Raja Rammohun Roy, Brahmo Samaj, Arya Samaj, Ramakrishna Mission, Aligarh movement\n"
                 "The Revolt of 1857: causes, leaders, spread (including Maniram Dewan in Assam), results\n"
                 "Rule of the Crown after 1858; growth of education and the press"),
                ("h4", "heading", "normal", "4. The Indian National Movement"),
                ("l4", "list", "suggested",
                 "Early associations and the Indian National Congress (1885); Moderates and Extremists\n"
                 "Partition of Bengal (1905) and the Swadeshi movement; Muslim League (1906); Surat split (1907)\n"
                 "Morley-Minto Reforms (1909); Home Rule Leagues (1916); Lucknow Pact (1916)\n"
                 "Gandhi's early struggles: Champaran, Kheda, Ahmedabad\n"
                 "Rowlatt Act and Jallianwala Bagh (1919); Khilafat and Non-Cooperation (1920 to 1922)\n"
                 "Swaraj Party, Simon Commission (1927), Nehru Report (1928), Purna Swaraj (1929)\n"
                 "Civil Disobedience and the Dandi March (1930); Round Table Conferences; Poona Pact (1932)\n"
                 "Government of India Act 1935 and the 1937 provincial ministries\n"
                 "{{term:quit-india-movement|Quit India Movement}} (1942), Subhas Chandra Bose and the INA\n"
                 "{{term:cabinet-mission|Cabinet Mission}} (1946), Mountbatten Plan and Independence (1947)\n"
                 "Revolutionary movements and the role of women, peasants and tribal people"),
                ("h5", "heading", "normal", "Read these in ASSAMPEDIA (GK > History of Assam)"),
                ("l5", "list", "normal", GK_HISTORY_EN),
                ("tip1", "paragraph", "suggested",
                 "Prelims questions are short facts: dates, firsts, pairs (person and work), places. "
                 "For each topic above, make one-line notes and practise with the quizzes in the Practice tab."),
            ],
            "as": [
                ("p1", "paragraph", "normal",
                 "{{term:preliminary-exam|প্ৰাৰম্ভিক পৰীক্ষাৰ}} সাধাৰণ অধ্যয়ন প্ৰথম কাকতত (২০০ নম্বৰ, ১০০টা প্ৰশ্ন, ২ ঘণ্টা) "
                 "পাঠ্যক্ৰমত ইতিহাস এটা শাৰীত দিয়া আছে। প্ৰশ্ন প্ৰাচীন, মধ্যযুগীয় আৰু আধুনিক ভাৰতৰ পৰা আহে, "
                 "বিশেষকৈ স্বাধীনতা সংগ্ৰাম আৰু অসমৰ ওপৰত বেছি গুৰুত্ব থাকে।"),
                ("f1", "fact_box", "exam_fact",
                 "এপিএছচিৰ পাঠ্যক্ৰম: ভাৰতৰ ইতিহাস আৰু ভাৰতীয় জাতীয় আন্দোলন।"),
                ("h1", "heading", "normal", "১. প্ৰাচীন ভাৰত"),
                ("l1", "list", "suggested",
                 "প্ৰাচীন ইতিহাসৰ উৎস: সাহিত্য, শিলালিপি, মুদ্ৰা, বিদেশী পৰিব্ৰাজক\n"
                 "প্ৰস্তৰ যুগ আৰু তাম্ৰ-প্ৰস্তৰ যুগৰ সংস্কৃতি\n"
                 "সিন্ধু উপত্যকা (হৰপ্পা) সভ্যতা: স্থান, নগৰ পৰিকল্পনা, মোহৰ, বাণিজ্য, অৱক্ষয়\n"
                 "বৈদিক যুগ: আদি আৰু পৰৱৰ্তী বৈদিক সমাজ, ৰাজনীতি, ধৰ্ম; চাৰিখন বেদ\n"
                 "ষোল্লটা মহাজনপদ আৰু মগধৰ উত্থান\n"
                 "বৌদ্ধ আৰু জৈন ধৰ্ম: শিক্ষা, সংগীতি, বিস্তাৰ\n"
                 "পাৰস্য আৰু গ্ৰীক আক্ৰমণ (আলেকজেণ্ডাৰ, খ্ৰীঃ পূঃ ৩২৬)\n"
                 "মৌৰ্য বংশ: চন্দ্ৰগুপ্ত, অশোক আৰু তেওঁৰ ধম্ম, শিলালিপি, প্ৰশাসন, পতন\n"
                 "মৌৰ্যৰ পিছত: শুংগ, কাণ্ব, ইণ্ডো-গ্ৰীক, কুষাণ (কণিষ্ক), সাতবাহন, সংগম যুগ\n"
                 "গুপ্ত বংশ: সমুদ্ৰগুপ্ত (এলাহাবাদ স্তম্ভলিপিত কামৰূপৰ নাম আছে), দ্বিতীয় চন্দ্ৰগুপ্ত, কলা, বিজ্ঞান, সাহিত্য\n"
                 "হৰ্ষবৰ্ধন, তেওঁৰ মিত্ৰ কামৰূপৰ ভাস্কৰবৰ্মন, আৰু হিউৱেন চাঙৰ ভ্ৰমণ\n"
                 "দাক্ষিণাত্য: পল্লৱ, চালুক্য, ৰাষ্ট্ৰকূট, চোল"),
                ("h2", "heading", "normal", "২. মধ্যযুগৰ ভাৰত"),
                ("l2", "list", "suggested",
                 "ৰাজপুত ৰাজ্যসমূহ; আৰবৰ সিন্ধু বিজয় (৭১২); গজনী আৰু ঘোৰীৰ আক্ৰমণ\n"
                 "দিল্লী ছুলতানী: দাস, খিলজী, তোগলক, ছৈয়দ আৰু লোদী বংশ; প্ৰশাসন আৰু অৰ্থনীতি\n"
                 "বখতিয়াৰ খিলজীৰ বিফল কামৰূপ আক্ৰমণ (১২০৬)\n"
                 "বিজয়নগৰ আৰু বাহমনী ৰাজ্য\n"
                 "ভক্তি আৰু ছুফী আন্দোলন: ৰামানন্দ, কবীৰ, চৈতন্য, নানক, মীৰাবাই, শংকৰদেৱ\n"
                 "মোগল: বাবৰৰ পৰা ঔৰংজেবলৈ, শ্বেৰশ্বাহ শূৰ, আকবৰৰ প্ৰশাসন (মনচবদাৰী) আৰু ধৰ্মনীতি\n"
                 "মোগল কলা, স্থাপত্য আৰু সাহিত্য\n"
                 "মাৰাঠাৰ উত্থান: শিৱাজী আৰু পেছোৱা\n"
                 "উত্তৰ-পূৰ্বৰ আঞ্চলিক ৰাজ্য: আহোম, কোচ, চুতীয়া, কছাৰী, জয়ন্তীয়া; মোগল-আহোম যুদ্ধ আৰু শৰাইঘাট (১৬৭১)"),
                ("h3", "heading", "normal", "৩. আধুনিক ভাৰত"),
                ("l3", "list", "suggested",
                 "ইউৰোপীয়সকলৰ আগমন: পৰ্তুগীজ, ডাচ, ইংৰাজ, ফৰাচী\n"
                 "ব্ৰিটিছৰ ৰাজ্য বিস্তাৰ: পলাশী (১৭৫৭), বক্সাৰ (১৭৬৪), ইংৰাজ-মহীশূৰ, ইংৰাজ-মাৰাঠা আৰু ইংৰাজ-শিখ যুদ্ধ\n"
                 "গৱৰ্ণৰ জেনেৰেলসকল আৰু তেওঁলোকৰ নীতি: হেষ্টিংছ, কৰ্ণৱালিছ, ৱেলেছলী (অধীনতামূলক মিত্ৰতা), বেণ্টিংক, ডালহৌচী (স্বত্ববিলোপ নীতি)\n"
                 "ভূমি ৰাজহ ব্যৱস্থা: চিৰস্থায়ী বন্দোবস্ত, ৰায়তৱাৰী, মহলৱাৰী; সম্পদ নিষ্কাশন\n"
                 "ইংৰাজ-বৰ্মী যুদ্ধ আৰু {{term:treaty-of-yandabo|ইয়াণ্ডাবুৰ সন্ধি}} (১৮২৬)\n"
                 "সমাজ-ধৰ্ম সংস্কাৰ: ৰাজা ৰামমোহন ৰায়, ব্ৰাহ্ম সমাজ, আৰ্য সমাজ, ৰামকৃষ্ণ মিছন, আলীগড় আন্দোলন\n"
                 "১৮৫৭ চনৰ বিদ্ৰোহ: কাৰণ, নেতা, বিস্তাৰ (অসমত মণিৰাম দেৱানকে ধৰি), ফলাফল\n"
                 "১৮৫৮ চনৰ পিছত ব্ৰিটিছ ৰাজমুকুটৰ শাসন; শিক্ষা আৰু সংবাদপত্ৰৰ বিকাশ"),
                ("h4", "heading", "normal", "৪. ভাৰতীয় জাতীয় আন্দোলন"),
                ("l4", "list", "suggested",
                 "আদিম সংগঠন আৰু ভাৰতীয় ৰাষ্ট্ৰীয় কংগ্ৰেছ (১৮৮৫); নৰমপন্থী আৰু চৰমপন্থী\n"
                 "বংগ বিভাজন (১৯০৫) আৰু স্বদেশী আন্দোলন; মুছলিম লীগ (১৯০৬); ছুৰাট বিভাজন (১৯০৭)\n"
                 "মৰ্লে-মিণ্টো সংস্কাৰ (১৯০৯); হোম ৰুল লীগ (১৯১৬); লক্ষ্ণৌ চুক্তি (১৯১৬)\n"
                 "গান্ধীৰ প্ৰথম সংগ্ৰাম: চম্পাৰণ, খেদা, আহমেদাবাদ\n"
                 "ৰাওলাট আইন আৰু জালিয়ানৱালা বাগ (১৯১৯); খিলাফত আৰু অসহযোগ আন্দোলন (১৯২০ ৰ পৰা ১৯২২)\n"
                 "স্বৰাজ দল, চাইমন কমিছন (১৯২৭), নেহৰু প্ৰতিবেদন (১৯২৮), পূৰ্ণ স্বৰাজ (১৯২৯)\n"
                 "আইন অমান্য আন্দোলন আৰু ডাণ্ডী যাত্ৰা (১৯৩০); গোলমেজ বৈঠক; পুণা চুক্তি (১৯৩২)\n"
                 "ভাৰত চৰকাৰ আইন ১৯৩৫ আৰু ১৯৩৭ চনৰ প্ৰাদেশিক মন্ত্ৰিসভা\n"
                 "{{term:quit-india-movement|ভাৰত ত্যাগ আন্দোলন}} (১৯৪২), নেতাজী সুভাষচন্দ্ৰ বসু আৰু আজাদ হিন্দ ফৌজ\n"
                 "{{term:cabinet-mission|কেবিনেট মিছন}} (১৯৪৬), মাউণ্টবেটেন পৰিকল্পনা আৰু স্বাধীনতা (১৯৪৭)\n"
                 "বিপ্লৱী আন্দোলন, আৰু মহিলা, কৃষক আৰু জনজাতীয় লোকৰ ভূমিকা"),
                ("h5", "heading", "normal", "ASSAMPEDIA ত পঢ়ক (সাধাৰণ জ্ঞান > অসমৰ ইতিহাস)"),
                ("l5", "list", "normal", GK_HISTORY_AS),
                ("tip1", "paragraph", "suggested",
                 "প্ৰাৰম্ভিক পৰীক্ষাৰ প্ৰশ্ন চমু তথ্যভিত্তিক: তাৰিখ, প্ৰথম, যোৰা (ব্যক্তি আৰু কৃতি), ঠাই। "
                 "ওপৰৰ প্ৰতিটো বিষয়ৰ বাবে এশাৰীৰ টোকা বনাওক আৰু অনুশীলন টেবত কুইজ কৰি অভ্যাস কৰক।"),
            ],
        },
    ),
    # ------------------------------------------------------------------ 3
    dict(
        slug="apsc-cce-mains-gs1-history", position=3,
        official_url=OFFICIAL, notification_url=OFFICIAL, applies_to=APPLIES,
        title={"en": "APSC Mains GS I: Indian culture and modern Indian history",
               "as": "এপিএছচি মুখ্য সাধাৰণ অধ্যয়ন ১: ভাৰতীয় সংস্কৃতি আৰু আধুনিক ভাৰতৰ ইতিহাস"},
        summary={"en": "The four history areas of General Studies Paper I, with every topic under them.",
                 "as": "সাধাৰণ অধ্যয়ন প্ৰথম কাকতৰ ইতিহাসৰ চাৰিটা ভাগ, প্ৰতিটোৰ তলৰ সকলো বিষয়ৰ সৈতে।"},
        sources=SOURCES + (
            "The detailed topic lists are our study guide built on the official lines; they are not APSC's words.\n"
            "TO VERIFY before publishing: the syllabus copies we found list no world history in GS I (UPSC's GS I has it). Check the latest APSC syllabus."
        ),
        blocks={
            "en": [
                ("p1", "paragraph", "normal",
                 "General Studies Paper I of the {{term:main-exam|Mains}} (250 marks, 3 hours) covers Indian heritage and culture, "
                 "history, society and geography. Its history part has four areas."),
                ("f1", "fact_box", "exam_fact",
                 "APSC syllabus, in short:\n"
                 "1. Indian culture: the main aspects of art forms, literature and architecture from ancient to modern times.\n"
                 "2. Modern Indian history from about the middle of the eighteenth century until the present: significant events, personalities and issues.\n"
                 "3. The freedom struggle: its various stages and important contributors from different parts of the country.\n"
                 "4. Post-independence consolidation and reorganisation within the country."),
                ("h1", "heading", "normal", "1. Indian culture: art, literature, architecture"),
                ("l1", "list", "suggested",
                 "Architecture: Harappan cities; Mauryan pillars and stupas; rock-cut caves (Ajanta, Ellora, Elephanta); temple styles Nagara, Dravida and Vesara; Indo-Islamic and Mughal buildings; colonial architecture\n"
                 "Sculpture: Mauryan, Gandhara, Mathura and Amaravati schools; Gupta and Chola bronzes\n"
                 "Painting: Ajanta murals; Mughal, Rajput and Pahari miniatures; manuscript painting of Assam; Bengal School\n"
                 "Music: Hindustani and Carnatic; Bhakti songs; {{term:borgeet|Borgeet}}\n"
                 "Dance: the classical dances recognised by the Sangeet Natak Akademi, including Sattriya of Assam; folk dances\n"
                 "Theatre and puppetry: Sanskrit drama, Ankiya Naat and Bhaona, folk theatre\n"
                 "Literature: Vedic and Sanskrit, Sangam Tamil, Pali and Prakrit, Bhakti literature, Persian and Urdu, modern Indian literature\n"
                 "Religion and philosophy: six schools of philosophy, Buddhism, Jainism, Bhakti and Sufi traditions\n"
                 "Fairs, festivals, crafts and UNESCO World Heritage Sites of India (Kaziranga, Manas and the Charaideo Moidams in Assam)"),
                ("h2", "heading", "normal", "2. Modern Indian history (about 1750 to today)"),
                ("l2", "list", "suggested",
                 "Decline of the Mughals and rise of regional powers\n"
                 "East India Company: conquest, Subsidiary Alliance, Doctrine of Lapse\n"
                 "Economic impact of British rule: land revenue settlements, decline of handicrafts, commercialisation of agriculture, drain of wealth, famines\n"
                 "Tea, oil and coal in Assam; indentured labour for the tea gardens\n"
                 "Education policy: Macaulay's Minute (1835), Wood's Despatch (1854), universities (1857)\n"
                 "Press and public opinion; Indian awakening and reform movements\n"
                 "Peasant and tribal revolts: Santhal, Indigo, Deccan riots, Phulaguri (1861) and Patharughat (1894) in Assam\n"
                 "Constitutional development: Regulating Act 1773 to the Indian Independence Act 1947\n"
                 "Important personalities: reformers, nationalist leaders, revolutionaries"),
                ("h3", "heading", "normal", "3. The freedom struggle: stages and contributors"),
                ("l3", "list", "suggested",
                 "Stage 1, the Moderate phase (1885 to 1905): petitions, economic critique, Dadabhai Naoroji\n"
                 "Stage 2, the Extremist phase and Swadeshi (1905 to 1918): Lal-Bal-Pal, boycott, national education\n"
                 "Stage 3, the Gandhian mass movements (1919 to 1947): Non-Cooperation, Civil Disobedience, {{term:quit-india-movement|Quit India}}\n"
                 "Revolutionary and left movements: Bhagat Singh, HSRA, Chittagong, Congress Socialists\n"
                 "Subhas Chandra Bose and the INA, which reached the Northeast frontier (Kohima, Moirang, 1944)\n"
                 "Contributors from the Northeast: Gomdhar Konwar, U Tirot Sing, Maniram Dewan, Piyoli Barua, Kanaklata Barua, Kushal Konwar, Bhogeswari Phukanani, Tarun Ram Phukan, Nabin Chandra Bardoloi, Gopinath Bordoloi, Rani Gaidinliu\n"
                 "Contributors from other regions: Tilak, Gokhale, Lala Lajpat Rai, Sardar Patel, Nehru, Ambedkar, Sarojini Naidu, Periyar, Khan Abdul Ghaffar Khan\n"
                 "The partition question: {{term:cabinet-mission|Cabinet Mission}} grouping and Assam's resistance; Sylhet referendum (1947)"),
                ("h4", "heading", "normal", "4. India after independence"),
                ("l4", "list", "suggested",
                 "Integration of princely states (Sardar Patel, V. P. Menon); Manipur and Tripura joining India (1949)\n"
                 "Making of the Constitution (1946 to 1950)\n"
                 "Linguistic reorganisation: Andhra (1953), States Reorganisation Act (1956)\n"
                 "Reorganisation of the Northeast: Nagaland (1963), North-Eastern Areas (Reorganisation) Act 1971, Meghalaya, Manipur and Tripura as states (1972), Mizoram and Arunachal Pradesh (1987)\n"
                 "{{term:sixth-schedule|Sixth Schedule}} and autonomous councils\n"
                 "Wars of 1962, 1965 and 1971; the Chinese aggression in Arunachal and Assam (1962)\n"
                 "Planning, Green Revolution, land reforms; the Emergency (1975 to 1977)\n"
                 "The Assam Movement (1979 to 1985) and the {{term:assam-accord|Assam Accord}}"),
                ("h5", "heading", "normal", "Read these in ASSAMPEDIA (GK)"),
                ("l5", "list", "normal",
                 "History of Assam: Assam under British rule; Assam in the freedom struggle; The Assam Movement and the Assam Accord\n"
                 "Art, Culture and Heritage: Sattriya dance and the Sattra institution; Folk dances and music; A short history of Assamese literature\n"
                 "Introduction to Assam: How the present state was formed\n"
                 "Polity and Administration: Sixth Schedule and autonomous councils\n"
                 "Important Personalities: Gopinath Bordoloi; Maniram Dewan; Lachit Borphukan"),
                ("tip1", "paragraph", "suggested",
                 "Mains answers need analysis, not only facts. For each topic, be ready to write about causes, results and significance, "
                 "and add an Assam or Northeast example wherever you can."),
            ],
            "as": [
                ("p1", "paragraph", "normal",
                 "{{term:main-exam|মুখ্য পৰীক্ষাৰ}} সাধাৰণ অধ্যয়ন প্ৰথম কাকতত (২৫০ নম্বৰ, ৩ ঘণ্টা) ভাৰতীয় ঐতিহ্য আৰু সংস্কৃতি, "
                 "ইতিহাস, সমাজ আৰু ভূগোল থাকে। ইয়াৰ ইতিহাসৰ অংশত চাৰিটা ভাগ আছে।"),
                ("f1", "fact_box", "exam_fact",
                 "এপিএছচিৰ পাঠ্যক্ৰম, চমুকৈ:\n"
                 "১. ভাৰতীয় সংস্কৃতি: প্ৰাচীন কালৰ পৰা আধুনিক কাললৈ কলা, সাহিত্য আৰু স্থাপত্যৰ প্ৰধান দিশসমূহ।\n"
                 "২. প্ৰায় অষ্টাদশ শতিকাৰ মাজভাগৰ পৰা বৰ্তমানলৈ আধুনিক ভাৰতৰ ইতিহাস: গুৰুত্বপূৰ্ণ ঘটনা, ব্যক্তি আৰু বিষয়।\n"
                 "৩. স্বাধীনতা সংগ্ৰাম: ইয়াৰ বিভিন্ন পৰ্যায় আৰু দেশৰ বিভিন্ন প্ৰান্তৰ গুৰুত্বপূৰ্ণ অৰিহণাকাৰী।\n"
                 "৪. স্বাধীনতাৰ পিছত দেশৰ ভিতৰত একত্ৰীকৰণ আৰু পুনৰ্গঠন।"),
                ("h1", "heading", "normal", "১. ভাৰতীয় সংস্কৃতি: কলা, সাহিত্য, স্থাপত্য"),
                ("l1", "list", "suggested",
                 "স্থাপত্য: হৰপ্পাৰ নগৰ; মৌৰ্য স্তম্ভ আৰু স্তূপ; শিল কাটি সজা গুহা (অজন্তা, ইলোৰা, এলিফেণ্টা); নাগৰ, দ্ৰাবিড় আৰু বেসৰ মন্দিৰ শৈলী; ইণ্ডো-ইছলামীয় আৰু মোগল অট্টালিকা; ঔপনিৱেশিক স্থাপত্য\n"
                 "ভাস্কৰ্য: মৌৰ্য, গান্ধাৰ, মথুৰা আৰু অমৰাৱতী শৈলী; গুপ্ত আৰু চোল যুগৰ ব্ৰঞ্জ মূৰ্তি\n"
                 "চিত্ৰকলা: অজন্তাৰ দেৱালচিত্ৰ; মোগল, ৰাজপুত আৰু পাহাৰী অণুচিত্ৰ; অসমৰ পুথিচিত্ৰ; বংগ শৈলী\n"
                 "সংগীত: হিন্দুস্তানী আৰু কৰ্ণাটকী; ভক্তিগীত; {{term:borgeet|বৰগীত}}\n"
                 "নৃত্য: সংগীত নাটক অকাদেমীয়ে স্বীকৃতি দিয়া শাস্ত্ৰীয় নৃত্য, অসমৰ সত্ৰীয়াকে ধৰি; লোকনৃত্য\n"
                 "নাট্য আৰু পুতলা নাচ: সংস্কৃত নাটক, অংকীয়া নাট আৰু ভাওনা, লোকনাট্য\n"
                 "সাহিত্য: বৈদিক আৰু সংস্কৃত, সংগম তামিল, পালি আৰু প্ৰাকৃত, ভক্তি সাহিত্য, ফাৰ্চী আৰু উৰ্দু, আধুনিক ভাৰতীয় সাহিত্য\n"
                 "ধৰ্ম আৰু দৰ্শন: ষড়দৰ্শন, বৌদ্ধ, জৈন, ভক্তি আৰু ছুফী পৰম্পৰা\n"
                 "মেলা, উৎসৱ, হস্তশিল্প আৰু ভাৰতৰ ইউনেস্কো বিশ্ব ঐতিহ্য ক্ষেত্ৰ (অসমত কাজিৰঙা, মানস আৰু চৰাইদেউৰ মৈদাম)"),
                ("h2", "heading", "normal", "২. আধুনিক ভাৰতৰ ইতিহাস (প্ৰায় ১৭৫০ ৰ পৰা আজিলৈ)"),
                ("l2", "list", "suggested",
                 "মোগলৰ পতন আৰু আঞ্চলিক শক্তিৰ উত্থান\n"
                 "ইষ্ট ইণ্ডিয়া কোম্পানী: ৰাজ্য জয়, অধীনতামূলক মিত্ৰতা, স্বত্ববিলোপ নীতি\n"
                 "ব্ৰিটিছ শাসনৰ অৰ্থনৈতিক প্ৰভাৱ: ভূমি ৰাজহ বন্দোবস্ত, হস্তশিল্পৰ অৱনতি, কৃষিৰ বাণিজ্যিকীকৰণ, সম্পদ নিষ্কাশন, দুৰ্ভিক্ষ\n"
                 "অসমত চাহ, তেল আৰু কয়লা; চাহ বাগিচালৈ চুক্তিবদ্ধ শ্ৰমিক\n"
                 "শিক্ষা নীতি: মেকলেৰ মিনিট (১৮৩৫), উডৰ ডেচপেচ (১৮৫৪), বিশ্ববিদ্যালয় (১৮৫৭)\n"
                 "সংবাদপত্ৰ আৰু জনমত; ভাৰতীয় জাগৰণ আৰু সংস্কাৰ আন্দোলন\n"
                 "কৃষক আৰু জনজাতীয় বিদ্ৰোহ: চাওঁতাল, নীল বিদ্ৰোহ, দাক্ষিণাত্যৰ বিদ্ৰোহ, অসমত ফুলগুৰি (১৮৬১) আৰু পথাৰুঘাট (১৮৯৪)\n"
                 "সাংবিধানিক বিকাশ: নিয়ন্ত্ৰণ আইন ১৭৭৩ ৰ পৰা ভাৰতীয় স্বাধীনতা আইন ১৯৪৭ লৈ\n"
                 "গুৰুত্বপূৰ্ণ ব্যক্তি: সংস্কাৰক, জাতীয়তাবাদী নেতা, বিপ্লৱী"),
                ("h3", "heading", "normal", "৩. স্বাধীনতা সংগ্ৰাম: পৰ্যায় আৰু অৰিহণাকাৰী"),
                ("l3", "list", "suggested",
                 "প্ৰথম পৰ্যায়, নৰমপন্থী যুগ (১৮৮৫ ৰ পৰা ১৯০৫): আবেদন, অৰ্থনৈতিক সমালোচনা, দাদাভাই নৌৰোজী\n"
                 "দ্বিতীয় পৰ্যায়, চৰমপন্থী যুগ আৰু স্বদেশী (১৯০৫ ৰ পৰা ১৯১৮): লাল-বাল-পাল, বৰ্জন, জাতীয় শিক্ষা\n"
                 "তৃতীয় পৰ্যায়, গান্ধীৰ গণ আন্দোলন (১৯১৯ ৰ পৰা ১৯৪৭): অসহযোগ, আইন অমান্য, {{term:quit-india-movement|ভাৰত ত্যাগ}}\n"
                 "বিপ্লৱী আৰু বাম আন্দোলন: ভগৎ সিং, এইচএছআৰএ, চট্টগ্ৰাম, কংগ্ৰেছ ছচিয়েলিষ্ট\n"
                 "সুভাষচন্দ্ৰ বসু আৰু আজাদ হিন্দ ফৌজ, যি উত্তৰ-পূৰ্বৰ সীমালৈ আহিছিল (কোহিমা, মৈৰাং, ১৯৪৪)\n"
                 "উত্তৰ-পূৰ্বৰ অৰিহণাকাৰী: গোমধৰ কোঁৱৰ, উ তিৰত সিং, মণিৰাম দেৱান, পিয়লি বৰুৱা, কনকলতা বৰুৱা, কুশল কোঁৱৰ, ভোগেশ্বৰী ফুকননী, তৰুণৰাম ফুকন, নবীনচন্দ্ৰ বৰদলৈ, গোপীনাথ বৰদলৈ, ৰাণী গাইদিনলিউ\n"
                 "অন্য অঞ্চলৰ অৰিহণাকাৰী: তিলক, গোখলে, লালা লাজপত ৰায়, চৰ্দাৰ পেটেল, নেহৰু, আম্বেদকাৰ, চৰোজিনী নাইডু, পেৰিয়াৰ, খান আব্দুল গফ্ফাৰ খান\n"
                 "বিভাজনৰ প্ৰশ্ন: {{term:cabinet-mission|কেবিনেট মিছনৰ}} গোট ব্যৱস্থা আৰু অসমৰ প্ৰতিবাদ; শ্ৰীহট্ট গণভোট (১৯৪৭)"),
                ("h4", "heading", "normal", "৪. স্বাধীনতাৰ পিছৰ ভাৰত"),
                ("l4", "list", "suggested",
                 "দেশীয় ৰাজ্যৰ একত্ৰীকৰণ (চৰ্দাৰ পেটেল, ভি. পি. মেনন); মণিপুৰ আৰু ত্ৰিপুৰাৰ ভাৰতভুক্তি (১৯৪৯)\n"
                 "সংবিধান প্ৰণয়ন (১৯৪৬ ৰ পৰা ১৯৫০)\n"
                 "ভাষাভিত্তিক পুনৰ্গঠন: অন্ধ্ৰ (১৯৫৩), ৰাজ্য পুনৰ্গঠন আইন (১৯৫৬)\n"
                 "উত্তৰ-পূৰ্বৰ পুনৰ্গঠন: নাগালেণ্ড (১৯৬৩), উত্তৰ-পূৰ্বাঞ্চল (পুনৰ্গঠন) আইন ১৯৭১, ৰাজ্য হিচাপে মেঘালয়, মণিপুৰ আৰু ত্ৰিপুৰা (১৯৭২), মিজোৰাম আৰু অৰুণাচল প্ৰদেশ (১৯৮৭)\n"
                 "{{term:sixth-schedule|ষষ্ঠ অনুসূচী}} আৰু স্বায়ত্তশাসিত পৰিষদ\n"
                 "১৯৬২, ১৯৬৫ আৰু ১৯৭১ চনৰ যুদ্ধ; অৰুণাচল আৰু অসমত চীনা আক্ৰমণ (১৯৬২)\n"
                 "পৰিকল্পনা, সেউজ বিপ্লৱ, ভূমি সংস্কাৰ; জৰুৰীকালীন অৱস্থা (১৯৭৫ ৰ পৰা ১৯৭৭)\n"
                 "অসম আন্দোলন (১৯৭৯ ৰ পৰা ১৯৮৫) আৰু {{term:assam-accord|অসম চুক্তি}}"),
                ("h5", "heading", "normal", "ASSAMPEDIA ত পঢ়ক (সাধাৰণ জ্ঞান)"),
                ("l5", "list", "normal",
                 "অসমৰ ইতিহাস: ব্ৰিটিছ শাসনত অসম; স্বাধীনতা সংগ্ৰামত অসম; অসম আন্দোলন আৰু অসম চুক্তি\n"
                 "কলা, সংস্কৃতি আৰু ঐতিহ্য: সত্ৰীয়া নৃত্য আৰু সত্ৰ অনুষ্ঠান; লোকনৃত্য আৰু লোকসংগীত; অসমীয়া সাহিত্যৰ চমু ইতিহাস\n"
                 "অসমৰ পৰিচয়: বৰ্তমানৰ অসম ৰাজ্য কেনেকৈ গঠন হ'ল\n"
                 "ৰাজনীতি আৰু প্ৰশাসন: ষষ্ঠ অনুসূচী আৰু স্বায়ত্তশাসিত পৰিষদ\n"
                 "বিশিষ্ট ব্যক্তি: গোপীনাথ বৰদলৈ; মণিৰাম দেৱান; লাচিত বৰফুকন"),
                ("tip1", "paragraph", "suggested",
                 "মুখ্য পৰীক্ষাৰ উত্তৰত কেৱল তথ্য নহয়, বিশ্লেষণো লাগে। প্ৰতিটো বিষয়ৰ কাৰণ, ফলাফল আৰু তাৎপৰ্য লিখিবলৈ সাজু থাকক, "
                 "আৰু য'তেই পাৰে অসম বা উত্তৰ-পূৰ্বৰ উদাহৰণ যোগ কৰক।"),
            ],
        },
    ),
    # ------------------------------------------------------------------ 4
    dict(
        slug="apsc-cce-mains-assam-history", position=4,
        official_url=OFFICIAL, notification_url=OFFICIAL, applies_to=APPLIES,
        title={"en": "APSC Mains paper on Assam: History, culture and heritage",
               "as": "এপিএছচি মুখ্য অসম বিষয়ক কাকত: অসমৰ ইতিহাস, সংস্কৃতি আৰু ঐতিহ্য"},
        summary={"en": "All twelve history and culture topics of the Assam paper, each opened up with subtopics.",
                 "as": "অসম বিষয়ক কাকতৰ ইতিহাস আৰু সংস্কৃতিৰ বাৰটা বিষয়, প্ৰতিটোৰ উপবিষয়ৰ সৈতে।"},
        sources=SOURCES + (
            "The detailed topic lists are our study guide built on the official lines; they are not APSC's words.\n"
            "TO VERIFY before publishing: the paper number (Paper VI in Drishti and the syllabus PDF copy, GS Paper V in SPM); "
            "Jnanpith years in l8 (Birendra Kumar Bhattacharya 1979, Mamoni Raisom Goswami 2000, Nilmani Phookan for 2021)."
        ),
        blocks={
            "en": [
                ("p1", "paragraph", "normal",
                 "The {{term:main-exam|Mains}} has a full General Studies paper on Assam (250 marks, 3 hours). "
                 "History, culture and heritage come first in it. This is where most of your Assam history preparation pays off."),
                ("f1", "fact_box", "exam_fact",
                 "APSC syllabus, in short (History of Assam):\n"
                 "1. Major landmarks in the history of Assam\n"
                 "2. Major dynasties, their administrative and revenue systems\n"
                 "3. Socio-cultural issues\n"
                 "4. The freedom movement\n"
                 "5. Political awakening and integration\n"
                 "6. Architecture and monuments\n"
                 "7. Arts, paintings and handicrafts\n"
                 "8. Important literature\n"
                 "9. Fairs, festivals, folk music and folk dances\n"
                 "10. Culture, tradition and heritage\n"
                 "11. Religious movements\n"
                 "12. Leading personalities"),
                ("h1", "heading", "normal", "1. Major landmarks in the history of Assam"),
                ("l1", "list", "suggested",
                 "Prehistoric Assam: Neolithic site of Daojali Hading (Dima Hasao)\n"
                 "Pragjyotisha and {{term:kamarupa|Kamarupa}}: Varman, Salastambha and Pala dynasties\n"
                 "Kamata kingdom, Chutia, Dimasa Kachari and Jaintia kingdoms; the Bhuyans\n"
                 "The {{term:ahom|Ahom}} kingdom (1228 to 1826) and the Koch kingdom\n"
                 "Mughal-Ahom conflicts; Battle of Saraighat (1671)\n"
                 "{{term:moamoria-rebellion|Moamoria rebellion}} (1769 onwards); Burmese invasions (1817 to 1826)\n"
                 "{{term:treaty-of-yandabo|Treaty of Yandabo}} (1826) and British annexation\n"
                 "{{term:chief-commissioner-province|Chief Commissioner's Province}} (1874); Eastern Bengal and Assam (1905 to 1912)\n"
                 "Sylhet {{term:referendum|referendum}} (1947); Assam as a state of India (1950); later separation of new states"),
                ("h2", "heading", "normal", "2. Major dynasties: administration and revenue"),
                ("l2", "list", "suggested",
                 "Kamarupa: king and ministers, land grants recorded on copper plates (Nidhanpur, Dubi), revenue from land\n"
                 "Ahom administration: the {{term:swargadeo|Swargadeo}}; the Patra Mantris (Burhagohain, Borgohain, Borpatragohain, and later the Borbarua and {{term:borphukan|Borphukan}})\n"
                 "Ahom officials: Rajkhowa, Baruas, Phukans, Hazarika, Saikia, Bora\n"
                 "The {{term:paik-system|Paik system}}, khels and gots; land survey under Pratap Singha and Rudra Singha\n"
                 "Recording history: the {{term:buranji|Buranjis}}\n"
                 "Koch administration under Naranarayan and Chilarai\n"
                 "British revenue system: land revenue in cash, rising rates, tea land grants (Wasteland Rules), new taxes"),
                ("h3", "heading", "normal", "3. Socio-cultural issues"),
                ("l3", "list", "suggested",
                 "Social structure: caste, tribes and communities; the place of women\n"
                 "Migration: tea garden labour, migration from East Bengal, the Line System (1920)\n"
                 "Language question: Bengali as court language (1836 to 1873) and its reversal; Official Language Act (1960); medium of instruction movement (1972)\n"
                 "Growth of the Assamese middle class, press and organisations\n"
                 "Identity movements of plains and hill communities; the Assam Movement (1979 to 1985)"),
                ("h4", "heading", "normal", "4. The freedom movement in Assam"),
                ("l4", "list", "suggested",
                 "Early revolts: Gomdhar Konwar (1828), Piyoli Phukan and Jiuram Dulia Barua (1830), U Tirot Sing and the Khasi resistance (1829 to 1833)\n"
                 "1857 in Assam: Maniram Dewan and Piyoli Barua\n"
                 "Peasant uprisings against high land revenue: Phulaguri (1861), Rangia and Lachima (1893 to 1894), Patharughat (1894)\n"
                 "Non-Cooperation (1921) in Assam; Gandhi's visit (1921)\n"
                 "Civil Disobedience (1930 to 1934)\n"
                 "{{term:quit-india-movement|Quit India}} (1942): {{term:mrityu-bahini|Mrityu Bahini}}, Kanaklata Barua and Mukunda Kakati at Gohpur, Kushal Konwar, Bhogeswari Phukanani\n"
                 "The {{term:cabinet-mission|Cabinet Mission}} grouping plan (1946) and Gopinath Bordoloi's fight to keep Assam in India"),
                ("h5", "heading", "normal", "5. Political awakening and integration"),
                ("l5", "list", "suggested",
                 "Early bodies: Jorhat Sarvajanik Sabha (1884), Assam Association (1903), Ryot Sabhas\n"
                 "Assam Sahitya Sabha (1917) and the cultural awakening\n"
                 "Assam Pradesh Congress Committee (1921); Congress session at Pandu, Guwahati (1926)\n"
                 "Elections and ministries under the 1935 Act\n"
                 "Integration of the Northeast after 1947: princely states, hills areas, {{term:sixth-schedule|Sixth Schedule}}\n"
                 "Formation of new states out of Assam (1963 to 1987); autonomous councils; {{term:assam-accord|Assam Accord}} (1985)"),
                ("h6", "heading", "normal", "6. Architecture and monuments"),
                ("l6", "list", "suggested",
                 "Da-Parbatia door frame near Tezpur (Gupta style), Bamuni Hills, Madan Kamdev, Surya Pahar\n"
                 "Kamakhya temple (rebuilt by the Koch king Naranarayan, 1565); Hayagriva Madhava at Hajo; Umananda\n"
                 "Ahom monuments: Rang Ghar, Talatal Ghar, Kareng Ghar, Sivadol, Joysagar tank\n"
                 "Charaideo {{term:maidam|Moidams}}, a UNESCO World Heritage Site (2024)\n"
                 "Sattras and Namghars as a building style; Poa Mecca at Hajo"),
                ("h7", "heading", "normal", "7. Arts, paintings and handicrafts"),
                ("l7", "list", "suggested",
                 "Manuscript painting on sanchipat (agar bark): Chitra Bhagavata, Hastividyarnava, Gita Govinda\n"
                 "Mask making of Majuli\n"
                 "Muga, Pat and Eri silk; gamosa weaving\n"
                 "Bell metal of Sarthebari, brass of Hajo, terracotta of Asharikandi\n"
                 "Cane and bamboo work; japi; jewellery (jonbiri, gamkharu)"),
                ("h8", "heading", "normal", "8. Important literature"),
                ("l8", "list", "suggested",
                 "{{term:charyapada|Charyapada}} (early roots)\n"
                 "Pre-Vaishnava: Hema Saraswati (Prahlad Charit), Madhav Kandali (Saptakanda Ramayana)\n"
                 "Vaishnava age: Sankardev (Kirtan Ghosha, Ankiya Naat), Madhavdev (Naam Ghosha), Bhattadev (prose)\n"
                 "Ahom age: {{term:buranji|Buranjis}} in prose\n"
                 "Missionaries and Orunodoi (1846); Hemchandra Barua's grammar and dictionary\n"
                 "{{term:jonaki-era|Jonaki era}} (1889): Lakshminath Bezbaroa, Chandra Kumar Agarwala, Hemchandra Goswami\n"
                 "Modern: Jyoti Prasad Agarwala, Bishnu Prasad Rabha, Birinchi Kumar Barua\n"
                 "{{term:jnanpith-award|Jnanpith Award}} winners: Birendra Kumar Bhattacharya, Mamoni Raisom Goswami, Nilmani Phookan"),
                ("h9", "heading", "normal", "9. Fairs, festivals, folk music and dances"),
                ("l9", "list", "suggested",
                 "Bihu (Bohag, Kati, Magh); Ambubachi Mela; Raas Leela of Majuli; Jonbeel Mela; Dehing Patkai festival\n"
                 "Community festivals: Me-Dam-Me-Phi, Ali-Aye-Ligang, Bwisagu, Baikho, Rongker, Bushu Dima, Karam\n"
                 "Folk music: Bihu geet, Borgeet, Zikir and Zari, Kamrupi and Goalpariya lokageet, Tokari geet\n"
                 "Dances: Bihu, Bagurumba, Jhumur, Deodhani, Ojapali, Sattriya"),
                ("h10", "heading", "normal", "10. Culture, tradition and heritage"),
                ("l10", "list", "suggested",
                 "The {{term:sattra|Sattra}} and the {{term:namghar|Namghar}} in village life\n"
                 "Symbols: gamosa, xorai, jaapi\n"
                 "Bhaona and Ankiya Naat\n"
                 "Geographical Indication tags of Assam (Muga silk, Assam tea, Joha rice, Bhut Jolokia and others)\n"
                 "Intangible heritage: oral traditions, Buranji writing, folk tales"),
                ("h11", "heading", "normal", "11. Religious movements"),
                ("l11", "list", "suggested",
                 "Shaktism and Tantra (Kamakhya); Shaivism; Buddhism (Hajo)\n"
                 "{{term:neo-vaishnavism|Neo-Vaishnavism}} of Sankardev and Madhavdev; the four samhatis (Brahma, Purusha, Kala, Nika)\n"
                 "Ahom kings and Hinduism; the traditional Tai Ahom faith and ancestor worship (Me-Dam-Me-Phi)\n"
                 "Islam in Assam: Azan Fakir and Zikir; Poa Mecca\n"
                 "Christian missions: the American Baptists in Sivasagar, missions in the hills"),
                ("h12", "heading", "normal", "12. Leading personalities"),
                ("l12", "list", "suggested",
                 "Kings and generals: Bhaskaravarman, Sukaphaa, Suhungmung, Naranarayan and Chilarai, Lachit Borphukan, Rudra Singha, Mula Gabharu, Joymoti\n"
                 "Saints and writers: Sankardev, Madhavdev, Azan Fakir, Lakshminath Bezbaroa, Jyoti Prasad Agarwala, Bishnu Prasad Rabha\n"
                 "Freedom fighters: Maniram Dewan, Gopinath Bordoloi, Tarun Ram Phukan, Nabin Chandra Bardoloi, Kanaklata Barua, Kushal Konwar, Chandraprabha Saikiani\n"
                 "Modern Assam: Bhupen Hazarika, Anandaram Dhekial Phukan, Gunabhiram Barua, Ambikagiri Raichoudhury"),
                ("h13", "heading", "normal", "Read these in ASSAMPEDIA (GK)"),
                ("l13", "list", "normal",
                 "History of Assam: all 8 chapters\n"
                 "Art, Culture and Heritage: Bihu; Sattriya dance and the Sattra institution; Folk dances and music; Silk and handloom; A short history of Assamese literature\n"
                 "Important Personalities: Srimanta Sankardev; Lachit Borphukan; Lakshminath Bezbaroa; Jyoti Prasad Agarwala; Gopinath Bordoloi; Bhupen Hazarika; Maniram Dewan\n"
                 "Important Places and Tourism: Kamakhya Temple; Majuli; Sivasagar and its monuments; Hajo; Tezpur\n"
                 "Introduction to Assam: How the present state was formed"),
                ("tip1", "paragraph", "suggested",
                 "This paper rewards Assam-specific detail. Learn names, years and places well, "
                 "and practise short notes (150 words) and long answers (250 words) on each of the twelve topics."),
            ],
            "as": [
                ("p1", "paragraph", "normal",
                 "{{term:main-exam|মুখ্য পৰীক্ষাত}} অসমৰ ওপৰত এখন সম্পূৰ্ণ সাধাৰণ অধ্যয়নৰ কাকত আছে (২৫০ নম্বৰ, ৩ ঘণ্টা)। "
                 "ইয়াত ইতিহাস, সংস্কৃতি আৰু ঐতিহ্য প্ৰথমতে আছে। অসমৰ ইতিহাসৰ প্ৰস্তুতিৰ সৰহভাগ ফল ইয়াতেই পোৱা যায়।"),
                ("f1", "fact_box", "exam_fact",
                 "এপিএছচিৰ পাঠ্যক্ৰম, চমুকৈ (অসমৰ ইতিহাস):\n"
                 "১. অসমৰ ইতিহাসৰ প্ৰধান মাইলৰ খুঁটি\n"
                 "২. প্ৰধান ৰাজবংশ, সিহঁতৰ প্ৰশাসনিক আৰু ৰাজহ ব্যৱস্থা\n"
                 "৩. সমাজ-সাংস্কৃতিক বিষয়\n"
                 "৪. স্বাধীনতা আন্দোলন\n"
                 "৫. ৰাজনৈতিক জাগৰণ আৰু একত্ৰীকৰণ\n"
                 "৬. স্থাপত্য আৰু কীৰ্তিচিহ্ন\n"
                 "৭. কলা, চিত্ৰকলা আৰু হস্তশিল্প\n"
                 "৮. গুৰুত্বপূৰ্ণ সাহিত্য\n"
                 "৯. মেলা, উৎসৱ, লোকসংগীত আৰু লোকনৃত্য\n"
                 "১০. সংস্কৃতি, পৰম্পৰা আৰু ঐতিহ্য\n"
                 "১১. ধৰ্মীয় আন্দোলন\n"
                 "১২. বিশিষ্ট ব্যক্তি"),
                ("h1", "heading", "normal", "১. অসমৰ ইতিহাসৰ প্ৰধান মাইলৰ খুঁটি"),
                ("l1", "list", "suggested",
                 "প্ৰাগৈতিহাসিক অসম: দাওজালি হাডিঙৰ নৱ্য প্ৰস্তৰ যুগৰ স্থান (ডিমা হাছাও)\n"
                 "প্ৰাগজ্যোতিষ আৰু {{term:kamarupa|কামৰূপ}}: বৰ্মন, শালস্তম্ভ আৰু পাল বংশ\n"
                 "কমতা ৰাজ্য, চুতীয়া, ডিমাছা কছাৰী আৰু জয়ন্তীয়া ৰাজ্য; ভূঞাসকল\n"
                 "{{term:ahom|আহোম}} ৰাজ্য (১২২৮ ৰ পৰা ১৮২৬) আৰু কোচ ৰাজ্য\n"
                 "মোগল-আহোম সংঘাত; শৰাইঘাটৰ যুদ্ধ (১৬৭১)\n"
                 "{{term:moamoria-rebellion|মোৱামৰীয়া বিদ্ৰোহ}} (১৭৬৯ ৰ পৰা); মানৰ আক্ৰমণ (১৮১৭ ৰ পৰা ১৮২৬)\n"
                 "{{term:treaty-of-yandabo|ইয়াণ্ডাবুৰ সন্ধি}} (১৮২৬) আৰু ব্ৰিটিছৰ অধিকাৰ\n"
                 "{{term:chief-commissioner-province|চিফ কমিছনাৰৰ প্ৰদেশ}} (১৮৭৪); পূব বংগ আৰু অসম (১৯০৫ ৰ পৰা ১৯১২)\n"
                 "শ্ৰীহট্ট {{term:referendum|গণভোট}} (১৯৪৭); ভাৰতৰ ৰাজ্য হিচাপে অসম (১৯৫০); পিছত নতুন ৰাজ্যৰ পৃথকীকৰণ"),
                ("h2", "heading", "normal", "২. প্ৰধান ৰাজবংশ: প্ৰশাসন আৰু ৰাজহ"),
                ("l2", "list", "suggested",
                 "কামৰূপ: ৰজা আৰু মন্ত্ৰী, তাম্ৰফলকত লিখা ভূমিদান (নিধানপুৰ, ডুবি), মাটিৰ পৰা ৰাজহ\n"
                 "আহোম প্ৰশাসন: {{term:swargadeo|স্বৰ্গদেউ}}; পাত্ৰমন্ত্ৰী (বুঢ়াগোহাঁই, বৰগোহাঁই, বৰপাত্ৰগোহাঁই, আৰু পিছত বৰবৰুৱা আৰু {{term:borphukan|বৰফুকন}})\n"
                 "আহোম বিষয়া: ৰাজখোৱা, বৰুৱা, ফুকন, হাজৰিকা, শইকীয়া, বৰা\n"
                 "{{term:paik-system|পাইক প্ৰথা}}, খেল আৰু গোট; প্ৰতাপ সিংহ আৰু ৰুদ্ৰ সিংহৰ দিনৰ মাটি জৰীপ\n"
                 "ইতিহাস লিখন: {{term:buranji|বুৰঞ্জী}}\n"
                 "নৰনাৰায়ণ আৰু চিলাৰায়ৰ দিনৰ কোচ প্ৰশাসন\n"
                 "ব্ৰিটিছৰ ৰাজহ ব্যৱস্থা: নগদ ধনত মাটিৰ খাজনা, খাজনাৰ হাৰ বৃদ্ধি, চাহৰ বাবে পতিত মাটি দান, নতুন কৰ"),
                ("h3", "heading", "normal", "৩. সমাজ-সাংস্কৃতিক বিষয়"),
                ("l3", "list", "suggested",
                 "সমাজ ব্যৱস্থা: জাতি, জনজাতি আৰু জনগোষ্ঠী; নাৰীৰ স্থান\n"
                 "প্ৰব্ৰজন: চাহ বাগিচাৰ শ্ৰমিক, পূব বংগৰ পৰা প্ৰব্ৰজন, ৰেখা প্ৰথা (১৯২০)\n"
                 "ভাষাৰ প্ৰশ্ন: আদালতৰ ভাষা হিচাপে বাংলা (১৮৩৬ ৰ পৰা ১৮৭৩) আৰু ইয়াৰ পৰিৱৰ্তন; ৰাজ্যিক ভাষা আইন (১৯৬০); মাধ্যম আন্দোলন (১৯৭২)\n"
                 "অসমীয়া মধ্যবিত্ত শ্ৰেণী, সংবাদপত্ৰ আৰু সংগঠনৰ বিকাশ\n"
                 "ভৈয়াম আৰু পাহাৰৰ জনগোষ্ঠীৰ পৰিচয়ৰ আন্দোলন; অসম আন্দোলন (১৯৭৯ ৰ পৰা ১৯৮৫)"),
                ("h4", "heading", "normal", "৪. অসমৰ স্বাধীনতা আন্দোলন"),
                ("l4", "list", "suggested",
                 "প্ৰথম বিদ্ৰোহ: গোমধৰ কোঁৱৰ (১৮২৮), পিয়লি ফুকন আৰু জিউৰাম দুলীয়া বৰুৱা (১৮৩০), উ তিৰত সিং আৰু খাচী প্ৰতিৰোধ (১৮২৯ ৰ পৰা ১৮৩৩)\n"
                 "অসমত ১৮৫৭: মণিৰাম দেৱান আৰু পিয়লি বৰুৱা\n"
                 "উচ্চ খাজনাৰ বিৰুদ্ধে কৃষক বিদ্ৰোহ: ফুলগুৰি (১৮৬১), ৰঙিয়া আৰু লাচিমা (১৮৯৩ ৰ পৰা ১৮৯৪), পথাৰুঘাট (১৮৯৪)\n"
                 "অসমত অসহযোগ আন্দোলন (১৯২১); গান্ধীৰ অসম ভ্ৰমণ (১৯২১)\n"
                 "আইন অমান্য আন্দোলন (১৯৩০ ৰ পৰা ১৯৩৪)\n"
                 "{{term:quit-india-movement|ভাৰত ত্যাগ}} (১৯৪২): {{term:mrityu-bahini|মৃত্যু বাহিনী}}, গহপুৰত কনকলতা বৰুৱা আৰু মুকুন্দ কাকতি, কুশল কোঁৱৰ, ভোগেশ্বৰী ফুকননী\n"
                 "{{term:cabinet-mission|কেবিনেট মিছনৰ}} গোট পৰিকল্পনা (১৯৪৬) আৰু অসমক ভাৰতত ৰাখিবলৈ গোপীনাথ বৰদলৈৰ সংগ্ৰাম"),
                ("h5", "heading", "normal", "৫. ৰাজনৈতিক জাগৰণ আৰু একত্ৰীকৰণ"),
                ("l5", "list", "suggested",
                 "প্ৰথম সংগঠন: যোৰহাট সাৰ্বজনিক সভা (১৮৮৪), আসাম এছোচিয়েচন (১৯০৩), ৰাইজ মেল\n"
                 "অসম সাহিত্য সভা (১৯১৭) আৰু সাংস্কৃতিক জাগৰণ\n"
                 "অসম প্ৰদেশ কংগ্ৰেছ কমিটি (১৯২১); গুৱাহাটীৰ পাণ্ডুত কংগ্ৰেছৰ অধিৱেশন (১৯২৬)\n"
                 "১৯৩৫ চনৰ আইনৰ অধীনত নিৰ্বাচন আৰু মন্ত্ৰিসভা\n"
                 "১৯৪৭ ৰ পিছত উত্তৰ-পূৰ্বৰ একত্ৰীকৰণ: দেশীয় ৰাজ্য, পাহাৰীয়া অঞ্চল, {{term:sixth-schedule|ষষ্ঠ অনুসূচী}}\n"
                 "অসমৰ পৰা নতুন ৰাজ্য গঠন (১৯৬৩ ৰ পৰা ১৯৮৭); স্বায়ত্তশাসিত পৰিষদ; {{term:assam-accord|অসম চুক্তি}} (১৯৮৫)"),
                ("h6", "heading", "normal", "৬. স্থাপত্য আৰু কীৰ্তিচিহ্ন"),
                ("l6", "list", "suggested",
                 "তেজপুৰৰ ওচৰৰ দহপৰ্বতীয়াৰ দুৱাৰডলি (গুপ্ত শৈলী), বামুণী পাহাৰ, মদন কামদেৱ, সূৰ্য পাহাৰ\n"
                 "কামাখ্যা মন্দিৰ (কোচ ৰজা নৰনাৰায়ণে ১৫৬৫ চনত পুনৰ নিৰ্মাণ কৰে); হাজোৰ হয়গ্ৰীৱ মাধৱ; উমানন্দ\n"
                 "আহোম কীৰ্তিচিহ্ন: ৰংঘৰ, তলাতল ঘৰ, কাৰেংঘৰ, শিৱদৌল, জয়সাগৰ পুখুৰী\n"
                 "চৰাইদেউৰ {{term:maidam|মৈদাম}}, ইউনেস্কো বিশ্ব ঐতিহ্য ক্ষেত্ৰ (২০২৪)\n"
                 "স্থাপত্য শৈলী হিচাপে সত্ৰ আৰু নামঘৰ; হাজোৰ পোৱা মক্কা"),
                ("h7", "heading", "normal", "৭. কলা, চিত্ৰকলা আৰু হস্তশিল্প"),
                ("l7", "list", "suggested",
                 "সাঁচিপাতত পুথিচিত্ৰ: চিত্ৰ ভাগৱত, হস্তীবিদ্যাৰ্ণৱ, গীতগোবিন্দ\n"
                 "মাজুলীৰ মুখা শিল্প\n"
                 "মুগা, পাট আৰু এৰী; গামোচা বোৱা\n"
                 "সৰ্থেবাৰীৰ কাঁহ, হাজোৰ পিতল, আশাৰিকান্দিৰ পোৰামাটিৰ শিল্প\n"
                 "বাঁহ-বেতৰ কাম; জাপি; অলংকাৰ (জোনবিৰি, গামখাৰু)"),
                ("h8", "heading", "normal", "৮. গুৰুত্বপূৰ্ণ সাহিত্য"),
                ("l8", "list", "suggested",
                 "{{term:charyapada|চৰ্যাপদ}} (আদি শিপা)\n"
                 "প্ৰাক্-বৈষ্ণৱ যুগ: হেম সৰস্বতী (প্ৰহ্লাদ চৰিত), মাধৱ কন্দলি (সপ্তকাণ্ড ৰামায়ণ)\n"
                 "বৈষ্ণৱ যুগ: শংকৰদেৱ (কীৰ্তন ঘোষা, অংকীয়া নাট), মাধৱদেৱ (নামঘোষা), ভট্টদেৱ (গদ্য)\n"
                 "আহোম যুগ: গদ্যত লিখা {{term:buranji|বুৰঞ্জী}}\n"
                 "মিছনেৰী আৰু অৰুণোদই (১৮৪৬); হেমচন্দ্ৰ বৰুৱাৰ ব্যাকৰণ আৰু অভিধান\n"
                 "{{term:jonaki-era|জোনাকী যুগ}} (১৮৮৯): লক্ষ্মীনাথ বেজবৰুৱা, চন্দ্ৰকুমাৰ আগৰৱালা, হেমচন্দ্ৰ গোস্বামী\n"
                 "আধুনিক: জ্যোতিপ্ৰসাদ আগৰৱালা, বিষ্ণুপ্ৰসাদ ৰাভা, বিৰিঞ্চি কুমাৰ বৰুৱা\n"
                 "{{term:jnanpith-award|জ্ঞানপীঠ বঁটা}} বিজয়ী: বীৰেন্দ্ৰ কুমাৰ ভট্টাচাৰ্য, মামণি ৰয়ছম গোস্বামী, নীলমণি ফুকন"),
                ("h9", "heading", "normal", "৯. মেলা, উৎসৱ, লোকসংগীত আৰু নৃত্য"),
                ("l9", "list", "suggested",
                 "বিহু (ব'হাগ, কাতি, মাঘ); অম্বুবাচী মেলা; মাজুলীৰ ৰাস লীলা; জোনবিল মেলা; ডিহিং পাটকাই উৎসৱ\n"
                 "জনগোষ্ঠীয় উৎসৱ: মে-ডাম-মে-ফি, আলি-আয়ে-লৃগাং, বৈশাগু, বাইখো, ৰংকেৰ, বুছু ডিমা, কৰম\n"
                 "লোকসংগীত: বিহুগীত, বৰগীত, জিকিৰ আৰু জাৰী, কামৰূপী আৰু গোৱালপৰীয়া লোকগীত, টোকাৰী গীত\n"
                 "নৃত্য: বিহু, বাগুৰুম্বা, ঝুমুৰ, দেওধনী, ওজাপালি, সত্ৰীয়া"),
                ("h10", "heading", "normal", "১০. সংস্কৃতি, পৰম্পৰা আৰু ঐতিহ্য"),
                ("l10", "list", "suggested",
                 "গাঁৱলীয়া জীৱনত {{term:sattra|সত্ৰ}} আৰু {{term:namghar|নামঘৰ}}\n"
                 "প্ৰতীক: গামোচা, শৰাই, জাপি\n"
                 "ভাওনা আৰু অংকীয়া নাট\n"
                 "অসমৰ ভৌগোলিক নিৰ্দেশনা (জিআই) চিহ্ন (মুগা পাট, অসম চাহ, জহা চাউল, ভূত জলকীয়া আদি)\n"
                 "অমূৰ্ত ঐতিহ্য: মৌখিক পৰম্পৰা, বুৰঞ্জী লিখন, সাধুকথা"),
                ("h11", "heading", "normal", "১১. ধৰ্মীয় আন্দোলন"),
                ("l11", "list", "suggested",
                 "শাক্ত ধৰ্ম আৰু তন্ত্ৰ (কামাখ্যা); শৈৱ ধৰ্ম; বৌদ্ধ ধৰ্ম (হাজো)\n"
                 "শংকৰদেৱ আৰু মাধৱদেৱৰ {{term:neo-vaishnavism|নৱ-বৈষ্ণৱ ধৰ্ম}}; চাৰি সংহতি (ব্ৰহ্ম, পুৰুষ, কাল, নিকা)\n"
                 "আহোম ৰজা আৰু হিন্দু ধৰ্ম; টাই আহোমৰ পৰম্পৰাগত বিশ্বাস আৰু পূৰ্বপুৰুষ পূজা (মে-ডাম-মে-ফি)\n"
                 "অসমত ইছলাম: আজান ফকিৰ আৰু জিকিৰ; পোৱা মক্কা\n"
                 "খ্ৰীষ্টান মিছন: শিৱসাগৰত আমেৰিকান বেপ্টিষ্ট, পাহাৰত মিছন"),
                ("h12", "heading", "normal", "১২. বিশিষ্ট ব্যক্তি"),
                ("l12", "list", "suggested",
                 "ৰজা আৰু সেনাপতি: ভাস্কৰবৰ্মন, চুকাফা, চুহুংমুং, নৰনাৰায়ণ আৰু চিলাৰায়, লাচিত বৰফুকন, ৰুদ্ৰ সিংহ, মূলা গাভৰু, জয়মতী\n"
                 "সন্ত আৰু সাহিত্যিক: শংকৰদেৱ, মাধৱদেৱ, আজান ফকিৰ, লক্ষ্মীনাথ বেজবৰুৱা, জ্যোতিপ্ৰসাদ আগৰৱালা, বিষ্ণুপ্ৰসাদ ৰাভা\n"
                 "স্বাধীনতা সংগ্ৰামী: মণিৰাম দেৱান, গোপীনাথ বৰদলৈ, তৰুণৰাম ফুকন, নবীনচন্দ্ৰ বৰদলৈ, কনকলতা বৰুৱা, কুশল কোঁৱৰ, চন্দ্ৰপ্ৰভা শইকীয়ানী\n"
                 "আধুনিক অসম: ভূপেন হাজৰিকা, আনন্দৰাম ঢেকিয়াল ফুকন, গুণাভিৰাম বৰুৱা, অম্বিকাগিৰি ৰায়চৌধুৰী"),
                ("h13", "heading", "normal", "ASSAMPEDIA ত পঢ়ক (সাধাৰণ জ্ঞান)"),
                ("l13", "list", "normal",
                 "অসমৰ ইতিহাস: আটাইকেইটা ৮টা অধ্যায়\n"
                 "কলা, সংস্কৃতি আৰু ঐতিহ্য: বিহু; সত্ৰীয়া নৃত্য আৰু সত্ৰ অনুষ্ঠান; লোকনৃত্য আৰু লোকসংগীত; পাট-মুগা আৰু তাঁতশাল; অসমীয়া সাহিত্যৰ চমু ইতিহাস\n"
                 "বিশিষ্ট ব্যক্তি: শ্ৰীমন্ত শংকৰদেৱ; লাচিত বৰফুকন; লক্ষ্মীনাথ বেজবৰুৱা; জ্যোতিপ্ৰসাদ আগৰৱালা; গোপীনাথ বৰদলৈ; ভূপেন হাজৰিকা; মণিৰাম দেৱান\n"
                 "গুৰুত্বপূৰ্ণ স্থান আৰু পৰ্যটন: কামাখ্যা মন্দিৰ; মাজুলী; শিৱসাগৰ আৰু ইয়াৰ কীৰ্তিচিহ্নসমূহ; হাজো; তেজপুৰ\n"
                 "অসমৰ পৰিচয়: বৰ্তমানৰ অসম ৰাজ্য কেনেকৈ গঠন হ'ল"),
                ("tip1", "paragraph", "suggested",
                 "এই কাকতত অসমৰ বিতং তথ্যৰ বাবে নম্বৰ পোৱা যায়। নাম, চন আৰু ঠাই ভালকৈ শিকক, "
                 "আৰু বাৰটা বিষয়ৰ প্ৰতিটোৰ ওপৰত চমু টোকা (১৫০ শব্দ) আৰু দীঘল উত্তৰ (২৫০ শব্দ) লিখি অভ্যাস কৰক।"),
            ],
        },
    ),
]
