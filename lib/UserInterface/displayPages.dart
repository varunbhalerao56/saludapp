import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saludsingapore/SellerSettings/seller_settings.dart';
import 'package:saludsingapore/UserInterface/displayCart.dart';
import 'package:saludsingapore/UserInterface/displayCategory.dart';
import 'package:saludsingapore/UserInterface/selectOptions.dart';
import 'package:saludsingapore/models/export_models.dart';
import 'package:smart_select/smart_select.dart';

class HomePage extends StatefulWidget {
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  int currentIndex = 0;

  final appBarText = ['Select Category', 'Help', 'Settings', 'Cart'];

  final tabs = [
    CategoryCard(),
    FeaturesSinglePopup(),
    sellerSettingsPage(),
    CartPage()
  ];

  @override
  Widget build(BuildContext context) {
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
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(appBarText[currentIndex]),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[tabs[currentIndex]],
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          type: BottomNavigationBarType.fixed,
          iconSize: 30,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home), title: Text('Home')),
            BottomNavigationBarItem(
                icon: Icon(Icons.help), title: Text('Help')),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), title: Text('Settings')),
            BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart), title: Text('Cart'))
          ],
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}
