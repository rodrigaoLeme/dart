// ignore_for_file: prefer_final_fields

import 'package:hive/hive.dart';

part 'highlight.g.dart';

@HiveType(typeId: 1)
class ChapterHighlights {
  @HiveField(0)
  int chapter;

  @HiveField(1)
  List<TextMark> marks;

  ChapterHighlights(
      {required this.chapter, required this.marks, DateTime? date});

  void addMark(TextMark mark) {
    removeMarks(mark.start, mark.end, mark.page);
    marks.add(mark);
  }

  void removeMark(TextMark mark) {
    marks.remove(mark);
  }

  void removeMarks(int start, int end, int page) {
    List<TextMark> remain = [];
    for (var mark in marks) {
      if (mark.page == page) {
        if (mark.start >= start && mark.start < end) {
          mark.start = end;
        }

        if (mark.end > start && mark.end <= end) {
          mark.end = start;
        }

        if (mark.start < start && mark.end > end) {
          remain.add(TextMark(
              color: mark.color,
              start: end,
              end: mark.end,
              page: page,
              day: mark.day));
          mark.end = start;
        }

        if (mark.length <= 0) continue;
      }
      remain.add(mark);
    }
    marks = remain;
  }
}

@HiveType(typeId: 2)
class TextMark {
  @HiveField(0)
  int start;
  @HiveField(1)
  int end;
  @HiveField(2)
  int color;
  @HiveField(3)
  String? description;
  @HiveField(4)
  String? reference;

  @HiveField(5)
  DateTime date;

  @HiveField(6)
  int page;

  @HiveField(7)
  int day;

  @HiveField(8)
  String? note;

  int get length => end - start;

  TextMark(
      {required this.start,
      required this.end,
      required this.color,
      required this.day,
      this.description,
      this.reference,
      DateTime? date,
      this.note,
      required this.page})
      : date = date ?? DateTime.now();
}

@HiveType(typeId: 3)
class BooksHighlights {
  @HiveField(0)
  String name;
  @HiveField(1)
  List<ChapterHighlights> get chapters => _chapters.values.toList();
  @HiveField(2)
  String key;
  @HiveField(3)
  Map<int, ChapterHighlights> _chapters;

  BooksHighlights(
      {required this.name,
      required this.key,
      required List<ChapterHighlights> chapters})
      : _chapters =
            Map.fromEntries(chapters.map((e) => MapEntry(e.chapter, e)));

  ChapterHighlights? getChapter(int chapter) => _chapters[chapter];

  void setChapter(ChapterHighlights chapter) {
    // ignore: prefer_is_empty
    if (chapter.marks.length > 0) {
      _chapters[chapter.chapter] = chapter;
    } else {
      _chapters.remove(chapter.chapter);
    }
  }
}
