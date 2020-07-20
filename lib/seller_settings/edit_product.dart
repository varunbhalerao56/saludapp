import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:saludsingapore/models/export_models.dart';
import 'package:provider/provider.dart';
import 'package:saludsingapore/helpers/export_helper.dart';

class EditButton extends StatelessWidget {
  const EditButton({
    Key key,
    this.data,
  }) : super(key: key);

  final Products data;

  @override
  Widget build(BuildContext context) {
    TextEditingController _productImgTextController = TextEditingController(
      text: data.img,
    );
    TextEditingController _productPriceTextController = TextEditingController(
      text: data.price,
    );
    TextEditingController _productNameTextController = TextEditingController(
      text: data.text,
    );
    final linksCollection = Provider.of<ProductCollection>(context);
    final _formKey = GlobalKey<FormState>();

    _displayEditDialog() async {
      return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Update product'),
            content: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  text_input(TextController: _productNameTextController,hintText: "Vodka",labelText: 'Product Name',message: 'Please enter a product name',),
                  text_input(TextController: _productImgTextController,hintText: "URL",labelText: 'Product Image',message: 'Please enter a product image link',),
                  text_input(TextController: _productPriceTextController,hintText: "25.99",labelText: 'Product Price',message: 'Please enter a product price',),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Update'),
                color: Colors.blueAccent,
                onPressed: () {
                  final userChangedTitle =
                      data.text != _productNameTextController.text;
                  final userChangedUrl = data.img != _productImgTextController.text;
                  final userUpdateForm = userChangedTitle || userChangedUrl;

                  if (_formKey.currentState.validate()) {
                    if (userUpdateForm) {
                      // If user updates the form field, send a update request to firebase
                      final newLink = Products(
                        text: _productNameTextController.text,
                        img: _productImgTextController.text,
                        price: _productPriceTextController.text,
                      );
                      linksCollection.collection
                          .document(data.documentId)
                          .updateData(newLink.toMap());
                    } // Else, it closes the dialog without sending a request
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          );
        },
      );
    }

    return IconButton(
      icon: Icon(Icons.edit),
      onPressed: _displayEditDialog,
    );
  }
}


