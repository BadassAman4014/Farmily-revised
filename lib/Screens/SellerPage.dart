import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:farmilyrev/Screens/Customer_page.dart';
import 'package:farmilyrev/Screens/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:permission_handler/permission_handler.dart';
import '../BottomNavScreen/IOT Monitor/IOT_Monitor.dart';
import 'OrdersPage.dart';
import '../Chatbot/geminichatbot.dart';
import '../Chatbot/inappbot.dart';
import '../Forms/AddFertilisers.dart';
import '../Forms/AddSeeds.dart';
import '../Forms/addGardeningtools.dart';
import '../Forms/addothers.dart';
import '../Forms/addtools.dart';
import '../SlidingScreen/CustomerCatSlider.dart';
import '../SlidingScreen/SellerCatSlider.dart';
import '../SlidingScreen/CustomerSliderWidget.dart';
import '../SlidingScreen/SellerSliderWidget.dart';
import '../SlidingScreen/Trending_Items.dart';
import 'package:http/http.dart' as http;

import 'Selling Category screen.dart';
import 'Store_page.dart';
import 'my_products_screen.dart';

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

class SellerHomePage extends StatefulWidget {
  @override
  _SellerHomePageState createState() => _SellerHomePageState();
}

class _SellerHomePageState extends State<SellerHomePage> {
  int _selectedIndex = 0;
  var user = "Aman Raut";
  var contact = "9021600896";
  List<String> categories = ['Farming Tools', 'Seeds & Saplings', 'Fertilisers', 'Gardening Tools', 'Others'];
  List<String> Trendingcategories = ['Tomatoes', 'Banana', 'Cabbage', 'Onion', 'Brinjal'];
  Map<String, dynamic>? weatherData;
  String? warning;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Image(
              image: AssetImage('assets/images/logo.jpg'),
              width: 100,
              height: 39,
              fit: BoxFit.cover,
            ),
          ],
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            UserLocationWidget(),
            SellersSlidingScreens(),
            SizedBox(height: 10),
            SellerHorizontalCategoriesWidget(
              categories: categories,
              categoryImages: [
                'assets/add/AddFarming Tools.png',
                'assets/add/AddSeeds & Saplings.png',
                'assets/add/AddFertilisers & Pesticides.png',
                'assets/add/AddGardening Tools.png',
                'assets/add/AddOthers.png',
              ],
              onTap: (index) {
                _navigateToCategoryPage(context, index);
              },
            ),
            SizedBox(height: 5),
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
                color: Colors.blue,
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40,
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
              leading: Icon(Icons.person_2_outlined),
              title: Text('Profile'),
              onTap: () {
                Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()), // Replace CartPage with the actual name of your cart page class
                ); // Call a method to navigate to the cart page
              },
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
                // Add your logic for when Item 3 is tapped
                Navigator.push(context, MaterialPageRoute(builder: (context) => CustomerHomePage()));
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
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 4), // Adjust vertical padding
            child: GNav(
              rippleColor: Colors.grey[300]!,
              hoverColor: Colors.grey[100]!,
              gap: 4, // Adjust gap between tabs
              activeColor: Colors.black,
              iconSize: 20, // Adjust the overall icon size
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8), // Adjust horizontal padding
              duration: Duration(milliseconds: 400),
              tabBackgroundColor: Colors.grey[100]!,
              color: Colors.black,
              tabs: [
                GButton(
                  icon: LineIcons.home,
                  text: 'Home',
                ),
                GButton(
                  icon: LineIcons.alternateList,
                  text: 'Orders',
                ),
                GButton(
                  icon: LineIcons.plusCircle,
                  text: 'Sell',
                  iconSize: 40, // Adjust the icon size for the specific button
                  iconColor: Colors.green,
                ),
                GButton(
                  icon: LineIcons.box,
                  text: 'Products',
                ),
                GButton(
                  icon: LineIcons.alternateStore,
                  text: 'My store',
                ),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });

                // Perform actions based on the selected tab index
                switch (index) {
                  case 0:
                  // Redirect to Home page
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SellerHomePage()));
                    break;
                  case 1:
                  // Navigate to Orders page
                    Navigator.push(context, MaterialPageRoute(builder: (context) => OrdersScreen()));
                    break;
                  case 2:
                  // Navigate to Sell page
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SCategoryScreen()));
                    break;
                  case 3:
                  // Navigate to Products page
                    Navigator.push(context, MaterialPageRoute(builder: (context) => MyProductsScreen()));
                    break;
                  case 4:
                  // Navigate to Profile page
                    Navigator.push(context, MaterialPageRoute(builder: (context) => StorePage()));
                    break;
                }
              },
            ),
          ),
        ),
      ),


      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => InApp(botType: 'InAPP')));
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
      Navigator.push(context, MaterialPageRoute(builder: (context) => AddFarmingToolsScreen()));
      break;
    case 1:
      Navigator.push(context, MaterialPageRoute(builder: (context) => AddSeedsSaplingsScreen()));
      break;
    case 2:
      Navigator.push(context, MaterialPageRoute(builder: (context) => AddFertilisersScreen()));
      break;
    case 3:
      Navigator.push(context, MaterialPageRoute(builder: (context) => AddGardeningToolsScreen()));
      break;
    case 4:
      Navigator.push(context, MaterialPageRoute(builder: (context) => AddOthersScreen()));
      break;
    default:
      break;
  }
}
