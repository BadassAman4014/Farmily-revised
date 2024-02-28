import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyProductsScreen extends StatelessWidget {
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
          "My Products",
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ProductList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add functionality to add a new product
        },
        child: Icon(Icons.add, color: Colors.white), // Set icon color to white
        backgroundColor: Colors.green,
      ),
    );
  }
}

class ProductList extends StatelessWidget {
  final List<Product> products = [
    Product('Apples', 'Fruits', 'Fresh farm apples', 109.99, 'myproducts/image1.jpg', true), // true means online
    Product('Oranges', 'Fruits', 'Fresh and Juicy', 69.99, 'myproducts/image2.jpg', true),
    Product('Carrot', 'Vegetable', 'With Vitamin A D', 29.99, 'myproducts/image3.jpg', true),
    Product('Pumpkin', 'Category B', 'Huge in size', 49.99, 'myproducts/image4.jpg', false),// false means offline
    // Add more products as needed
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        Product product = products[index];

        Color cardColor = product.isOnline ? Color(0xFFE3FFD6) : Color(0xFFEEEDEB); // Set colors based on online/offline status

        return Card(
          elevation: 3,
          margin: EdgeInsets.all(8),
          color: cardColor,
          child: Stack(
            children: [
              ListTile(
                contentPadding: EdgeInsets.all(16),
                title: Text(
                  product.name,
                  style: TextStyle(
                    color: Colors.black, // Set text color to black for both online and offline products
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Category: ${product.category}'),
                    Text('Description: ${product.description}'),
                    Text(
                      'Price: ${NumberFormat.currency(symbol: '\₹', decimalDigits: 2).format(product.price)}',
                    ),
                  ],
                ),
                leading: Container(
                  width: 120,
                  height: 120,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      'assets/${product.image}',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                onTap: () {
                  // Add functionality for when the item is clicked
                },
              ),
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: product.isOnline ? Colors.red : Colors.grey,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.sell_outlined, size: 16, color: Colors.white),
                      SizedBox(width: 4),
                      Text(
                        product.isOnline ? 'Live' : 'Offline',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

}

class Product {
  final String name;
  final String category;
  final String description;
  final double price;
  final String image;
  final bool isOnline;

  Product(this.name, this.category, this.description, this.price, this.image, this.isOnline);
}