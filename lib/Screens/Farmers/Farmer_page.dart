import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:farmilyrev/BottomNavScreen/AgroGuide/CropDiseasePrediction/main.dart';
import 'package:farmilyrev/BottomNavScreen/CropRecommendation/crop_recommendation.dart';
import 'package:farmilyrev/Forms/AddGrocery.dart';
import 'package:farmilyrev/Screens/Sellers/SellerPage.dart';
import 'package:farmilyrev/Screens/Sellers/Selling%20Category%20screen.dart';
import 'package:farmilyrev/Screens/profile_page.dart';
import 'package:farmilyrev/Screens/weather_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../BottomNavScreen/IOT Monitor/IOT_Monitor.dart';
import '../../Chatbot/geminichatbot.dart';
import '../../Chatbot/inappbot.dart';
import '../../Forms/addtools.dart';
import '../../ListScreens/Farmingtoolslist.dart';
import '../../ListScreens/Fertiliserlist.dart';
import '../../ListScreens/Gardening tools list.dart';
import '../../ListScreens/Others list.dart';
import '../../ListScreens/grocerylist.dart';
import '../../ListScreens/seedslist.dart';
import '../../SlidingScreen/CustomerCatSlider.dart';
import '../../SlidingScreen/CustomerSliderWidget.dart';
import '../../SlidingScreen/Farmer SliderWidget.dart';
import '../../SlidingScreen/Trending_Items.dart';
import 'package:http/http.dart' as http;
import '../Customers/Bcategory.dart';
import '../Customers/Cart.dart';
import 'Farmerbuy Category Tile Screen.dart';
import '../Sellers/my_products_screen.dart';

// Import your other widgets here
class FarmerHomePage extends StatefulWidget {
  @override
  _FarmerHomePageState createState() => _FarmerHomePageState();
}

class _FarmerHomePageState extends State<FarmerHomePage> {
  int _selectedIndex = 0;
  var user = "Aman Raut";
  var contact = "9021600896";
  List<String> categories = ['Farming Tools', 'Seeds & Saplings', 'Fertilisers', 'Gardening Tools', 'Others'];
  List<String> Trendingcategories = ['Gardening  \nAccessories', 'Potash  \nFertiliser', 'Garden Tower', 'All In Once\n Seed Pack', 'Fertiliser'];
  Map<String, dynamic>? weatherData;
  String? warning;
  ValueNotifier<bool> isDialOpen = ValueNotifier(false);
  bool customDialRoot = true;
  bool extend = false;
  bool rmIcons = false;

  @override
  void initState() {
    fetchData();
    // Request notification permission and trigger notification
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
    super.initState();
    fetchData();
    _requestLocationPermission();
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
    triggernotification(message);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      switch (index) {
        case 1: // Index for the "Cart" tab
          Navigator.push(
            context as BuildContext,
            MaterialPageRoute(builder: (context) => MyCart()), // Replace CartPage with the actual name of your cart page class
          ); // Call a method to navigate to the cart page
          break;
        case 2: // Index for the "Cart" tab
          Navigator.push(
            context as BuildContext,
            MaterialPageRoute(builder: (context) => BCategoryScreen()), // Replace CartPage with the actual name of your cart page class
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
        automaticallyImplyLeading: false, // Set to false to remove back button
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
            FarmerSlidingScreens(),
            SizedBox(height: 10),
            CustomerHorizontalCategoriesWidget(
              categories: categories,
              categoryImages: [
                'assets/Catagories/Farming Tools.png',
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
                'assets/FTcat/gtool.jpg',
                'assets/FTcat/fert2.jpg',
                'assets/FTcat/gtool2.jpg',
                'assets/FTcat/vgs.jpg',
                'assets/FTcat/fert3.jpg',
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SpeedDial(
        // animatedIcon: AnimatedIcons.menu_close,
        // animatedIconTheme: IconThemeData(size: 22.0),
        // / This is ignored if animatedIcon is non null
        // child: Text("open"),
        // activeChild: Text("close"),
        backgroundColor: Colors.lightGreenAccent,
        icon: Icons.add,
        activeIcon: Icons.close,
        spacing: 3,
        openCloseDial: isDialOpen,
        childPadding: const EdgeInsets.all(5),
        spaceBetweenChildren: 4,
        // dialRoot: customDialRoot? (ctx, open, toggleChildren) {
        //   return ElevatedButton(
        //     onPressed: toggleChildren,
        //     style: ElevatedButton.styleFrom(
        //       primary: Colors.blue[900],
        //       padding: const EdgeInsets.symmetric(
        //           horizontal: 22, vertical: 18),
        //     ),
        //     child: const Text(
        //       "Custom Dial Root",
        //       style: TextStyle(fontSize: 17),
        //     ),
        //   );
        // } : null,
        buttonSize: Size.fromRadius(30), // SpeedDial size which defaults to 56 itself
        // iconTheme: IconThemeData(size: 22),
        label: extend? const Text("Open") : null, // The label of the main button.
        /// The active label of the main button, Defaults to label if not specified.
        activeLabel: extend ? const Text("Close") : null,

        /// Transition Builder between label and activeLabel, defaults to FadeTransition.
        // labelTransitionBuilder: (widget, animation) => ScaleTransition(scale: animation,child: widget),
        /// The below button size defaults to 56 itself, its the SpeedDial childrens size
        childrenButtonSize: Size.fromRadius(35),
        visible: true,
        direction: SpeedDialDirection.up,
        switchLabelPosition: false,

        /// If true user is forced to close dial manually
        closeManually: false,

        /// If false, backgroundOverlay will not be rendered.
        renderOverlay: true,
        useRotationAnimation: true,

        elevation: 8.0,
        animationCurve: Curves.elasticInOut,
        isOpenOnStart: false,
        animationDuration: const Duration(milliseconds: 500),
        children: [
          SpeedDialChild(
            child: Image.asset(
              'assets/images/chatbot.png',
              width: 50.0, // Adjust the width as needed
              height: 50.0, // Adjust the height as needed
              fit: BoxFit.cover,
            ),
            shape: CircleBorder(),
            backgroundColor: Colors.white60,
            foregroundColor: Colors.white,
            onTap: () {
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
            label: "Chat Bot",
            labelBackgroundColor: Colors.lightGreenAccent,
            // label: 'First',
          ),

          SpeedDialChild(
            child: Image.asset(
              'assets/images/sell.png',
              width: 50.0,
              height: 50.0,
              fit: BoxFit.cover,
            ),
            shape: CircleBorder(),
            backgroundColor: Colors.white60,
            foregroundColor: Colors.white,
            onTap: () {
              _showConfirmationDialog(context, () {
                // Navigate to the Add Grocery page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddGroceryScreen()),
                );
              });
            },
            label: "Sell Groceries",
            labelBackgroundColor: Colors.lightGreenAccent,
          ),

          SpeedDialChild(
            child: Image.asset(
              'assets/images/agroguide.png',
              width: 50.0,
              height: 50.0,
              fit: BoxFit.cover,
            ),
            shape: CircleBorder(),
            backgroundColor: Colors.white60,
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(color: Colors.green, width: 3.0),
                    ),
                    child: Container(
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.white,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'AgroGuide',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.lightGreen,
                            ),
                          ),
                          Divider(  // Add a horizontal line
                            color: Colors.black,
                            thickness: 2,
                            indent: 0,
                            endIndent: 0,
                          ),
                          SizedBox(height: 16.0),
                          ListTile(
                            leading: Icon(Icons.bug_report),
                            title: Text(
                              'Crop Disease Prediction',
                              style: TextStyle(fontSize: 16.0),
                            ),
                            onTap: () {
                              // Add logic for Option 1
                              Navigator.push(context, MaterialPageRoute(builder: (context) => CropDiseasePredictionPage()));
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.search),
                            title: Text(
                              'Crop Recommendation',
                              style: TextStyle(fontSize: 16.0),
                            ),
                            onTap: () {
                              // Add logic for Option 2
                              Navigator.push(context, MaterialPageRoute(builder: (context) => CropRecommendation()));
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.devices),
                            title: Text(
                              'IOT Monitor',
                              style: TextStyle(fontSize: 16.0),
                            ),
                            onTap: () {
                              // Add logic for Option 3
                              Navigator.push(context, MaterialPageRoute(builder: (context) => SensorDataScreen()));
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            label: "AgroGuide",
            labelBackgroundColor: Colors.lightGreenAccent,
          ),



        ],
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 8.0,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        height: 60,
        color: Colors.white70,
        shape: const CircularNotchedRectangle(),
        notchMargin: 5,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(LineIcons.home),  // Create an instance of Icon and pass LineIcons.home
              onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => FarmerHomePage()));
              },
            ),
            IconButton(
              icon: const Icon(
                LineIcons.boxOpen,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyProductsScreen()), // Replace CartPage with the actual name of your cart page class
                );
              },
            ),

            SizedBox(width: 40),

            IconButton(
              icon: const Icon(
                  LineIcons.alternateListAlt,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FBCategoryScreen()), // Replace CartPage with the actual name of your cart page class
                );
              },
            ),
            IconButton(
              icon: const Icon(
                  LineIcons.user,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()), // Replace CartPage with the actual name of your cart page class
                );
              },
            ),
          ],
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
      Navigator.push(context, MaterialPageRoute(builder: (context) => FarmToolsScreen()));
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

void triggernotification(String Message) {
  AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: 10,
      channelKey: 'basic_channel',
      title: 'AgroGuide',
      body: Message, // Use the passed argument here
    ),
  );
}

void _showConfirmationDialog(BuildContext context, Function onConfirm) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white, // Set the background color of the dialog
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.green, width: 3.0), // Set border color and thickness
          borderRadius: BorderRadius.circular(20.0), // Set border radius of the dialog
        ),
        title: Text("Confirmation"),
        content: Text("Do you want to go to the Add Grocery page?"),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.green, backgroundColor: Colors.white, shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0), // Set border radius of the button
              ), // Set text color to green when pressed
            ),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              // Close the dialog and call the onConfirm function
              Navigator.of(context).pop();
              onConfirm();
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.green, backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0), // Set border radius of the button
              ), // Set background color to green
            ),
            child: Text("Confirm"),
          ),
        ],
      );
    },
  );
}






