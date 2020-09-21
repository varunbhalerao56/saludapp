import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saludsingapore/models/export_models.dart';
import 'package:saludsingapore/models/product.dart';
import 'package:saludsingapore/payment/locator.dart';
import 'package:saludsingapore/payment/network/network_service.dart';
import 'package:saludsingapore/payment/ui/edit_customer_screen.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:stripe_sdk/stripe_sdk_ui.dart';

class HomePage1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _products = Provider.of<List<Products>>(context);
    final users = Provider.of<Stream<User>>(context);

    return MultiProvider(providers: [
      StreamProvider<User>(
        create: (_) {
          return users;
        },
      )
    ], child: testRun());
  }
}

class testRun extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _products = Provider.of<List<Products>>(context);
    final user = Provider.of<User>(context);

    return Scaffold(
      backgroundColor: Colors.indigo[50],
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text("Home"),
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(8.0),
        itemCount: _products.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 0.8),
        itemBuilder: (context, index) {
          return ScopedModelDescendant<User>(builder: (context, child, model) {
            return Card(
                child: Column(children: <Widget>[
              Image.network(
                _products[index].productImg,
                height: 120,
                width: 120,
              ),
              Text(
                _products[index].productName,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text("\$" + _products[index].productPrice.toString()),
              OutlineButton(
                  child: Text("Add"),
                  onPressed: () => model.addProduct(_products[index]))
            ]));
          });
        },
      ),

      // ListView.builder(
      //   itemExtent: 80,
      //   itemCount: _products.length,
      //   itemBuilder: (context, index) {
      //     return ScopedModelDescendant<CartModel>(
      //         builder: (context, child, model) {
      //       return ListTile(
      //           leading: Image.network(_products[index].imgUrl),
      //           title: Text(_products[index].title),
      //           subtitle: Text("\$"+_products[index].price.toString()),
      //           trailing: OutlineButton(
      //               child: Text("Add"),
      //               onPressed: () => model.addProduct(_products[index])));
      //     });
      //   },
      // ),

      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Container(
            height: 50,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  iconSize: 30.0,
                  icon: Icon(Icons.help),
                  onPressed: () {},
                ),
                IconButton(
                  iconSize: 30.0,
                  icon: Icon(Icons.settings),
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
                    if (user.seller == 'buyer' || user.seller == '') {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditCustomerScreen()));
                    } else if (user.seller == 'seller') {
                      Navigator.of(context).pushNamed('/sellerSettings');
                    }
                  },
                ),
                IconButton(
                  iconSize: 30.0,
                  icon: Icon(Icons.credit_card),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      final paymentMethods = Provider.of<PaymentMethodStore>(
                          context,
                          listen: false);
                      // ignore: deprecated_member_use
                      return PaymentMethodsScreen(
                          createSetupIntent:
                              locator.get<NetworkService>().createSetupIntent,
                          paymentMethodStore: paymentMethods);
                    }));
                  },
                ),
                IconButton(
                  iconSize: 30.0,
                  icon: Icon(Icons.shopping_cart),
                  onPressed: () {
                    Navigator.pushNamed(context, '/cart');
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
