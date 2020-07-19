import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:saludsingapore/pages/login_page.dart';
import 'package:saludsingapore/pages/product_home.dart';
import 'package:saludsingapore/pages/register_page.dart';
import 'package:saludsingapore/seller_settings/seller_settings.dart';
import 'package:provider/provider.dart';
import 'package:saludsingapore/models/Products.dart';
import 'helpers/firestore.dart';
import 'models/User.dart';
import 'not_found_page.dart';

void main() {
  Provider.debugCheckInvalidValueType = null;
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<FirebaseUser>(
          create: (_) => FirebaseAuth.instance.onAuthStateChanged,
          initialData: null,
        ),
        ProxyProvider<FirebaseUser, Stream<List<products>>>(
          update: (_, user, __)
          {
            return userproductCollection(productCollection(user?.uid));
          }
        ),
        ProxyProvider<FirebaseUser, Stream<User>>(update: (_, user, __) {
          return userData(user?.uid);
        }),
        ProxyProvider<FirebaseUser, CollectionReference>(
          update: (_, user, __) => productCollection(user.uid),
        ),
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
        routes:
        {
          '/settings': (_) => SettingsPage(abc: "abc",),
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

    if (home == '/') {
      return LoginPage();
    } else if (isUserLoggedIn) {
      return ShoppingHomePage();
    } else if (notLoggedInUserGoToLogin || notLoggedInUserGoToSettings) {
      return LoginPage();
    } else if (notLoggedInUserGoToRegister) {
      return RegisterPage();
    } else {
      return NotFoundPage(routeName: home);
    }
  }
}
