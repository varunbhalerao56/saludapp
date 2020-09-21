import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saludsingapore/SellerSettings/seller_settings.dart';
import 'package:saludsingapore/cart/cartpage.dart';
import 'package:saludsingapore/cart/home.dart';
import 'package:saludsingapore/models/export_models.dart';
import 'package:saludsingapore/payment/locator.dart';
import 'package:saludsingapore/payment/network/network_service.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:stripe_sdk/stripe_sdk.dart';
import 'package:stripe_sdk/stripe_sdk_ui.dart';
import 'AuthService/export_pages.dart';
import 'UserInterface/displayCart.dart';
import 'UserInterface/displayPages.dart';
import 'UserInterface/displayProduct.dart';
import 'helpers/database_service.dart';
import 'helpers/restart.dart';

const _stripePublishableKey =
    'pk_test_51H6mH9ID8MNBX0WyY9ez3h9SRhRmzbkgvvouePSwRt2iA711XXD2HyWA4hSuXJMRLJ68XGcbM5LbepWklDrCq0y200IAnkBIAT';
const _returnUrl = "stripesdk://com.saludsingapore";

void main() {
  Provider.debugCheckInvalidValueType = null;
  initializeLocator();

  runApp(RestartWidget(
    child: StartUp(
      model: User(),
    ),
  ));
}

// This class is called when the the app opens
class StartUp extends StatelessWidget {
  final User model;

  const StartUp({Key key, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Stripe.init(_stripePublishableKey, returnUrlForSca: _returnUrl);

    CustomerSession.initCustomerSession(
        (version) => locator.get<NetworkService>().getEphemeralKey(version));

    final app = ScopedModel<User>(
      model: model,
      child: MaterialApp(
        title: 'Salud App',
        theme: ThemeData(
          brightness: Brightness.light,
        ),
        onGenerateRoute: (home) {
          print(home.name);
          return MaterialPageRoute(
            builder: (context) => AuthWidgets(home: home.name),
          );
        },
        routes: {
          '/sellerSettings': (context) => sellerSettingsPage(),
          '/usercustomer': (context) => StartUp(),
          '/cart': (context) => CartPage1(),
          '/test': (context) => ProductGridCard(),
        },
      ),
    );
    final products = ProductCollection().collection.snapshots().map((snapshot) {
      return snapshot.documents
          .map((doc) => Products.fromDocument(doc))
          .toList();
    });
    return MultiProvider(providers: [
      StreamProvider<FirebaseUser>(
        create: (_) => FirebaseAuth.instance.onAuthStateChanged,
        initialData: null,
      ),
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
      Provider<ProductCollection>(create: (_) => ProductCollection()),
      ChangeNotifierProvider(
        create: (_) => PaymentMethodStore(),
      ),
    ], child: app);
  }
}

class AuthWidgets extends StatelessWidget {
  const AuthWidgets({Key key, @required this.home}) : super(key: key);
  final String home;

  @override
  Widget build(BuildContext context) {
    final isUserLoggedIn = Provider.of<FirebaseUser>(context) != null;
    final notLoggedInUserGoToSettings = home == '/home' && !isUserLoggedIn;
    final notLoggedInUserGoToLogin = home == '/login' && !isUserLoggedIn;
    final notLoggedInUserGoToRegister = home == '/register' && !isUserLoggedIn;

    if (isUserLoggedIn) {
      return HomePage();
    } else if (home == '/') {
      return Login();
    } else if (notLoggedInUserGoToLogin || notLoggedInUserGoToSettings) {
      return Login();
    } else if (notLoggedInUserGoToRegister) {
      return SignUp();
    }
  }
}
