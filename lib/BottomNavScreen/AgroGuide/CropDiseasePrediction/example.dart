import 'dart:io';
import 'package:tflite/tflite.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'api/crop_disease_geminiapi.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:get/get.dart';
import 'gemini_results.dart';

class Example extends StatefulWidget {
  @override
  _ExampleState createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  File? _imageFile;
  final ImagePicker _imagePicker = ImagePicker();
  List<dynamic>? _recognitions = [];
  String? _predictedDisease;

  @override
  void initState() {
    super.initState();
    loadModel();
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

  void runInferenceOnImage(XFile? imageFile) async {
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

  }

  void disposeModel() async {
    await Tflite.close();
  }

  void _showModalSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
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
                      _predictedDisease ?? "",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),

                    // Disease Description
                    SizedBox(height: 8),
                    Text(
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin vitae ligula non nunc vestibulum fermentum. Integer id arcu feugiat, tempus elit nec, hendrerit orci.',
                      style: TextStyle(fontSize: 16),
                    ),

                    // Our Guidance
                    SizedBox(height: 16),
                    Container(
                      padding: EdgeInsets.all(12),
                      color: Colors.blue, // Change background color as needed
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
                    SizedBox(height: 8),
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[200], // Change background color as needed
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Medicare (Cure)',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          // Add bullet points for Medicare(Cure) section
                        ],
                      ),
                    ),

                    // CultivationTips section
                    SizedBox(height: 8),
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[200], // Change background color as needed
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Cultivation Tips',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          // Add bullet points for Cultivation Tips section
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
          SizedBox(height: 16),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              title: Text(
                'Disease: ${_predictedDisease ?? 'Upload Image For Disease Detection'}',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              subtitle: Text(
                'Confidence: ${_recognitions?.isNotEmpty == true ? (_recognitions![0]['confidence'] * 100).toStringAsFixed(2) + '%' : ''}',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      return Container(
        margin: EdgeInsets.only(top: 0.04 * MediaQuery.of(context).size.height),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(34),
          child: Image.asset(
            "assets/placeholder_image.png",
            fit: BoxFit.cover,
            height: MediaQuery.of(context).size.height * 0.64,
            width: MediaQuery.of(context).size.width * 0.84,
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
        backgroundColor: Color(0xFF003032),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Scan your plant",
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              margin: EdgeInsets.only(top: 0.04 * MediaQuery.of(context).size.height),
              decoration: BoxDecoration(
                color: Color(0xFF003032),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(20),
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF003032),
                  Colors.white70,
                ],
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
                SizedBox(height: 15),
                FloatingActionButton.extended(
                  onPressed: () {
                    _showImagePickerDialog();
                  },
                  backgroundColor: Color(0xFF003032),
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showModalSheet,
        backgroundColor: Color(0xFF003032),
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
    );
  }
}
