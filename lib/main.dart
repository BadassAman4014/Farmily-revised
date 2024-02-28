import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:farmilyrev/Screens/Sellers/SellerPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:provider/provider.dart';
import 'BottomNavScreen/AgroGuide/CropDiseasePrediction/main.dart';
import 'BottomNavScreen/IOT Monitor/IOT_Monitor.dart';
import 'Screens/Sellers/OrdersPage.dart';
import 'BottomNavScreen/CropRecommendation/crop_recommendation.dart';
import 'Screens/Farmers/Farmer_page.dart';
import 'Screens/phone_auth_provider.dart';
import 'Screens/splashscreen.dart';
import 'Screens/weather_screen.dart';
import 'SlidingScreen/CustomerSliderWidget.dart';
import 'firebase_options.dart';

void main() async {
  AwesomeNotifications().initialize(
      null,
      [NotificationChannel(
          channelKey: 'basic_channel',
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel for basic tests',
        ),
      ],
    debug: true,
  );
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()), // Provide AuthProvider
        // Add any other providers you need
      ],
      child: const MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Farmily',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: SplashScreen(),
    );
  }
}

