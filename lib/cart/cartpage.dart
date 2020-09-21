import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saludsingapore/models/product.dart';
import 'package:saludsingapore/models/user.dart';
import 'package:saludsingapore/payment/locator.dart';
import 'package:saludsingapore/payment/network/network_service.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:stripe_sdk/stripe_sdk.dart';

class CartPage1 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CartPageState();
  }
}

class _CartPageState extends State<CartPage1> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ScopedModel.of<User>(context, rebuildOnChange: true).cart.length == 0
        ? Center(
            child: Text("No items in Cart"),
          )
        : Container(
            padding: EdgeInsets.all(8.0),
            child: Column(children: <Widget>[
              Expanded(
                child: ListView.builder(
                  itemCount:
                      ScopedModel.of<User>(context, rebuildOnChange: true)
                          .total,
                  itemBuilder: (context, index) {
                    return ScopedModelDescendant<User>(
                      builder: (context, child, model) {
                        return Material(
                          child: ListTile(
                            title: Text(model.cart[index].productName),
                            subtitle: Text(model.cart[index].qty.toString() +
                                " x " +
                                model.cart[index].productPrice.toString() +
                                " = " +
                                (model.cart[index].qty *
                                        (model.cart[index].productPrice))
                                    .toString()),
                            trailing:
                                Row(mainAxisSize: MainAxisSize.min, children: [
                              IconButton(
                                icon: Icon(Icons.add),
                                onPressed: () {
                                  model.updateProduct(model.cart[index],
                                      model.cart[index].qty + 1);
                                  // model.removeProduct(model.cart[index]);
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.remove),
                                onPressed: () {
                                  model.updateProduct(model.cart[index],
                                      model.cart[index].qty - 1);
                                  // model.removeProduct(model.cart[index]);
                                },
                              ),
                            ]),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              Container(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Total: \$ " +
                        ScopedModel.of<User>(context, rebuildOnChange: true)
                            .totalCartValue
                            .toString() +
                        "",
                    style:
                        TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                  )),
              SizedBox(
                  width: double.infinity,
                  child: RaisedButton(
                    color: Colors.yellow[900],
                    textColor: Colors.white,
                    elevation: 0,
                    child: Text("BUY NOW"),
                    onPressed: () {
                      createAutomaticPaymentIntent(
                          context,
                          ScopedModel.of<User>(context, rebuildOnChange: true)
                              .totalCartValue);
                    },
                  ))
            ]));
  }

  void createAutomaticPaymentIntent(BuildContext context, double cost) async {
    final NetworkService networkService = locator.get();
    final response =
        await networkService.createAutomaticPaymentIntent(cost.toInt() * 100);
    if (response.status == "succeeded") {
      // TODO: success
      debugPrint("Success before authentication.");

      return;
    }
    final result = await Stripe.instance.confirmPayment(response.clientSecret,
        paymentMethodId: "pm_card_threeDSecure2Required");
    if (result['status'] == "succeeded") {
      // TODO: success
      debugPrint("Success after authentication.");

      return;
    } else {
      debugPrint("Error");
    }
  }
}
