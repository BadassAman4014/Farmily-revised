import 'package:flutter/material.dart';

import '../Screens/Farmers/Farmer_page.dart';

class FarmerPage extends StatelessWidget {
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _livingAddressController = TextEditingController();
  TextEditingController _acresOfLandController = TextEditingController();
  TextEditingController _kisanIdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Farmer Page'),
        backgroundColor: Color(0xffffffff), // Set the app bar color to a hex color
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Add a full-width GIF from assets
            Image.asset(
              'assets/farmer1.gif', // Replace with the actual path to your GIF
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildTextField('Full Name', Icons.person, controller: _fullNameController),
                  SizedBox(height: 10.0),
                  _buildTextField('Living Address', Icons.location_on, controller: _livingAddressController),
                  SizedBox(height: 10.0),
                  _buildTextField('Acres of Land', Icons.landscape, controller: _acresOfLandController, keyboardType: TextInputType.number),
                  SizedBox(height: 10.0),
                  _buildTextField('Yield Type', Icons.layers, controller: null), // Removed dropdown
                  SizedBox(height: 10.0),
                  _buildTextField('Kisan ID Number', Icons.confirmation_number, controller: _kisanIdController, keyboardType: TextInputType.number),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => FarmerHomePage()), // Replace CartPage with the actual name of your cart page class
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

  Widget _buildTextField(String label, IconData icon, {TextEditingController? controller, TextInputType? keyboardType}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: FarmerPage(),
  ));
}