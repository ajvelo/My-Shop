import 'dart:convert';

import 'package:app/models/products_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.price,
      @required this.imageUrl,
      this.isFavorite = false});

  void _setFavoriteValue(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

  Future<void> toggleFavoriteStatus() async {
    final oldStatus = isFavorite;
    try {
      final response = await http.patch(
          ProductsProvider.baseUrl + '/products/$id.json',
          body: json.encode({'isFavorite': isFavorite}));
      if (response.statusCode >= 400) {
        _setFavoriteValue(oldStatus);
      } else {
        isFavorite = !isFavorite;
        notifyListeners();
      }
    } catch (error) {
      _setFavoriteValue(oldStatus);
    }
  }
}
