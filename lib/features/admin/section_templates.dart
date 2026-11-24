import '../../data/models.dart';

/// A standard section heading in both languages. When [suggested] is true,
/// the paragraph under it is marked "Suggestion: not official information".
typedef SectionTemplate = ({String en, String as, bool suggested});

/// The 20 sections every exam page should have (master plan, Part 6.5).
/// Headings only: the facts are written by the admin from official sources.
const List<SectionTemplate> examSections = [
  (en: 'Introduction', as: 'পৰিচয়', suggested: false),
  (en: 'Conducting authority', as: 'পৰীক্ষা লোৱা কৰ্তৃপক্ষ', suggested: false),
  (en: 'Purpose', as: 'উদ্দেশ্য', suggested: false),
  (en: 'Posts offered', as: 'উপলব্ধ পদ', suggested: false),
  (en: 'Eligibility criteria', as: 'যোগ্যতাৰ চৰ্ত', suggested: false),
  (en: 'Educational qualification', as: 'শৈক্ষিক অৰ্হতা', suggested: false),
  (en: 'Age limit', as: 'বয়সৰ সীমা', suggested: false),
  (en: 'Age relaxation', as: 'বয়সৰ ৰেহাই', suggested: false),
  (en: 'Examination pattern', as: 'পৰীক্ষাৰ ধৰণ', suggested: false),
  (en: 'Detailed syllabus', as: 'বিতং পাঠ্যক্ৰম', suggested: false),
  (en: 'Subject-wise marks distribution', as: 'বিষয়ভিত্তিক নম্বৰৰ বিভাজন', suggested: false),
  (en: 'Exam stages (Preliminary, Mains, Interview)', as: 'পৰীক্ষাৰ পৰ্যায় (প্ৰাৰম্ভিক, মুখ্য, সাক্ষাৎকাৰ)', suggested: false),
  (en: 'Negative marking', as: 'ঋণাত্মক নম্বৰ', suggested: false),
  (en: 'Selection procedure', as: 'বাছনি প্ৰক্ৰিয়া', suggested: false),
  (en: 'Preparation strategy', as: 'প্ৰস্তুতিৰ কৌশল', suggested: true),
  (en: 'Recommended study resources', as: 'পৰামৰ্শিত অধ্যয়ন সামগ্ৰী', suggested: true),
  (en: 'Previous-year question papers', as: 'পূৰ্বৱৰ্তী বছৰৰ প্ৰশ্নকাকত', suggested: false),
  (en: 'Official notification', as: 'চৰকাৰী জাননী', suggested: false),
  (en: 'Official website', as: 'চৰকাৰী ৱেবছাইট', suggested: false),
  (en: 'Frequently asked questions', as: 'সঘনাই সোধা প্ৰশ্ন', suggested: false),
];

/// The sections every career page should have (master plan, Part 7).
const List<SectionTemplate> jobSections = [
  (en: 'Introduction', as: 'পৰিচয়', suggested: false),
  (en: 'Department', as: 'বিভাগ', suggested: false),
  (en: 'Administrative position', as: 'প্ৰশাসনিক স্থান', suggested: false),
  (en: 'Duties and responsibilities', as: 'কৰ্তব্য আৰু দায়িত্ব', suggested: false),
  (en: 'Daily work routine', as: 'দৈনিক কামৰ ৰুটিন', suggested: false),
  (en: 'Powers and authority', as: 'ক্ষমতা আৰু কৰ্তৃত্ব', suggested: false),
  (en: 'Field responsibilities', as: 'ক্ষেত্ৰ পৰ্যায়ৰ দায়িত্ব', suggested: false),
  (en: 'Office responsibilities', as: 'কাৰ্যালয়ৰ দায়িত্ব', suggested: false),
  (en: 'Public interaction', as: 'ৰাইজৰ সৈতে যোগাযোগ', suggested: false),
  (en: 'Educational qualifications', as: 'শৈক্ষিক অৰ্হতা', suggested: false),
  (en: 'Recruitment examination', as: 'নিযুক্তি পৰীক্ষা', suggested: false),
  (en: 'Selection procedure', as: 'বাছনি প্ৰক্ৰিয়া', suggested: false),
  (en: 'Salary and pay scale', as: 'দৰমহা আৰু বেতনক্ৰম', suggested: false),
  (en: 'Allowances', as: 'ভাট্টাসমূহ', suggested: false),
  (en: 'Promotion opportunities', as: 'পদোন্নতিৰ সুযোগ', suggested: false),
  (en: 'Career progression', as: 'কেৰিয়াৰৰ অগ্ৰগতি', suggested: false),
  (en: 'Posting and transfer', as: 'নিযুক্তিস্থান আৰু বদলি', suggested: false),
  (en: 'Working conditions', as: 'কামৰ পৰিৱেশ', suggested: false),
  (en: 'Challenges', as: 'প্ৰত্যাহ্বান', suggested: false),
  (en: 'Skills required', as: 'প্ৰয়োজনীয় দক্ষতা', suggested: false),
  (en: 'How it differs from similar posts', as: 'একে ধৰণৰ পদৰ সৈতে পাৰ্থক্য', suggested: false),
];

List<SectionTemplate> sectionsFor(String section) => switch (section) {
  'exam' => examSections,
  'job' => jobSections,
  _ => const [],
};

BlockStyle styleUnder(SectionTemplate t) => t.suggested ? BlockStyle.suggested : BlockStyle.normal;
