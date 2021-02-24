import 'package:app/models/product.dart';
import 'package:flutter/material.dart';

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
                return;
              },
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  return;
                },
                color: Theme.of(context).errorColor),
          ],
        ),
      ),
    );
  }
}
