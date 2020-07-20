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
    final productCollections = Provider.of<ProductCollection>(context) ;
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
                  text_input(TextController: _productNameTextController,hintText: "Vodka",labelText: 'Product Name',message: 'Please enter a product name',),
                  text_input(TextController: _productImgTextController,hintText: "URL",labelText: 'Product Image',message: 'Please enter a product image link',),
                  text_input(TextController: _productPriceTextController,hintText: "25.99",labelText: 'Product Price',message: 'Please enter a product price',),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    final data = Products(
                        text: _productNameTextController.text,
                        img: _productImgTextController.text,
                        price: _productPriceTextController.text)
                        .toMap();
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



final databaseReference = Firestore.instance;
void createRecordS() async {
  await Firestore.instance.collection("bundles").document("6 bottle bundle").setData(
    {
      'text': 'Tequila',
      'img':
      'https://firebasestorage.googleapis.com/v0/b/saludapp-63b42.appspot.com/o/ImageVert%2FTequilaVert.jpg?alt=media&token=404544aa-0efd-47bd-a9a2-1f0e1971bc54',
      'price': '24.99'
    },
  );
}

final a = [
  {
    'text': 'Vodka',
    'img':
    'https://firebasestorage.googleapis.com/v0/b/saludapp-63b42.appspot.com/o/ImageVert%2FVodkaVert.jpg?alt=media&token=03662c8d-eee5-4c69-804b-2bbad6a1754e',
    'price': '24.99'
  },
  {
    'text': 'Gin',
    'img':
    'https://firebasestorage.googleapis.com/v0/b/saludapp-63b42.appspot.com/o/ImageVert%2FGinVert.jpg?alt=media&token=a95c684f-86a2-4f46-8ac2-be57a03e06d6',
    'price': '24.99'
  },
  {
    'text': 'Whisky',
    'img':
    'https://firebasestorage.googleapis.com/v0/b/saludapp-63b42.appspot.com/o/ImageVert%2FWhiskyVert.jpg?alt=media&token=565c6d18-74e7-4440-84ce-95d94de16142',
    'price': '24.99'
  },
  {
    'text': 'Bourbon',
    'img':
    'https://firebasestorage.googleapis.com/v0/b/saludapp-63b42.appspot.com/o/ImageVert%2FBourbonVert.jpg?alt=media&token=92a795b2-0fcf-4ab9-bfee-6348d1a5f893',
    'price': '24.99'
  },
  {
    'text': 'Rum',
    'img':
    'https://firebasestorage.googleapis.com/v0/b/saludapp-63b42.appspot.com/o/ImageVert%2FRumVert.jpg?alt=media&token=f5329c9e-3cb8-45ac-b972-ac650333ae57',
    'price': '24.99'
  },
  {
    'text': 'Tequila',
    'img':
    'https://firebasestorage.googleapis.com/v0/b/saludapp-63b42.appspot.com/o/ImageVert%2FTequilaVert.jpg?alt=media&token=404544aa-0efd-47bd-a9a2-1f0e1971bc54',
    'price': '24.99'
  },
];
