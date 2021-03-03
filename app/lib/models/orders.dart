import 'dart:convert';

import 'package:app/models/cart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Order {
  final String id;
  final double amount;
  final List<Cart> products;
  final DateTime dateTime;

  Order(
      {@required this.id,
      @required this.amount,
      @required this.products,
      @required this.dateTime});
}

class OrdersProvider with ChangeNotifier {
  static const baseUrl =
      'https://my-shop-7f98a-default-rtdb.europe-west1.firebasedatabase.app';

  List<Order> _orders = [];

  List<Order> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    final response = await http.get(baseUrl + '/orders.json');
    final List<Order> loadedOrders = [];
    final data = json.decode(response.body) as Map<String, dynamic>;
    if (data == null) {
      return;
    }
    data.forEach((key, value) {
      loadedOrders.add(Order(
          id: key,
          amount: value['amount'],
          products: (value['products'] as List<dynamic>)
              .map((e) => Cart(
                  id: e['id'],
                  title: e['title'],
                  quantity: e['quantity'],
                  price: e['price']))
              .toList(),
          dateTime: DateTime.parse(value['dateTime'])));
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<Cart> products, double total) async {
    final timeStamp = DateTime.now();
    final response = await http.post(baseUrl + '/orders.json',
        body: json.encode({
          'amount': total,
          'dateTime': timeStamp.toIso8601String(),
          'products': products
              .map((e) => {
                    'id': e.id,
                    'title': e.title,
                    'quantity': e.quantity,
                    'price': e.price
                  })
              .toList()
        }));
    _orders.insert(
        0,
        Order(
            id: json.decode(response.body)['id'],
            amount: total,
            products: products,
            dateTime: timeStamp));
    notifyListeners();
  }
}
