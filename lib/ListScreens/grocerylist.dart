import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:url_launcher/url_launcher.dart';

class GroceryScreen extends StatefulWidget {
  static const String screenId = 'Gscreen';

  @override
  _GroceryScreenState createState() => _GroceryScreenState();
}

class _GroceryScreenState extends State<GroceryScreen> {
  final DatabaseReference _databaseReference =
  FirebaseDatabase.instance.reference().child('groceries');

  List<Map<String, dynamic>> groceries = [];

  @override
  void initState() {
    super.initState();
    initializeFirebase();
    _loadGroceries();
  }

  Future<void> initializeFirebase() async {
    await Firebase.initializeApp();
  }

  Future<void> _loadGroceries() async {
    _databaseReference.onValue.listen((event) {
      DataSnapshot snapshot = event.snapshot;
      if (snapshot.value is Map<dynamic, dynamic>) {
        Map<dynamic, dynamic> values =
        snapshot.value as Map<dynamic, dynamic>;
        groceries.clear(); // Clear the old data
        values.forEach((key, value) {
          if (value is Map<dynamic, dynamic>) {
            groceries.add(Map<String, dynamic>.from(value));
          }
        });
        setState(() {}); // Update the UI with the fetched data
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Icon(Icons.arrow_back_ios_rounded,
              color: Colors.white,),

          ),
          title: Text('Grocery',
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
          itemCount: groceries.length,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: () {
                _showDetailsDialog(groceries[index]);
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
                        groceries[index]['imageUrl'],
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        groceries[index]['name'],
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
        border: Border.all(color: Colors.green, width: 4),
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
                  print('Buy button pressed');
                  launch('https://graphicsackbyaman.myinstamojo.com/product/4634312/jowar-4e9fc/');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, // Set background color to green
                ),
                child: Text(
                  'Buy',
                  style: TextStyle(
                    color: Colors.white, // Set text color to white
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  print('Close button pressed');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, // Set background color to green
                ),
                child: Text(
                  'Close',
                  style: TextStyle(
                    color: Colors.white, // Set text color to white
                  ),
                ),
              ),
            ],
          )

        ],
      ),
    );
  }
}

