import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DHomePage extends StatelessWidget {
  DHomePage({super.key});

  final User? user = FirebaseAuth.instance.currentUser;

  // sign user out method
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        actions: [
          IconButton(
            onPressed: signUserOut,
            icon: Icon(Icons.logout),
          )
        ],
      ),
      body: Center(
        child: user != null && user?.email != null
            ? Text(
          "LOGGED IN AS: " + user!.email!,
          style: TextStyle(fontSize: 20),
        )
            : Text(
          "User information not available",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
