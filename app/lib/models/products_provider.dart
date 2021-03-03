import 'dart:convert';

import 'package:app/models/product.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductsProvider with ChangeNotifier {
  static const baseUrl =
      'https://my-shop-7f98a-default-rtdb.europe-west1.firebasedatabase.app';

  List<Product> _items = [];

  set items(List<Product> value) {
    _items = value;
    notifyListeners();
  }

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((product) => product.isFavorite).toList();
  }

  void refreshProductList() {
    notifyListeners();
  }

  Future<List<Product>> fetchAndSetProducts() async {
    try {
      final response = await http.get(baseUrl + '/products.json');
      final data = json.decode(response.body) as Map<String, dynamic>;
      if (data == null) {
        return null;
      }
      final List<Product> loadedProducts = [];
      data.forEach((key, value) {
        loadedProducts.add(Product(
            id: key,
            title: value['title'],
            description: value['description'],
            price: value['price'],
            imageUrl: value['imageUrl'],
            isFavorite: value['isFavorite']));
      });
      return loadedProducts;
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addProduct(Product product) async {
    try {
      final response = await http.post(baseUrl + '/products.json',
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
            'isFavorite': product.isFavorite
          }));
      final newProduct = Product(
          id: json.decode(response.body)['name'],
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl);
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product product) async {
    final index = _items.indexWhere((element) => element.id == id);
    if (index >= 0) {
      try {
        await http.patch(baseUrl + '/products/$id.json',
            body: json.encode({
              'title': product.title,
              'description': product.description,
              'imageUrl': product.imageUrl,
              'price': product.price,
            }));
        _items[index] = product;
        notifyListeners();
      } catch (error) {
        throw error;
      }
    }
  }

  Future<void> deleteProduct(String id) async {
    http.delete(baseUrl + '/products/$id.json');
    _items.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  Product findById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }
}
