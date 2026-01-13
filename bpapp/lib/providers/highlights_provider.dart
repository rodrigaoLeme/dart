import 'package:bibleplan/providers/language_provider.dart';
import 'package:bibleplan/providers/Model/highlight.dart';
import 'package:hive/hive.dart';

class HighlightsProvider {
  static HighlightsProvider shared = HighlightsProvider._();

  late Box<BooksHighlights> _books;

  HighlightsProvider._();

  Future init() async {
    _books = await Hive.openBox("BooksHighlights");
  }

  List<BooksHighlights> all() {
    return _books.values.toList();
  }

  ChapterHighlights? get(String bookKey, int chapter) =>
      _books.get("$bookKey-${Language.instance.current}")?.getChapter(chapter);

  void save(
      String bookName, String bookShort, ChapterHighlights highlights) async {
    String key = "$bookShort-${Language.instance.current}";
    var book = _books.get(key) ??
        BooksHighlights(name: bookName, key: bookShort, chapters: []);
    book.setChapter(highlights);
    // ignore: prefer_is_empty
    if (book.chapters.length > 0) {
      _books.put(key, book);
    } else {
      _books.delete(key);
    }
  }
}
