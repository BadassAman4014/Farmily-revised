import 'package:flutter/material.dart';

import 'Bcategory.dart';
import 'Selling Category screen.dart';

class MyCart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Add back button functionality here
            Navigator.pop(context);
          },
        ),
        title: Text('Review Cart'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Add search button functionality here
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              Center(
                child: Image.asset(
                  'assets/images/Ecart.png', // Replace with your image asset path
                  width: 250.0, // Adjust the width as needed
                  height: 250.0, // Adjust the height as needed
                ),
              ),
              Text(
                'Your cart is empty',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
          SizedBox(height: 25.0),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0,vertical: 50),
            child: Container(
              width: double.infinity, // Makes the button span the width of the screen
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => BCategoryScreen()));
                  // Add functionality to navigate to the store or perform an action
                  // For example, you can use Navigator.push to navigate to another page
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, // Set the background color to green
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0), // Adjust the radius as needed
                  ),
                ),
                child: Text(
                  'Go To Store',
                  style: TextStyle(
                    color: Colors.white, // Set the text color to white
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
