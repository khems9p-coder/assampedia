"""Group 10: Assam Current Development (অসমৰ সাম্প্ৰতিক উন্নয়ন)."""

CATEGORY_SLUG = "development"
CATEGORY_NAME = "Assam Current Development"
LAST_CHECKED = "2026-11-24"

EXISTING_TERMS = {"tributary"}

W = "https://en.wikipedia.org/wiki/"

TERMS = [
    dict(slug="road-cum-rail-bridge", en="Road-cum-rail bridge", **{"as": "পথ-ৰেল দলং"},
         meaning_en="A bridge that carries both a road and a railway line, often on two levels (decks).",
         meaning_as="পথ আৰু ৰেলপথ দুয়োটা কঢ়িয়াই নিয়া দলং, প্ৰায়ে দুটা মহলাত।"),
    dict(slug="double-decker-bridge", en="Double-decker bridge", **{"as": "দুমহলীয়া দলং"},
         meaning_en="A bridge with two levels, one above the other.",
         meaning_as="এটাৰ ওপৰত আনটো থকা দুটা মহলাৰ দলং।"),
]

CHAPTERS = [
    dict(
        slug="major-bridges-of-assam", position=1,
        title={"en": "Major bridges of Assam", "as": "অসমৰ প্ৰধান দলংসমূহ"},
        summary={"en": "Saraighat, Bogibeel, Dhola-Sadiya and Kolia Bhomora: the bridges that join Assam's two banks.",
                 "as": "শৰাইঘাট, বগীবিল, ঢোলা-শদিয়া আৰু কলীয়াভোমোৰা: অসমৰ দুই পাৰ সংযোগ কৰা দলংসমূহ।"},
        sources="\n".join([f"Saraighat Bridge, Wikipedia: {W}Saraighat_Bridge", f"Bogibeel Bridge, Wikipedia: {W}Bogibeel_Bridge",
                           f"Dhola-Sadiya Bridge, Wikipedia: {W}Dhola%E2%80%93Sadiya_Bridge", f"Tezpur, Wikipedia: {W}Tezpur"]),
        blocks={
            "en": [
                ("p1", "paragraph", "normal",
                 "The Brahmaputra and its tributaries divide Assam into north and south banks, so bridges are vital for travel and trade."),
                ("h1", "heading", "normal", "Saraighat Bridge (1962)"),
                ("p2", "paragraph", "verified_fact",
                 "The Saraighat Bridge joins Guwahati and North Guwahati. Completed in 1962, it was the first {{term:road-cum-rail-bridge|road-cum-rail bridge}} "
                 "of its kind across the Brahmaputra in Assam. It is 1,298 metres long. A New Saraighat Bridge was opened beside it in January 2017."),
                ("h2", "heading", "normal", "Bogibeel Bridge (2018)"),
                ("p3", "paragraph", "verified_fact",
                 "The Bogibeel Bridge over the Brahmaputra joins Dibrugarh and Dhemaji. It is a {{term:double-decker-bridge|double-decker}} bridge, with two "
                 "railway lines below and a three-lane road above, and is 4.94 km long. Its foundation was laid in January 1997, and Prime Minister Narendra Modi "
                 "inaugurated it on 25 December 2018. It is the longest road-cum-rail bridge in India."),
                ("h3", "heading", "normal", "Dhola-Sadiya Bridge, Bhupen Hazarika Setu (2017)"),
                ("p4", "paragraph", "verified_fact",
                 "The Dhola-Sadiya Bridge crosses the Lohit, a {{term:tributary}} of the Brahmaputra, in Tinsukia district. It is 9.15 km long and was opened on "
                 "26 May 2017. It is named after Bhupen Hazarika and gives easier access to Arunachal Pradesh."),
                ("h4", "heading", "normal", "Kolia Bhomora Setu"),
                ("p5", "paragraph", "normal",
                 "The 3.015 km Kolia Bhomora Setu over the Brahmaputra links Tezpur with Silghat in Nagaon district. It is named after the Ahom general Kalia Bhomora Borphukan."),
                ("exam1", "fact_box", "exam_fact",
                 "Remember for exams: Saraighat 1962; Dhola-Sadiya (Bhupen Hazarika Setu) 2017, 9.15 km; Bogibeel 2018, longest road-cum-rail bridge in India."),
            ],
            "as": [
                ("p1", "paragraph", "normal",
                 "ব্ৰহ্মপুত্ৰ আৰু ইয়াৰ উপনৈসমূহে অসমক উত্তৰ আৰু দক্ষিণ পাৰত ভগাই ৰাখিছে, সেয়েহে যাতায়াত আৰু বাণিজ্যৰ বাবে দলং অতি গুৰুত্বপূৰ্ণ।"),
                ("h1", "heading", "normal", "শৰাইঘাট দলং (১৯৬২)"),
                ("p2", "paragraph", "verified_fact",
                 "শৰাইঘাট দলঙে গুৱাহাটী আৰু উত্তৰ গুৱাহাটী সংযোগ কৰে। ১৯৬২ চনত সম্পূৰ্ণ হোৱা এই দলং অসমত ব্ৰহ্মপুত্ৰৰ ওপৰত এনেধৰণৰ প্ৰথম "
                 "{{term:road-cum-rail-bridge|পথ-ৰেল দলং}}। ইয়াৰ দৈৰ্ঘ্য ১,২৯৮ মিটাৰ। ২০১৭ চনৰ জানুৱাৰীত ইয়াৰ কাষতে নতুন শৰাইঘাট দলং মুকলি কৰা হয়।"),
                ("h2", "heading", "normal", "বগীবিল দলং (২০১৮)"),
                ("p3", "paragraph", "verified_fact",
                 "ব্ৰহ্মপুত্ৰৰ ওপৰৰ বগীবিল দলঙে ডিব্ৰুগড় আৰু ধেমাজি সংযোগ কৰে। ই এখন {{term:double-decker-bridge|দুমহলীয়া}} দলং, তলত দুটা "
                 "ৰেললাইন আৰু ওপৰত তিনি লেনৰ পথ, আৰু ইয়াৰ দৈৰ্ঘ্য ৪.৯৪ কিমি। ১৯৯৭ চনৰ জানুৱাৰীত ইয়াৰ আধাৰশিলা স্থাপন কৰা হয়, আৰু ২০১৮ চনৰ "
                 "২৫ ডিচেম্বৰত প্ৰধানমন্ত্ৰী নৰেন্দ্ৰ মোদীয়ে ইয়াৰ উদ্বোধন কৰে। ই ভাৰতৰ দীৰ্ঘতম পথ-ৰেল দলং।"),
                ("h3", "heading", "normal", "ঢোলা-শদিয়া দলং, ভূপেন হাজৰিকা সেতু (২০১৭)"),
                ("p4", "paragraph", "verified_fact",
                 "ঢোলা-শদিয়া দলঙে তিনিচুকীয়া জিলাত ব্ৰহ্মপুত্ৰৰ {{term:tributary|উপনৈ}} লুইত পাৰ হৈছে। ইয়াৰ দৈৰ্ঘ্য ৯.১৫ কিমি আৰু ই "
                 "২০১৭ চনৰ ২৬ মে'ত মুকলি হয়। ইয়াক ভূপেন হাজৰিকাৰ নামেৰে নামকৰণ কৰা হৈছে আৰু ই অৰুণাচল প্ৰদেশলৈ যাতায়াত সহজ কৰিছে।"),
                ("h4", "heading", "normal", "কলীয়াভোমোৰা সেতু"),
                ("p5", "paragraph", "normal",
                 "ব্ৰহ্মপুত্ৰৰ ওপৰৰ ৩.০১৫ কিমি দীঘল কলীয়াভোমোৰা সেতুৱে তেজপুৰক নগাঁও জিলাৰ শিলঘাটৰ সৈতে সংযোগ কৰে। ইয়াক আহোম সেনাপতি কলীয়াভোমোৰা বৰফুকনৰ নামেৰে নামকৰণ কৰা হৈছে।"),
                ("exam1", "fact_box", "exam_fact",
                 "পৰীক্ষাৰ বাবে মনত ৰাখক: শৰাইঘাট ১৯৬২; ঢোলা-শদিয়া (ভূপেন হাজৰিকা সেতু) ২০১৭, ৯.১৫ কিমি; বগীবিল ২০১৮, ভাৰতৰ দীৰ্ঘতম পথ-ৰেল দলং।"),
            ],
        },
    ),
]
