import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:saludsingapore/helpers/export_helper.dart';
import 'package:saludsingapore/models/export_models.dart';
import 'package:provider/provider.dart';


class DeleteButton extends StatelessWidget {
  const DeleteButton({
    Key key,
    @required this.data,
  }) : super(key: key);

  final Products data;

  @override
  Widget build(BuildContext context) {
    final linksCollection = Provider.of<ProductCollection>(context);
    void _showDeleteDialog() {
      showDialog(
        context: context,
        child: AlertDialog(
          title: Text('Are you sure you want to delete ${data.text} - product?'),
          content: Text('Deleted products cant be retrived'),
          actions: <Widget>[
            FlatButton(
              color: Colors.redAccent,
              onPressed: () {
                linksCollection.collection.document(data.documentId).delete();
                Navigator.of(context).pop();
              },
              child: Text('Delete'),
            )
          ],
        ),
      );
    }
    return IconButton(
      icon: Icon(Icons.delete),
      onPressed: _showDeleteDialog,
    );
  }
}

