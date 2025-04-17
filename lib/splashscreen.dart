// ignore_for_file: unused_local_variable, prefer_const_constructors, use_build_context_synchronously, library_private_types_in_public_api, use_key_in_widget_constructors, constant_identifier_names

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:healthscout/HomeScreen.dart';
import 'package:healthscout/authscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VideoSplashScreen extends StatefulWidget {
  @override
  _VideoSplashScreenState createState() => _VideoSplashScreenState();
}

class _VideoSplashScreenState extends State<VideoSplashScreen> {
  static const String KEYLOGIN = 'login';

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 1800), () {
      whereToGo(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child:
                Image.asset("assets/splash_screen.gif", fit: BoxFit.fitWidth),
          ),
          Positioned(
            top: 80,
            child: Image.asset("assets/Healthscout.png", width: 200),
          ),
          Positioned(
            bottom: 150,
            child: Text(
              "Your Health, Our Priority",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void whereToGo(BuildContext context) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    var isLoggedIn = sharedPreferences.getBool(KEYLOGIN);

    Timer(Duration(seconds: 2), () {
      if (isLoggedIn != null && isLoggedIn) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => login()),
        );
      }
    });
  }
}
