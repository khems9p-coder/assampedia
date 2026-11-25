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
  String get navCourses => _t('অধ্যয়ন', 'Study');
  String get studyTitle => _t('অধ্যয়ন', 'Study');
  String get tabFree => _t('বিনামূলীয়া', 'Free');
  String get tabPremium => _t('প্ৰিমিয়াম', 'Premium');
  String get freeIntro => _t(
    'সকলোৰে বাবে বিনামূলীয়া: পিডিএফ, টোকা আৰু ভিডিঅ’। ডাউনল’ড কৰক আৰু বন্ধুক শ্বেয়াৰ কৰক।',
    'Free for everyone: PDFs, notes and videos. Read them and share the app with friends.',
  );
  String get premiumIntro => _t(
    'সম্পূৰ্ণ পাঠ্যক্ৰম, টোকা আৰু ভিডিঅ’ শ্ৰেণী। প্ৰতিটোৰে প্ৰথম ৩টা বিনামূলীয়াকৈ চাওক।',
    'Full courses, notes and video classes. Try the first 3 items of each for free.',
  );
  String get unlockAll => _t('প্ৰিমিয়ামৰ সৈতে সকলো খোলক', 'Unlock everything with Premium');
  String get unlockAllHint => _t('সকলো পাঠ্যক্ৰম, পিডিএফ টোকা, ভিডিঅ’ আৰু আদৰ্শ পৰীক্ষা।', 'All courses, PDF notes, videos and mock tests.');
  String get coursesHeading => _t('পাঠ্যক্ৰম', 'Courses');
  String get materialHeading => _t('অধ্যয়ন সামগ্ৰী', 'Study material');
  String get nothingHereYet => _t('ইয়াত এতিয়াও একো নাই।', 'Nothing here yet.');
  String get itemPdf => _t('পিডিএফ', 'PDF');
  String get itemImage => _t('ছবি', 'Picture');
  String get itemVideo => _t('ভিডিঅ’', 'Video');
  String get itemPage => _t('টোকা', 'Notes');
  String get itemQuiz => _t('কুইজ', 'Quiz');
  String itemsCount(int n) => _t('$nটা বস্তু', n == 1 ? '1 item' : '$n items');
  String sectionsCount(int n) => _t('$nটা উপ-শাখা', n == 1 ? '1 sub-section' : '$n sub-sections');
  String moreWithPremium(int n) => _t('প্ৰিমিয়ামৰ সৈতে আৰু $nটা খোলক', n == 1 ? 'Unlock 1 more with Premium' : 'Unlock $n more with Premium');
  String get previewHint => _t('প্ৰথম ৩টা বিনামূলীয়া। বাকীবোৰ প্ৰিমিয়ামত।', 'The first 3 are free to try. The rest are in Premium.');
  String get fileNeedsInternet => _t('এই ফাইলটো খুলিবলৈ ইণ্টাৰনেট লাগিব।', 'You need the internet to open this file.');
  String get couldNotOpenVideo => _t('ভিডিঅ’টো খুলিব পৰা নগ’ল।', "Couldn't open the video.");
  String get sharePdf => _t('শ্বেয়াৰ কৰক', 'Share');
  String sharePdfText(String title, String url) => _t(
    '"$title" আৰু বহুতো বিনামূলীয়া অধ্যয়ন সামগ্ৰী ASSAMPEDIA এপত পঢ়ক: $url',
    'Read "$title" and more free study material in the ASSAMPEDIA app: $url',
  );
  String get endOfFreeItem => _t('ভাল লাগিলনে? প্ৰিমিয়ামত আৰু বহুত আছে।', 'Liked it? There is much more in Premium.');
  String get compareFeature => _t('কি পাব', 'What you get');
  String get compareFreePdf => _t('বিনামূলীয়া পিডিএফ আৰু দৈনিক প্ৰশ্ন', 'Free PDFs and daily question');
  String get compareFirst3 => _t('প্ৰতিটো গোট আৰু পাঠ্যক্ৰমৰ প্ৰথম ৩টা', 'First 3 of every group and course');
  String get compareAllNotes => _t('সকলো টোকা, পিডিএফ আৰু ভিডিঅ’', 'All notes, PDFs and videos');
  String get compareAllTests => _t('সকলো কুইজ আৰু আদৰ্শ পৰীক্ষা', 'All quizzes and mock tests');

  String get coursesTitle => _t('পাঠ্যক্ৰম', 'Courses');
  String get coursesIntro => _t(
    'প্ৰতিটো পাঠ্যক্ৰম এটা পৰীক্ষাৰ বাবে ক্ৰমান্বয়ে পঢ়াৰ পথ। পাঠবোৰ ক্ৰমে পঢ়ক আৰু কুইজ দিয়ক। প্ৰথম ৩টা পাঠ বিনামূলীয়া।',
    'Each course is a step-by-step study path for one exam. Read the lessons in order and take the quizzes. The first 3 lessons are free.',
  );
  String get noCourses => _t('এতিয়ালৈকে কোনো পাঠ্যক্ৰম প্ৰকাশ হোৱা নাই।', 'No courses published yet.');
  String get noLessons => _t('এই পাঠ্যক্ৰমত এতিয়ালৈকে কোনো পাঠ নাই।', 'This course has no lessons yet.');
  String lessonsCount(int n) => _t('$nটা পাঠ', n == 1 ? '1 lesson' : '$n lessons');
  String lessonsDone(int done, int total) => _t('$total টাৰ $doneটা সম্পূৰ্ণ', '$done of $total done');
  String lessonNo(int n) => _t('পাঠ $n', 'Lesson $n');
  String get lessonChapter => _t('সাধাৰণ জ্ঞানৰ অধ্যায়', 'GK chapter');
  String get lessonExam => _t('পৰীক্ষাৰ পাঠ্যক্ৰম', 'Exam syllabus');
  String get lessonCareer => _t('কেৰিয়াৰ', 'Career');
  String get lessonNews => _t('সাম্প্ৰতিক ঘটনা', 'Current affairs');
  String get lessonQuiz => _t('কুইজ', 'Quiz');
  String get lessonFree => _t('বিনামূলীয়া', 'Free');
  String get markDone => _t('সম্পূৰ্ণ হিচাপে চিহ্নিত কৰক', 'Mark as done');
  String get continueCourse => _t('আগবাঢ়ক', 'Continue');
  String get startCourse => _t('আৰম্ভ কৰক', 'Start');
  String get courseFinished => _t('অভিনন্দন! আপুনি এই পাঠ্যক্ৰম সম্পূৰ্ণ কৰিলে।', 'Well done! You have finished this course.');
  String get quizNotFound => _t('এই কুইজটো এতিয়া উপলব্ধ নহয়।', 'This quiz is not available right now.');

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
  String get welcome => _t('স্বাগতম', 'Welcome');
  String get inspiration =>
      _t('জ্ঞানেই শক্তি। আজিৰ অধ্যয়নেই কাইলৈৰ সফলতা।', "Knowledge is power. What you learn today is tomorrow's success.");
  String get signInToStart =>
      _t('শিকিবলৈ আৰম্ভ কৰিবলৈ ছাইন ইন কৰক বা নতুন একাউণ্ট খোলক।', 'Sign in or create an account to start learning.');
  String get enterEmailPassword => _t('ইমেইল আৰু পাছৱৰ্ড দুয়োটা লিখক।', 'Please enter your email and a password.');
  String get badEmail => _t('শুদ্ধ ইমেইল ঠিকনা লিখক।', 'Please enter a valid email address.');
  String get shortPassword => _t('পাছৱৰ্ড অন্ততঃ ৬টা আখৰৰ হ’ব লাগিব।', 'The password must be at least 6 characters.');
  String get wrongLogin => _t('ইমেইল বা পাছৱৰ্ড ভুল।', 'Wrong email or password.');
  String get accountExists =>
      _t('এই ইমেইলেৰে একাউণ্ট আগতেই আছে। ছাইন ইন কৰক।', 'An account with this email already exists. Please sign in.');
  String get emailNotConfirmed => _t(
    'আগতে আপোনাৰ ইমেইলত পঠোৱা লিংকটোত টিপি একাউণ্ট নিশ্চিত কৰক।',
    'Please confirm your account first using the link sent to your email.',
  );
  String get tooManyTries =>
      _t('বহুবাৰ চেষ্টা কৰা হ’ল। কিছু সময় পিছত পুনৰ চেষ্টা কৰক।', 'Too many tries. Please wait a little and try again.');
  // Sign-up with an email code, and forgotten passwords.
  String get strongPasswordRule => _t(
    'অন্ততঃ ৮টা আখৰ: আখৰ, সংখ্যা আৰু এটা বিশেষ চিন (যেনে @ # !) লাগিব।',
    'At least 8 characters, with letters, numbers and a special character (like @ # !).',
  );
  String get confirmPassword => _t('পাছৱৰ্ড পুনৰ লিখক', 'Re-enter password');
  String get passwordsDiffer => _t('দুয়োটা পাছৱৰ্ড একে হোৱা নাই।', 'The two passwords are not the same.');
  String get forgotPassword => _t('পাছৱৰ্ড পাহৰিলে?', 'Forgot password?');
  String get noAccountYet => _t('নতুন ছাত্ৰ-ছাত্ৰী?', 'New here?');
  String get enterCode => _t('ক’ড লিখক', 'Enter the code');
  String codeSentTo(String email) => _t(
    '$email লৈ এটা ক’ড পঠোৱা হৈছে। ইমেইল (আৰু স্পাম ফ’ল্ডাৰ) চাওক।',
    'We sent a code to $email. Check your email (and the spam folder).',
  );
  String get code => _t('ক’ড', 'Code');
  String get badCode => _t('ক’ডটো ভুল বা ইয়াৰ সময় উকলি গৈছে।', 'The code is wrong or has expired.');
  String get confirm => _t('নিশ্চিত কৰক', 'Confirm');
  String get resendCode => _t('ক’ড পুনৰ পঠাওক', 'Send the code again');
  String resendIn(int s) => _t('$s ছেকেণ্ডৰ পিছত পুনৰ পঠাব পাৰিব', 'You can send it again in $s s');
  String get codeResent => _t('নতুন ক’ড পঠোৱা হ’ল।', 'A new code has been sent.');
  String get sendCode => _t('ক’ড পঠাওক', 'Send code');
  String get resetPasswordTitle => _t('নতুন পাছৱৰ্ড', 'New password');
  String get resetPasswordHint =>
      _t('আপোনাৰ ইমেইল লিখক। আমি নতুন পাছৱৰ্ড দিবলৈ এটা ক’ড পঠিয়াম।', "Enter your email. We'll send you a code to set a new password.");
  String get newPassword => _t('নতুন পাছৱৰ্ড', 'New password');
  String get passwordChanged => _t('পাছৱৰ্ড সলনি হ’ল।', 'Your password has been changed.');

  // Home screen (tiles, banner slides, side menu).
  String hello(String name) => _t('নমস্কাৰ, $name', 'Hello, $name');
  String get helloNoName => _t('নমস্কাৰ!', 'Hello!');
  String get helloSub => _t('আজি অলপ পঢ়া-শুনা কৰোঁ আহক', "Ready for today's study?");
  String get quickRead => _t('পঢ়ক', 'Read');
  String get quickPractice => _t('অনুশীলন', 'Practice');
  String get quickMock => _t('আদৰ্শ পৰীক্ষা', 'Mock test');
  String get gridGk => _t('অসমৰ জ্ঞান', 'Assam GK');
  String get gridNews => _t('খবৰ', 'News');
  String get gridCareers => _t('কেৰিয়াৰ', 'Careers');
  String get openMenu => _t('মেনু খোলক', 'Open menu');
  String get switchLanguage => _t('ভাষা সলনি কৰক', 'Switch language');
  String get tileExams => _t('পৰীক্ষাৰ পাঠ্যক্ৰম', 'Exam syllabus');
  String get tileCareers => _t('কেৰিয়াৰ গাইড', 'Career guide');
  String get tileNews => _t('আজিৰ খবৰ', 'Current affairs');
  String get tileJobs => _t('চাকৰিৰ খবৰ', 'Job vacancies');
  String get slideLearnCta => _t('পঢ়িবলৈ আৰম্ভ কৰক', 'Start learning');
  String get slidePremium => _t('সকলো অধ্যায় আৰু কুইজ খোলক', 'Unlock every chapter and quiz');
  String get slidePremiumCta => _t('প্ৰিমিয়াম লওক', 'Go Premium');
  String get slidePractice => _t('কুইজ আৰু আদৰ্শ পৰীক্ষাৰে প্ৰতিদিনে অনুশীলন কৰক', 'Practise every day with quizzes and mock tests');
  String get slidePracticeCta => _t('কুইজ আৰম্ভ কৰক', 'Start a quiz');
  String get slideJobs => _t('অসমৰ শেহতীয়া চাকৰিৰ খবৰ এক ঠাইতে', 'The latest job vacancies in Assam, in one place');
  String get slideJobsCta => _t('চাকৰি চাওক', 'See vacancies');
  String get shareApp => _t('এপটো শ্বেয়াৰ কৰক', 'Share the app');
  String get rateApp => _t('এপটোক ৰেটিং দিয়ক', 'Rate the app');
  String shareText(String link) => _t(
    'ASSAMPEDIA: অসমৰ সাধাৰণ জ্ঞান, পৰীক্ষা, চাকৰি আৰু কুইজ, অসমীয়া আৰু ইংৰাজীত। $link',
    'ASSAMPEDIA: Assam GK, exams, jobs and quizzes in Assamese and English. $link',
  );

  // Security question.
  String get securityQuestion => _t('সুৰক্ষা প্ৰশ্ন', 'Security question');
  String get securityQuestionHint => _t(
    'পাছৱৰ্ড পাহৰিলে এই প্ৰশ্নৰ উত্তৰ দি নতুন পাছৱৰ্ড দিব পাৰিব।',
    'If you forget your password, you can answer this question to set a new one.',
  );
  String get chooseQuestion => _t('এটা প্ৰশ্ন বাছক', 'Choose a question');
  String get answerNeeded =>
      _t('সুৰক্ষা প্ৰশ্ন বাছি উত্তৰ লিখক (অন্ততঃ ২টা আখৰ)।', 'Choose a security question and write an answer (at least 2 letters).');
  String get answerYourQuestion =>
      _t('আপোনাৰ সুৰক্ষা প্ৰশ্নৰ উত্তৰ দিয়ক আৰু নতুন পাছৱৰ্ড বাছক।', 'Answer your security question and choose a new password.');
  String get wrongAnswer => _t('উত্তৰ মিলা নাই। পুনৰ চেষ্টা কৰক।', "That answer doesn't match. Please try again.");
  String get answerLocked =>
      _t('বহুবাৰ ভুল উত্তৰ দিয়া হ’ল। ১ ঘণ্টাৰ পিছত পুনৰ চেষ্টা কৰক।', 'Too many wrong answers. Please try again after 1 hour.');
  String get useEmailCode => _t('ইয়াৰ সলনি ইমেইল ক’ড ব্যৱহাৰ কৰক', 'Use an email code instead');
  String get changeAnswerHint => _t('সলনি কৰিবলৈ হে নতুন উত্তৰ লিখক।', 'Write a new answer only if you want to change it.');

  // Student profile.
  String get myProfile => _t('মোৰ প্ৰ’ফাইল', 'My profile');
  String get setUpProfile => _t('আপোনাৰ প্ৰ’ফাইল সাজক', 'Set up your profile');
  String get profileHint => _t(
    'আপোনাৰ বিষয়ে অলপ কওক, যাতে এপটো আপোনাৰ প্ৰস্তুতিৰ বাবে উপযোগী হয়।',
    'Tell us a little about yourself so the app can suit your preparation.',
  );
  String get fullName => _t('সম্পূৰ্ণ নাম', 'Full name');
  String get nameNeeded => _t('আপোনাৰ নাম লিখক।', 'Please enter your name.');
  String get education => _t('শিক্ষাগত অৰ্হতা', 'Education');
  String get examsPreparing => _t('কোনবোৰ পৰীক্ষাৰ বাবে প্ৰস্তুতি চলাইছে?', 'Which exams are you preparing for?');
  String get district => _t('জিলা / চহৰ (ইচ্ছা অনুসৰি)', 'District / town (optional)');
  String get saveAndContinue => _t('ছেভ কৰি আগবাঢ়ক', 'Save and continue');
  String get save => _t('ছেভ কৰক', 'Save');
  String get profileSaved => _t('প্ৰ’ফাইল ছেভ হ’ল।', 'Profile saved.');
  String get notSet => _t('দিয়া হোৱা নাই', 'Not set');
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
  String get examsIntro =>
      _t('চৰকাৰী পৰীক্ষাৰ পাঠ্যক্ৰম, যোগ্যতা আৰু পৰীক্ষাৰ ধৰণ।', 'Government exam syllabuses, eligibility and exam patterns.');
  String get careersIntro =>
      _t('চৰকাৰী পদবীৰ কাম, দায়িত্ব আৰু কেৰিয়াৰৰ সুযোগ।', 'What government posts involve, and where they can lead.');
  String get officialWebsite => _t('চৰকাৰী ৱেবছাইট', 'Official website');
  String get officialNotification => _t('চৰকাৰী জাননী', 'Official notification');
  String appliesTo(String v) => _t('প্ৰযোজ্য: $v', 'Applies to: $v');
  String get checkOfficial =>
      _t('আবেদন কৰাৰ আগতে সদায় চৰকাৰী জাননী পৰীক্ষা কৰক।', 'Always check the official notification before you apply.');
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
  String questionsCount(int n) => _t('$nটা প্ৰশ্ন', n == 1 ? '1 question' : '$n questions');
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

  // Phase 6b: revision
  String get flashcards => _t('ফ্লেচকাৰ্ড', 'Flashcards');
  String get oneLiners => _t('এশাৰীৰ তথ্য', 'One-liners');
  String get question => _t('প্ৰশ্ন', 'Question');
  String get answer => _t('উত্তৰ', 'Answer');
  String get tapToSeeAnswer => _t('উত্তৰ চাবলৈ টিপক', 'Tap to see the answer');
  String get tapToSeeQuestion => _t('প্ৰশ্নলৈ উভতি যাবলৈ টিপক', 'Tap to go back to the question');
  String cardOf(int a, int b) => _t('কাৰ্ড $a / $b', 'Card $a of $b');
  String get shuffle => _t('মিহলাওক', 'Shuffle');

  // Phase 6c: Premium
  String get premium => _t('প্ৰিমিয়াম', 'Premium');
  String get premiumTitle => _t('ASSAMPEDIA প্ৰিমিয়াম', 'ASSAMPEDIA Premium');
  String get lockedPage => _t('এই পৃষ্ঠাটো প্ৰিমিয়াম সদস্যৰ বাবে।', 'This page is for Premium members.');
  String get freeNote => _t(
    'প্ৰতিটো গোটৰ প্ৰথম ৩টা পৃষ্ঠা আৰু প্ৰতিবিধ কুইজৰ প্ৰথম ৩টা বিনামূলীয়া।',
    'The first 3 pages of every group and the first 3 quizzes of every type are free.',
  );
  String get benefitAll => _t('সকলো অধ্যায়, পৰীক্ষা আৰু কেৰিয়াৰৰ পৃষ্ঠা', 'Every chapter, exam and career page');
  String get benefitQuizzes => _t('সকলো কুইজ, আদৰ্শ পৰীক্ষা আৰু ফ্লেচকাৰ্ড', 'All quizzes, mock tests and flashcards');
  String get benefitNews => _t('সকলো সাম্প্ৰতিক ঘটনা', 'All current affairs');
  String get benefitStudy => _t('সকলো পিডিএফ টোকা আৰু ভিডিঅ’ শ্ৰেণী', 'All PDF notes and video classes');
  String get benefitFree => _t('চাকৰিৰ খবৰ সদায় বিনামূলীয়া', 'Job vacancies always stay free');
  String perYear(String price) => _t('বছৰি $price', '$price per year');
  String get subscribe => _t('প্ৰিমিয়াম লওক', 'Subscribe');
  String get restorePurchase => _t('আগৰ ক্ৰয় পুনৰুদ্ধাৰ কৰক', 'Restore purchase');
  String get signInToSubscribe => _t('প্ৰিমিয়াম ল’বলৈ প্ৰথমে ছাইন ইন কৰক।', 'Please sign in first to subscribe.');
  String get storeUnavailable =>
      _t('Google Playৰ পৰা ইনষ্টল কৰা এপত হে প্ৰিমিয়াম কিনিব পাৰি।', 'Premium can be bought in the app installed from Google Play.');
  String get cancelAnytime =>
      _t('Google Play → চাবস্ক্ৰিপচনত যিকোনো সময়ত বাতিল কৰিব পাৰি।', 'Cancel any time in Google Play → Subscriptions.');
  String premiumUntil(String d) => _t('প্ৰিমিয়াম সক্ৰিয়, $d লৈকে', 'Premium active until $d');
  String get youArePremium => _t('আপুনি প্ৰিমিয়াম সদস্য। ধন্যবাদ!', "You're a Premium member. Thank you!");
  String get manageSubscription => _t('চাবস্ক্ৰিপচন পৰিচালনা কৰক', 'Manage subscription');
  String get freePlan => _t('বিনামূলীয়া', 'Free plan');
  String get seePremium => _t('প্ৰিমিয়াম চাওক', 'See Premium');

  // Notifications
  String get notifications => _t('জাননী', 'Notifications');
  String get thoughtForToday => _t('আজিৰ প্ৰেৰণা', 'Thought for today');
  String get openJobs => _t('খোলা চাকৰিৰ খালী পদ', 'Open job vacancies');
  String get newBadge => _t('নতুন', 'NEW');
  String get noOpenJobs => _t('এই মুহূৰ্তত কোনো খোলা খালী পদ নাই।', 'No open vacancies right now.');
  String get morningQuote => _t('ৰাতিপুৱাৰ প্ৰেৰণা', 'Morning quote');
  String get morningQuoteHint =>
      _t('প্ৰতিদিনে ৰাতিপুৱা ৭ বজাত এজন মহান ব্যক্তিৰ প্ৰেৰণাদায়ক বাণী', 'A motivational quote by a great person every day at 7 AM');
  String newJobsCount(int n) => _t('$nটা নতুন খালী পদ', n == 1 ? '1 new vacancy' : '$n new vacancies');

  // Mock tests
  String get mockTests => _t('আদৰ্শ পৰীক্ষা', 'Mock Tests');
  String get mockTestsHint => _t('সময় বান্ধি প্ৰকৃত পৰীক্ষাৰ দৰে অনুশীলন', 'Timed tests that work like the real exam');
  String get noMockTests => _t('এতিয়ালৈকে কোনো আদৰ্শ পৰীক্ষা প্ৰকাশ হোৱা নাই।', 'No mock tests published yet.');
  String lastAttempt(String marks, String max) => _t('শেষবাৰ: $max ৰ ভিতৰত $marks', 'Last time: $marks / $max');
  String timesTaken(int n) => _t('$n বাৰ দিয়া হৈছে', n == 1 ? 'Taken once' : 'Taken $n times');
  String get generalInstructions => _t('সাধাৰণ নিৰ্দেশনা', 'General instructions');
  String get testInstructions => _t('এই পৰীক্ষাৰ নিৰ্দেশনা', 'Instructions for this test');
  String get totalQuestions => _t('মুঠ প্ৰশ্ন', 'Total questions');
  String get totalMarks => _t('মুঠ নম্বৰ', 'Total marks');
  String get timeAllowed => _t('সময়', 'Time allowed');
  String get noTimeLimit => _t('সময়সীমা নাই', 'No time limit');
  String get marksForCorrect => _t('শুদ্ধ উত্তৰৰ বাবে', 'For each right answer');
  String get marksForWrong => _t('ভুল উত্তৰৰ বাবে', 'For each wrong answer');
  String get marksForSkipped => _t('উত্তৰ নিদিলে', 'For a question left out');
  String get noNegative => _t('ঋণাত্মক নম্বৰ নাই', 'No negative marking');
  String plusMarks(String m) => '+$m';
  String minusMarks(String m) => '−$m';
  List<String> mockRules({required int minutes, required bool negative}) => [
    if (minutes > 0)
      _t(
        'পৰীক্ষা আৰম্ভ হোৱাৰ লগে লগে ওপৰত $minutes মিনিটৰ ঘড়ী চলিবলৈ ধৰিব। সময় শেষ হ’লে আপোনাৰ উত্তৰবোৰ নিজে নিজে জমা হ’ব।',
        'A $minutes-minute timer starts at the top as soon as the test begins. When time runs out, your answers are submitted by themselves.',
      ),
    _t(
      'প্ৰতিটো প্ৰশ্নৰ কেইবাটাও বিকল্প আছে, তাৰে এটাহে শুদ্ধ। এটা বিকল্প টিপি উত্তৰ বাছক।',
      'Each question has several options and only one is right. Tap an option to choose it.',
    ),
    _t(
      'যিকোনো প্ৰশ্নলৈ যাবলৈ ওপৰৰ প্ৰশ্ন তালিকাৰ বুটামটো টিপক। "আগৰ" আৰু "সংৰক্ষণ কৰি পৰৱৰ্তী" বুটামেৰেও আগ-পিছ কৰিব পাৰি।',
      'Tap the question palette button at the top to jump to any question. You can also move with "Previous" and "Save & next".',
    ),
    _t(
      'নিশ্চিত নহ’লে "পুনৰীক্ষণৰ বাবে চিহ্নিত কৰক" টিপক আৰু পিছত উভতি আহক। চিহ্নিত প্ৰশ্নৰ উত্তৰ দিয়া থাকিলে সেইটোও গণনা কৰা হ’ব।',
      'Not sure? Tap "Mark for review" and come back later. A marked question that has an answer is still counted.',
    ),
    _t('বাছি লোৱা উত্তৰ আঁতৰাবলৈ "উত্তৰ মচক" টিপক।', 'Tap "Clear answer" to remove the option you chose.'),
    if (negative)
      _t(
        'প্ৰতিটো ভুল উত্তৰৰ বাবে নম্বৰ কটা যাব। উত্তৰ নিদিয়া প্ৰশ্নৰ বাবে নম্বৰ কটা নাযায়, গতিকে আন্দাজ কৰাৰ আগতে ভাবক।',
        'Marks are taken away for every wrong answer. Questions left out lose nothing, so think before you guess.',
      ),
    _t(
      'শেষত "পৰীক্ষা জমা দিয়ক" টিপক। জমা দিয়াৰ পিছত উত্তৰ সলনি কৰিব নোৱাৰি।',
      'Tap "Submit test" when you finish. Answers cannot be changed after you submit.',
    ),
    _t(
      'পৰীক্ষাৰ মাজত এপৰ পৰা ওলাই গ’লে উত্তৰবোৰ হেৰাব। ভাষা যিকোনো সময়ত সলনি কৰিব পাৰি।',
      'Leaving the test midway loses your answers. You can switch language at any time.',
    ),
  ];
  String get paletteLegend => _t('প্ৰশ্ন তালিকাৰ ৰং', 'Question palette colours');
  String get notVisited => _t('চোৱা হোৱা নাই', 'Not visited');
  String get answered => _t('উত্তৰ দিয়া হৈছে', 'Answered');
  String get markedForReview => _t('পুনৰীক্ষণৰ বাবে চিহ্নিত', 'Marked for review');
  String get answeredAndMarked => _t('উত্তৰ দিয়া আৰু চিহ্নিত', 'Answered and marked');
  String get readInstructions => _t('মই নিৰ্দেশনাবোৰ পঢ়িলোঁ আৰু বুজি পালোঁ।', 'I have read and understood the instructions.');
  String get startTest => _t('পৰীক্ষা আৰম্ভ কৰক', 'Start test');
  String get questionPalette => _t('প্ৰশ্ন তালিকা', 'Question palette');
  String get markForReview => _t('পুনৰীক্ষণৰ বাবে চিহ্নিত কৰক', 'Mark for review');
  String get unmark => _t('চিহ্ন আঁতৰাওক', 'Remove mark');
  String get clearAnswer => _t('উত্তৰ মচক', 'Clear answer');
  String get saveAndNext => _t('সংৰক্ষণ কৰি পৰৱৰ্তী', 'Save & next');
  String marksLine(String plus, String minus) => _t('শুদ্ধ: $plus · ভুল: $minus', 'Right: $plus · Wrong: $minus');
  String get submitConfirmTitle => _t('পৰীক্ষা জমা দিবনে?', 'Submit the test?');
  String submitConfirmTime(String t) => _t('এতিয়াও $t সময় বাকী আছে।', 'You still have $t left.');
  String get submitConfirmHint => _t('জমা দিয়াৰ পিছত উত্তৰ সলনি কৰিব নোৱাৰিব।', 'You cannot change your answers after submitting.');
  String get goBack => _t('উভতি যাওক', 'Go back');
  String get submit => _t('জমা দিয়ক', 'Submit');
  String get leaveTest => _t('পৰীক্ষাৰ পৰা ওলাই যাবনে?', 'Leave the test?');
  String get leaveTestHint => _t('আপোনাৰ উত্তৰবোৰ হেৰাব আৰু ফলাফল নাপাব।', 'Your answers will be lost and you will not get a result.');
  String get fiveMinutesLeft => _t('মাত্ৰ ৫ মিনিট বাকী!', 'Only 5 minutes left!');
  String get oneMinuteLeft => _t('মাত্ৰ ১ মিনিট বাকী!', 'Only 1 minute left!');

  String get analysis => _t('ফলাফল বিশ্লেষণ', 'Result analysis');
  String get timeUpSubmitted => _t('সময় শেষ হোৱাত পৰীক্ষাটো নিজে নিজে জমা হ’ল।', 'Time ran out, so the test was submitted by itself.');
  String get yourScore => _t('আপোনাৰ নম্বৰ', 'Your score');
  String outOf(String max) => _t('$max ৰ ভিতৰত', 'out of $max');
  String get correctLabel => _t('শুদ্ধ', 'Correct');
  String get wrongLabel => _t('ভুল', 'Wrong');
  String get skippedLabel => _t('এৰি দিয়া', 'Skipped');
  String get attemptedLabel => _t('উত্তৰ দিয়া', 'Attempted');
  String get accuracyLabel => _t('শুদ্ধতা', 'Accuracy');
  String get timeTaken => _t('লগা সময়', 'Time taken');
  String get perQuestion => _t('প্ৰতি প্ৰশ্নত গড়', 'Average per answer');
  String negativeLost(String m) => _t('ভুল উত্তৰৰ বাবে $m নম্বৰ কটা গ’ল।', m == '1' ? '1 mark was taken away for wrong answers.' : '$m marks were taken away for wrong answers.');
  String get accuracyHint => _t('শুদ্ধতা = উত্তৰ দিয়া প্ৰশ্নৰ ভিতৰত শুদ্ধ', 'Accuracy = right answers out of the ones you answered');
  String get topicWise => _t('বিষয়ভিত্তিক বিশ্লেষণ', 'Topic-wise analysis');
  String get generalTopic => _t('সাধাৰণ', 'General');
  String topicLine(int c, int w, int sk) => _t('শুদ্ধ $c · ভুল $w · এৰি দিয়া $sk', '$c right · $w wrong · $sk skipped');
  String get strongTopic => _t('শক্তিশালী', 'Strong');
  String get weakTopic => _t('অধিক অনুশীলন লাগে', 'Needs practice');
  String get reviewAnswers => _t('উত্তৰ আৰু ব্যাখ্যা', 'Review answers');
  String get all => _t('সকলো', 'All');
  String get noneHere => _t('এই ভাগত কোনো প্ৰশ্ন নাই।', 'No questions here.');
  String get retakeTest => _t('পুনৰ পৰীক্ষা দিয়ক', 'Retake test');
  String secondsShort(int n) => _t('$n ছেকেণ্ড', '${n}s');
}
