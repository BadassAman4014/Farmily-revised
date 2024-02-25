import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddFarmingToolsScreen extends StatefulWidget {
  static const String screenId = 'add_farming_tools_screen';

  @override
  _AddFarmingToolsScreenState createState() => _AddFarmingToolsScreenState();
}

class _AddFarmingToolsScreenState extends State<AddFarmingToolsScreen> {
  File? _image;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _selectedEquipment;
  String? _selectedOption;

  List<String> _equipmentList = ['Tractor', 'Plough', 'Hoe', 'Harvester', 'Seeder'];

  List<String> get _optionList => ['Buy', 'Rent'];

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
          return 'Please select an option';
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
                  Text('Tap to select image'),
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
      // TODO: Implement form submission
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Form submitted')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Farming Tools'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _buildImagePicker(context),
                const SizedBox(height: 16.0),
                Text(
                  'Fill out the details below:',
                  style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16.0),
                _buildDropDownField(context, _equipmentList, 'Equipment', _selectedEquipment),
                const SizedBox(height: 16.0),
                _buildDropDownField(context, _optionList, 'Option', _selectedOption),
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
