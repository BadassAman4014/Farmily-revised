import 'package:farmilyrev/Screens/portalpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:farmilyrev/Screens/phone_login_page.dart';
import 'valhari/firebase_options.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  bool _isEmailValid = true;

  // sign user in method
  void signUserIn() async {
    // show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
// try sign in
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      // pop the loading circle
      Navigator.pop(context);

      // Navigate to LanguagePage after successful sign-in
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => PortalPage()),
      );
    } on FirebaseAuthException catch (e) {
      // pop the loading circle
      Navigator.pop(context);
      // WRONG EMAIL
      if (e.code == 'user-not-found') {
        // show error to user
        wrongEmailMessage();
      }

      // WRONG PASSWORD
      else if (e.code == 'wrong-password') {
        // show error to user
        wrongPasswordMessage();
      }
    }
  }

  // wrong email message popup
  void wrongEmailMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          backgroundColor: Colors.deepPurple,
          title: Center(
            child: Text(
              'Incorrect Email',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  // wrong password message popup
  void wrongPasswordMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          backgroundColor: Colors.deepPurple,
          title: Center(
            child: Text(
              'Incorrect Password',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(Icons.arrow_back_ios_rounded),
        ),
        title: Text('Log In'),
        backgroundColor: Colors.green,
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                "Bridging Agriculture for a Sustainable Future.",
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 30.0),

              // Email Address Title
              Container(
                width: 200.0,  // Specify a width for the container
                child: Text(
                  "Email Address",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              SizedBox(height: 8.0),

              // Email Address Input
              Container(
                width: 350.0,  // Specify a width for the container
                padding: EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(color: Colors.grey),
                ),
                child: Row(
                  children: [
                    Icon(Icons.email),
                    SizedBox(width: 12.0),
                    Expanded(
                      child: TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          hintText: "Enter a valid email address",
                          border: InputBorder.none,
                        ),
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (value) {
                          setState(() {
                            _isEmailValid = _isValidEmail(value);
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20.0),

              // Password Title
              Container(
                width: 200.0,  // Specify a width for the container
                child: Text(
                  "Password",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              SizedBox(height: 8.0),

              // Password Input
              Container(
                width: 350.0,  // Specify a width for the container
                padding: EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(color: Colors.grey),
                ),
                child: Row(
                  children: [
                    Icon(Icons.lock),
                    SizedBox(width: 12.0),
                    Expanded(
                      child: TextField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          hintText: "Enter your password",
                          border: InputBorder.none,
                        ),
                        obscureText: true,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20.0),

              // Continue button
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(1.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.green,
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      signUserIn();
                      // Perform actions when Continue button is pressed
                      // For now, just print the email and password
                      print("Email: ${_emailController.text}");
                      print("Password: ${_passwordController.text}");
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green, // Background color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    child: Text(
                      "Continue",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 12.0),

              // "or" text
              Container(
                width: double.infinity,
                child: Text(
                  "or continue with",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black45,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              SizedBox(height: 16.0),

              // Sign up with phone number option
              Container(
                padding: EdgeInsets.all(1.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  border: Border.all(color: Colors.grey),
                ),
                child: Row(
                  children: [
                    SizedBox(width: 20.0),
                    Icon(
                      Icons.phone,
                      color: Colors.green, // Highlighted icon color
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PhoneLoginPage(),
                            ),
                          );
                          // Implement sign up with phone number action
                          print("Phone Number Sign In");
                        },
                        child: Text(
                          "Phone Number Sign In",
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to check if the email is valid using a simple regex pattern
  bool _isValidEmail(String email) {
    String emailPattern = r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$';
    RegExp regExp = RegExp(emailPattern);
    return regExp.hasMatch(email);
  }
}

void main() {
  runApp(MaterialApp(
    home: SignUpPage(),
  ));
}
