import 'package:flutter/material.dart';

class CustomerHorizontalCategoriesWidget extends StatelessWidget {
  final List<String> categories;
  final List<String> categoryImages;
  final Function(int) onTap;

  CustomerHorizontalCategoriesWidget({
    required this.categories,
    required this.categoryImages,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 16.0),
          child: Text(
            'Categories',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(categories.length, (index) {
              return Padding(
                padding: const EdgeInsets.only(right: 18.0, left: 18.0),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        onTap(index);
                      },
                      child: Container(
                        width: 65,
                        height: 65,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage(categoryImages[index]),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      categories[index],
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}

class CategoryItem extends StatelessWidget {
  final String name;

  CategoryItem({required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.blue,
      ),
      constraints: BoxConstraints(
        maxWidth: 100.0,
        maxHeight: 100.0,
      ),
      child: Center(
        child: Text(
          name,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
