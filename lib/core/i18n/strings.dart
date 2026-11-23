import 'app_lang.dart';

/// Every piece of app text in both languages.
/// Content (chapters) comes from the database; this file is only for
/// buttons, menus and messages.
class S {
  S(this.lang);
  final AppLang lang;

  String _t(String as, String en) => lang == AppLang.assamese ? as : en;

  String get tagline => _t('অসম অন্বেষণ কৰক। শিকক। প্ৰস্তুত হওক। সফল হওক।',
      'Explore Assam. Learn. Prepare. Succeed.');
  String get chooseLanguage => 'আপোনাৰ ভাষা বাছনি কৰক\nChoose your language';
  String get changeLaterHint =>
      _t('আপুনি যিকোনো সময়ত ভাষা সলনি কৰিব পাৰে।', 'You can switch language at any time.');
  String get continueLabel => _t('আগবাঢ়ক', 'Continue');

  String get navHome => _t('মূল পৃষ্ঠা', 'Home');
  String get navLearn => _t('শিকক', 'Learn');
  String get navExams => _t('পৰীক্ষা', 'Exams');
  String get navJobs => _t('চাকৰি', 'Jobs');
  String get navMe => _t('মোৰ', 'Me');

  String get encyclopedia => _t('অসমৰ সাধাৰণ জ্ঞান', 'Assam GK Encyclopedia');
  String get encyclopediaHint =>
      _t('ইতিহাস, ভূগোল, সংস্কৃতি আৰু অধিক', 'History, geography, culture and more');
  String get continueLearning => _t('য’ত এৰিছিল তাৰ পৰা পঢ়ক', 'Continue learning');
  String get categories => _t('শ্ৰেণীসমূহ', 'Categories');
  String get seeAll => _t('সকলো চাওক', 'See all');

  String get noChapters => _t('এতিয়ালৈকে কোনো অধ্যায় প্ৰকাশ হোৱা নাই।', 'No chapters published yet.');
  String get offlineNotice =>
      _t('আপুনি অফলাইন। সংৰক্ষিত কপি দেখুওৱা হৈছে।', "You're offline. Showing your saved copy.");
  String get loadFailed => _t('ল’ড কৰিব পৰা নগ’ল। ইণ্টাৰনেট পৰীক্ষা কৰক।',
      "Couldn't load. Please check your internet connection.");
  String get retry => _t('পুনৰ চেষ্টা কৰক', 'Try again');
  String get notConnected => _t('বিষয়বস্তুৰ চাৰ্ভাৰ এতিয়াও সংযোগ কৰা হোৱা নাই।',
      'The content server is not connected yet.');

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
  String get signInHint => _t('ছাইন ইন কৰিলে আপোনাৰ প্ৰগতি সুৰক্ষিত থাকিব।',
      'Sign in to keep your progress safe on any phone.');
  String get checkEmail => _t('নিশ্চিত কৰিবলৈ আপোনাৰ ইমেইল চাওক।', 'Check your email to confirm your account.');
  String signedInAs(String who) => _t('$who হিচাপে ছাইন ইন কৰা হৈছে', 'Signed in as $who');
  String get adminPanel => _t('এডমিন পেনেল', 'Admin panel');
}
