import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';

import '../Screens/weather_screen.dart';

class WeatherInfoCard extends StatelessWidget {
  final double? temperature;
  final double? windSpeed;
  final double? humidity;
  final String? description;
  final String? cityN;

  WeatherInfoCard({
    required this.temperature,
    required this.windSpeed,
    required this.humidity,
    required this.description,
    required this.cityN,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 370.0,
      margin: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
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
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              image: DecorationImage(
                image: AssetImage('assets/upslide/weatherback3.gif'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Current Weather',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.location_on, color: Colors.black),
                            SizedBox(width: 5),
                            Text(
                              '$cityN',
                              style: TextStyle(fontSize: 16, color: Colors.black),
                            ),
                          ],
                        ),
                        SizedBox(height: 1),
                      ],
                    ),
                    Text(
                      '${_getCurrentDay()}, ${_getCurrentDate()}',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black45),
                    ),
                  ],
                ),
                SizedBox(height: 1),
                Row(
                  children: [
                    Text(
                      '   ${temperature.toString()}°C',
                      style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 8),
                  height: 2,
                  width: 350,
                  color: Colors.black45,
                ),
                Row(
                  children: [
                    SizedBox(width: 15),
                    Padding(
                      padding: EdgeInsets.only(top: 1),
                      child: Text(
                        '${description.toString()}',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getCurrentDay() {
    final DateTime now = DateTime.now();
    final String day = DateFormat('EEE').format(now);
    return day;
  }

  String _getCurrentDate() {
    final DateTime now = DateTime.now();
    final String date = DateFormat('d MMM').format(now);
    return date;
  }
}

class FarmerSlidingScreens extends StatefulWidget {
  const FarmerSlidingScreens({Key? key}) : super(key: key);

  @override
  _FarmerSlidingScreensState createState() => _FarmerSlidingScreensState();
}

class _FarmerSlidingScreensState extends State<FarmerSlidingScreens> {
  final PageController _controller = PageController(initialPage: 0);

  final List<Map<String, dynamic>> _screenImages = [
    {
      'asset': 'assets/upslide/mainpage.gif',
      'width': 400.0,
      'height': 150.0,
      'isGif': false,
    },
    // Add your other screen images here
  ];

  double? currentTemperature;
  double? windSpeed;
  double? humidity;
  String? description;
  String? city;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude, position.longitude);

    String cityName = placemarks.first.locality ?? "";

    final String apiUrl =
        'https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/$cityName?unitGroup=metric&include=days%2Ccurrent%2Cevents%2Calerts&key=8W4N7TWVVDAV27TGEZXP2EK9V&contentType=json';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        final currentConditions = data['currentConditions'];
        currentTemperature = currentConditions['temp'].toDouble();
        windSpeed = currentConditions['windspeed'].toDouble();
        humidity = currentConditions['humidity'].toDouble();
        description = data['days'][0]['description'].toString();
        city = data['address'].toString();

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
      height: 200.0,
      child: PageView.builder(
        controller: _controller,
        scrollDirection: Axis.horizontal,
        itemCount: _screenImages.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index == _screenImages.length) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WeatherScreen(), // Replace WeatherScreen with your actual screen
                  ),
                );
              },
              child: WeatherInfoCard(
                temperature: currentTemperature,
                windSpeed: windSpeed,
                humidity: humidity,
                description: description,
                cityN: city,
              ),
            );
          } else {
            final Map<String, dynamic> imageInfo = _screenImages[index];
            return GestureDetector(
              onTap: () {
                // Handle navigation when an image is tapped
                // Add your onTap logic here
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
          }
        },
      ),
    );
  }
}
