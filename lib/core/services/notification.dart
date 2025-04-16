import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:intl/intl.dart';
import 'package:taskati/core/models/task_model.dart';
import 'package:taskati/core/services/local_helper.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class NotificationService {
  static Future<void> init() async {
    // تهيئة المناطق الزمنية
    tz.initializeTimeZones();

    // إعداد Android
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // إعدادات عامة
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    // تهيئة الإشعارات
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static Future<void> scheduleDailyTaskNotification() async {
    final box = AppLocalStorage.taskBox;
    String today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    List<TaskModel> tasksToday = box!.values
        .where((task) => task.date == today)
        .cast<TaskModel>()
        .toList();

    String title = '🗓️ تذكير اليوم';
    String body = tasksToday.isNotEmpty
        ? '📌 لديك ${tasksToday.length} مهام لإنجازها اليوم'
        : '🎉 لا توجد مهام اليوم، استمتع بوقتك!';

    await flutterLocalNotificationsPlugin.zonedSchedule(
  1,
  title,
  body,
  _nextInstanceOf8AM(),
  const NotificationDetails(
    android: AndroidNotificationDetails(
      'daily_tasks_channel',
      'Daily Task Reminders',
      importance: Importance.max,
      priority: Priority.high,
    ),
  ),
  matchDateTimeComponents: DateTimeComponents.time,
  androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
);
  }

  static tz.TZDateTime _nextInstanceOf8AM() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, 8);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }
}
