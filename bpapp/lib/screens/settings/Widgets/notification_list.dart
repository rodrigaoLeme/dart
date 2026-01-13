import 'package:bibleplan/common.dart';
import 'package:bibleplan/providers/language_provider.dart';
import 'package:bibleplan/providers/Model/notification_schedule.dart';
import 'package:bibleplan/providers/settings_provider.dart';
import 'package:bibleplan/screens/settings/notification_configuration.dart';
//import 'package:flutter/material.dart';

class NotificationList extends StatefulWidget {
  const NotificationList({Key? key}) : super(key: key);

  @override
  _NotificationListState createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  String notificationDescription(NotificationSchedule schedule) {
    var calc = schedule.days.fold<int>(0, (v, e) => (v << 1) | (e ? 1 : 0));
    if (calc == 0x7f) return localize("All days");
    if (calc == 0x41) return localize("Weekends");
    if (calc == 0x3E) return localize("Week days");
    if (calc == 0) return localize("Never");

    List<int> days = [];

    for (var i = 0; i < 7; i++) {
      if (schedule.dayInfo(i)) days.add(i);
    }

    if (days.length == 1) return Language.daysOfWeek[days[0]];
    return days.map((e) => Language.daysOfWeekShort[e]).join(", ");
  }

  String timeToString(int time) {
    var h = time ~/ 60;
    var m = time % 60;

    if (m == 0) return "${h}h";

    return "${h.toString().padLeft(2, "0")}:${m.toString().padLeft(2, "0")}";
  }

  Widget notificationWidget(NotificationSchedule schedule) {
    return Cell(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      minHeight: 30,
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: timeToString(schedule.time),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const TextSpan(text: " - "),
            TextSpan(text: notificationDescription(schedule)),
          ],
        ),
        style: TextStyle(color: AppStyle.primaryColor, fontSize: 16),
      ),
      accessory: Switch.adaptive(
        value: schedule.enabled,
        activeColor: AppStyle.primaryVariant,
        inactiveTrackColor: AppStyle.secondaryVariant,
        onChanged: (value) {
          setState(() {
            schedule.enabled = value;
          });
          SettingsProvider.instance.saveNotifications(context);
        },
      ),
      onPressed: () async {
        await pushScreen(
          context,
          NotificationConfiguration(
            notificationSchedule: schedule,
          ),
        );
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        children: SettingsProvider.instance.notificationSchedules
            .map(notificationWidget)
            .toList());
  }
}
