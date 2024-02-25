// import 'package:awesome_notifications/awesome_notifications.dart';
// import 'package:farmilyrev/Screens/SellerPage.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get_navigation/src/root/get_material_app.dart';
// import 'BottomNavScreen/IOT_Monitor.dart';
// import 'BottomNavScreen/OrdersPage.dart';
// import 'BottomNavScreen/crop_recommendation.dart';
// import 'Screens/Customer_page.dart';
// import 'Screens/weather_screen.dart';
// import 'SlidingScreen/CustomerSliderWidget.dart';
// import 'firebase_options.dart';
//
// void main() async {
//   AwesomeNotifications().initialize(
//       null,
//       [NotificationChannel(
//           channelKey: 'basic_channel',
//           channelName: 'Basic notifications',
//           channelDescription: 'Notification channel for basic tests',
//         ),
//       ],
//     debug: true,
//   );
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: CustomerHomePage(),
//     );
//   }
// }
//

// Widget _buildCircularMenu() {
//   return Positioned(
//     top: 620.0,
//     left: 0.0,
//     right: 0.0,
//     child: CircularMenu(
//       alignment: Alignment.bottomCenter,
//       backgroundWidget: Container(
//         height: 80.0, // Adjust the height to cover the bottom navigation bar
//         color: Colors.transparent, // Set a transparent color
//       ),
//       toggleButtonColor: Colors.pink,
//       items: [
//         CircularMenuItem(
//             icon: Icons.home,
//             color: Colors.green,
//             onTap: () {
//               _onCircularMenuItemTapped(0, Colors.green, 'Green');
//             }),
//         CircularMenuItem(
//             icon: Icons.search,
//             color: Colors.blue,
//             onTap: () {
//               _onCircularMenuItemTapped(1, Colors.blue, 'Blue');
//             }),
//         CircularMenuItem(
//             icon: Icons.settings,
//             color: Colors.orange,
//             onTap: () {
//               _onCircularMenuItemTapped(2, Colors.orange, 'Orange');
//             }),
//         CircularMenuItem(
//             icon: Icons.chat,
//             color: Colors.purple,
//             onTap: () {
//               _onCircularMenuItemTapped(3, Colors.purple, 'Purple');
//             }),
//         CircularMenuItem(
//             icon: Icons.notifications,
//             color: Colors.brown,
//             onTap: () {
//               _onCircularMenuItemTapped(4, Colors.brown, 'Brown');
//             })
//       ],
//     ),
//   );
// }
//
//
// void _onCircularMenuItemTapped(int index, Color color, String name) {
//   setState(() {
//     _color = color;
//     _colorName = name;
//     _currentIndex = index;
//   });
// }
//
// void _onBottomNavigationBarItemTapped(int index) {
//   setState(() {
//     _currentIndex = index;
//   });
// }