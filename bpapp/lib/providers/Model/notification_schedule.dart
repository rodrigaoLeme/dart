//import 'dart:ffi';

import 'package:bibleplan/common.dart';

class NotificationSchedule {
  //Time of the day in minutes since 00:00
  int time;
  bool enabled = true;
  List<bool> _days;

  List<bool> get days => _days.toList(growable: false);

  NotificationSchedule(this.time)
      : _days = List.filled(7, false, growable: false),
        assert(time < 60 * 24);

  factory NotificationSchedule.now() {
    var now = TimeOfDay.now();
    return NotificationSchedule(now.hour * 60 + now.minute);
  }

  bool get everyDay => _days.every((element) => element);

  void toggleDay(int day) {
    if (day < 0 || day > 6) return;
    _days[day] = !_days[day];
  }

  void setDay(int day, bool value) {
    if (day < 0 || day > 6) return;
    _days[day] = value;
  }

  void turnDayOn(int day) {
    if (day < 0 || day > 6) return;
    _days[day] = true;
  }

  void turnDayOff(int day) {
    if (day < 0 || day > 6) return;
    _days[day] = false;
  }

  void setWeek(List<bool> days) {
    if (days.length != 7) return;
    _days = List.from(days, growable: false);
  }

  bool dayInfo(int day) => _days[day];

  NotificationSchedule copy() =>
      NotificationSchedule(time).._days = _days.toList(growable: false);

  Map<String, dynamic> toJson() {
    return {
      "time": time,
      "days": _days.fold<int>(0, (p, e) => p << 1 | (e ? 1 : 0)),
      "enabled": enabled
    };
  }

  static NotificationSchedule? fromJson(Map<String, dynamic> json) {
    if (!json.containsKey("time") || json["time"] is! int) return null;
    int time = json["time"] as int;

    NotificationSchedule result = NotificationSchedule(time);
    result.enabled = json["enabled"] == true;
    int _days = json["days"] as int;
    result._days =
        List.generate(7, (index) => (_days & 1 << index) > 0, growable: false);

    return result;
  }
}
