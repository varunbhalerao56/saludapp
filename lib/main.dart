import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:saludsingapore/models/Bundles.dart';
import 'package:saludsingapore/pages/product_home.dart';
import 'package:saludsingapore/seller_settings/seller_settings.dart';
import 'package:provider/provider.dart';
import 'package:saludsingapore/models/Products.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    final productCollection = Firestore.instance.collection('products');
    final product = productCollection.snapshots().map((snapshot) {
      return snapshot.documents
          .map((doc) => products.fromDocument(doc))
          .toList();
    });
    final bundlesCollection = Firestore.instance.collection('bundles');
    final bundle = bundlesCollection.snapshots().map((snapshot) {
      return snapshot.documents
          .map((doc) => bundles.fromDocument(doc))
          .toList();
    });
    return MultiProvider(
      providers: [
        StreamProvider<List<products>>(
          create: (_) => product,
          initialData: [],
        ),
        StreamProvider<List<bundles>>(
          create: (_) => bundle,
          initialData: [],
        ),
        Provider<CollectionReference>(
          create: (_) => productCollection,
        ),
        Provider<CollectionReference>(
          create: (_) => bundlesCollection,
        )
      ],
      child: MaterialApp(
        title: 'Salud App',
        theme: ThemeData(
          brightness: Brightness.dark,
        ),
        initialRoute: '/settings',
        routes: {
          '/': (context) => ShoppingHomePage(),
          '/settings': (context) => SettingsPage(),
        },
      ),
    );
  }
}

class ShoppingHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Material(
      child: Container(
        child: Column(
          children: <Widget>[
            Card(
                elevation: 10,
                shape: (RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                )),
                child: Container(
                  height: 60,
                  width: width > 992
                      ? 992
                      : width *
                          0.95, //checking if the width is greater than 768 to change the size of the container
                  child: Center(
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Welcome to Salud, here are your browsing options',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                        ),
                        Spacer(),
                        IconButton(
                          icon: Icon(
                            Icons.settings,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.of(context).pushNamed('/settings');
                            // do something
                          },
                        )
                      ],
                    ),
                  ),
                )),
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
    );
  }
}
