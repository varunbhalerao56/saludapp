import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:saludsingapore/helpers/export_helper.dart';
import 'package:saludsingapore/models/export_models.dart';
import 'package:saludsingapore/not_found_page.dart';
import 'package:saludsingapore/pages/export_pages.dart';
import 'package:saludsingapore/payment/existing_cards.dart';
import 'package:saludsingapore/payment/payment_method.dart';
import 'package:saludsingapore/seller_settings/seller_settings.dart';
import 'package:provider/provider.dart';

import 'user_settings/user_settings.dart';

void main() {
  Provider.debugCheckInvalidValueType = null;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    final products = ProductCollection().collection.snapshots().map((snapshot) {
      return snapshot.documents
          .map((doc) => Products.fromDocument(doc))
          .toList();
    });
    return MultiProvider(
      providers: [
        StreamProvider<FirebaseUser>(
          create: (_) => FirebaseAuth.instance.onAuthStateChanged,
          initialData: null,
        ),
        ProxyProvider<FirebaseUser, Stream<List<Cart>>>(update: (_, user, __) {
          return userCartCollection(cartCollection(user?.uid));
        }),
        ProxyProvider<FirebaseUser, Stream<User>>(update: (_, user, __) {
          return userData(user?.uid);
        }),
        ProxyProvider<FirebaseUser, CollectionReference>(
          update: (_, user, __) => cartCollection(user.uid),
        ),
        StreamProvider<List<Products>>(
          create: (_) => products,
          initialData: [],
        ),
        Provider<ProductCollection>(create: (_) => ProductCollection())
      ],
      child: MaterialApp(
        title: 'Salud App',
        theme: ThemeData(
          brightness: Brightness.dark,
        ),
        onGenerateRoute: (home) {
          print(home.name);
          return MaterialPageRoute(
            builder: (context) => AuthWidget(home: home.name),
          );
        },
        routes: {
          '/userSettings': (context) => userSettingsPage(),
          '/sellerSettings': (context) => sellerSettingsPage(),
          '/paymentmethod': (context) => HomePage(),
          '/existing-cards': (context) => ExistingCardsPage()
        },
      ),
    );
  }
}

class AuthWidget extends StatelessWidget {
  const AuthWidget({Key key, @required this.home}) : super(key: key);
  final String home;
  @override
  Widget build(BuildContext context) {
    final isUserLoggedIn = Provider.of<FirebaseUser>(context) != null;
    final notLoggedInUserGoToSettings = home == '/home' && !isUserLoggedIn;
    final notLoggedInUserGoToLogin = home == '/login' && !isUserLoggedIn;
    final notLoggedInUserGoToRegister = home == '/register' && !isUserLoggedIn;

    if (isUserLoggedIn) {
      return ShoppingHomePage();
    } else if (home == '/') {
      return LoginPage();
    } else if (notLoggedInUserGoToLogin || notLoggedInUserGoToSettings) {
      return LoginPage();
    } else if (notLoggedInUserGoToRegister) {
      return RegisterPage();
    } else {
      return NotFoundPage(routeName: home);
    }
  }
}
