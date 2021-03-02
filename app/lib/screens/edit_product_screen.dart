import 'package:app/models/product.dart';
import 'package:app/models/products_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = 'edit-product';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  var _editedProduct =
      Product(id: null, title: '', description: '', price: 0, imageUrl: '');

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    final productId = ModalRoute.of(context).settings.arguments as String;
    if (productId != null) {
      _editedProduct =
          Provider.of<ProductsProvider>(context).findById(productId);
      _imageUrlController.text = _editedProduct.imageUrl;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlFocusNode.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    if (_form.currentState.validate()) {
      _form.currentState.save();
      final provider = Provider.of<ProductsProvider>(context, listen: false);
      if (_editedProduct.id != null) {
        provider.updateProduct(_editedProduct.id, _editedProduct);
      } else {
        try {
          await provider.addProduct(_editedProduct);
        } catch (error) {
          await showDialog<Null>(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('An error occured!'),
                  content: Text(error.toString()),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("Ok"))
                  ],
                );
              });
        } finally {
          setState(() {
            Navigator.of(context).pop();
          });
        }
      }
      // Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
            key: _form,
            child: ListView(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Title'),
                  textInputAction: TextInputAction.next,
                  initialValue: _editedProduct.title,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_priceFocusNode);
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please provide a title';
                    } else {
                      return null;
                    }
                  },
                  onSaved: (newValue) {
                    _editedProduct = Product(
                        id: _editedProduct.id,
                        title: newValue,
                        description: _editedProduct.description,
                        price: _editedProduct.price,
                        isFavorite: _editedProduct.isFavorite,
                        imageUrl: _editedProduct.imageUrl);
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Price'),
                  textInputAction: TextInputAction.next,
                  initialValue: _editedProduct.price.toString(),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  focusNode: _priceFocusNode,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_descriptionFocusNode);
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please provide a price';
                    } else if (double.tryParse(value) == null) {
                      return 'Please provide a valid number';
                    } else if (double.parse(value) <= 0) {
                      return 'Please provide a price greater than zero';
                    } else {
                      return null;
                    }
                  },
                  onSaved: (newValue) {
                    _editedProduct = Product(
                        id: _editedProduct.id,
                        title: _editedProduct.title,
                        description: _editedProduct.description,
                        isFavorite: _editedProduct.isFavorite,
                        price: double.parse(newValue),
                        imageUrl: _editedProduct.imageUrl);
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Description'),
                  initialValue: _editedProduct.description,
                  maxLines: 3,
                  focusNode: _descriptionFocusNode,
                  keyboardType: TextInputType.multiline,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please provide a description';
                    } else {
                      return null;
                    }
                  },
                  onSaved: (newValue) {
                    _editedProduct = Product(
                        id: _editedProduct.id,
                        title: _editedProduct.title,
                        description: newValue,
                        price: _editedProduct.price,
                        isFavorite: _editedProduct.isFavorite,
                        imageUrl: _editedProduct.imageUrl);
                  },
                ),
                SizedBox(
                  height: 32.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        width: 80,
                        height: 200,
                        margin: EdgeInsets.only(top: 8, right: 16.0),
                        decoration: BoxDecoration(
                            border: Border.all(width: 1.0, color: Colors.grey)),
                        child: _imageUrlController.text.isEmpty
                            ? Center(
                                child: Text(
                                  'Enter a URL',
                                  textAlign: TextAlign.center,
                                ),
                              )
                            : FittedBox(
                                child: Image.network(
                                    _editedProduct.imageUrl.isNotEmpty
                                        ? _editedProduct.imageUrl
                                        : _imageUrlController.text),
                                fit: BoxFit.fill,
                              ),
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(labelText: 'Image URL'),
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.done,
                        controller: _imageUrlController,
                        focusNode: _imageUrlFocusNode,
                        onSaved: (newValue) {
                          _editedProduct = Product(
                              id: _editedProduct.id,
                              title: _editedProduct.title,
                              description: _editedProduct.description,
                              isFavorite: _editedProduct.isFavorite,
                              price: _editedProduct.price,
                              imageUrl: newValue.isEmpty
                                  ? "https://upload.wikimedia.org/wikipedia/commons/e/e2/Unknown_toxicity_icon.png"
                                  : newValue);
                        },
                        onFieldSubmitted: (_) {
                          _saveForm();
                        },
                      ),
                    )
                  ],
                )
              ],
            )),
      ),
    );
  }
}
