import 'app_lang.dart';

/// Every piece of app text in both languages.
/// Content (chapters) comes from the database; this file is only for
/// buttons, menus and messages.
class S {
  S(this.lang);
  final AppLang lang;

  String _t(String as, String en) => lang == AppLang.assamese ? as : en;

  String get tagline => _t('অসম অন্বেষণ কৰক। শিকক। প্ৰস্তুত হওক। সফল হওক।', 'Explore Assam. Learn. Prepare. Succeed.');
  String get chooseLanguage => 'আপোনাৰ ভাষা বাছনি কৰক\nChoose your language';
  String get changeLaterHint => _t('আপুনি যিকোনো সময়ত ভাষা সলনি কৰিব পাৰে।', 'You can switch language at any time.');
  String get continueLabel => _t('আগবাঢ়ক', 'Continue');

  String get navHome => _t('মূল পৃষ্ঠা', 'Home');
  String get navLearn => _t('শিকক', 'Learn');
  String get navExams => _t('পৰীক্ষা', 'Exams');
  String get navJobs => _t('চাকৰি', 'Jobs');
  String get navMe => _t('মোৰ', 'Me');

  String get encyclopedia => _t('অসমৰ সাধাৰণ জ্ঞান', 'Assam GK Encyclopedia');
  String get encyclopediaHint => _t('ইতিহাস, ভূগোল, সংস্কৃতি আৰু অধিক', 'History, geography, culture and more');
  String get continueLearning => _t('য’ত এৰিছিল তাৰ পৰা পঢ়ক', 'Continue learning');
  String get categories => _t('শ্ৰেণীসমূহ', 'Categories');
  String get seeAll => _t('সকলো চাওক', 'See all');

  String get noChapters => _t('এতিয়ালৈকে কোনো অধ্যায় প্ৰকাশ হোৱা নাই।', 'No chapters published yet.');
  String get offlineNotice => _t('আপুনি অফলাইন। সংৰক্ষিত কপি দেখুওৱা হৈছে।', "You're offline. Showing your saved copy.");
  String get loadFailed => _t('ল’ড কৰিব পৰা নগ’ল। ইণ্টাৰনেট পৰীক্ষা কৰক।', "Couldn't load. Please check your internet connection.");
  String get retry => _t('পুনৰ চেষ্টা কৰক', 'Try again');
  String get notConnected => _t('বিষয়বস্তুৰ চাৰ্ভাৰ এতিয়াও সংযোগ কৰা হোৱা নাই।', 'The content server is not connected yet.');

  String notAvailableIn(AppLang l) => l == AppLang.english
      ? _t('এই অধ্যায়টো এতিয়াও ইংৰাজীত উপলব্ধ নহয়।', 'This chapter is not yet available in English.')
      : _t('এই অধ্যায়টো এতিয়াও অসমীয়াত উপলব্ধ নহয়।', 'This chapter is not yet available in Assamese.');
  String readIn(AppLang l) => _t('${l.label}ত পঢ়ক', 'Read in ${l.label}');
  String get sources => _t('উৎস', 'Sources');
  String lastChecked(String date) => _t('শেষবাৰ পৰীক্ষা কৰা: $date', 'Last checked: $date');

  String comingInPhase(int n) => _t('এই অংশটো পৰ্যায় $nত যোগ কৰা হ’ব।', 'This section is added in Phase $n.');
  String get examsTitle => _t('পৰীক্ষা আৰু কেৰিয়াৰ', 'Exams & Careers');
  String get jobsTitle => _t('চাকৰি আৰু সাম্প্ৰতিক ঘটনা', 'Jobs & Current Affairs');

  String get settings => _t('ছেটিংছ', 'Settings');
  String get language => _t('ভাষা', 'Language');
  String get appearance => _t('ৰূপ', 'Appearance');
  String get followPhone => _t('ফোনৰ দৰে', 'Follow phone');
  String get light => _t('পোহৰ', 'Light');
  String get dark => _t('আন্ধাৰ', 'Dark');
  String get account => _t('একাউণ্ট', 'Account');
  String get signIn => _t('ছাইন ইন কৰক', 'Sign in');
  String get signOut => _t('ছাইন আউট', 'Sign out');
  String get createAccount => _t('নতুন একাউণ্ট খোলক', 'Create account');
  String get email => _t('ইমেইল', 'Email');
  String get password => _t('পাছৱৰ্ড', 'Password');
  String get signInHint => _t('ছাইন ইন কৰিলে আপোনাৰ প্ৰগতি সুৰক্ষিত থাকিব।', 'Sign in to keep your progress safe on any phone.');
  String get checkEmail => _t('নিশ্চিত কৰিবলৈ আপোনাৰ ইমেইল চাওক।', 'Check your email to confirm your account.');
  String signedInAs(String who) => _t('$who হিচাপে ছাইন ইন কৰা হৈছে', 'Signed in as $who');
  String get adminPanel => _t('এডমিন পেনেল', 'Admin panel');

  // Phase 3: search, dictionary, saved chapters, side-by-side
  String get search => _t('বিচাৰক', 'Search');
  String get searchHint => _t('অধ্যায়, শব্দ বা তথ্য বিচাৰক', 'Search chapters, terms and facts');
  String get typeMore => _t('কমেও ২টা আখৰ লিখক।', 'Type at least 2 letters.');
  String get noResults => _t('একো পোৱা নগ’ল।', 'Nothing found.');
  String get searchOffline =>
      _t('অফলাইন: এই ফোনত সংৰক্ষিত অধ্যায়তহে বিচৰা হৈছে।', 'Offline: only chapters saved on this phone were searched.');
  String get chaptersHeading => _t('অধ্যায়', 'Chapters');
  String get dictionary => _t('শব্দকোষ', 'Dictionary');
  String get dictionaryHint => _t('গুৰুত্বপূৰ্ণ শব্দৰ অৰ্থ', 'Meanings of key terms');
  String get noTerms => _t('শব্দকোষত এতিয়ালৈকে কোনো শব্দ নাই।', 'No terms in the dictionary yet.');
  String get termMissing => _t('এই শব্দটো এতিয়াও শব্দকোষত নাই।', 'This term is not in the dictionary yet.');
  String get openDictionary => _t('শব্দকোষ খোলক', 'Open dictionary');
  String get saved => _t('সংৰক্ষিত', 'Saved');
  String get savedHint => _t('আপুনি সাঁচি থোৱা অধ্যায়', 'Chapters you saved');
  String get noSaved =>
      _t('এতিয়ালৈকে একো সংৰক্ষণ কৰা হোৱা নাই। পঢ়োঁতে বুকমাৰ্ক চিহ্নত টিপক।', 'Nothing saved yet. Tap the bookmark icon while reading.');
  String get saveChapter => _t('অধ্যায়টো সংৰক্ষণ কৰক', 'Save this chapter');
  String get savedDone => _t('সংৰক্ষণ কৰা হ’ল। আপুনি পঢ়ি থকা ঠাইখিনিও মনত ৰখা হ’ল।', 'Saved, along with the place you were reading.');
  String get removedSaved => _t('সংৰক্ষিত তালিকাৰ পৰা আঁতৰোৱা হ’ল।', 'Removed from Saved.');
  String get remove => _t('আঁতৰাওক', 'Remove');
  String get sideBySide => _t('দুয়োটা ভাষা একেলগে', 'Both languages side by side');

  // Phase 4: exams and careers
  String get examsTab => _t('পৰীক্ষা', 'Exams');
  String get careersTab => _t('কেৰিয়াৰ', 'Careers');
  String get examsIntro => _t('চৰকাৰী পৰীক্ষাৰ পাঠ্যক্ৰম, যোগ্যতা আৰু পৰীক্ষাৰ ধৰণ।',
      'Government exam syllabuses, eligibility and exam patterns.');
  String get careersIntro =>
      _t('চৰকাৰী পদবীৰ কাম, দায়িত্ব আৰু কেৰিয়াৰৰ সুযোগ।', 'What government posts involve, and where they can lead.');
  String get officialWebsite => _t('চৰকাৰী ৱেবছাইট', 'Official website');
  String get officialNotification => _t('চৰকাৰী জাননী', 'Official notification');
  String appliesTo(String v) => _t('প্ৰযোজ্য: $v', 'Applies to: $v');
  String get checkOfficial => _t('আবেদন কৰাৰ আগতে সদায় চৰকাৰী জাননী পৰীক্ষা কৰক।',
      'Always check the official notification before you apply.');
  String get suggestedLabel => _t('পৰামৰ্শ: চৰকাৰী তথ্য নহয়', 'Suggestion: not official information');
  String get cantOpenLink => _t('লিংকটো খুলিব পৰা নগ’ল।', "Couldn't open the link.");

  // Phase 5: vacancies and current affairs
  String get vacanciesTab => _t('খালী পদ', 'Vacancies');
  String get newsTab => _t('সাম্প্ৰতিক ঘটনা', 'Current Affairs');
  String get openNow => _t('আবেদন কৰিব পাৰি', 'Open');
  String get closedAndResults => _t('বন্ধ আৰু ফলাফল', 'Closed & results');
  String get allCategories => _t('সকলো শ্ৰেণী', 'All categories');
  String get allStates => _t('সকলো ৰাজ্য', 'All states');
  String get searchJobs => _t('পদ, প্ৰতিষ্ঠান বা অৰ্হতা বিচাৰক', 'Search post, organisation or qualification');
  String get noVacancies => _t('এই মুহূৰ্তত দেখুৱাবলৈ কোনো খালী পদ নাই।', 'No vacancies to show right now.');
  String lastDate(String d) => _t('শেষ তাৰিখ: $d', 'Last date: $d');
  String daysLeft(int n) => n == 0 ? _t('আজি শেষ দিন', 'Last day today') : _t('আৰু $n দিন', '$n days left');
  String posts(int n) => _t('$nটা পদ', '$n posts');
  String lastVerified(String d) => _t('চৰকাৰী উৎসৰ সৈতে শেষবাৰ মিলোৱা: $d', 'Last verified with the official source: $d');
  String get fOrganisation => _t('নিযুক্তি কৰ্তৃপক্ষ', 'Recruitment organisation');
  String get fDepartment => _t('বিভাগ', 'Department');
  String get fPost => _t('পদৰ নাম', 'Post name');
  String get fCount => _t('খালী পদৰ সংখ্যা', 'Number of vacancies');
  String get fQualification => _t('শৈক্ষিক অৰ্হতা', 'Educational qualification');
  String get fAge => _t('বয়সৰ সীমা', 'Age limit');
  String get fPay => _t('দৰমহা আৰু বেতনক্ৰম', 'Salary and pay scale');
  String get fStart => _t('আবেদন আৰম্ভ', 'Application starts');
  String get fClose => _t('আবেদনৰ শেষ তাৰিখ', 'Application closes');
  String get fFee => _t('আবেদন মাচুল', 'Application fee');
  String get fSelection => _t('বাছনি প্ৰক্ৰিয়া', 'Selection procedure');
  String get fLocation => _t('কৰ্মস্থান', 'Job location');
  String get fNotes => _t('অন্যান্য তথ্য', 'Other details');
  String get fStatus => _t('নিযুক্তিৰ স্থিতি', 'Recruitment status');
  String get examSyllabus => _t('পৰীক্ষাৰ পাঠ্যক্ৰম', 'Examination syllabus');
  String get applyOnline => _t('চৰকাৰী আবেদন লিংক', 'Official application link');
  String get notificationPdf => _t('চৰকাৰী জাননী (PDF)', 'Official notification (PDF)');
  String get closedNote => _t('এই নিযুক্তিৰ আবেদন বন্ধ হৈ গৈছে।', 'Applications for this recruitment are closed.');
  String get jobSaved => _t('চাকৰিটো সংৰক্ষণ কৰা হ’ল।', 'Job saved.');
  String get saveJob => _t('চাকৰিটো সংৰক্ষণ কৰক', 'Save this job');
  String get noSavedJobs => _t('এতিয়ালৈকে কোনো চাকৰি সংৰক্ষণ কৰা হোৱা নাই।', 'No saved jobs yet.');
  String get periodToday => _t('আজি', 'Today');
  String get periodWeek => _t('এই সপ্তাহ', 'This week');
  String get periodMonth => _t('এই মাহ', 'This month');
  String get periodAll => _t('সকলো', 'All');
  String get allGroups => _t('সকলো', 'All');
  String get noNews => _t('এই সময়ছোৱাৰ কোনো সাম্প্ৰতিক ঘটনা এতিয়াও নাই।', 'No current affairs for this period yet.');

  // Phase 6: practice zone
  String get practiceZone => _t('অনুশীলন কক্ষ', 'Practice Zone');
  String get practiceHint => _t('কুইজ, আদৰ্শ পৰীক্ষা আৰু পুনৰীক্ষণ', 'Quizzes, mock tests and revision');
  String get dailyQuestion => _t('আজিৰ অসমৰ সাধাৰণ জ্ঞানৰ প্ৰশ্ন', 'Daily Assam GK question');
  String get allLevels => _t('সকলো স্তৰ', 'All levels');
  String get noQuizzes => _t('এতিয়ালৈকে কোনো কুইজ প্ৰকাশ হোৱা নাই।', 'No quizzes published yet.');
  String get noQuestions => _t('এই কুইজত এতিয়াও কোনো প্ৰশ্ন নাই।', 'This quiz has no questions yet.');
  String questionsCount(int n) => _t('$nটা প্ৰশ্ন', '$n questions');
  String minutes(int n) => _t('$n মিনিট', '$n min');
  String bestScore(int a, int b) => _t('শ্ৰেষ্ঠ: $a/$b', 'Best: $a/$b');
  String questionOf(int a, int b) => _t('প্ৰশ্ন $a / $b', 'Question $a of $b');
  String get correct => _t('শুদ্ধ!', 'Correct!');
  String get wrong => _t('অশুদ্ধ', 'Not correct');
  String rightAnswer(String a) => _t('শুদ্ধ উত্তৰ: $a', 'Correct answer: $a');
  String get explanation => _t('ব্যাখ্যা', 'Explanation');
  String get background => _t('পটভূমি', 'Background');
  String get examRelevance => _t('পৰীক্ষাৰ বাবে প্ৰাসংগিকতা', 'Examination relevance');
  String source(String s) => _t('উৎস: $s', 'Source: $s');
  String get next => _t('পৰৱৰ্তী', 'Next');
  String get previous => _t('আগৰ', 'Previous');
  String get finish => _t('শেষ কৰক', 'Finish');
  String get submitTest => _t('পৰীক্ষা জমা দিয়ক', 'Submit test');
  String timeLeft(String t) => _t('বাকী সময়: $t', 'Time left: $t');
  String get timeUp => _t('সময় শেষ। আপোনাৰ উত্তৰ জমা দিয়া হ’ল।', 'Time is up. Your answers were submitted.');
  String get yourResult => _t('আপোনাৰ ফলাফল', 'Your result');
  String scoreLine(int a, int b) => _t('$b টাৰ ভিতৰত $aটা শুদ্ধ', '$a of $b correct');
  String accuracy(int p) => _t('শুদ্ধতা: $p%', 'Accuracy: $p%');
  String get yourAnswer => _t('আপোনাৰ উত্তৰ', 'Your answer');
  String get notAnswered => _t('উত্তৰ দিয়া হোৱা নাই', 'Not answered');
  String get tryAgain => _t('পুনৰ দিয়ক', 'Try again');
  String get practiseWrong => _t('ভুলবোৰ পুনৰ অনুশীলন কৰক', 'Practise the wrong ones');
  String get done => _t('হ’ল', 'Done');
  String get myProgress => _t('মোৰ অগ্ৰগতি', 'My progress');
  String progressLine(int quizzes, int answered, int pct) =>
      _t('$quizzesটা কুইজ · $answeredটা প্ৰশ্ন · $pct% শুদ্ধ', '$quizzes quizzes · $answered questions · $pct% correct');
  String get noProgress => _t('এটা কুইজ দিয়ক, আপোনাৰ নম্বৰ ইয়াত দেখা যাব।', 'Take a quiz and your scores will appear here.');
  String get leaveQuiz => _t('কুইজৰ পৰা ওলাই যাবনে?', 'Leave this quiz?');
  String get leaveQuizHint => _t('আপোনাৰ উত্তৰবোৰ সংৰক্ষণ নহ’ব।', 'Your answers will not be saved.');
  String get stay => _t('থাকক', 'Stay');
  String get leave => _t('ওলাই যাওক', 'Leave');
  String get timedTest => _t('সময়সীমা থকা পৰীক্ষা', 'Timed test');
  String get mockHint => _t('শেষত উত্তৰ আৰু ব্যাখ্যা দেখুওৱা হ’ব।', 'Answers and explanations are shown at the end.');
}
