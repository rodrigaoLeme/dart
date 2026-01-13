import 'package:bibleplan/data/data.dart';

class BibleBookProgress {
  List<bool>? chapters;
  BibleBookProgress({this.chapters});

  bool get isCompleted => chapters!.every((test) => test == true);

  void complete() {
    chapters = List<bool>.filled(chapters!.length, true);
  }

  void clear() {
    chapters = List<bool>.filled(chapters!.length, false);
  }
}

class DayProgress implements Data {
  late List<BibleBookProgress> bibleReading;
  bool egwReadingCompleted = false;

  DayProgress({List<BibleBookProgress>? bible}) : bibleReading = bible ?? [];

  bool get isComplete =>
      egwReadingCompleted && bibleReading.every((test) => test.isCompleted);

  void toggleCompletion() {
    if (isComplete) {
      clear();
    } else {
      complete();
    }
  }

  void complete() {
    egwReadingCompleted = true;
    for (var element in bibleReading) {
      element.complete();
    }
  }

  void clear() {
    egwReadingCompleted = false;
    for (var element in bibleReading) {
      element.clear();
    }
  }

  DayProgress.fromJson(Map<String, dynamic> json) {
    if (json["complete"] == true) {
      egwReadingCompleted = true;
      bibleReading = (json["books"] as List<dynamic>)
          .map((f) => BibleBookProgress(chapters: List<bool>.filled(f, true)))
          .toList();
    } else {
      egwReadingCompleted = json["egwReadingCompleted"] == true;
      bibleReading = (json["bibleReading"] as List<dynamic>)
          .map((f) => BibleBookProgress(
              chapters: f.map<bool>((p) => p == true).toList()))
          .toList();
    }
  }

  @override
  Map<String, dynamic> toJson() {
    if (isComplete) {
      return {
        "complete": true,
        "books": bibleReading.map((f) => f.chapters!.length).toList()
      };
    }

    return {
      "egwReadingCompleted": egwReadingCompleted,
      "bibleReading": bibleReading.map((f) => f.chapters).toList()
    };
  }
}
