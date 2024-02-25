import 'dart:io';
import 'package:flutter/material.dart';

class GroceryDetailsScreen extends StatelessWidget {
  final String dropdownValue;
  final String name;
  final String address;
  final String contactDetails;
  final String description;
  final File? image;

  const GroceryDetailsScreen({
    required this.dropdownValue,
    required this.name,
    required this.address,
    required this.contactDetails,
    required this.description,
    required this.image,
    required String groceryId,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Grocery Details'), // Replace with your title
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 200.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: image != null
                        ? FileImage(image!)
                        : AssetImage('assets/images/default.jpeg') as ImageProvider<Object>,
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),

              const SizedBox(height: 8.0),
              Text(
                'Categories: $dropdownValue',
                style: const TextStyle(fontSize: 20.0),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16.0),
              Text(
                'Name: $name',
                style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8.0),
              Text(
                'Address: $address',
                style: const TextStyle(fontSize: 20.0),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8.0),
              Text(
                'Contact: $contactDetails',
                style: const TextStyle(fontSize: 20.0),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8.0),
              Text(
                'Description: $description',
                style: const TextStyle(fontSize: 20.0),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}