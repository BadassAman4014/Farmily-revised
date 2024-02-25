import 'package:flutter/material.dart';

import '../Forms/customerform.dart';
import '../Forms/farmer.dart';
import '../Forms/seller_form.dart';


class PortalScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PortalPage(),
    );
  }
}

class PortalPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFA8DF8E).withOpacity(0.8), Color(0xFFE5FCF5)],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 100),
            Center(
              child: Column(
                children: [
                  Text(
                    'Select your preference',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Text(
                    'Select the role that best describes you',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontStyle: FontStyle.italic,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  Positioned(
                    top: screenHeight / 20,
                    left: 6,
                    child: Material(
                      elevation: 4, // Set the elevation value as needed
                      shape: CircleBorder(),
                      child: CircularButton(
                        imagePath: 'assets/farmer.png',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => FarmerPage()),
                          );
                          // Add functionality for User button press
                          print('Farmer button pressed');
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    top: screenHeight / 4.8,
                    right: 6,
                    child: Material(
                      elevation: 4, // Set the elevation value as needed
                      shape: CircleBorder(),
                      child: CircularButton(
                        imagePath: 'assets/customer.png',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => CustomerFormPage()),
                          );
                          // Add functionality for Business button press
                          print('Customer button pressed');
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    top: screenHeight / 2.6,
                    left: 10,
                    child: Material(
                      elevation: 4, // Set the elevation value as needed
                      shape: CircleBorder(),
                      child: CircularButton(
                        imagePath: 'assets/seller.png',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SellerFormPage()),
                          );
                          // Add functionality for Student button press
                          print('Seller button pressed');
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CircularButton extends StatelessWidget {
  final String imagePath;
  final VoidCallback? onPressed;

  CircularButton({required this.imagePath,  this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 160.0,
        height: 160.0,
        margin: EdgeInsets.all(8.0),
        child: ClipOval(
          child: Stack(
            children: [
              Image.asset(
                imagePath,
                width: 170.0,
                height: 170.0,
                fit: BoxFit.cover,
              ),
          ]
          ),
        ),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
      ),
    );
  }
}



