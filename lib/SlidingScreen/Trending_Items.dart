import 'package:flutter/material.dart';

class TrendingCategoriesWidget extends StatelessWidget {
  final List<String> Trendingcategories;
  final List<String> TrendingcategoryImages;

  TrendingCategoriesWidget({required this.Trendingcategories, required this.TrendingcategoryImages});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 16.0),
          child: Text(
            'Best Sellers',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 13),
        Container(
          height: 150,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: Trendingcategories.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 18.0, left: 18.0),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Handle category tap
                      },
                      child: Container(
                        width: 110,
                        height: 110,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage(TrendingcategoryImages[index]),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        Trendingcategories[index],
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class TrendingcategoryItem extends StatelessWidget {
  final String name;

  TrendingcategoryItem({required this.name});

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
