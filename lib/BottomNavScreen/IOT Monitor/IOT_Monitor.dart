import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class SensorDataScreen extends StatefulWidget {
  @override
  _SensorDataScreenState createState() => _SensorDataScreenState();
}

class _SensorDataScreenState extends State<SensorDataScreen> {
  final DatabaseReference _databaseReference =
  FirebaseDatabase.instance.reference().child('SensorData');

  String temperatureInsight = '';
  String moistureInsight = '';
  String humidityInsight = '';
  String nInsight = '';
  String pInsight = '';
  String kInsight = '';

  @override
  void initState() {
    // Request notification permission and trigger notification
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
    super.initState();
  }

  Widget build(BuildContext context) {
    triggernotification("$moistureInsight\n$temperatureInsight\n$humidityInsight");
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Sensor Data",
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.green,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [ Colors.white70, Colors.green],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: StreamBuilder(
          stream: _databaseReference.onValue,
          builder: (context, snapshot) {
            if (snapshot.hasData &&
                snapshot.data != null &&
                snapshot.data!.snapshot.value != null) {
              var data =
              snapshot.data!.snapshot.value as Map<dynamic, dynamic>?;

              if (data != null) {
                var humidity = data['humidity'];
                var raw_moisture = data['moisture'];
                var moisture = ((1024 - raw_moisture) + 1);
                var moisturePercentage = (moisture / 1024) * 100;
                var temperature = data['temperature'];
                var nValue = data['nValue'];
                var pValue = data['pValue'];
                var kValue = data['kValue'];

                if (temperature > 48) {
                  temperatureInsight = 'Temperature is high.';
                } else {
                  temperatureInsight = 'Temperature is good.';
                }

                if (moisturePercentage > 30 && moisturePercentage < 60) {
                  moistureInsight = 'Well moisturized.';
                } else if (moisturePercentage > 60) {
                  moistureInsight = 'You have Overwatered the plant 💦.';
                } else {
                  moistureInsight = 'Water the plant.';
                }

                if (humidity > 65) {
                  humidityInsight = 'Humidity is high, promote fungal growth.';
                } else {
                  humidityInsight = 'Humidity is good 🌱.';
                }

                if (nValue > 30) {
                  nInsight = 'Nitrogen level is high.';
                } else if (nValue < 15) {
                  nInsight = 'Nitrogen level is low.';
                } else {
                  nInsight = 'Nitrogen level is optimal.';
                }

                if (pValue > 15) {
                  pInsight = 'Phosphorus level is high.';
                } else if (pValue < 8) {
                  pInsight = 'Phosphorus level is low.';
                } else {
                  pInsight = 'Phosphorus level is optimal.';
                }

                if (kValue > 10) {
                  kInsight = 'Potassium level is high.';
                } else if (kValue < 5) {
                  kInsight = 'Potassium level is low.';
                } else {
                  kInsight = 'Potassium level is optimal.';
                }
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      InsightsCard(
                        temperatureInsight: temperatureInsight,
                        moistureInsight: moistureInsight,
                        humidityInsight: humidityInsight,
                        nInsight: nInsight,
                        pInsight: pInsight,
                        kInsight: kInsight,
                      ),
                      SleekSlider(
                        temperature: temperature,
                        humidity: humidity,
                        moisturePercentage: moisturePercentage,
                        nValue: nValue,
                        pValue: pValue,
                        kValue: kValue,
                        temperatureInsight: temperatureInsight,
                        moistureInsight: moistureInsight,
                        humidityInsight: humidityInsight,
                        nInsight: nInsight,
                        pInsight: pInsight,
                        kInsight: kInsight,
                      ),
                    ],
                  ),
                );
              }
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}

class InsightsCard extends StatelessWidget {
  final String temperatureInsight;
  final String moistureInsight;
  final String humidityInsight;
  final String nInsight;
  final String pInsight;
  final String kInsight;

  InsightsCard({
    required this.temperatureInsight,
    required this.moistureInsight,
    required this.humidityInsight,
    required this.nInsight,
    required this.pInsight,
    required this.kInsight,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
        side: BorderSide(color: Colors.green, width: 2.0),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.center,
                child: Text(
                  'Insights',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    'Temperature: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text('$temperatureInsight'),
                ],
              ),
              Row(
                children: [
                  Text(
                    'Moisture: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text('$moistureInsight'),
                ],
              ),
              Row(
                children: [
                  Text(
                    'Humidity: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text('$humidityInsight'),
                ],
              ),
              Row(
                children: [
                  Text(
                    'N Value: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text('$nInsight'),
                ],
              ),
              Row(
                children: [
                  Text(
                    'P Value: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text('$pInsight'),
                ],
              ),
              Row(
                children: [
                  Text(
                    'K Value: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text('$kInsight'),
                ],
              ),
            ],
          ),
        ),
      ),
    );

  }
}

class SleekSlider extends StatelessWidget {
  final dynamic temperature;
  final dynamic humidity;
  final double moisturePercentage;
  final int nValue;
  final int pValue;
  final int kValue;
  final String temperatureInsight;
  final String moistureInsight;
  final String humidityInsight;
  final String nInsight;
  final String pInsight;
  final String kInsight;

  SleekSlider({
    required this.temperature,
    required this.humidity,
    required this.moisturePercentage,
    required this.nValue,
    required this.pValue,
    required this.kValue,
    required this.temperatureInsight,
    required this.moistureInsight,
    required this.humidityInsight,
    required this.nInsight,
    required this.pInsight,
    required this.kInsight,
  });

  Widget buildSliderTile({
    required double initialValue,
    required double minValue,
    required double maxValue,
    required Color trackColor,
    required Color progressBarColor,
    required Color labelColor,
    required String labelText,
    required String insightText,
  }) {
    double modifiedInitialValue = initialValue;

    if (labelText == 'Moisture') {
      if (initialValue == 100) {
        modifiedInitialValue = 0;
      } else if (initialValue == 0) {
        modifiedInitialValue = 100;
      }
    }

    return Card(
      elevation: 5,
      margin: EdgeInsets.all(10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SleekCircularSlider(
                      appearance: CircularSliderAppearance(
                        size: 80,
                        startAngle: 135,
                        angleRange: 270,
                        customWidths: CustomSliderWidths(progressBarWidth: 6),
                        customColors: CustomSliderColors(
                          hideShadow: true,
                          trackColor: trackColor,
                          progressBarColor: progressBarColor,
                          shadowMaxOpacity: 20,
                        ),
                        infoProperties: InfoProperties(
                          modifier: (double value) {
                            if (labelText == 'Temperature') {
                              return '${value.toStringAsFixed(0)}°C';
                            } else {
                              return '${value.toStringAsFixed(0)}%';
                            }
                          },
                        ),
                      ),
                      min: minValue,
                      max: maxValue,
                      initialValue:
                      modifiedInitialValue.clamp(minValue, maxValue),
                      onChange: null,
                    ),
                  ],
                ),
                SizedBox(width: 80),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        insightText,
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Center(
      child: Container(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildSliderTile(
                initialValue: temperature.toDouble(),
                minValue: 0,
                maxValue: 100,
                trackColor: Colors.orange,
                progressBarColor: Colors.deepOrangeAccent,
                labelColor: Colors.orange,
                labelText: 'Temperature',
                insightText: temperatureInsight,
              ),
              buildSliderTile(
                initialValue: humidity.toDouble(),
                minValue: 0,
                maxValue: 100,
                trackColor: Colors.green,
                progressBarColor: Colors.greenAccent,
                labelColor: Colors.green,
                labelText: 'Humidity',
                insightText: humidityInsight,
              ),
              buildSliderTile(
                initialValue: moisturePercentage,
                minValue: 0,
                maxValue: 100,
                trackColor: Colors.blue,
                progressBarColor: Colors.blueAccent,
                labelColor: Colors.blue,
                labelText: 'Moisture',
                insightText: moistureInsight,
              ),
              buildSliderTile(
                initialValue: nValue.toDouble(),
                minValue: 0,
                maxValue: 100,
                trackColor: Colors.red,
                progressBarColor: Colors.deepOrange,
                labelColor: Colors.red,
                labelText: 'N Value',
                insightText: nInsight,
              ),
              buildSliderTile(
                initialValue: pValue.toDouble(),
                minValue: 0,
                maxValue: 100,
                trackColor: Colors.blue,
                progressBarColor: Colors.lightBlue,
                labelColor: Colors.blue,
                labelText: 'P Value',
                insightText: pInsight,
              ),
              buildSliderTile(
                initialValue: kValue.toDouble(),
                minValue: 0,
                maxValue: 100,
                trackColor: Colors.green,
                progressBarColor: Colors.lightGreen,
                labelColor: Colors.green,
                labelText: 'K Value',
                insightText: kInsight,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void triggernotification(String humidityInsight) {
  AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: 10,
      channelKey: 'basic_channel',
      title: 'AgroGuide',
      body: humidityInsight, // Use the passed argument here
    ),
  );
}
