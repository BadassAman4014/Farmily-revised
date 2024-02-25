import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../ListScreens/Farmingtoolslist.dart';
import '../ListScreens/Fertiliserlist.dart';
import '../ListScreens/Gardening tools list.dart';
import '../ListScreens/Others list.dart';
import '../ListScreens/grocerylist.dart';
import '../ListScreens/seedslist.dart';

class FBCategoryScreen extends StatelessWidget {
  final double logoSize = 100.0;
  static const String screenId = 'Buy';

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(Icons.arrow_back_ios_rounded),
        ),
        backgroundColor: Colors.green,
        title: Text('Purchase Categories'),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 0.85,
        padding: EdgeInsets.all(screenWidth * 0.05),
        mainAxisSpacing: screenWidth * 0.05,
        crossAxisSpacing: screenWidth * 0.05,
        children: <Widget>[
          _buildCategoryTile(context, 'Fertilisers', 'Icons/Fertilisers & Pesticides.png', FertilizerScreen()),
          _buildCategoryTile(context, 'Seeds & Saplings', 'Icons/Seeds & Saplings.png', SeedsScreen()),
          _buildCategoryTile(context, 'Farming Tools', 'Icons/Farming Tools.png', FarmToolsScreen()),
          _buildCategoryTile(context, 'Gardening Tools', 'Icons/Gardening Tools.png', GardenTool()),
          _buildCategoryTile(context, 'Others', 'Icons/Others.png', OtherScreen()),
        ],
      ),
    );
  }

  Widget _buildCategoryTile(BuildContext context, String name, String imagePath, Widget screen) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screen),
        );
      },
      child: FutureBuilder<String?>(
        future: _getImageURL(imagePath),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingTile();
          } else if (snapshot.hasError || snapshot.data == null || snapshot.data!.isEmpty) {
            print('Error loading image: ${snapshot.error}');
            return _buildErrorTile();
          } else {
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(
                    snapshot.data!,
                    width: logoSize,
                    height: logoSize,
                  ),
                  SizedBox(height: 3.0),
                  Text(
                    name,
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildLoadingTile() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildErrorTile() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Center(
        child: Text('Error loading image'),
      ),
    );
  }

  Future<String?> _getImageURL(String imagePath) async {
    try {
      Reference ref = FirebaseStorage.instance.ref().child(imagePath);
      return await ref.getDownloadURL();
    } catch (e) {
      print('Error getting image URL: $e');
      return null;
    }
  }
}
