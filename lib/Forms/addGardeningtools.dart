import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class AddGardeningToolsScreen extends StatefulWidget {
  static const String screenId = 'add_gardening_tools_screen';

  @override
  _AddGardeningToolsScreenState createState() => _AddGardeningToolsScreenState();
}

class _AddGardeningToolsScreenState extends State<AddGardeningToolsScreen> {
  File? _image;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final DatabaseReference database = FirebaseDatabase.instance.ref();

  String? _selectedEquipment;
  String? _selectedOption;

  final TextEditingController _enteredPriceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _contactDetailsController = TextEditingController();

  List<String> _equipmentList = [
    'Lawn Mower',
    'Hedge Trimmer',
    'Pruner',
    'Rake',
    'Shovel',
  ];

  List<String> _optionList = [
    'Buy',
    'Rent',
  ];

  Widget _buildDropDownField(BuildContext context, List<String> options, String label, String? value) {
    return DropdownButtonFormField<String>(
      value: value,
      items: options.map((option) {
        return DropdownMenuItem<String>(
          value: option,
          child: Text(option),
        );
      }).toList(),
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
      onChanged: (String? value) {
        setState(() {
          if (label == 'Equipment') {
            _selectedEquipment = value;
          } else if (label == 'Option') {
            _selectedOption = value;
          }
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Select an option';
        }
        return null;
      },
    );
  }

  Widget _buildImagePicker(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          'Select an image:',
          style: const TextStyle(fontSize: 16.0),
        ),
        const SizedBox(height: 8.0),
        InkWell(
          onTap: () async {
            final pickedFile = await ImagePicker().getImage(
              source: ImageSource.gallery, // or ImageSource.camera
            );
            if (pickedFile != null) {
              setState(() {
                _image = File(pickedFile.path);
              });
            }
          },
          child: Container(
            height: 150.0,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: _image == null
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_a_photo,
                    size: 40.0,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 8.0),
                  Text('Tap to select an image.'),
                ],
              ),
            )
                : Image.file(_image!),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(BuildContext context, String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Some text indicating an error';
        }
        return null;
      },
    );
  }

  Widget _buildIntField(BuildContext context, String label, TextEditingController enteredPriceController) {
    return TextFormField(
      controller: _enteredPriceController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Phone number is required';
        }

        // Validate if the entered value is a valid integer
        try {
          int.parse(value);
        } catch (e) {
          return 'Enter a valid phone number';
        }

        return null;
      },
    );
  }

  Future<String> uploadImageToStorage() async {
    try {
      if (_image != null) {
        Reference storageReference = FirebaseStorage.instance.ref().child('images/${DateTime.now().toString()}');
        UploadTask uploadTask = storageReference.putFile(_image!);
        await uploadTask.whenComplete(() => null);

        String imageUrl = await storageReference.getDownloadURL();

        return imageUrl;
      } else {
        return '';
      }
    } catch (e) {
      print('Error uploading image: $e');
      return '';
    }
  }

  void _uploadData() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print("User Null Hai");
      return;
    }

    try {
      String imageUrl = await uploadImageToStorage();

      final DatabaseReference gardentoolsRef = database.child('gardening_tools').push();

      await gardentoolsRef.set({
        'equipment': _selectedEquipment,
        'option': _selectedOption,
        'contactDetails': _contactDetailsController.text,
        'description': _descriptionController.text,
        'imageUrl': imageUrl,
        'price': _enteredPriceController.text,
        'userId': user.uid,
        'timestamp': ServerValue.timestamp,
      });
    } catch (error) {
      print('Failed to add Tools: $error');
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_formKey.currentState!.validate()) {
        _uploadData();
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Form submitted')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Gardening Tools'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _buildImagePicker(context),
                const SizedBox(height: 16.0),
                Text(
                  'Fill in the details:',
                  style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16.0),
                _buildDropDownField(context, _equipmentList, 'Equipment', _selectedEquipment),
                const SizedBox(height: 16.0),
                _buildDropDownField(context, _optionList, 'Option', _selectedOption),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _contactDetailsController,
                  decoration: InputDecoration(
                    labelText: 'Contact Details',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(10),
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Contact details are required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                _buildIntField(context, 'Price', _enteredPriceController),
                const SizedBox(height: 16.0),
                _buildTextField(context, 'Description', _descriptionController),
                const SizedBox(height: 32.0),
                ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Colors.green, // Set text color to white
                  ),
                  child: Text('Submit'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
