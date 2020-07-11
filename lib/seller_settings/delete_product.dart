import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saludsingapore/models/Products.dart';


class DeleteButton extends StatelessWidget {
  const DeleteButton({
    Key key,
    @required this.data,
  }) : super(key: key);

  final products data;

  @override
  Widget build(BuildContext context) {
    final linksCollection = Provider.of<CollectionReference>(context);
    void _showDeleteDialog() {
      showDialog(
        context: context,
        child: AlertDialog(
          title: Text('Are you sure you want to delete ${data.text} Link?'),
          content: Text('Deleted links are not retrievable.'),
          actions: <Widget>[
            FlatButton(
              color: Colors.redAccent,
              onPressed: () {
                linksCollection.document(data.documentId).delete();
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

