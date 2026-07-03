import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final _notifications = FlutterLocalNotificationsPlugin();

  // 🚀 INIT
  static Future init() async {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Ho_Chi_Minh'));

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');

    const settings = InitializationSettings(
      android: android,
    );

    await _notifications.initialize(settings);

    // 🔥 TẠO CHANNEL (PHẢI TRÙNG)
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'test_channel',
      'Test',
      description: 'Test notifications',
      importance: Importance.max,
    );

    await _notifications
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }


  static Future showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    await _notifications.show(
      id,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'test_channel',
          'Test',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
    );
  }

  static void scheduleReminder({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
  }) {
    final now = DateTime.now();

    var target = DateTime(
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    // nếu giờ đã qua → sang ngày mai
    if (target.isBefore(now)) {
      target = target.add(const Duration(days: 1));
    }

    final difference = target.difference(now);

    Future.delayed(difference, () {
      showNotification(
        id: id,
        title: title,
        body: body,
      );
    });
  }

  // static Future scheduleTest() async {    //TEST REMINDER
  //   Future.delayed(const Duration(seconds: 5), () async {
  //     await _notifications.show(
  //       0,
  //       'TEST',
  //       'Hiện sau 5s 🔥',
  //       const NotificationDetails(
  //         android: AndroidNotificationDetails(
  //           'test_channel',
  //           'Test',
  //           importance: Importance.max,
  //           priority: Priority.high,
  //         ),
  //       ),
  //     );
  //   });
  //
  // }

  // 🚀 DÙNG THẬT (theo giờ)
  static Future scheduleNotification({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
  }) async {
    final now = tz.TZDateTime.now(tz.local);

    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    // nếu giờ đã qua → +1 ngày
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    await _notifications.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'test_channel', // 🔥 PHẢI TRÙNG
          'Test',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}