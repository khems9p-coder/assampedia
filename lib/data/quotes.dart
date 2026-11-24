import '../core/i18n/app_lang.dart';

/// A motivational quote shown in the morning notification and on the
/// Notifications screen.
///
/// Only quotes whose wording and author are well documented are listed here.
/// The Assamese text is a translation of the English original.
class Quote {
  const Quote({required this.textEn, required this.textAs, required this.authorEn, required this.authorAs});

  final String textEn;
  final String textAs;
  final String authorEn;
  final String authorAs;

  String text(AppLang l) => l == AppLang.assamese ? textAs : textEn;
  String author(AppLang l) => l == AppLang.assamese ? authorAs : authorEn;
}

const quotes = <Quote>[
  Quote(
    textEn: 'Education is the most powerful weapon which you can use to change the world.',
    textAs: 'শিক্ষাই হৈছে আটাইতকৈ শক্তিশালী অস্ত্ৰ, যাৰ দ্বাৰা আপুনি পৃথিৱীখন সলনি কৰিব পাৰে।',
    authorEn: 'Nelson Mandela',
    authorAs: 'নেলছন মেণ্ডেলা',
  ),
  Quote(
    textEn: 'Arise, awake, and stop not till the goal is reached.',
    textAs: 'উঠা, জাগা, আৰু লক্ষ্যত উপনীত নোহোৱালৈকে নাথামিবা।',
    authorEn: 'Swami Vivekananda',
    authorAs: 'স্বামী বিবেকানন্দ',
  ),
  Quote(
    textEn: 'Dream, dream, dream. Dreams transform into thoughts and thoughts result in action.',
    textAs: 'সপোন দেখা, সপোন দেখা, সপোন দেখা। সপোন চিন্তালৈ ৰূপান্তৰিত হয় আৰু চিন্তাৰ পৰা কৰ্মৰ জন্ম হয়।',
    authorEn: 'A. P. J. Abdul Kalam',
    authorAs: 'এ. পি. জে. আব্দুল কালাম',
  ),
  Quote(
    textEn: 'Where the mind is without fear and the head is held high; where knowledge is free.',
    textAs: 'য’ত মন নিৰ্ভয় আৰু শিৰ উন্নত; য’ত জ্ঞান মুক্ত।',
    authorEn: 'Rabindranath Tagore (Gitanjali)',
    authorAs: 'ৰবীন্দ্ৰনাথ ঠাকুৰ (গীতাঞ্জলি)',
  ),
  Quote(
    textEn: 'Education is the manifestation of the perfection already in man.',
    textAs: 'মানুহৰ মাজত আগৰে পৰা থকা পূৰ্ণতাৰ প্ৰকাশেই হৈছে শিক্ষা।',
    authorEn: 'Swami Vivekananda',
    authorAs: 'স্বামী বিবেকানন্দ',
  ),
  Quote(
    textEn: 'Strength does not come from physical capacity. It comes from an indomitable will.',
    textAs: 'শক্তি শাৰীৰিক সামৰ্থ্যৰ পৰা নাহে। ই অদম্য ইচ্ছাশক্তিৰ পৰা আহে।',
    authorEn: 'Mahatma Gandhi',
    authorAs: 'মহাত্মা গান্ধী',
  ),
  Quote(
    textEn: 'Learning without thought is labour lost; thought without learning is perilous.',
    textAs: 'চিন্তা নকৰাকৈ শিকা পৰিশ্ৰম বৃথা; নিশিকাকৈ চিন্তা কৰা বিপজ্জনক।',
    authorEn: 'Confucius',
    authorAs: 'কনফুচিয়াছ',
  ),
  Quote(
    textEn: 'The roots of education are bitter, but the fruit is sweet.',
    textAs: 'শিক্ষাৰ শিপা তিতা, কিন্তু ইয়াৰ ফল মিঠা।',
    authorEn: 'Aristotle',
    authorAs: 'এৰিষ্টটল',
  ),
  Quote(
    textEn: 'One child, one teacher, one book, one pen can change the world.',
    textAs: 'এজন শিশু, এজন শিক্ষক, এখন কিতাপ আৰু এটা কলমে পৃথিৱী সলনি কৰিব পাৰে।',
    authorEn: 'Malala Yousafzai',
    authorAs: 'মালালা ইউছুফজাই',
  ),
  Quote(
    textEn: "If you can't fly then run, if you can't run then walk, if you can't walk then crawl, but whatever you do you have to keep moving forward.",
    textAs: 'উৰিব নোৱাৰিলে দৌৰা, দৌৰিব নোৱাৰিলে খোজ কাঢ়া, খোজ কাঢ়িব নোৱাৰিলে বগাই যোৱা, কিন্তু যিয়েই নকৰা, আগবাঢ়ি থাকিবই লাগিব।',
    authorEn: 'Martin Luther King Jr.',
    authorAs: 'মাৰ্টিন লুথাৰ কিং জুনিয়ৰ',
  ),
  Quote(
    textEn: 'Genius is one per cent inspiration and ninety-nine per cent perspiration.',
    textAs: 'প্ৰতিভা এক শতাংশ অনুপ্ৰেৰণা আৰু নিৰানব্বৈ শতাংশ ঘাম (পৰিশ্ৰম)।',
    authorEn: 'Thomas Edison',
    authorAs: 'টমাছ এডিচন',
  ),
  Quote(
    textEn: 'Educate, agitate, organise.',
    textAs: 'শিক্ষিত হোৱা, সংগ্ৰাম কৰা, সংগঠিত হোৱা।',
    authorEn: 'B. R. Ambedkar',
    authorAs: 'বি. আৰ. আম্বেদকাৰ',
  ),
];

/// The quote for [day]: a different one each day, the same all day long.
Quote quoteForDay(DateTime day) {
  final dayNumber = DateTime.utc(day.year, day.month, day.day).millisecondsSinceEpoch ~/ Duration.millisecondsPerDay;
  return quotes[dayNumber % quotes.length];
}
