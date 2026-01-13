import 'package:bibleplan/data/data.dart';

class BibleStudyReference implements Data {
  int? book;
  List<int>? chapters;
  String? reference;

  BibleStudyReference();

  BibleStudyReference.fromJson(Map<String, dynamic> data) {
    book = data["book"];
    chapters = (data["chapters"] as List<dynamic>).map<int>((f) => f).toList();
    reference = data["reference"];
  }

  @override
  Map<String, dynamic> toJson() =>
      {"book": book, "chapters": chapters, "reference": reference};
}

class EGWStudyReference implements Data {
  String? book;
  int? chapterIndex;
  String? chapter;

  EGWStudyReference();

  EGWStudyReference.fromJson(Map<String, dynamic> data) {
    book = data["book"];
    chapterIndex = data["chapter"];
    chapter = data["reference"];
  }

  @override
  Map<String, dynamic> toJson() =>
      {"book": book, "chapterIndex": chapterIndex, "chapter": chapter};
}

class StudyPlanDayInfo implements Data {
  List<BibleStudyReference>? bibleChapters;
  EGWStudyReference? egwReading;
  int day;
  late DateTime date;

  StudyPlanDayInfo.fromJson(Map<String, dynamic> data, this.day) {
    var now = DateTime.now();
    date = DateTime(now.year, 1, 1).add(Duration(days: day));

    bibleChapters = (data["bibleChapters"] as List<dynamic>)
        .map((p) => BibleStudyReference.fromJson(p))
        .toList();
    if (data["egwReading"] != null) {
      egwReading = EGWStudyReference.fromJson(data["egwReading"]);
    }
  }

  @override
  Map<String, dynamic> toJson() => {
        "bibleChapters": bibleChapters?.toJson(),
        "egwReading": egwReading?.toJson()
      };
}

class StudyPlan implements Data {
  late List<StudyPlanDayInfo> days;
  String? name;

  StudyPlan();

  StudyPlan.fromJson(Map<String, dynamic> data) {
    days = (data["days"] as List<dynamic>)
        .asMap()
        .entries
        .map((p) => StudyPlanDayInfo.fromJson(p.value, p.key))
        .toList();
    name = data["name"];
  }

  @override
  Map<String, dynamic> toJson() => {"days": days.toJson(), "name": name};
}
