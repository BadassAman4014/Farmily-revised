import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../Screens/UpdateScreen.dart';

class AddGroceryScreen extends StatefulWidget {
  static const String screenId = 'add_grocery_screen';

  @override
  _AddGroceryScreenState createState() => _AddGroceryScreenState();
}

class _AddGroceryScreenState extends State<AddGroceryScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _contactDetailsController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final DatabaseReference database = FirebaseDatabase.instance.ref();

  String? _selectedDropdownValue;
  File? _image;

  Widget _buildImagePicker(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          'Select an image:',
          style: TextStyle(fontSize: 16.0),
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

  Widget _buildTextField(
      BuildContext context, String label, TextEditingController controller) {
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

  Widget _buildPhoneTextField(
      BuildContext context, String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.phone,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10),
      ],
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
        if (value.length != 10) {
          return 'Some text indicating an error';
        }
        return null;
      },
    );
  }

  Widget _buildDropdownButton(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: _selectedDropdownValue,
      decoration: InputDecoration(
        labelText: 'Categories',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
      items: [
        DropdownMenuItem(
          value: 'Fruits',
          child: Text('Fruits'),
        ),
        DropdownMenuItem(
          value: 'Herbs',
          child: Text('Herbs'),
        ),
        DropdownMenuItem(
          value: 'Vegetables',
          child: Text('Vegetables'),
        ),
        DropdownMenuItem(
          value: 'Nuts',
          child: Text('Nuts'),
        ),
        DropdownMenuItem(
          value: 'Others',
          child: Text('Others'),
        ),
      ],
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Select a category';
        }
        return null;
      },
      onChanged: (value) {
        setState(() {
          _selectedDropdownValue = value;
        });
      },
    );
  }

  void _uploadData() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print("User Null Hai");
      return;
    }

    try {
      String imageUrl = '';
      if (_image != null) {
        final Reference storageReference = FirebaseStorage.instance
            .ref()
            .child('grocery_images')
            .child('${DateTime.now().millisecondsSinceEpoch}.jpg');

        final UploadTask uploadTask = storageReference.putFile(_image!);
        await uploadTask.whenComplete(() async {
          imageUrl = await storageReference.getDownloadURL();
        });
      }

      final DatabaseReference groceryRef =
      FirebaseDatabase.instance.reference().child('groceries').push();

      await groceryRef.set({
        'name': _nameController.text,
        'address': _addressController.text,
        'contactDetails': _contactDetailsController.text,
        'description': _descriptionController.text,
        'category': _selectedDropdownValue!,
        'imageUrl': imageUrl,
        'userId': user.uid,
        'timestamp': ServerValue.timestamp,
      });

      // Navigate to the grocery details screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GroceryDetailsScreen(
            groceryId: groceryRef.key!,
            dropdownValue: _selectedDropdownValue!,
            name: _nameController.text,
            address: _addressController.text,
            contactDetails: _contactDetailsController.text,
            description: _descriptionController.text,
            image: _image,
          ),
        ),
      );
    } catch (error) {
      print('Failed to add grocery: $error');
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _uploadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[600],
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Add Groceries",
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(height: 16.0),
                Text(
                  'Fill in the details:',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16.0),
                _buildImagePicker(context),
                const SizedBox(height: 16.0),
                _buildDropdownButton(context),
                const SizedBox(height: 16.0),
                _buildTextField(context, 'Name', _nameController),
                const SizedBox(height: 16.0),
                _buildTextField(context, 'Address', _addressController),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _contactDetailsController,
                  decoration: InputDecoration(
                    labelText: 'Contact',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(10),
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter a valid phone number';
                    }
                    return null;
                  },
                ),
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
