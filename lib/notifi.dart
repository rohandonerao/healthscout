import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> requestExactAlarmPermission() async {
  if (Platform.isAndroid) {
    final plugin = FlutterLocalNotificationsPlugin();
    await plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestExactAlarmsPermission();
  }
}
