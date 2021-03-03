import 'package:app/models/cart.dart';
import 'package:app/models/products_provider.dart';
import 'package:app/screens/cart_screen.dart';
import 'package:app/widgets/app_drawer.dart';
import 'package:app/widgets/badge.dart';
import 'package:app/widgets/products-grid.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum FilterOptions { Favorites, All }

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFavorites = false;

  @override
  void didChangeDependencies() {
    Provider.of<ProductsProvider>(context, listen: false)
        .fetchAndSetProducts()
        .then((loadedProducts) {
      setState(() {
        Provider.of<ProductsProvider>(context, listen: false).items =
            loadedProducts;
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('My Shop'),
          actions: [
            PopupMenuButton(
                onSelected: (FilterOptions selectedValue) {
                  setState(() {
                    if (selectedValue == FilterOptions.Favorites) {
                      _showOnlyFavorites = true;
                    } else {
                      _showOnlyFavorites = false;
                    }
                  });
                },
                icon: Icon(Icons.more_vert),
                itemBuilder: (_) {
                  return [
                    PopupMenuItem(
                      child: Text('Only Favorites'),
                      value: FilterOptions.Favorites,
                    ),
                    PopupMenuItem(
                      child: Text('Show All'),
                      value: FilterOptions.All,
                    )
                  ];
                }),
            Consumer<CartProvider>(
              builder: (context, cart, ch) {
                return Badge(
                  child: ch,
                  value: cart.itemCount.toString(),
                );
              },
              child: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.of(context).pushNamed(CartScreen.routeName);
                },
              ),
            )
          ],
        ),
        drawer: AppDrawer(),
        body: ProductsGrid(showOnlyFavorites: _showOnlyFavorites));
  }
}
