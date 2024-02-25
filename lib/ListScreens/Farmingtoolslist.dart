import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Screens/Ftool detail page.dart';

class FarmingTool {
  String name;
  String image;
  String description;
  double price;
  double rentalPrice;

  FarmingTool({
    required this.name,
    required this.image,
    required this.description,
    required this.price,
    required this.rentalPrice,
  });
}

class FarmToolsScreen extends StatefulWidget {
  static const String screenId = 'Ftools';

  @override
  _FarmToolsScreenState createState() => _FarmToolsScreenState();
}

class _FarmToolsScreenState extends State<FarmToolsScreen> {
  final DatabaseReference _databaseReference =
  FirebaseDatabase.instance.reference().child('farming_tools');

  List<FarmingTool> _tools = [];

  @override
  void initState() {
    super.initState();
    initializeFirebase();
    _loadFarmingTools();
  }

  Future<void> initializeFirebase() async {
    await Firebase.initializeApp();
  }

  Future<void> _loadFarmingTools() async {
    _databaseReference.onValue.listen((event) {
      DataSnapshot snapshot = event.snapshot;
      if (snapshot.value is Map<dynamic, dynamic>) {
        Map<dynamic, dynamic> values = snapshot.value as Map<dynamic, dynamic>;
        _tools.clear(); // Clear the old data
        values.forEach((key, value) {
          if (value is Map<dynamic, dynamic>) {
            _tools.add(FarmingTool(
              name: value['equipment'] ?? '',
              image: value['imageUrl'] ?? '',
              description: value['description'] ?? '',
              price: double.tryParse(value['price'].toString()) ?? 0.0,
              rentalPrice: double.tryParse(value['price'].toString()) ?? 0.0,
            ));
          }
        });
        setState(() {}); // Update the UI with the fetched data
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Farming Tools",
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          childAspectRatio: 85 / 90,
        ),
        itemCount: _tools.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () { },
            child: Card(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Image.network(
                      _tools[index].image,
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    _tools[index].name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Price for Selling: \u20B9 ${_tools[index].price}',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Price for Renting: \u20B9 ${_tools[index].rentalPrice}/day',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Spacer(),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                        ),
                        onPressed: () {
                          launch("https://example.com/buy-link"); // Replace with your buy link
                        },
                        child: Text('Buy'),
                      ),
                      Spacer(),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ToolDetails(tool: _tools[index]),
                            ),
                          );
                        },
                        child: Text('Rent'),
                      ),
                      Spacer(),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                        ),
                        onPressed: () {
                          // Implement contact functionality
                        },
                        child: Text('Contact'),
                      ),
                      Spacer(),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
