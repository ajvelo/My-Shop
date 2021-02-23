import 'package:app/models/cart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartItem extends StatelessWidget {
  final Cart cart;
  final String productId;

  CartItem({this.cart, this.productId});
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(cart.id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40.0,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 16.0),
        margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        Provider.of<CartProvider>(context, listen: false).removeItem(productId);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: ListTile(
          leading: CircleAvatar(
            radius: 32,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FittedBox(
                  child: Text(
                "\$${cart.price}",
              )),
            ),
          ),
          title: Text("${cart.title}"),
          subtitle: Text(
              "Total \$${(cart.price * cart.quantity).toStringAsFixed(2)}"),
          trailing: Text('${cart.quantity}x'),
        ),
      ),
    );
  }
}
