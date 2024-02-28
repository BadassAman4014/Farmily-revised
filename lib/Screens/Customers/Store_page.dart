import 'package:flutter/material.dart';
import 'package:flutter_echarts/flutter_echarts.dart';

class StorePage extends StatefulWidget {
  const StorePage({Key? key}) : super(key: key);

  @override
  _StorePageState createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  bool acceptingOrders = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Store'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Store information section
            Card(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Store logo placeholder
                    Container(
                      width: 80,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[300],
                      ),
                      child: const Icon(Icons.add_a_photo, size: 40),
                    ),
                    const SizedBox(width: 16),
                    // Store name and location
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Aman Raut',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            'Wanadongri ct, Maharashtra',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                          // Preview and share buttons
                          Row(
                            children: [
                              const Text(
                                'Rating : ⭐⭐⭐⭐',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Accepting orders toggle switch
            const SizedBox(height: 5),
            Card(
              child: ListTile(
                title: Text(
                  'Accepting Orders',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: Switch(
                  value: acceptingOrders,
                  onChanged: (value) {
                    // Update the state of accepting orders when the switch is toggled
                    setState(() {
                      acceptingOrders = value;
                    });
                  },
                ),
              ),
            ),

            // Your customers section
            const SizedBox(height: 5),
            Card(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Your customers',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Purchased and followed counts
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              const Text(
                                '0',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Text(
                                'Purchased',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              const Text(
                                '0',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Text(
                                'Followed',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 5),
            // Grow your store section
  //           Card(
  //               child:Container(
  //                 child: Echarts(
  //                   option: '''
  //   {
  //     xAxis: {
  //       type: 'category',
  //       data: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
  //     },
  //     yAxis: {
  //       type: 'value'
  //     },
  //     series: [{
  //       data: [820, 932, 901, 934, 1290, 1330, 1320],
  //       type: 'line'
  //     }]
  //   }
  // ''',
  //                 ),
  //                 width: 300,
  //                 height: 250,
  //               )
  //           ),
            Card(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Grow your store',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Coupons & discounts, Store highlights, and Personalized carts options
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildOption(
                          imagePath: 'assets/images/coupon.png',
                          label: 'Coupons &\ndiscounts',
                        ),
                        const SizedBox(width: 20),
                        _buildOption(
                          imagePath: 'assets/images/storehighlight.png',
                          label: 'Store\nhighlights',
                        ),
                        const SizedBox(height: 10),
                        _buildOption(
                          imagePath: 'assets/images/carts.png',
                          label: 'Personalized\ncarts',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // Bottom navigation bar
    );
  }

  // A helper method to build an option widget
  Widget _buildOption({required String imagePath, required String label}) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          child: Image.asset(
            imagePath,
            width: 20,
            height: 20,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black, // Set text color to black
          ),
          textAlign: TextAlign.center, // Center align the text
        ),
      ],
    );
  }

}
