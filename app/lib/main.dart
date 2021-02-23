import 'package:app/models/cart.dart';
import 'package:app/models/orders.dart';
import 'package:app/screens/cart_screen.dart';
import 'package:app/screens/product_detail_screen.dart';
import 'package:app/screens/products_overview_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/products_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) {
            return ProductsProvider();
          },
        ),
        ChangeNotifierProvider(create: (context) {
          return CartProvider();
        }),
        ChangeNotifierProvider(create: (context) {
          return OrdersProvider();
        })
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'My Shop',
        theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato'),
        home: ProductsOverviewScreen(),
        routes: {
          ProductDetailScreen.routeName: (context) => ProductDetailScreen(),
          CartScreen.routeName: (context) => CartScreen()
        },
      ),
    );
  }
}
