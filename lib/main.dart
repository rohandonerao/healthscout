import 'dart:io';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:healthscout/Features/notification_service.dart';
import 'package:healthscout/notifi.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:healthscout/splashscreen.dart';

void alarmCallback() async {
  final player = AudioPlayer();
  await player
      .play(AssetSource('alarm.mp3')); // Make sure this file is in assets
  print("🔔 Alarm Triggered!");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: Platform.isAndroid
            ? const FirebaseOptions(
                apiKey: 'AIzaSyDsB4Wkl6XBSkqoKxdYa_cnjkeD0ilPfxA',
                appId: '1:787953937051:android:9b72b5079c688e1c2d343e',
                messagingSenderId: '787953937051',
                projectId: 'healthscout-4e38c',
                storageBucket: 'healthscout-4e38c.appspot.com',
              )
            : null,
      );
      await FirebaseAppCheck.instance.activate();
    }
  } catch (e) {
    print('Error initializing Firebase: $e');
  }
  await requestExactAlarmPermission();
  await AndroidAlarmManager.initialize();
  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  runApp(MyApp(savedThemeMode: savedThemeMode));
}

class MyApp extends StatelessWidget {
  final AdaptiveThemeMode? savedThemeMode;

  const MyApp({super.key, this.savedThemeMode});

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        brightness: Brightness.light,
        colorSchemeSeed: Colors.blue,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      dark: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.blue,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      initial: savedThemeMode ?? AdaptiveThemeMode.light,
      builder: (theme, darkTheme) => MaterialApp(
        theme: theme,
        darkTheme: darkTheme,
        home: VideoSplashScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
