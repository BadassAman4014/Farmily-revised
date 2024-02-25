import 'dart:async';
import 'package:farmilyrev/ListScreens/grocerylist.dart';
import 'package:flutter/material.dart';

import '../Screens/Store_page.dart';

class SellersSlidingScreens extends StatefulWidget {
  const SellersSlidingScreens({Key? key}) : super(key: key);

  @override
  _SellersSlidingScreensState createState() => _SellersSlidingScreensState();
}

class _SellersSlidingScreensState extends State<SellersSlidingScreens> {
  final PageController _controller = PageController(initialPage: 0);

  final List<Map<String, dynamic>> _screenImages = [
    {
      'asset': 'assets/recommendation/discount.png',
      'width': 400.0,
      'height': 150.0,
      'isGif': false,
      'destinationPage': GroceryScreen(), // Add the destination page for this image
    },
    {
      'asset': 'assets/recommendation/organic-transformed.jpeg',
      'width': 400.0,
      'height': 150.0,
      'isGif': false,
      'destinationPage': GroceryScreen(), // Add the destination page for this image
    },
    {
      'asset': 'assets/recommendation/grcoeriesonline.jpg',
      'width': 400.0,
      'height': 150.0,
      'isGif': false,
      'destinationPage': GroceryScreen(), // Add the destination page for this image
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 210.0,
      child: PageView.builder(
        controller: _controller,
        scrollDirection: Axis.horizontal,
        itemCount: _screenImages.length,
        itemBuilder: (BuildContext context, int index) {
          final Map<String, dynamic> imageInfo = _screenImages[index];
          return GestureDetector(
            onTap: () {
              // Handle image tap by navigating to the specified destination page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => imageInfo['destinationPage']),
              );
            },
            child: Container(
              width: 370.0,
              margin: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(15.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 3,
                    blurRadius: 5,
                    offset: Offset(3, 3),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: imageInfo['isGif']
                    ? Image.asset(
                  imageInfo['asset'],
                  width: imageInfo['width'],
                  height: imageInfo['height'],
                  fit: BoxFit.cover,
                  gaplessPlayback: true,
                )
                    : Image.asset(
                  imageInfo['asset'],
                  width: imageInfo['width'],
                  height: imageInfo['height'],
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
