import 'package:bibleplan/data/binary_reader.dart';
import 'package:collection/collection.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:bibleplan/shared/extensions/string_extensions.dart';
import 'package:uuid/uuid.dart';

class BibleReference {
  String text;
  String reference;

  BibleReference({required this.text, required this.reference});
}

class BibleBookChapter {
  List<String>? _verses;

  final BibleBook book;
  int chapter;
  int contentPosition;
  String initVerse = "";
  String finishVerse = "";
  String secondInitVerse = "";
  String secondFinishVerse = "";
  bool isFullChapter = true;
  final String id;

  int get count => verses?.length ?? 0;
  List<String>? get verses => _getVerses();

  BibleBookChapter(this.book, this.chapter, this.contentPosition)
      : id = const Uuid().v4();

  List<String>? _getVerses() {
    _verses ??= book.bible.loadChapterContent(this);
    return _verses;
  }

  BibleReference? getReference(int start, int end, [int? truncate = 100]) {
    final List<String>? verses = this.verses;
    if (verses == null) return null;

    int first = -1, last = -1;
    int total = 0;

    StringBuffer sb = StringBuffer();

    for (int i = 0; i < verses.length; i++) {
      String line = "${i + 1} ${verses[i]}\n";
      int verLength = line.length;
      sb.write(line);

      if (start >= total && start < total + verLength) first = i + 1;
      if (end > total && end <= total + verLength) last = i + 1;

      total += verLength;
      if (total > end) break;
    }

    if (first > 0 && last > 0) {
      String text = sb.toString().substring(start, end);
      if (truncate != null) text = text.substringToWord(truncate);
      String ref = first == last ? "$first" : "$first-$last";
      return BibleReference(
          text: text, reference: "${book.name} $chapter:$ref");
    }

    return null;
  }
}

class BibleBook {
  List<BibleBookChapter>? _chapters;

  final Bible bible;

  BibleBook(this.bible);

  String? name;
  String? shortName;
  int? number;
  int? chaptersCount;
  int? contentPosition;
  List<BibleBookChapter>? get chapters => _getChapters();

  List<BibleBookChapter>? _getChapters() {
    _chapters ??= bible.loadChaptersForBook(this);
    return _chapters;
  }
}

class Bible {
  final BinaryReader _reader;
  late List<BibleBook?> books;
  Bible._(this._reader);

  static Future<Bible?> load(String name) async {
    var file = await rootBundle.load('assets/data/$name.bl');
    BinaryReader reader = BinaryReader(file);

    if (reader.readByte() != 66 ||
        reader.readByte() != 86 ||
        reader.readByte() != 2) {
      return null;
    }
    int c = reader.readByte();

    List<BibleBook> books = [];
    Bible res = Bible._(reader);
    for (var i = 0; i < c; i++) {
      BibleBook bb = BibleBook(res);
      bb.name = reader.readString();
      bb.shortName = reader.readString();
      bb.chaptersCount = reader.readByte();
      bb.contentPosition = reader.readInt();
      bb.number = i;
      reader.readInt();
      books.add(bb);
    }
    res.books = books;

    return res;
  }

  List<BibleBookChapter> loadChaptersForBook(BibleBook book) {
    List<BibleBookChapter> res = [];
    int position = book.contentPosition!;

    for (var i = 0; i < book.chaptersCount!; i++) {
      _reader.setPosition(position);
      BibleBookChapter chapter = BibleBookChapter(book, i + 1, position);
      res.add(chapter);
      position += _reader.readInt() + 4;
    }
    return res;
  }

  List<String> loadChapterContent(BibleBookChapter chapter) {
    _reader.setPosition(chapter.contentPosition);
    var content = _reader.readLongString().trim();
    return content.split("\n");
  }

  String _chaptersSequence(int? from, int? to) =>
      from == to ? "$from" : "$from-$to";

  String stringfyChapters(List<BibleBookChapter> chapters,
      [bool useShortName = false]) {
    StringBuffer sb = StringBuffer();
    Map<String?, List<BibleBookChapter>> grouped =
        groupBy(chapters, (p) => useShortName ? p.book.shortName : p.book.name);

    for (var item in grouped.entries) {
      if (item.value.isEmpty) continue;
      item.value.sort((a, b) => a.chapter.compareTo(b.chapter));

      if (sb.length > 0) sb.writeln();

      sb.write("${item.key} ");
      int? from = item.value[0].chapter;
      int? to = from;

      bool appended = false;
      for (var i = 1; i < item.value.length; i++) {
        int? val = item.value[i].chapter;
        if (val == to! + 1) {
          to = val;
          continue;
        }
        if (appended) {
          sb.write(", ");
        } else {
          appended = true;
        }
        sb.write(_chaptersSequence(from, to));
        from = to = val;
      }
      if (appended) sb.write(", ");
      sb.write(_chaptersSequence(from, to));
    }

    return sb.toString();
  }
}
