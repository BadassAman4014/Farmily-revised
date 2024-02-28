import 'package:flutter/material.dart';

import '../Screens/Customers/Customer_page.dart';

class CustomerFormPage extends StatelessWidget {
  TextEditingController _customerNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _deliveryAddressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer Page'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Add a full-width GIF from assets
            Image.asset(
              'assets/customer_text.gif', // Replace with the actual path to your GIF
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildTextField('Customer Name', Icons.person, controller: _customerNameController),
                  SizedBox(height: 10.0),
                  _buildTextField('Email ID', Icons.email, controller: _emailController),
                  SizedBox(height: 10.0),
                  _buildTextField('Delivery Address', Icons.location_on, controller: _deliveryAddressController),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CustomerHomePage()), // Replace CartPage with the actual name of your cart page class
                      );
                    },
                    child: Text('Submit'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.green,
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

  Widget _buildTextField(String label, IconData icon, {TextEditingController? controller}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(),
      ),
    );
  }
}