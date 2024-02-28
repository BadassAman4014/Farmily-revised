import 'package:farmilyrev/Screens/Sellers/SellerPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SellerFormPage extends StatefulWidget {
  @override
  _SellerFormPageState createState() => _SellerFormPageState();
}

class _SellerFormPageState extends State<SellerFormPage> {
  TextEditingController _gstController = TextEditingController();
  TextEditingController _fullNameController = TextEditingController();

  TextEditingController _businessNameController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _businessTypeController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seller Page'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTextField('Email ID', Icons.email),
              SizedBox(height: 10.0),
              _buildPhoneNumberField('Business Phone Number', Icons.phone),
              SizedBox(height: 10.0),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: _buildGSTField('GST Number', Icons.confirmation_number),
                  ),
                  SizedBox(width: 10.0),
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      onPressed: () async {
                        await _fetchGSTData();
                      },
                      child: Text('✔️ Validate'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white, backgroundColor: Colors.green,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              _buildTextField('Full Name', Icons.person, controller: _fullNameController),
              SizedBox(height: 20.0),
              _buildTextField('Business Name', Icons.business, controller: _businessNameController),
              SizedBox(height: 20.0),
              _buildTextField('Address', Icons.location_on, controller: _addressController),
              SizedBox(height: 20.0),
              _buildTextField('Business Type', Icons.business_center, controller: _businessTypeController),
              SizedBox(height: 30.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SellerHomePage()), // Replace CartPage with the actual name of your cart page class
                  ); // Call a method to navigate to the cart page
                  // Add your form submission logic here
                },
                child: Text('Submit'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.green,
                ),
              ),
            ],
          ),
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

  Widget _buildPhoneNumberField(String label, IconData icon) {
    return TextFormField(
      keyboardType: TextInputType.phone,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10),
      ],
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(),
      ),
    );
  }


  bool _isGstValid = true;
  String _errorMessage = '';

  Widget _buildGSTField(String label, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          controller: _gstController,
          inputFormatters: [
            LengthLimitingTextInputFormatter(15),
          ],
          textCapitalization: TextCapitalization.characters,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            labelText: label,
            prefixIcon: Icon(icon),
            border: OutlineInputBorder(),
          ),
        ),
        if (!_isGstValid)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              _errorMessage,
              style: TextStyle(color: Colors.red),
            ),
          ),
      ],
    );
  }

  Future<void> _fetchGSTData() async {
    final String gstNumber = _gstController.text;

    if (gstNumber.isNotEmpty) {
      final String apiUrl = 'https://sheet.gstincheck.co.in/check/05c51dd1c5348c5776a709a8c859d2ac/$gstNumber';

      try {
        final response = await http.get(Uri.parse(apiUrl));

        if (response.statusCode == 200) {
          final Map<String, dynamic> data = json.decode(response.body);

          if (data['flag'] == true) {
            final String fullName = data['data']['lgnm'];
            final String businessName = data['data']['tradeNam'];
            final String address = data['data']['pradr']['adr'];
            final String businessType = data['data']['nba'][0];

            _fullNameController.text = fullName;
            _businessNameController.text = businessName;
            _addressController.text = address;
            _businessTypeController.text = businessType;
          } else {
            // Invalid GST, set validation status and error message
            setState(() {
              _isGstValid = false;
              _errorMessage = data['message'];
            });
          }
        } else {
          // Handle error response
          // ...
        }
      } catch (error) {
        // Handle network or other errors
        // ...
      }
    }
  }

}
