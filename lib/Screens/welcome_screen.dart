import 'package:flutter/material.dart';
import 'package:farmilyrev/Screens/default_login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'language_page.dart';
import 'options/firebase_options.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WelcomeScreen(),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Dark curved background
          Container(
            height: MediaQuery.of(context).size.height / 3,
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(150.0),
                bottomRight: Radius.circular(150.0),
              ),
            ),
          ),
          // White circle with app logo
          Positioned(
            top: MediaQuery.of(context).size.height / 6,
            left: MediaQuery.of(context).size.width / 4,
            child: Container(
              width: MediaQuery.of(context).size.width / 2,
              height: MediaQuery.of(context).size.width / 2,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Image.asset(
                  "assets/logo.png",
                  width: 180.0,
                  height: 180.0,
                ),
              ),
            ),
          ),
          // App name text in the center of the screen
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 130),
                  child:Image.asset(
                    "assets/welcomemessage.gif",
                    width: 250.0,
                    height: 250.0,
                  ),
                ),
                // Add the GIF widget below the text
                // Image.asset(
                //   "assets/welcomemessage.gif",
                //   width: 250.0,
                //   height: 250.0,
                // ),
              ],
            ),
          ),
          // Get Started button
          Positioned(
            bottom: 80.0,
            left: 120.0,
            right: 120.0,
            child: ElevatedButton(
              onPressed: () {
                // Replace the current page with the Sign up page
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LanguagePage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // Background color
              ),
              child: Text(
                "Join us ",
                style: TextStyle(color: Colors.white, fontSize: 20), // Text color
              ),
            ),
          ),
        ],
      ),
    );
  }
}
