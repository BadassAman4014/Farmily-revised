import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';

import '../ListScreens/grocerylist.dart';

class SlidingScreens extends StatefulWidget {
  const SlidingScreens({Key? key}) : super(key: key);

  @override
  _SlidingScreensState createState() => _SlidingScreensState();
}

class _SlidingScreensState extends State<SlidingScreens> {
  final PageController _controller = PageController(initialPage: 0);

  final List<Map<String, dynamic>> _screenImages = [
    {
      'asset': 'assets/recommendation/discount.png',
      'width': 400.0,
      'height': 150.0,
      'isGif': false,
    },
    {
      'asset': 'assets/recommendation/grcoeriesonline.jpg',
      'width': 400.0,
      'height': 150.0,
      'isGif': false,
    },
    {
      'asset': 'assets/recommendation/organic-transformed.jpeg',
      'width': 400.0,
      'height': 150.0,
      'isGif': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    fetchData(); // Fetch data when the widget is initialized
  }

  Future<void> fetchData() async {
    // Fetch the user's current location
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    // Use geocoding to get city name from coordinates
    List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude, position.longitude);

    // Extract city name from the first placemark
    String cityName = placemarks.first.locality ?? "";

    // Construct the API URL with the obtained city name
    final String apiUrl =
        'https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/$cityName?unitGroup=metric&include=days%2Ccurrent%2Cevents%2Calerts&key=8W4N7TWVVDAV27TGEZXP2EK9V&contentType=json';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        // Process the weather data if needed
        // ...

        // Update the state to trigger a rebuild
        setState(() {});
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 210.0,
      child: PageView.builder(
        controller: _controller,
        scrollDirection: Axis.horizontal,
        itemCount: _screenImages.length,
        itemBuilder: (BuildContext context, int index) {
          final Map<String, dynamic> imageInfo = _screenImages[index];
          return GestureDetector(
            onTap: () {
              // Handle image tap
              // For example, navigate to a grocery screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => GroceryScreen()),
              );
            },
            child: Container(
              width: 370.0,
              margin: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(15.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 3,
                    blurRadius: 5,
                    offset: Offset(3, 3),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: imageInfo['isGif']
                    ? Image.asset(
                  imageInfo['asset'],
                  width: imageInfo['width'],
                  height: imageInfo['height'],
                  fit: BoxFit.cover,
                  gaplessPlayback: true,
                )
                    : Image.asset(
                  imageInfo['asset'],
                  width: imageInfo['width'],
                  height: imageInfo['height'],
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}