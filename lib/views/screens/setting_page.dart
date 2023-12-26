import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/helpers/local_notification_helper.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () async {
                  await LocalNotificationHelper.localNotificationHelper
                      .showSimpleLocalPushNotification();
                },
                child: Text(
                  "SimpleNotification",
                ),
              ),
              OutlinedButton(
                onPressed: () async {
                  await LocalNotificationHelper.localNotificationHelper
                      .showScheduledLocalPushNotification();
                },
                child: Text(
                  "Scheduled Notification",
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  await LocalNotificationHelper.localNotificationHelper
                      .showBigPictureLocalPushNotification();
                },
                child: Text(
                  "Big picture",
                ),
              ),
              OutlinedButton(
                onPressed: () async {
                  await LocalNotificationHelper.localNotificationHelper
                      .showMediaStyleLocalPushNotification();
                },
                child: Text(
                  "Media style",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
