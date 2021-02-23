import 'package:app/models/orders.dart';
import 'package:app/widgets/order_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<OrdersProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Your Orders'),
        ),
        body: ListView.builder(
            itemBuilder: (context, index) {
              return OrderItem(order: orderData.orders[index]);
            },
            itemCount: orderData.orders.length));
  }
}
