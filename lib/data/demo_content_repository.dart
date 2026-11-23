import '../core/i18n/app_lang.dart';
import 'content_repository.dart';
import 'models.dart';

/// Layout-testing content only. Every text says it is sample text, so it can
/// never be mistaken for real Assam GK.
class DemoContentRepository implements ContentRepository {
  final _cats = [
    Category(id: 'c1', slug: 'history', position: 1, icon: 'history', nameEn: 'History of Assam', nameAs: 'অসমৰ ইতিহাস'),
    Category(id: 'c2', slug: 'geography', position: 2, icon: 'terrain', nameEn: 'Geography of Assam', nameAs: 'অসমৰ ভূগোল'),
    Category(
      id: 'c3',
      slug: 'culture',
      position: 3,
      icon: 'theater',
      nameEn: 'Art, Culture and Heritage',
      nameAs: 'কলা, সংস্কৃতি আৰু ঐতিহ্য',
    ),
    Category(id: 'c4', slug: 'wildlife', position: 4, icon: 'pets', nameEn: 'Wildlife and Environment', nameAs: 'বন্যপ্ৰাণী আৰু পৰিৱেশ'),
  ];

  @override
  Future<List<Category>> categories() async => _cats;

  @override
  Future<List<ChapterSummary>> chapters(String categoryId) async => [
    ChapterSummary(
      id: 'demo',
      slug: 'sample',
      position: 1,
      titles: {AppLang.english: 'Sample chapter (layout test)', AppLang.assamese: 'নমুনা অধ্যায় (পৰীক্ষা)'},
    ),
  ];

  @override
  Future<Chapter> chapter(String contentId) async {
    List<Block> blocks(String label, String para) => [
      Block(key: 'h1', position: 1, type: BlockType.heading, body: '$label 1'),
      for (var i = 1; i <= 8; i++) Block(key: 'p$i', position: i + 1, body: '$para ($i)'),
      Block(key: 'f1', position: 20, type: BlockType.factBox, style: BlockStyle.examFact, body: '$label: exam fact box'),
      Block(key: 'f2', position: 21, type: BlockType.factBox, style: BlockStyle.definition, body: '$label: definition box'),
    ];
    return Chapter(
      id: 'demo',
      slug: 'sample',
      versions: {
        AppLang.english: ChapterVersion(
          title: 'Sample chapter (layout test)',
          blocks: blocks(
            'Sample heading',
            'This is sample text with a {{term:sample-term}} used only to test the reading screen. It is not real information.',
          ),
        ),
        AppLang.assamese: ChapterVersion(
          title: 'নমুনা অধ্যায় (পৰীক্ষা)',
          blocks: blocks(
            'নমুনা শিৰোনাম',
            'এইটো {{term:sample-term}} থকা কেৱল পঢ়া পৃষ্ঠাটো পৰীক্ষা কৰিবলৈ নমুনা লিখনি। ই প্ৰকৃত তথ্য নহয়।',
          ),
        ),
      },
    );
  }

  final _terms = [
    Term(
      slug: 'sample-term',
      termEn: 'Sample term',
      termAs: 'নমুনা শব্দ',
      meaningEn: 'A sample dictionary entry used only to test tapping on words. Not real information.',
      meaningAs: 'শব্দত টিপা পৰীক্ষা কৰিবলৈ এটা নমুনা। ই প্ৰকৃত তথ্য নহয়।',
    ),
  ];

  @override
  Future<List<Term>> terms() async => _terms;

  @override
  Future<SearchResults> search(String query) async => searchLocally([await chapter('demo')], _terms, query);
}
