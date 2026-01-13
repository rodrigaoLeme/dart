import 'package:bibleplan/common.dart';
import 'package:bibleplan/providers/language_provider.dart';
import 'package:bibleplan/providers/Model/notification_schedule.dart';
import 'package:bibleplan/providers/settings_provider.dart';
import 'package:bibleplan/shared/widgets/timer_picker.dart';

class NotificationConfiguration extends StatefulWidget {
  final NotificationSchedule? notificationSchedule;

  const NotificationConfiguration({Key? key, this.notificationSchedule})
      : super(key: key);

  @override
  _NotificationConfigurationState createState() =>
      _NotificationConfigurationState();
}

class _NotificationConfigurationState extends State<NotificationConfiguration> {
  late TimerPickerController timerPickerController;
  late NotificationSchedule _notificationSchedule;

  @override
  void initState() {
    super.initState();

    _notificationSchedule =
        widget.notificationSchedule?.copy() ?? NotificationSchedule.now();

    int hour = _notificationSchedule.time ~/ 60;
    int min = _notificationSchedule.time % 60;

    timerPickerController =
        TimerPickerController(TimeOfDay(hour: hour, minute: min));
  }

  Widget _dayButton(int day) {
    return RoundedButton(
      child: SizedBox(
          height: 44,
          width: 35,
          child: Center(
              child:
                  Txt(Language.daysOfWeekShort[day].toUpperCase(), size: 14))),
      onPressed: () {
        setState(() {
          _notificationSchedule.toggleDay(day);
        });
      },
      padding: const EdgeInsets.all(6),
      cornerRadius: 8,
      textStyle: TextStyle(
          color: _notificationSchedule.days[day]
              ? AppStyle.onPrimaryColor
              : AppStyle.primaryColor),
      color: _notificationSchedule.days[day]
          ? AppStyle.primaryColor
          : AppStyle.secondaryColor,
    );
  }

  void _save() {
    _notificationSchedule.time = timerPickerController.value.hour * 60 +
        timerPickerController.value.minute;
    if (widget.notificationSchedule != null) {
      widget.notificationSchedule?.time = _notificationSchedule.time;
      widget.notificationSchedule?.setWeek(_notificationSchedule.days);
    } else {
      SettingsProvider.instance.addNotification(_notificationSchedule);
    }

    SettingsProvider.instance.saveNotifications(context);
    popScreen(context);
  }

  void _delete() {
    if (widget.notificationSchedule == null) return;
    SettingsProvider.instance.removeNotification(widget.notificationSchedule!);

    SettingsProvider.instance.saveNotifications(context);
    popScreen(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Txt(localize("CONFIGURE ALARM")),
      ),
      body: Column(
        children: [
          TimerPicker(controller: timerPickerController),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(AppStyle.defaultMargin),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Txt.b(localize("Repeat")),
                const VSpacer(32),
                Center(
                  child: SizedBox(
                    width: 250,
                    child: Wrap(
                      direction: Axis.horizontal,
                      alignment: WrapAlignment.center,
                      runSpacing: 16,
                      spacing: 16,
                      children: [
                        _dayButton(0),
                        _dayButton(1),
                        _dayButton(2),
                        _dayButton(3),
                        _dayButton(4),
                        _dayButton(5),
                        _dayButton(6)
                      ],
                    ),
                  ),
                ),
                const VSpacer(32),
                Center(
                  child: RoundedButton.textSecondary(
                    localize("All days"),
                    onPressed: () {
                      setState(() {
                        _notificationSchedule.setWeek(List.filled(7, true));
                      });
                    },
                    cornerRadius: 8,
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppStyle.bigMargin,
                        vertical: AppStyle.defaultMargin),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SafeArea(
              child: Row(
                children: [
                  if (widget.notificationSchedule != null)
                    TextButton.icon(
                        onPressed: _delete,
                        icon: const Icon(Icons.delete),
                        label: Txt(localize("Delete"))),
                  const Spacer(),
                  RoundedButton.text(localize("Save Changes"), onPressed: _save)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
