import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isOnline = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              // Implement edit profile functionality
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.green,
                    width: 4,
                  ),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage('assets/images/Profile.png'),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Aniket Shahu',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.green,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Farmer',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.green,
                ),
              ),
              SizedBox(height: 10),
              _buildInfoCard('Contact Information', Icons.mail, [
                'aniketshahu@gemail.com',
                '+919370373334',
                '@aniketshahu', // Add social media links
              ]),
              _buildInfoCard('Farm Details', Icons.landscape, [
                'Green Fields Farm',
                'Rural Area, Country',
                '100 acres',
                'Wheat, Corn, Soybeans',
              ]),

              _buildOnlineSwitch(),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, IconData icon, List<String> details) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: Colors.green,
                ),
                SizedBox(width: 10),
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: details
                  .map((detail) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.arrow_right,
                      color: Colors.green,
                      size: 16,
                    ),
                    SizedBox(width: 5),
                    Text(
                      detail,
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOnlineSwitch() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.power_settings_new,
          color: Colors.green,
          size: 30,
        ),
        SizedBox(width: 10),
        Text(
          'Online Status:',
          style: TextStyle(fontSize: 18, color: Colors.green),
        ),
        SizedBox(width: 10),
        Switch(
          value: isOnline,
          onChanged: (value) {
            setState(() {
              isOnline = value;
            });
          },
          activeTrackColor: Colors.lightGreenAccent,
          activeColor: Colors.green,
        ),
        Text(
          isOnline ? 'Online' : 'Offline',
          style: TextStyle(fontSize: 18, color: Colors.green),
        ),
      ],
    );
  }
}
