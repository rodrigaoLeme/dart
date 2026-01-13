import 'dart:convert';

import 'package:bibleplan/data/study_plan.dart';
import 'package:bibleplan/providers/language_provider.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';

enum StudyPlanOption { classic }

const List<String> _studyNames = ["classic", "leap"];

class StudyProvider {
  static StudyProvider instance = StudyProvider._();
  StudyPlan? currentPlan;
  StudyProvider._();
  bool isLeapYear = true;

  Future init() async {
    isLeapYear = checkIsLeapYear();
    currentPlan = await _loadPlan(StudyPlanOption.classic);
  }

  bool checkIsLeapYear() {
    int year = DateTime.now().year;
    DateTime startOfNextYear = DateTime(year + 1, 1, 1);
    DateTime startOfYear = DateTime(year, 1, 1);
    int daysInYear = startOfNextYear.difference(startOfYear).inDays;
    return (daysInYear == 366) ? true : false;
  }

  Future<StudyPlan> _loadPlan(StudyPlanOption plan) async {
    String lg = Language.instance.current;

    var type = (isLeapYear) ? _studyNames[1] : _studyNames[plan.index];

    var data = await rootBundle.loadString('assets/data/${type}_$lg.json');
    var json = jsonDecode(data);
    return StudyPlan.fromJson(json);
  }

  Future<StudyPlan> changePlan(StudyPlanOption plan) async {
    var res = await _loadPlan(plan);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt("CURRENTPLAN", plan.index);
    currentPlan = res;
    return res;
  }
}
