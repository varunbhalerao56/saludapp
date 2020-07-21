import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:saludsingapore/helpers/show_error.dart';
import 'package:saludsingapore/models/export_models.dart';
import 'package:saludsingapore/main.dart';
import 'package:saludsingapore/payment/checkout_area.dart';
import 'package:saludsingapore/user_settings/user_settings.dart';

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
              product_app_bar(width: width),
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

class product_app_bar extends StatelessWidget {
  const product_app_bar({
    Key key,
    @required this.width,
  }) : super(key: key);

  final double width;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return Card(
        elevation: 10,
        shape: (RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(3.0),
        )),
        child: Container(
          height: 40,
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
                    'yo',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ),
                Spacer(),
                FlatButton.icon(
                  icon: Icon(Icons.exit_to_app),
                  label: Text('Logout'),
                  onPressed: () {
                    FirebaseAuth.instance
                        .signOut()
                        .then((value) =>
                        Navigator.of(context).popAndPushNamed('/login'))
                        .catchError((error) => showErrorDialog(context, error));
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.supervised_user_circle,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    if(user.seller == 'buyer' || user.seller == '')
                      {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context){
                          return  PaymentScreen(user,Firestore.instance);
                        }));
                      }
                    else if (user.seller == 'seller')
                      {
                        Navigator.of(context).pushNamed('/paymentmethod');
                      }
                  },
                )
              ],
            ),
          ),
        ));
  }
}

class RowSlider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final productName = Provider.of<List<Products>>(context);
    return Center(
      child: Container(
        width: width > 992 ? 992 : width * 0.95,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: <Widget>[
              for (var data in productName)
                ProductCard(
                  text: data.text,
                  img: data.img,
                  price: data.price,
                ),
              SizedBox(
                width: 30,
              ),
            ],
          ),
        ),
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
      height: 300,
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
          ],
        ),
      ),
    );
  }
}
