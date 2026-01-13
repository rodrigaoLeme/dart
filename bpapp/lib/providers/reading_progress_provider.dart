import 'dart:convert';
import 'dart:io';

import 'package:bibleplan/data/reading_progress.dart';
import 'package:bibleplan/data/study_plan.dart';
import 'package:bibleplan/providers/study_provider.dart';
import 'package:path_provider/path_provider.dart';

class ReadingProgressProvider {
  String? _appDocDir;
  List<DayProgress>? _planProgress;

  static ReadingProgressProvider instance = ReadingProgressProvider._();
  ReadingProgressProvider._();

  List<DayProgress>? get planProgress => _planProgress;

  Future init() async {
    // ignore: prefer_conditional_assignment
    if (_appDocDir == null) {
      _appDocDir = (await getApplicationDocumentsDirectory()).path;
    }
    if (_planProgress == null) {
      var file = File("$_appDocDir/plan.pgs");
      if (file.existsSync()) {
        List<dynamic> content = jsonDecode(file.readAsStringSync());
        _planProgress = content.map((f) => DayProgress.fromJson(f)).toList();
      } else {
        _planProgress = StudyProvider.instance.currentPlan!.days
            .map((f) => DayProgress(
                bible: f.bibleChapters!
                    .map((p) => BibleBookProgress(
                        chapters: List<bool>.filled(p.chapters!.length, false)))
                    .toList()))
            .toList();
      }
    }
    updateStruct();
  }

  void saveProgress() {
    var bbl = jsonEncode(_planProgress!.map((f) => f.toJson()).toList());
    var bblfile = File("$_appDocDir/plan.pgs");
    bblfile.writeAsStringSync(bbl);
  }

  bool isDayCompleted(StudyPlanDayInfo info) =>
      (info.day < _planProgress!.length) && _planProgress![info.day].isComplete;

  // ignore: prefer_is_empty
  double totalProgress() => _planProgress == null || _planProgress!.length == 0
      ? 0
      : _planProgress!.fold(
              0, (dynamic value, item) => value += item.isComplete ? 1 : 0) /
          _planProgress!.length.toDouble();

  void updateStruct() {
    var alter = false;
    if (_planProgress![195].bibleReading.length == 3) {
      _planProgress![195].bibleReading = [
        BibleBookProgress(chapters: [false, false]),
        BibleBookProgress(chapters: [false, false])
      ];
      alter = true;
    }

    if (alter) saveProgress();
  }

  void reset() {
    _planProgress = StudyProvider.instance.currentPlan!.days
        .map((f) => DayProgress(
            bible: f.bibleChapters!
                .map((p) => BibleBookProgress(
                    chapters: List<bool>.filled(p.chapters!.length, false)))
                .toList()))
        .toList();
    saveProgress();
  }
}
