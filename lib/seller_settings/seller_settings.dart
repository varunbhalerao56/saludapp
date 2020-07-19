import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:saludsingapore/seller_settings/delete_product.dart';
import 'package:saludsingapore/seller_settings/edit_product.dart';
import 'package:provider/provider.dart';
import 'package:saludsingapore/models/Products.dart';
import 'add_product.dart';

class SettingsPage extends StatelessWidget {
  final String abc;


  const SettingsPage({Key key, this.abc}) : super(key: key);@override
  Widget build(BuildContext context) {
    final productLinks = Provider.of <Stream<List<products>>> (context);
     final productName = Provider.of<List<products>>(context);
    return StreamProvider<List<products>>(
      create: (_) { return productLinks; },
      initialData: [],
      child: Scaffold(
        appBar:AppBar(
          title: Text('Settings'),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.home,
                color: Colors.white,
              ),
              onPressed: () {Navigator.of(context).pop();
                // do something
              },
            )
          ],
        ),
        body: Row(
          children: <Widget>[
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) => Container(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: AddButton(width: constraints.maxWidth * 0.6),
                      ),
                      SizedBox(height: 30),
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: constraints.maxHeight * 0.5,
                          maxWidth: constraints.maxWidth * 0.6,
                        ),
                        child: ReorderableListView(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          onReorder: (int oldIndex, int newIndex) {},
                          children: [
                            for (var data in productName)
                              ListTile(
                                key: Key(data.text),
                                title: Text(data.text),
                                leading: Icon(Icons.drag_handle),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    EditButton(data: data,),
                                    DeleteButton(data: data,),

                                  ],
                                ),
                              )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ButtonSettings extends StatelessWidget {
  const ButtonSettings({
    Key key, this.a,
  }) : super(key: key);
final String a;
  @override
  Widget build(BuildContext context) {
    final productName = Provider.of<List<products>>(context);

    return Expanded(
      child: LayoutBuilder(
        builder: (context, constraints) => Container(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: AddButton(width: constraints.maxWidth * 0.6),
              ),
              SizedBox(height: 30),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: constraints.maxHeight * 0.5,
                  maxWidth: constraints.maxWidth * 0.6,
                ),
                child: ReorderableListView(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  onReorder: (int oldIndex, int newIndex) {},
                  children: [
                    for (var data in productName)
                      ListTile(
                        key: Key(data.text),
                        title: Text(data.text),
                        leading: Icon(Icons.drag_handle),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            EditButton(data: data,),
                            DeleteButton(data: data,),

                          ],
                        ),
                      )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

