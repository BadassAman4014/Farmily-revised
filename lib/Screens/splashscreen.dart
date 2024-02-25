import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:farmilyrev/Screens/welcome_screen.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'email_auth_page.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AuthPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFA8DF8E), Colors.white70],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: Center(
          child: AnimatedContainer(
            duration: Duration(seconds: 5),
            curve: Curves.easeInOut,
            height: 200.0,
            width: 200.0,
            child: Image.asset('assets/logo.png'), // Replace with your logo image
          ),
        ),
      ),
    );
  }
}
