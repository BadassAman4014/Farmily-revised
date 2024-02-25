import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:farmilyrev/Screens/SellerPage.dart';
import 'package:farmilyrev/Screens/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:permission_handler/permission_handler.dart';
import '../Chatbot/geminichatbot.dart';
import '../Chatbot/inappbot.dart';
import '../ListScreens/Fertiliserlist.dart';
import '../ListScreens/Gardening tools list.dart';
import '../ListScreens/Others list.dart';
import '../ListScreens/grocerylist.dart';
import '../ListScreens/seedslist.dart';
import '../SlidingScreen/CustomerCatSlider.dart';
import '../SlidingScreen/CustomerSliderWidget.dart';
import '../SlidingScreen/Trending_Items.dart';
import 'package:http/http.dart' as http;

import 'Bcategory.dart';
import 'Cart.dart';

// Import your other widgets here

class UserInformationWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var user = "Aman Raut";
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hello $user',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class UserLocationWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        UserInformationWidget(),
        Text('Wanadongri, Nagpur', style: TextStyle(fontSize: 14, color: Colors.grey)),
      ],
    );
  }
}

class CustomerHomePage extends StatefulWidget {
  @override
  _CustomerHomePageState createState() => _CustomerHomePageState();
}

class _CustomerHomePageState extends State<CustomerHomePage> {
  int _selectedIndex = 0;
  var user = "Aman Raut";
  var contact = "9021600896";
  List<String> categories = ['Grocery', 'Seeds & Saplings', 'Fertilisers', 'Gardening Tools', 'Others'];
  List<String> Trendingcategories = ['Tomatoes', 'Banana', 'Cabbage', 'Onion', 'Brinjal'];
  Map<String, dynamic>? weatherData;
  String? warning;

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
    fetchData();
  }

  Future<void> _requestLocationPermission() async {
    var status = await Permission.location.request();
    if (status == PermissionStatus.granted) {
      fetchData();
    } else {
      // Handle case when permission is denied
      print('Location permission denied');

    }
  }

  Future<void> fetchData() async {
    String message= '';
    //location
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    // Use geocoding to get city name from coordinates
    List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude, position.longitude);

    // Extract city name from the first placemark
    String cityName = placemarks.first.locality ?? "";

    try {
      final response = await http.get(Uri.parse(
          'https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/$cityName?unitGroup=metric&include=days%2Ccurrent%2Cevents%2Calerts&key=8W4N7TWVVDAV27TGEZXP2EK9V&contentType=json'));

      if (response.statusCode == 200) {
        setState(() {
          weatherData = json.decode(response.body);
          message = weatherData!['currentConditions']['conditions'];
          message ='Weather Conditions: $message through out the day';
          print(message);
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
    //triggernotification(message);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      switch (index) {
        case 1: // Index for the "Cart" tab
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MyCart()), // Replace CartPage with the actual name of your cart page class
          ); // Call a method to navigate to the cart page
          break;
        case 2: // Index for the "Cart" tab
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => BCategoryScreen()), // Replace CartPage with the actual name of your cart page class
          ); // Call a method to navigate to the cart page
          break;
        case 3: // Index for the "Cart" tab
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProfilePage()), // Replace CartPage with the actual name of your cart page class
          ); // Call a method to navigate to the cart page
          break;
      // Add cases for other tabs if needed
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Image(
              image: AssetImage('assets/images/logo.jpg'),
              width: 100,  // Set the desired width
              height: 39, // Set the desired height
              fit: BoxFit.cover, // Adjust the fit as needed
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              UserLocationWidget(),
              SlidingScreens(),
              SizedBox(height: 10),
              CustomerHorizontalCategoriesWidget(
                categories: categories,
                categoryImages: [
                  'assets/Catagories/Grocery.png',
                  'assets/Catagories/Seeds & Saplings.png',
                  'assets/Catagories/Fertilisers & Pesticides.png',
                  'assets/Catagories/Gardening Tools.png',
                  'assets/Catagories/Others.png',
                ],
                onTap: (index) {
                  _navigateToCategoryPage(context, index);
                },
              ),
              SizedBox(height: 10),
              TrendingCategoriesWidget(
                Trendingcategories: Trendingcategories,
                TrendingcategoryImages: [
                  'assets/Tcat/totatoees.jpg',
                  'assets/Tcat/banana.jpg',
                  'assets/Tcat/cabbage.jpg',
                  'assets/Tcat/onion.jpg',
                  'assets/Tcat/brinjal.jpg',
                ],
              ),
            ],
          ),
        ),
      endDrawer: Drawer(
        // Your right-side drawer content goes here
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.green,
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundImage: AssetImage('assets/images/Profile.png'),
                  ),
                  SizedBox(width: 25),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$user',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                        ),
                      ),
                      Text(
                        '$contact',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('About Us'),
              onTap: () {
                // Add your logic for when Item 1 is tapped
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.share),
              title: Text('Share'),
              onTap: () {
                // Add your logic for when Item 2 is tapped
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.support),
              title: Text('Support'),
              onTap: () {
                // Add your logic for when Item 4 is tapped
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Log Out'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => SellerHomePage()));
                // Add your logic for when Item 3 is tapped
              },
            ),
            // Add more items as needed
          ],
        ),
      ),


      bottomNavigationBar: Container(
        // Your existing bottom navigation bar code
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
              // Your existing bottom navigation bar code
              rippleColor: Colors.grey[300]!,
              hoverColor: Colors.grey[100]!,
              gap: 8,
              activeColor: Colors.black,
              iconSize: 24,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              duration: Duration(milliseconds: 400),
              tabBackgroundColor: Colors.grey[100]!,
              color: Colors.black,
              tabs: [
                GButton(
                  icon: LineIcons.home,
                  text: 'Home',
                ),
                GButton(
                  icon: LineIcons.shoppingCart,
                  text: 'Cart',
                ),
                GButton(
                  icon: LineIcons.alternateListAlt,
                  text: 'Categories',
                ),
                GButton(
                  icon: LineIcons.user,
                  text: 'Profile',
                ),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: _onItemTapped,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
                child: Container(
                  color: Theme.of(context).canvasColor,
                  height: 200.0, // Adjusted height for better spacing
                  child: Stack(
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          // Heading for the pop-up with adjusted padding
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0, bottom: 8.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.chat,
                                  color: Colors.green, // Set the desired color
                                  size: 24.0, // Set the desired size
                                ),
                                SizedBox(width: 8.0), // Add some space between the icon and text
                                Text(
                                  'Select Assistance Type',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            // Add a Divider below the text
                            color: Colors.black26,
                            thickness: 1.0,
                            height: 40.0,
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: ListTile(
                                  contentPadding: EdgeInsets.all(8.0),
                                  leading: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.support_agent_rounded,
                                      color: Colors.green, // Set the desired color
                                    ),
                                  ),
                                  title: const Text('Chat 1'),
                                  subtitle: const Text('General ChatBot'),
                                  onTap: () {
                                    Navigator.pop(context);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const HomePage(botType: 'Family'),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Expanded(
                                child: ListTile(
                                  contentPadding: EdgeInsets.all(8.0),
                                  leading: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.phonelink_setup_rounded,
                                      color: Colors.green, // Set the desired color
                                    ),
                                  ),
                                  title: const Text('Chat 2'),
                                  subtitle: const Text('In App Support'),
                                  onTap: () {
                                    Navigator.pop(context);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const InApp(botType: 'InAPP'),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Positioned(
                        top: 8.0,
                        right: 16.0,
                        child: IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        backgroundColor: Colors.white,
        child:
          Image.asset('assets/images/chatbot.png',
          width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
      ),
    );
  }
}

void _navigateToCategoryPage(BuildContext context, int index) {
  // Navigate to the respective page based on the category index
  // For simplicity, using a switch statement. You can modify it based on your page navigation logic.
  switch (index) {
    case 0:
      Navigator.push(context, MaterialPageRoute(builder: (context) => GroceryScreen()));
      break;
    case 1:
      Navigator.push(context, MaterialPageRoute(builder: (context) => SeedsScreen()));
      break;
    case 2:
      Navigator.push(context, MaterialPageRoute(builder: (context) => FertilizerScreen()));
      break;
    case 3:
      Navigator.push(context, MaterialPageRoute(builder: (context) => GardenTool()));
      break;
    case 4:
      Navigator.push(context, MaterialPageRoute(builder: (context) => OtherScreen()));
      break;
    default:
      break;
  }
}