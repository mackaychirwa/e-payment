import 'dart:async';
import 'package:flutter/material.dart';
import 'package:total_load_up/auth/login.dart';
import 'package:total_load_up/colors/color.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 3000),
        () {
      Navigator.push(context, MaterialPageRoute(
          builder: (context) => LoginPage()));
        }
      );
  }
  Widget build(context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: greyColors,
        ),
        child: Center(
          child: Image.asset("assets/images/logo.png"),
        ),
      ),
    );
  }
}
