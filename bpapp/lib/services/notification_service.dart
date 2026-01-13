import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  static bool _initialized = false;

  static Future<void> initialize() async {
    if (_initialized) return;

    tz.initializeTimeZones();

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    _initialized = true;
  }

  static void _onNotificationTapped(NotificationResponse response) {
    // Aqui você pode navegar para a tela desejada
    // Por exemplo, usando um GlobalKey<NavigatorState>
    debugPrint('Notification tapped: ${response.payload}');
  }

  static Future<void> cancelAll() async {
    await _notifications.cancelAll();
  }

  // Agendar notificação diária
  static Future<void> showDailyAtTime({
    required String title,
    required String message,
    required Time time,
    int id = 0,
  }) async {
    await _notifications.zonedSchedule(
      id,
      title,
      message,
      _nextInstanceOfTime(time),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_notifications',
          'Daily Notifications',
          channelDescription: 'Daily Bible reading reminders',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      androidScheduleMode: AndroidScheduleMode.alarmClock,
    );
  }

  // Agendar notificação semanal
  static Future<void> showWeeklyAtDayAndTime({
    required String title,
    required String message,
    required Time time,
    required Day day,
    int? id,
  }) async {
    final scheduleId = id ?? (day.value * 100 + time.hour * 10 + time.minute);

    await _notifications.zonedSchedule(
      scheduleId,
      title,
      message,
      _nextInstanceOfDayAndTime(day, time),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'weekly_notifications',
          'Weekly Notifications',
          channelDescription: 'Weekly Bible reading reminders',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      androidScheduleMode: AndroidScheduleMode.alarmClock,
    );
  }

  // Agendar notificação única
  static Future<void> schedule({
    required String title,
    required String message,
    required Duration duration,
    int id = 999,
  }) async {
    final scheduledDate = tz.TZDateTime.now(tz.local).add(duration);

    await _notifications.zonedSchedule(
      id,
      title,
      message,
      scheduledDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'scheduled_notifications',
          'Scheduled Notifications',
          channelDescription: 'Scheduled Bible reading reminders',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.alarmClock,
    );
  }

  // Calcular próxima instância do horário
  static tz.TZDateTime _nextInstanceOfTime(Time time) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return scheduledDate;
  }

  // Calcular próxima instância do dia e horário
  static tz.TZDateTime _nextInstanceOfDayAndTime(Day day, Time time) {
    final now = tz.TZDateTime.now(tz.local);

    int targetWeekday = day.value;

    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    // Calcular quantos dias até o próximo dia da semana desejado
    int daysUntilTarget = (targetWeekday - now.weekday) % 7;

    // Se é hoje mas já passou a hora, ou se é outro dia
    if (daysUntilTarget == 0 && scheduledDate.isBefore(now)) {
      daysUntilTarget = 7; // Próxima semana
    }

    scheduledDate = scheduledDate.add(Duration(days: daysUntilTarget));

    return scheduledDate;
  }

  static Future<bool> requestPermissions() async {
    final result = await _notifications
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
    return result ?? true;
  }
}

// Classes auxiliares para manter compatibilidade
class Time {
  final int hour;
  final int minute;

  const Time(this.hour, this.minute);
}

class Day {
  final int value;

  const Day(this.value); // 1-7 (Monday-Sunday)
}
