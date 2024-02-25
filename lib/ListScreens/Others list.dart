import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class OtherScreen extends StatefulWidget {
  static const String screenId = 'SScreen';

  @override
  _OtherScreenState createState() => _OtherScreenState();
}

class _OtherScreenState extends State<OtherScreen> {
  final DatabaseReference _databaseReference =
  FirebaseDatabase.instance.reference().child('others');

  List<Map<String, dynamic>> others = [];

  @override
  void initState() {
    super.initState();
    initializeFirebase();
    _loadOthers();
  }

  Future<void> initializeFirebase() async {
    await Firebase.initializeApp();
  }

  Future<void> _loadOthers() async {
    _databaseReference.onValue.listen((event) {
      DataSnapshot snapshot = event.snapshot;
      if (snapshot.value is Map<dynamic, dynamic>) {
        Map<dynamic, dynamic> values =
        snapshot.value as Map<dynamic, dynamic>;
        others.clear(); // Clear the old data
        values.forEach((key, value) {
          if (value is Map<dynamic, dynamic>) {
            others.add(Map<String, dynamic>.from(value));
          }
        });
        setState(() {}); // Update the UI with the fetched data
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Quicksand',
        primarySwatch: myGreen,
      ),
      home: Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Icon(Icons.arrow_back_ios_rounded,
              color: Colors.white,),

          ),
          title: Text('Others',
            style: TextStyle(
              color: Colors.white,
            ),),
          backgroundColor: Colors.green,
        ),
        body: GridView.builder(
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 3 / 4,
          ),
          itemCount: others.length,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: () {
                _showDetailsDialog(others[index]);
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Image.network(
                        others[index]['imageUrl'],
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        others[index]['name'],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showDetailsDialog(Map<String, dynamic> details) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: contentBox(details),
        );
      },
    );
  }

  Widget contentBox(Map<String, dynamic> details) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue, width: 2),
        color: Colors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.network(
              details['imageUrl'],
              width: double.infinity,
              height: 150,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  details['name'],
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Description: ${details['description']}',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 8),
                Text(
                  'Address: ${details['address']}',
                  style: TextStyle(fontSize: 16),
                ),
                // Add other details as needed
              ],
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () {
                  print('Chat button pressed');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                child: Text('Chat'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  print('Close button pressed');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                child: Text('Close'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

MaterialColor myGreen = MaterialColor(
  0xFF4CAF50,
  <int, Color>{
    50: Color(0xFFE8F5E9),
    100: Color(0xFFC8E6C9),
    200: Color(0xFFA5D6A7),
    300: Color(0xFF81C784),
    400: Color(0xFF66BB6A),
    500: Color(0xFF4CAF50),
    600: Color(0xFF43A047),
    700: Color(0xFF388E3C),
    800: Color(0xFF2E7D32),
    900: Color(0xFF1B5E20),
  },
);
