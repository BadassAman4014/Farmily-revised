import 'package:flutter/material.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.lightBlue,
          ),
        ),

        title: const Text(
          'Orders',
          style: TextStyle(color: AppColors.darkText),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Create and share carts for customers to order with one click',
              style: TextStyle(
                color: AppColors.darkText,
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16.0),
            _buildOrderCategory(
              title: 'ONGOING ORDERS',
              items: [
                _buildOrderItem(
                  title: '0 Pending',
                  subtitle: 'Review your orders to accept them',
                  icon: Icons.hourglass_empty,
                  color: Colors.orange,
                ),
                _buildOrderItem(
                  title: '0 Accepted',
                  subtitle: 'Schedule these orders for pickup',
                  icon: Icons.check_circle_outline,
                  color: Colors.green,
                ),
                _buildOrderItem(
                  title: '0 For pickup',
                  subtitle: 'Keep items ready for pickup',
                  icon: Icons.shopping_bag_outlined,
                  color: Colors.blue,
                ),
                _buildOrderItem(
                  title: '0 In-transit',
                  subtitle: 'Keep a track of your deliveries',
                  icon: Icons.local_shipping_outlined,
                  color: Colors.purple,
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            _buildOrderCategory(
              title: 'PAST ORDERS',
              items: [
                _buildOrderItem(
                  title: 'Delivered, Cancelled & Rejected',
                  subtitle: '0 Orders are delivered to customer',
                  icon: Icons.done_all_outlined,
                  color: Colors.grey,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderCategory({
    required String title,
    required List<Widget> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: AppColors.lightBlue,
            fontSize: 14.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8.0),
        Column(children: items),
      ],
    );
  }

  Widget _buildOrderItem({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return _buildCard(
      ListTile(
        leading: Icon(
          icon,
          color: color,
          size: 32.0,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: AppColors.darkText,
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: AppColors.darkText,
            fontSize: 14.0,
          ),
        ),
        trailing: const Icon(
          Icons.keyboard_arrow_right,
          color: AppColors.lightBlue,
          size: 32.0,
        ),
      ),
    );
  }

  Widget _buildCard(Widget child) {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: child,
    );
  }
}

class AppColors {
  static const backgroundColor = Colors.white;
  static const darkText = Colors.black;
  static const lightBlue = Colors.blue;
}

