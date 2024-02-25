import 'dart:io';
import 'package:tflite/tflite.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'api/crop_disease_geminiapi.dart';
import 'gemini_results.dart';

class CropDiseasePredictionPage extends StatefulWidget {
  @override
  _CropDiseasePredictionPageState createState() => _CropDiseasePredictionPageState();
}

class _CropDiseasePredictionPageState extends State<CropDiseasePredictionPage> {
  File? _imageFile;
  final ImagePicker _imagePicker = ImagePicker();
  List<dynamic>? _recognitions = [];
  String? _predictedDisease;
  String location = "India";
  String? _medicareDescription;
  String? _cultivationTipsDescription;

  @override
  void initState() {
    super.initState();
    loadModel();
    String? _cultivationTipsDescription;
  }

  @override
  void dispose() {
    disposeModel();
    super.dispose();
  }

  String extractDiseaseName(String label) {
    List<String> parts = label.split(" ");
    if (parts.length > 1) {
      return parts.sublist(1).join(" ");
    } else {
      return label;
    }
  }

  void loadModel() async {
      String modelPath = 'assets/TFModels/model_unquant.tflite';
    String labelsPath = 'assets/TFModels/labels.txt';

    await Tflite.loadModel(
      model: modelPath,
      labels: labelsPath,
    );
  }

  Future<void> runInferenceOnImage(XFile? imageFile) async {
    if (imageFile == null) {
      print("Image File is null");
      return;
    }

    print("Image Path: ${imageFile.path}");

    var recognitions = await Tflite.runModelOnImage(
      path: imageFile.path,
      numResults: 5,
      threshold: 0.2,
    );

    print("Recognitions: $recognitions");

    setState(() {
      _imageFile = File(imageFile.path);
      _recognitions = recognitions;
      if (recognitions != null && recognitions.isNotEmpty) {
        _predictedDisease = extractDiseaseName(recognitions[0]['label']);
      } else {
        _predictedDisease = null;
      }
    });

    // Get Gemini API description
    String description = await GeminiAPI.getGeminiData(
      "I am a farmer from $location. My crop is suffering from $_predictedDisease. Please provide the output only about - Plant Disease Description (4 lines): Give a concise paragraph describing the cause, symptoms, and conditions provoking the specified crop disease.",
    );

    // Get Gemini API description for "Medicare (Cure)"
    _medicareDescription = await GeminiAPI.getGeminiData(
      "I am a farmer from $location. My crop is suffering from $_predictedDisease. Please provide the output only about - Medicare (Cure) (5 numbered points with only content): Provide accurate and appropriate measures and medications for treating plants affected by the specified disease.",
    );

    // Get Gemini API description for "Cultivation Tips"
    _cultivationTipsDescription = await GeminiAPI.getGeminiData(
      "I am a farmer from $location. My crop is suffering from $_predictedDisease. Please provide the output only about - Cultivation Tips (6 numbered points ): Offer cultivation tips to help users prevent the occurrence of the diagnosed disease in their crops. Additionally, provide advice on how to safeguard other plants from being affected and prevent the disease from spreading further.",
    );

    // Show the result as a bottom sheet
    _showModalSheet(description: description);
  }

  void disposeModel() async {
    await Tflite.close();
  }

  // Function to remove ** symbols from the text and make it bold
  String removeAsterisksAndBold(String text) {
    // Replace "**" with an empty string and wrap the text in bold tags
    return '**$text**'.replaceAll('**', '');
  }

  // Function to show the result as a bottom sheet
  void _showModalSheet({required String description}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          maxChildSize: 0.75,
          initialChildSize: 0.25,
          minChildSize: 0.25,
          builder: (BuildContext context, ScrollController scrollController) {
            return Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Highlighted and bold disease name
                    Text(
                      "Predicted Disease :-" +_predictedDisease! ?? "",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),

                    // Disease Description
                    SizedBox(height: 8),
                    Text(
                      description,
                      style: TextStyle(fontSize: 16),
                    ),

                    // Our Guidance
                    SizedBox(height: 30),
                    Container(
                      padding: EdgeInsets.all(12),
                      color: Color(0xFF003032), // Change background color as needed
                      child: Text(
                        'Our Guidance',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    // Medicare(Cure) section
                    SizedBox(height: 30),
                    Container(
                      height: 120, // Set the desired height for the card
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          Container(
                            width: 160, // Set the desired width for the card
                            child: _buildSectionCard(
                              title: 'Medicare (Cure)',
                              image: "assets/icons/hand.png",
                              onTap: () {
                                // Handle onTap for Medicare (Cure)
                                print('Medicare (Cure) tapped');
                                _showMedicareDescription();
                              },
                            ),
                          ),
                          SizedBox(width: 24),
                          Container(
                            width: 160, // Set the desired width for the card
                            child: _buildSectionCard(
                              title: 'Cultivation Tips',
                              image: "assets/icons/organic.png", // Add icon for Cultivation Tips
                              onTap: () {
                                // Handle onTap for Cultivation Tips
                                print('Cultivation Tips tapped');
                                _showCultivationTipsDescription();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
  Widget _buildImagePicker() {
    if (_imageFile != null) {
      return Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 0.04 * MediaQuery.of(context).size.height),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.file(
                _imageFile!,
                height: MediaQuery.of(context).size.height * 0.64,
                width: MediaQuery.of(context).size.width * 0.84,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 10),
        ],
      );
    } else {
      return Container(
        margin: EdgeInsets.only(top: 0.04 * MediaQuery.of(context).size.height),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(34),
          child: Image.asset(
            "assets/icons/placeholder_image.png",
            fit: BoxFit.cover,
            height: MediaQuery.of(context).size.height * 0.60,
            width: MediaQuery.of(context).size.width * 0.80,
          ),
        ),
      );
    }
  }

  Future<void> _pickImage() async {
    final imageSource = await showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Select Image Source"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, ImageSource.camera),
            child: Text("Camera"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, ImageSource.gallery),
            child: Text("Gallery"),
          ),
        ],
      ),
    );

    if (imageSource != null) {
      final imageFile = await _imagePicker.pickImage(source: imageSource);

      if (imageFile != null) {
        setState(() {
          _imageFile = File(imageFile.path);
        });

        runInferenceOnImage(imageFile);
      }
    }
  }

  Future<void> _showImagePickerDialog() async {
    final imageSource = await showDialog<ImageSource>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Select Image"),
          content: Text("Choose how to select your image"),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Color(0xFF003032),
              ),
              onPressed: () {
                _pickImageFromSource(ImageSource.camera);
                Navigator.pop(context);
              },
              child: Text("Camera"),
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Color(0xFF003032),
              ),
              onPressed: () {
                _pickImageFromSource(ImageSource.gallery);
                Navigator.pop(context);
              },
              child: Text("From Gallery"),
            ),
          ],
        );
      },
    );

    if (imageSource != null) {
      final imageFile = await _imagePicker.pickImage(source: imageSource);
      runInferenceOnImage(imageFile);
    }
  }

  Future<void> _pickImageFromSource(ImageSource source) async {
    final pickedFile = await _imagePicker.getImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });

      runInferenceOnImage(XFile(pickedFile.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Scan Your Plant",
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.green,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              margin: EdgeInsets.only(top: 0.04 * MediaQuery.of(context).size.height),
              decoration: BoxDecoration(
                color: Color(0xFFA8DF8E),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(20),
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [ Colors.white70, Colors.green],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),
          Center(
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    _pickImage();
                  },
                  child: _buildImagePicker(),
                ),
                SizedBox(height: 10),
                FloatingActionButton.extended(
                  onPressed: () {
                    _showImagePickerDialog();
                  },
                  backgroundColor: Colors.green,
                  icon: Icon(
                    Icons.image_outlined,
                    color: Colors.white,
                    size: 40,
                  ),
                  label: Text(
                    "Select Image",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  // Function to show Medicare (Cure) description
  void _showMedicareDescription() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          maxChildSize: 0.75,
          initialChildSize: 0.25,
          minChildSize: 0.25,
          builder: (BuildContext context, ScrollController scrollController) {
            return Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Highlighted and bold disease name
                    Text(
                      'Medicare (Cure)',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),

                    // Medicare (Cure) Description
                    SizedBox(height: 8),
                    Text(
                      _medicareDescription ?? "",
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }


  // Function to show Cultivation Tips description
  void _showCultivationTipsDescription() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          maxChildSize: 0.75,
          initialChildSize: 0.25,
          minChildSize: 0.25,
          builder: (BuildContext context, ScrollController scrollController) {
            return Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Highlighted and bold disease name
                    Text(
                      'Cultivation Tips',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),

                    // Cultivation Tips Description
                    SizedBox(height: 8),
                    Text(
                      _cultivationTipsDescription ?? "",
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }


  Widget _buildSectionCard({
    required String title,
    required String image,
    required Function onTap,
  }) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              image,
              height: 40,
              width: 40,
            ),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
