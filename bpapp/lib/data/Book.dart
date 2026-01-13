import 'package:bibleplan/data/binary_reader.dart';
import 'package:flutter/services.dart';

class BookChapter {
  Book book;

  String title;
  int number;
  String? _content;
  int contentPosition;
  String? get content => _getContent();

  BookChapter(this.book, this.contentPosition, this.number, this.title);

  String? _getContent() {
    _content ??= book.readChapterContent(contentPosition);

    return _content;
  }
}

class Book {
  final String name;
  final String shortName;
  late List<BookChapter?> chapters;

  final BinaryReader _reader;
  Book._(this.name, this.shortName, this._reader);

  static Future<Book?> load(String? filename, String language) async {
    var file = await rootBundle.load('assets/data/$language/$filename.ewb');
    BinaryReader reader = BinaryReader(file);

    if (reader.readByte() != 69 ||
        reader.readByte() != 87 ||
        reader.readByte() != 1) {
      return null;
    }

    String name = reader.readString();
    String shortName = reader.readString();

    int c = reader.readByte();

    List<BookChapter?> chapters = [];
    Book res = Book._(name, shortName, reader);
    for (var i = 0; i < c; i++) {
      var number = reader.readByte();
      var title = reader.readString();
      BookChapter bc = BookChapter(res, reader.readInt(), number, title);
      chapters.add(bc);
    }

    res.chapters = chapters;
    return res;
  }

  String readChapterContent(int position) {
    _reader.setPosition(position);
    return _reader.readLongString();
  }
}
