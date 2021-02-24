import 'package:app/models/products_provider.dart';
import 'package:app/screens/edit_product_screen.dart';
import 'package:app/widgets/app_drawer.dart';
import 'package:app/widgets/user_product_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductsProvider>(context);
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
            itemCount: productsData.items.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  UserProductItem(
                    product: productsData.items[index],
                  ),
                  Divider()
                ],
              );
            }),
      ),
    );
  }
}
