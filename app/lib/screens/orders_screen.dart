import 'package:app/models/orders.dart';
import 'package:app/widgets/app_drawer.dart';
import 'package:app/widgets/order_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) => {
          Provider.of<OrdersProvider>(context, listen: false)
              .fetchAndSetOrders()
        });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<OrdersProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Your Orders'),
        ),
        drawer: AppDrawer(),
        body: ListView.builder(
            itemBuilder: (context, index) {
              return OrderItem(order: orderData.orders[index]);
            },
            itemCount: orderData.orders.length));
  }
}
