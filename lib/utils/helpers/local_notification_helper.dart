import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class LocalNotificationHelper {
  LocalNotificationHelper._();

  static final LocalNotificationHelper localNotificationHelper =
      LocalNotificationHelper._();

  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  //todo: showSimpleLocalPushNotification()

  Future<void> showSimpleLocalPushNotification() async {
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      "Simple",
      "Simple Notification Channel",
      priority: Priority.max,
      importance: Importance.max,
    );
    DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails();

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      1,
      "Simple Notification",
      "Simple Body",
      notificationDetails,
      payload: "Dummy payload data with simple notification.",
    );
  }

//todo: showScheduledLocalPushNotification()

  Future<void> showScheduledLocalPushNotification() async {
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      "Scheduled",
      "Scheduled Notification Channe",
      priority: Priority.max,
      importance: Importance.max,
    );
    DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails();

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      1,
      "Scheduled Notification",
      "Scheduled Body",
      tz.TZDateTime.now(tz.local).add(
        const Duration(
          seconds: 5,
        ),
      ),
      notificationDetails,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: "Dummy payload data with scheduled notification.",
    );
  }

//todo: showBigPictureLocalPushNotification()

  Future<void> showBigPictureLocalPushNotification() async {
    BigPictureStyleInformation bigPictureStyleInformation =
    BigPictureStyleInformation(
      DrawableResourceAndroidBitmap(
        "mipmap/ic_launcher",
      ),
      largeIcon: DrawableResourceAndroidBitmap(
        "mipmap/ic_launcher",
      ),
    );

    AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
      "Big Picture",
      "Big Picture Notification Channel",
      priority: Priority.max,
      importance: Importance.max,
      styleInformation: bigPictureStyleInformation,
    );
    DarwinNotificationDetails darwinNotificationDetails =
    DarwinNotificationDetails();

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      1,
      "Big Picture Notification",
      "Big Picture Body",
      notificationDetails,
      payload: "Dummy payload data with Big Picture notification.",
    );
  }

//todo: showMediaStyleLocalPushNotification()

  Future<void> showMediaStyleLocalPushNotification() async {
    AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
      "Media Style",
      "Media Style Notification Channel",
      priority: Priority.max,
      importance: Importance.max,
      largeIcon: DrawableResourceAndroidBitmap(
        "mipmap/ic_launcher",
      ),
      color: Colors.red,
      colorized: true,
      styleInformation: MediaStyleInformation(),
    );

    DarwinNotificationDetails darwinNotificationDetails =
    DarwinNotificationDetails();

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      1,
      "Media Style Notification",
      "Media Style Body",
      notificationDetails,
      payload: "Dummy payload data with Media Style notification.",
    );
  }
}
