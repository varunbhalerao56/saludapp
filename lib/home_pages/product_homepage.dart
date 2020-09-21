import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saludsingapore/DropDown/drop_downtemp.dart';
import 'package:saludsingapore/helpers/restart.dart';

import 'package:saludsingapore/helpers/show_error.dart';
import 'package:saludsingapore/models/export_models.dart';

import 'package:scoped_model/scoped_model.dart';
import '../main.dart';

class ShoppingHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final products = Provider.of<List<Products>>(context);
    final user = Provider.of<Stream<User>>(context);
    return MultiProvider(
      providers: [
        StreamProvider<User>(
          create: (_) {
            return user;
          },
        )
      ],
      child: Material(
        child: Container(
          child: Column(
            children: <Widget>[
              home_buttons(),
              SizedBox(
                height: 30,
              ),
              RowSlider(),
              SizedBox(
                height: 30,
              ),
              Text(
                'Bundle Deals',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class home_buttons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return Column(
      children: <Widget>[
        Container(
          child: Center(
            child: FlatButton.icon(
                icon: Icon(Icons.update),
                label: Text('Logout'),
                onPressed: () {
                  FirebaseAuth.instance
                      .signOut()
                      .then((value) =>
                      Navigator.of(context).popAndPushNamed('/login'))
                      .catchError((error) => showErrorDialog(context, error));
                  RestartWidget.restartApp(context);
                }),
          ),
        ),
        Container(color: Colors.blue,
          child: Center(
            child: FlatButton.icon(
                icon: Icon(Icons.settings),
                label: Text('Seller Settings'),
                onPressed: () {
                  Navigator.of(context).pushNamed('/cart');
                }),
          ),
        ),
        Container(
          child: Center(
            child: FlatButton.icon(
                icon: Icon(Icons.shopping_cart),
                label: Text('Cart'),
                onPressed: () {
                  user.currentUserChatroomOrderStatus(
                      "abcd", "active", "kU6U1htqBlPJXujqCEF7pzfF3JV2");

                  //user.AddObjectToArray('no');

                }),
          ),
        ),
        Container(
          child: FlatButton.icon(
            icon: Icon(Icons.save),
            label: Text('abccc'),
            onPressed: () async {
              final HttpsCallable callable =
              CloudFunctions.instance.getHttpsCallable(
                functionName: "updateUser",
              );
              final DocumentSnapshot getuserdoc = await Firestore.instance
                  .collection('user')
                  .document(user.id)
                  .get();
              dynamic response = callable.call(<String, dynamic>{
                'name': getuserdoc.data['displayName'],
                'customer': user.stripeId
                //replace param1 with the name of the parameter in the Cloud Function and the value you want to insert
              }).catchError((onError) {
                //Handle your error here if the function failed
              });
            },
          ),
        ),

      ],
    );
  }
}

class RowSlider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery
        .of(context)
        .size
        .width;
    final productName = Provider.of<List<Products>>(context);
    final user = Provider.of<User>(context);
    int counter = 0;
    return Container(height: 400,
      child: ListView.builder(
        itemExtent: 80,
        itemCount: productName.length,
        itemBuilder: (context, index) {
          return ScopedModelDescendant<User>(
              builder: (context, child, model) {
                return ListTile(
                    leading: Image.network(productName[index].productImg),
                    title: Text(productName[index].productName),
                    subtitle: Text(
                        "\$" + productName[index].productPrice.toString()),
                    trailing: OutlineButton(
                        child: Text("Add"),
                        onPressed: () => model.addProduct(productName[index])));
              });
        },
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  const ProductCard({Key key, this.text, this.img, this.price, this.cardWidth})
      : super(key: key);

  final int cardWidth;
  final String text;
  final String img;
  final String price;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      width: 200,
      child: Card(
        elevation: 5,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Text(
                text,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              height: 200.0,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image(image: NetworkImage(img))),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 9),
              child: Text(
                price,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            Container(
              child: Center(
                child: FlatButton.icon(
                    icon: Icon(Icons.add),
                    label: Text('Add to cart'),
                    onPressed: () {
                      Navigator.of(context).pushNamed('/cart');
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
