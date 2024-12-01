import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
// ignore: unused_import
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static FlutterLocalNotificationsPlugin? _instance;

  static Future<void> init() async {
    tz.initializeTimeZones();

    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(currentTimeZone));

    const initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(
        requestSoundPermission: false,
        requestBadgePermission: false,
        requestAlertPermission: false,
      ),
    );

    _instance = FlutterLocalNotificationsPlugin();
    await _instance?.initialize(initializationSettings);
  }

  static Future<bool?> requestPermissions() async {
    bool? result;
    if (Platform.isIOS) {
      result = await _instance
          ?.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    }
    return result;
  }

  static Future<void> createScheduledNotification({
    required int id,
    required String title,
    required String body,
    required DateTime showAt,
  }) async {
    try {
      const notificationDetails = NotificationDetails(
        iOS: DarwinNotificationDetails(),
      );

      final ts = tz.TZDateTime.from(showAt, tz.local);

      await _instance?.zonedSchedule(
        id,
        title,
        body,
        ts,
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      );
    } catch (_) {}
  }

  static Future<void> deleteScheduledNotification(int id) async {
    await _instance?.cancel(id);
  }

  static Future<void> deleteAllScheduledNotification() async {
    await _instance?.cancelAll();
  }
}
