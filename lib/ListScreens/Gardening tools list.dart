import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:url_launcher/url_launcher.dart';

class GardeningTool {
  String name;
  String image;
  String description;
  double price;
  double rentalPrice;
  double contact;
  String contactDetails; // Add this property

  GardeningTool({
    required this.name,
    required this.image,
    required this.description,
    required this.price,
    required this.rentalPrice,
    required this.contact,
    required this.contactDetails, // Initialize it in the constructor
  });
}

class GardenTool extends StatefulWidget {
  static const String screenId = 'Gtools';

  @override
  _GardenToolState createState() => _GardenToolState();
}

class _GardenToolState extends State<GardenTool> {
  final DatabaseReference _databaseReference =
  FirebaseDatabase.instance.reference().child('gardening_tools');

  List<GardeningTool> _tools = [];

  @override
  void initState() {
    super.initState();
    initializeFirebase();
    _loadGardeningTool();
  }

  Future<void> initializeFirebase() async {
    await Firebase.initializeApp();
  }

  Future<void> _loadGardeningTool() async {
    _databaseReference.onValue.listen((event) {
      DataSnapshot snapshot = event.snapshot;
      if (snapshot.value is Map<dynamic, dynamic>) {
        Map<dynamic, dynamic> values =
        snapshot.value as Map<dynamic, dynamic>;
        _tools.clear(); // Clear the old data
        values.forEach((key, value) {
          if (value is Map<dynamic, dynamic>) {
            _tools.add(GardeningTool(
              name: value['equipment'] ?? '',
              image: value['imageUrl'] ?? '',
              description: value['description'] ?? '',
              price: double.tryParse(value['price'].toString()) ?? 0.0,
              rentalPrice: double.tryParse(value['price'].toString()) ?? 0.0,
              contact: double.tryParse(value['contactDetails'].toString()) ?? 0.0,
              contactDetails: value['contactDetails'] ?? '',
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
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.white,
          ),
        ),
        title: Text(
          'Gardening Tools',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.green,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white70, Colors.green],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            childAspectRatio: 85 / 90,
          ),
          itemCount: _tools.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {},
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
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0), // Set the desired radius
                              ),
                            ),
                          ),
                          onPressed: () {
                            launch("https://graphicsackbyaman.myinstamojo.com/product/4634353/shovel-e7162/");
                          },
                          child: Text(
                            'Buy',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white, // Set text color to white
                            ),
                          ),

                        ),
                        Spacer(),
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0), // Set the desired radius
                              ),
                            ),
                          ),
                          onPressed: () {
                            String ownerNum = _tools[index].contact.toStringAsFixed(0);
                            final Uri phoneNumber = Uri.parse('tel:+91$ownerNum');
                            final Uri whatsappLink = Uri.parse('https://wa.me/${phoneNumber.pathSegments.last}?text=I+want+to+Buy/Rent+${_tools[index].name}');
                            launch(whatsappLink.toString());
                          },
                          child:Text(
                            'Rent',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white, // Set text color to white
                            ),
                          ),

                        ),
                        Spacer(),
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0), // Set the desired radius
                              ),
                            ),
                          ),
                          onPressed: () {
                            String ownerPhoneNumber = _tools[index].contact.toString();
                            ownerPhoneNumber = ownerPhoneNumber.replaceAll(RegExp(r'0+$'), '');
                            launch('tel:$ownerPhoneNumber');
                          },
                          child: Text(
                            'Contact',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white, // Set text color to white
                            ),
                          ),

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
      ),
    );
  }
}
