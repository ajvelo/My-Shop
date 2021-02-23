import 'dart:math';

import 'package:flutter/material.dart';
import 'package:app/models/orders.dart';
import 'package:intl/intl.dart';

class OrderItem extends StatefulWidget {
  final Order order;

  OrderItem({this.order});

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          ListTile(
            title: Text('\$${widget.order.amount}'),
            subtitle: Text(DateFormat('EEE, MMMM yyyy')
                .add_Hm()
                .format(widget.order.dateTime)),
            trailing: IconButton(
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          if (_expanded)
            Container(
              padding: const EdgeInsets.all(16.0),
              height: min(widget.order.products.length * 20.0 + 64.0, 100),
              child: ListView.builder(
                  itemBuilder: (context, index) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.order.products[index].title,
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "${widget.order.products[index].quantity}x \$${widget.order.products[index].price}",
                          style: TextStyle(fontSize: 18.0, color: Colors.grey),
                        )
                      ],
                    );
                  },
                  itemCount: widget.order.products.length),
            )
        ],
      ),
    );
  }
}
