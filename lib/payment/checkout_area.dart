
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:saludsingapore/models/user.dart';

import 'package:stripe_payment/stripe_payment.dart';





class PaymentScreen extends StatefulWidget {

  User user;

  Firestore _db;

  PaymentScreen( this.user, this._db);
  @override
  _PaymentScreenState createState() => _PaymentScreenState(user);
}

class _PaymentScreenState extends State<PaymentScreen> {
  _PaymentScreenState(this.user);



  @override
  void initState() {
    StripePayment.setOptions(StripeOptions(
        publishableKey: "pk_test_51H6mH9ID8MNBX0WyY9ez3h9SRhRmzbkgvvouePSwRt2iA711XXD2HyWA4hSuXJMRLJ68XGcbM5LbepWklDrCq0y200IAnkBIAT")); // TODO: Add Publishable Key
    super.initState();
  }
  User user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        title: Text("STRIPE PAYMENTS"),
        backgroundColor: Colors.pinkAccent,
        centerTitle: true,
        actions: <Widget>[

        ],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SignInButtonBuilder(
              text: 'Pay via Stripe',
              icon: Icons.credit_card,
              onPressed: (){
                startPaymentProcess();

              },
              backgroundColor: Colors.blueGrey[700],
            )
          ],
        ),
      ),
    );
  }


  final HttpsCallable INTENT = CloudFunctions.instance
      .getHttpsCallable(functionName: 'createPaymentIntent');





  startPaymentProcess() {
    StripePayment.paymentRequestWithCardForm(CardFormPaymentRequest())
        .then((paymentMethod) {
      double amount=100*100.0; // multipliying with 100 to change $ to cents
      INTENT.call(<String, dynamic>{'amount': amount,'currency':'sgd','receipt_email': user.email, 'customer': user.email}).then((response) {
        confirmDialog(response.data["client_secret"],paymentMethod); //function for confirmation for payment
      });
    });
  }

  confirmDialog(String clientSecret,PaymentMethod paymentMethod) {
    var confirm = AlertDialog(
      title: Text("Confirm Payement"),
      content: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              "Make Payment",
              // style: TextStyle(fontSize: 25),
            ),
            Text("Charge amount:\$100")
          ],
        ),
      ),
      actions: <Widget>[
        new RaisedButton(
          child: new Text('CANCEL'),
          onPressed: () {
            Navigator.of(context).pop();
            final snackBar = SnackBar(content: Text('Payment Cancelled'),);
            Scaffold.of(context).showSnackBar(snackBar);
          },
        ),
        new RaisedButton(
          child: new Text('Confirm'),
          onPressed: () {
            Navigator.of(context).pop();
            confirmPayment(clientSecret, paymentMethod); // function to confirm Payment
          },
        ),
      ],
    );
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return confirm;
        });
  }


  confirmPayment(String sec, PaymentMethod paymentMethod) {
    StripePayment.confirmPaymentIntent(
      PaymentIntent(clientSecret: sec, paymentMethodId: paymentMethod.id),
    ).then((val) {
      addPaymentDetailsToFirestore(paymentMethod); //Function to add Payment details to firestore
      final snackBar = SnackBar(content: Text('Payment Successfull'),);
      Scaffold.of(context).showSnackBar(snackBar);
    });
  }
  void addPaymentDetailsToFirestore(PaymentMethod paymentMethod) {
    String userId =user.id;
    widget._db.document("user/$userId").collection('PaymentInfo').add({
      "currency":"SGD",
      'amount':'100',
      'paymentmethod': paymentMethod.id
    });
  }
}