import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saludsingapore/models/Products.dart';

class edit_button extends StatelessWidget {
  const edit_button({
    Key key, this.data,
  }) : super(key: key);
  final products data;

  @override
  Widget build(BuildContext context) {
    final productCollection = Provider.of<CollectionReference>(context);
    TextEditingController _productImgTextController = TextEditingController(text: data.img);
    TextEditingController _productNameTextController = TextEditingController(text: data.text);
    TextEditingController _productPriceTextController = TextEditingController(text: data.price);
    final _formKey = GlobalKey<FormState>();
    _showEditDialog() {
      return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Update Product'),
            content: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    controller: _productNameTextController,
                    decoration: InputDecoration(
                        hintText: "Vodka", labelText: "Product Name"),
                    validator: (value) =>
                    value.isEmpty ? 'Please enter some text' : null,
                  ),
                  TextFormField(
                    controller: _productImgTextController,
                    decoration: InputDecoration(
                        hintText: "Image Link", labelText: "Product Image"),
                    validator: (value) =>
                    value.isEmpty
                        ? 'Please enter some text'
                        : null
                  ),
                  TextFormField(
                    controller: _productPriceTextController,
                    decoration: InputDecoration(
                        hintText: "Price", labelText: "Product Price"),
                    validator: (value) =>
                    value.isEmpty ? 'Please enter some text' : null,
                  )
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    final updatedData = products(
                        text: _productNameTextController.text,
                        img: _productImgTextController.text,
                        price: _productPriceTextController.text);
                    productCollection.document(updatedData.documentId).updateData(updatedData.toMap());

                    Navigator.of(context).pop();
                  }
                },
                child: Text(
                  'Update Product',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          );
        },
      );
    }
    return IconButton(
      icon: Icon(Icons.edit),
      onPressed: () {
        _showEditDialog();
      },
    );
  }
}
