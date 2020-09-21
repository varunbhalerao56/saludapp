import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:saludsingapore/models/export_models.dart';
import 'package:provider/provider.dart';
import 'package:saludsingapore/helpers/export_helper.dart';

class AddButton extends StatelessWidget {
  const AddButton({
    Key key,
    this.width,
  }) : super(key: key);
  final double width;

  @override
  Widget build(BuildContext context) {
    final productCollections = Provider.of<ProductCollection>(context);
    TextEditingController _productImgTextController = TextEditingController();
    TextEditingController _productNameTextController = TextEditingController();
    TextEditingController _productPriceTextController = TextEditingController();
    final _formKey = GlobalKey<FormState>();
    _showAddDialog() {
      return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Add Product'),
            content: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  text_input(
                    TextController: _productNameTextController,
                    hintText: "Vodka",
                    labelText: 'Product Name',
                    message: 'Please enter a product name',
                  ),
                  text_input(
                    TextController: _productImgTextController,
                    hintText: "URL",
                    labelText: 'Product Image',
                    message: 'Please enter a product image link',
                  ),
                  text_input(
                    TextController: _productPriceTextController,
                    hintText: "25.99",
                    labelText: 'Product Price',
                    message: 'Please enter a product price',
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                color: Colors.blue,
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    final data = Products(
                      productName: _productNameTextController.text,
                      productImg: _productImgTextController.text,
                      productPrice:
                          double.parse(_productPriceTextController.text),
                      qty: 1,
                    ).toMap();
                    productCollections.collection.add(data);

                    Navigator.of(context).pop();
                  }
                },
                child: Text(
                  'Insert Product',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          );
        },
      );
    }

    return SizedBox(
      width: width,
      child: FlatButton(
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(15.0),
        ),
        padding: EdgeInsets.symmetric(vertical: 20),
        onPressed: () {
          _showAddDialog();
        },
        child: Text(
          'Add Product',
          style: TextStyle(fontSize: 20, color: Colors.greenAccent),
        ),
      ),
    );
  }
}
