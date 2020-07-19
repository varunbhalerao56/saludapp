import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saludsingapore/main.dart';
import 'package:saludsingapore/models/Products.dart';


class EditButton extends StatelessWidget {
  const EditButton({
    Key key,
    this.data,
  }) : super(key: key);

  final products data;

  @override
  Widget build(BuildContext context) {
    TextEditingController _imageTextController = TextEditingController(
      text: data.img,
    );
    TextEditingController _priceTextController = TextEditingController(
      text: data.price,
    );
    TextEditingController _titleTextController = TextEditingController(
      text: data.text,
    );
    final linksCollection = Provider.of<CollectionReference>(context);
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
                  TextFormField(
                    validator: (value) =>
                    value.isEmpty ? 'Please enter a Product name' : null,
                    controller: _titleTextController,
                    decoration: InputDecoration(
                      hintText: "Vodka",
                      labelText: 'Title',
                    ),
                  ),
                  TextFormField(
                    validator: (value) =>
                    value.isEmpty ? 'Please enter a url' : null,
                    controller: _imageTextController,
                    decoration: InputDecoration(
                      hintText: "Img Link",
                      labelText: 'URL',
                    ),
                  ),
                  TextFormField(
                    validator: (value) =>
                    value.isEmpty ? 'Please enter a price' : null,
                    controller: _priceTextController,
                    decoration: InputDecoration(
                      hintText: "25.99",
                      labelText: 'Price',
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Update'),
                color: Colors.blueAccent,
                onPressed: () {
                  final userChangedTitle =
                      data.text != _titleTextController.text;
                  final userChangedUrl = data.img != _imageTextController.text;
                  final userUpdateForm = userChangedTitle || userChangedUrl;

                  if (_formKey.currentState.validate()) {
                    if (userUpdateForm) {
                      // If user updates the form field, send a update request to firebase
                      final newLink = products(
                        text: _titleTextController.text,
                        img: _imageTextController.text,
                        price: _imageTextController.text,
                      );
                      linksCollection
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


