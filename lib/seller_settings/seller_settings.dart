import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:saludsingapore/models/export_models.dart';
import 'package:provider/provider.dart';
import 'add_new_product.dart';
import 'delete_product.dart';
import 'edit_product.dart';

class sellerSettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          ButtonSettings(),
        ],
      ),
    );
  }
}

class ButtonSettings extends StatelessWidget {
  const ButtonSettings({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<List<Products>>(context);

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
                    for (var data in products)
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

