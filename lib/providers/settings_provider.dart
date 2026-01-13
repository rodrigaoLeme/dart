import 'dart:convert';
import 'dart:io';

import 'package:bibleplan/common.dart';
import 'package:bibleplan/providers/Model/notification_schedule.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:bibleplan/services/notification_service.dart' as ns;

class SettingsProvider extends ChangeNotifier {
  static SettingsProvider instance = SettingsProvider._();
  static const List<String> fontOptions = [
    "Merriweather",
    "Roboto",
    "Noto Sans",
    "Noto Serif",
    "Lora",
    "Nunito"
  ];
  static List<double> sizeOptions = [12, 14, 16, 18, 20, 24, 32];
  static List<double> lineHeights = [2.0, 1.8, 1.6, 1.6, 1.6, 1.6, 1.4];
  static late SharedPreferences _sharedPreferences;

  SettingsProvider._();

  int _fontOption = 0;
  String? _fontName;
  ThemeMode _appTheme = ThemeMode.system;
  List<NotificationSchedule> _notificationSchedules = [];

  Future init(BuildContext context) async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _fontOption = _sharedPreferences.getInt("APPREADINGFONTSIZE") ?? 2;
    _fontName = _sharedPreferences.getString("APPREADINGFONTNAME");

    await ns.NotificationService.initialize();

    await _loadNotifications();

    int apptheme = _sharedPreferences.getInt("APPTHEME") ?? 0;
    if (apptheme == 0) {
      apptheme = Theme.of(context).brightness == Brightness.light ? 1 : 2;
    }

    appTheme = ThemeMode.values[apptheme];
  }

  List<NotificationSchedule> get notificationSchedules =>
      _notificationSchedules.toList(growable: false);

  void addNotification(NotificationSchedule notification) {
    _notificationSchedules.add(notification);
  }

  void removeNotification(NotificationSchedule notification) {
    _notificationSchedules.remove(notification);
  }

  int get fontSizeOption => _fontOption;

  ThemeMode get appTheme => _appTheme;

  set fontSizeOption(int size) {
    _fontOption = size;
    _sharedPreferences.setInt("APPREADINGFONTSIZE", size);
    notifyListeners();
  }

  set fontName(String name) {
    if (!fontOptions.contains(name)) return;
    _fontName = name;
    _sharedPreferences.setString("APPREADINGFONTNAME", _fontName!);
    notifyListeners();
  }

  String get fontName => _fontName ?? fontOptions[0];
  double get curretFontSize => sizeOptions[_fontOption];
  double get currentLineHeight => lineHeights[_fontOption];

  set appTheme(ThemeMode mode) {
    _appTheme = mode;
    _sharedPreferences.setInt("APPTHEME", mode.index);
    AppStyle.setStyle(
        mode == ThemeMode.light ? Brightness.light : Brightness.dark);
    notifyListeners();
  }

  static TextStyle styleForFont(String font, {TextStyle? baseStyle}) {
    switch (font) {
      case "Roboto":
        return GoogleFonts.roboto(textStyle: baseStyle);
      case "Noto Sans":
        return GoogleFonts.notoSans(textStyle: baseStyle);
      case "Noto Serif":
        return GoogleFonts.notoSerif(textStyle: baseStyle);
      case "Lora":
        return GoogleFonts.lora(textStyle: baseStyle);
      case "Nunito":
        return GoogleFonts.nunito(textStyle: baseStyle);
      default:
        return GoogleFonts.merriweather(textStyle: baseStyle);
    }
  }

  Future saveNotifications(BuildContext context) async {
    String data =
        jsonEncode(_notificationSchedules.map((e) => e.toJson()).toList());
    Directory documents = await getApplicationDocumentsDirectory();

    var file = File("${documents.path}/schedule.json");
    file.writeAsString(data, flush: true);

    await scheduleNotifications(context);
  }

  Future _loadNotifications() async {
    Directory documents = await getApplicationDocumentsDirectory();
    var file = File("${documents.path}/schedule.json");
    if (!(await file.exists())) return;

    String data = await file.readAsString();
    List<dynamic> json = jsonDecode(data);
    _notificationSchedules = json
        .map((e) => NotificationSchedule.fromJson(e))
        .where((element) => element != null)
        .cast<NotificationSchedule>()
        .toList();
  }

  Future scheduleNotifications(BuildContext context) async {
    await ns.NotificationService.cancelAll();

    var title = localize("Have you read your Bible today?");
    var message =
        localize("Dont forget to take a time every day to read your Bible.");

    int notificationId = 1;

    for (var schedule in _notificationSchedules) {
      if (!schedule.enabled) continue;

      if (schedule.everyDay) {
        // Notificação diária
        await ns.NotificationService.showDailyAtTime(
          title: title,
          message: message,
          time: ns.Time(schedule.time ~/ 60, schedule.time % 60),
          id: notificationId++,
        );
      } else {
        // Notificações semanais específicas
        for (var i = 0; i < 7; i++) {
          if (schedule.dayInfo(i)) {
            await ns.NotificationService.showWeeklyAtDayAndTime(
              title: title,
              message: message,
              time: ns.Time(schedule.time ~/ 60, schedule.time % 60),
              day: ns.Day(i + 1), // Day usa 1-7 (Monday-Sunday)
              id: notificationId++,
            );
          }
        }
      }
    }

    // Notificação única de teste (10 segundos)
    await ns.NotificationService.schedule(
      title: title,
      message: message,
      duration: const Duration(seconds: 10),
      id: 999,
    );
  }

  TextStyle getReadingStyle() {
    TextStyle baseStyle = TextStyle(
      color: AppStyle.onBackgroundColor,
      fontSize: sizeOptions[_fontOption],
      height: lineHeights[_fontOption],
    );
    return styleForFont(fontName, baseStyle: baseStyle);
  }
}
