import 'package:flutter/material.dart';
import 'package:farmilyrev/Screens/phone_auth_provider.dart';
import 'package:provider/provider.dart';

class PhoneLoginPage extends StatefulWidget {
  static const String screenId = 'welcome';

  @override
  _PhoneLoginPageState createState() => _PhoneLoginPageState();
}

class _PhoneLoginPageState extends State<PhoneLoginPage> {
  bool _validPhoneNumber = false;
  var _phoneNumberController = TextEditingController();
  String countryCode = "+91";

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    // Function to navigate to the next page
    // void navigateToNextPage() {
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) => DHomePage(),
    //     ),
    //   );
    // }

    return Scaffold(
      appBar: AppBar(
        title: Text("Phone number Login"),
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

              // Phone Number Title
              Container(
                width: 200.0, // Specify a width for the container
                child: Text(
                  "Phone Number",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              SizedBox(height: 8.0),

              // Phone Number Input
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(1.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(color: Colors.grey),
                ),
                child: Row(
                  children: [
                    SizedBox(width: 10.0),
                    Icon(Icons.phone),
                    SizedBox(width: 19.0),
                    Text(
                      countryCode,
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 19,
                      ),
                    ),
                    SizedBox(width: 10.0),
                    Expanded(
                      // Adjust the height as needed
                      child: TextField(
                        controller: _phoneNumberController,
                        decoration: InputDecoration(
                          hintText: "Enter your phone number",
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(top: 20.0),
                        ),
                        autofocus: true,
                        keyboardType: TextInputType.phone,
                        maxLength: 10,
                        onChanged: (value) {
                          // Check if the phone number is valid on each change
                          setState(() {
                            _validPhoneNumber = value.length == 10;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20.0),

              // Continue button
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(1.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color:
                  _validPhoneNumber ? Colors.green : Colors.grey,
                ),
                child: ElevatedButton(
                  onPressed: _validPhoneNumber
                      ? () {
                    String number = '$countryCode${_phoneNumberController.text}';
                    auth.verifyPhone(context, number);
                    print("PHONE NUMBER");
                    print(number);
                    // Navigate to the next page with the phone number
                    //navigateToNextPage();
                  }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _validPhoneNumber ? Colors.green: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  child: Text(
                    _validPhoneNumber ? "Continue" : "Enter Phone Number",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
