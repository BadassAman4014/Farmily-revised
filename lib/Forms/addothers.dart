import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddOthersScreen extends StatefulWidget {
  static const String screenId = 'add_fertilisers_screen';

  @override
  _AddOthersScreenState createState() => _AddOthersScreenState();
}

class _AddOthersScreenState extends State<AddOthersScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  File? _image;

  Widget _buildImagePicker(BuildContext context) {
    return Column(
      children: <Widget>[
        const Text(
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
                  const Text('Tap to select image'),
                ],
              ),
            )
                : Image.file(_image!),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(BuildContext context, String label) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Form submitted')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Seeds/Saplings'),
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
                const Text(
                  'Fill out the details below:',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16.0),
                _buildImagePicker(context),
                const SizedBox(height: 16.0),
                _buildTextField(context, 'Name'),
                const SizedBox(height: 16.0),
                _buildTextField(context, 'Type'),
                const SizedBox(height: 16.0),
                _buildTextField(context, 'Price'),
                const SizedBox(height: 16.0),
                _buildTextField(context, 'Description'),
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
