import 'package:app/models/product.dart';
import 'package:app/models/products_provider.dart';
import 'package:app/screens/edit_product_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserProductItem extends StatelessWidget {
  final Product product;

  UserProductItem({this.product});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(product.title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(product.imageUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.routeName,
                    arguments: product.id);
              },
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  Provider.of<ProductsProvider>(context, listen: false)
                      .deleteProduct(product.id);
                },
                color: Theme.of(context).errorColor),
          ],
        ),
      ),
    );
  }
}
