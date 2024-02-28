import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:get/get.dart';
import '../../Screens/Farmers/CropRecommendationResultPage.dart';
import 'package:farmilyrev/BottomNavScreen/CropRecommendation/api/gemini.dart';

class CropRecommendation extends StatefulWidget {
  @override
  _CropRecommendationState createState() => _CropRecommendationState();
}

class _CropRecommendationState extends State<CropRecommendation> {
  final TextEditingController nController = TextEditingController();
  final TextEditingController pController = TextEditingController();
  final TextEditingController kController = TextEditingController();
  final TextEditingController tempController = TextEditingController();
  final TextEditingController humidityController = TextEditingController();
  final TextEditingController phController = TextEditingController();
  final TextEditingController rainfallController = TextEditingController();

  var predValue = "";
  var predictedCrop = "";
  var errorMessages = Map<String, String>();
  var loading = false;

  @override
  void initState() {
    super.initState();
    predValue = "Click predict button";
  }

  Widget buildTextField(
      String label, TextEditingController controller, String hintText) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: label,
              hintText: hintText,
              filled: true,
              fillColor: Colors.white,
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent, width: 2.0),
                borderRadius: BorderRadius.circular(8.0),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent, width: 2.0),
                borderRadius: BorderRadius.circular(8.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 2.0),
                borderRadius: BorderRadius.circular(8.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF003032), width: 2.0),
                borderRadius: BorderRadius.circular(8.0),
              ),
              labelStyle:
              TextStyle(color: Colors.black), // Set label text color
              hintStyle:
              TextStyle(color: Colors.black), // Set hint text color
              // You can also customize other TextField styles as needed
            ),
            style: TextStyle(color: Colors.black), // Set input text color
            controller: controller,
          ),
          if (errorMessages[label] != null)
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                errorMessages[label]!,
                style: TextStyle(color: Colors.red, fontSize: 12.0),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> predData() async {
    RxString result = ''.obs;
    setState(() {
      errorMessages = {};
      loading = true;
    });

    if (nController.text.isEmpty) {
      setState(() {
        errorMessages["Nitrogen"] = "Field cannot be empty";
      });
    }
    if (pController.text.isEmpty) {
      setState(() {
        errorMessages["Phosphorus"] = "Field cannot be empty";
      });
    }
    if (kController.text.isEmpty) {
      setState(() {
        errorMessages["Potassium"] = "Field cannot be empty";
      });
    }
    if (tempController.text.isEmpty) {
      setState(() {
        errorMessages["Temperature"] = "Field cannot be empty";
      });
    }
    if (humidityController.text.isEmpty) {
      setState(() {
        errorMessages["Humidity"] = "Field cannot be empty";
      });
    }
    if (phController.text.isEmpty) {
      setState(() {
        errorMessages["pH value"] = "Field cannot be empty";
      });
    }
    if (rainfallController.text.isEmpty) {
      setState(() {
        errorMessages["Rainfall"] = "Field cannot be empty";
      });
    }

    if (errorMessages.isNotEmpty) {
      setState(() {
        loading = false;
      });
      return;
    }

    final interpreter =
    await Interpreter.fromAsset('crop_recommendation_model.tflite');

    double n = double.tryParse(nController.text) ?? 0.0;
    double p = double.tryParse(pController.text) ?? 0.0;
    double k = double.tryParse(kController.text) ?? 0.0;
    double temperature = double.tryParse(tempController.text) ?? 0.0;
    double humidity = double.tryParse(humidityController.text) ?? 0.0;
    double ph = double.tryParse(phController.text) ?? 0.0;
    double rainfall = double.tryParse(rainfallController.text) ?? 0.0;

    var input = [[n, p, k, temperature, humidity, ph, rainfall]];
    print(input);
    var output = List.filled(22, 0).reshape([1, 22]);
    print(output);
    interpreter.run(input, output);

    int predictedClass = output[0]
        .indexOf(output[0].reduce((a, b) => (a as double) > (b as double) ? a : b));

    List<String> labels = [
      "Apple",
      "Banana",
      "Blackgram",
      "Chickpea",
      "Coconut",
      "Coffee",
      "Cotton",
      "Grapes",
      "Jute",
      "Kidneybeans",
      "Lentil",
      "Maize",
      "Mango",
      "Mothbeans",
      "Mungbean",
      "Muskmelon",
      "Orange",
      "Papaya",
      "Pigeonpeas",
      "Pomegranate",
      "Rice",
      "Watermelon"
    ];

    predictedCrop = labels[predictedClass];

    print("Predicted class index: $predictedClass");
    print("Predicted crop: $predictedCrop");

    setState(() {
      predValue = predictedCrop;
    });
    String location = "Nagpur";
    result.value = await GeminiAPI.getGeminiData(
        "I am a farmer based in $location where in my soil the Nitrogen value is $n, " +
            "phosphorus is $p, potassium is $k. The Average temperature is $temperature, " +
            "humidity is $humidity, and the ph value of the soil is $ph. " +
            "The rainfall is $rainfall. As a farmer considering the time of the year, " +
            "I have decided to grow $predictedCrop. Provide me a full professional guide " +
            "to grow this crop efficiently considering my soil conditions and weather."
    );

    setState(() {
      loading = false;
    });

    // Navigate to ResultPage with the result
    await Get.to(ResultPage(result: result.value, predictedCrop: predictedCrop));
  }

  Future<void> fetchData() async {
    // Add your logic to fetch data here
    print("Fetch Data button is pressed.");

    // Assuming you have some predefined values for the text boxes
    nController.text = "25"; // Replace with your actual value
    pController.text = "15"; // Replace with your actual value
    kController.text = "10"; // Replace with your actual value
    tempController.text = "28"; // Replace with your actual value
    humidityController.text = "70"; // Replace with your actual value
    phController.text = "6.5"; // Replace with your actual value
    rainfallController.text = "800"; // Replace with your actual value
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
          "Crop Recommendation",
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [ Colors.white70, Colors.green],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    buildTextField("Nitrogen", nController, ""),
                    buildTextField("Phosphorus", pController, ""),
                    buildTextField("Potassium", kController, ""),
                    buildTextField("Temperature", tempController, ""),
                    buildTextField("Humidity", humidityController, ""),
                    buildTextField("pH value", phController, ""),
                    buildTextField("Rainfall", rainfallController, ""),
                    SizedBox(height: 20.0),
                    Container(
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: fetchData,
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.lightGreen,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Text(
                                '  Fetch  ',
                                style: TextStyle(fontSize: 22.0),
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: predData,
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.lightGreen,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Text(
                                'Predict',
                                style: TextStyle(fontSize: 22.0),
                              ),
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
          if (loading)
            Center(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  color: Colors.transparent,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/loading.gif', // Update with your actual file path
                        width: 200, // Adjust width as needed
                        height: 200, // Adjust height as needed
                      ),
                      //SizedBox(height: 10),
                      Text(
                        'Loading...',
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
