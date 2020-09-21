import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saludsingapore/helpers/show_error.dart';
import 'file:///C:/AMD/saludapp/lib/helpers/restart.dart';
import 'package:stripe_sdk/stripe_sdk.dart';

import '../../main.dart';

class EditCustomerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final session = CustomerSession.instance;
    return Scaffold(
      backgroundColor: Colors.indigo[50],
      appBar: AppBar(
        title: Text('Customer'),
      ),
      body: FutureProvider.value(
        value: session.retrieveCurrentCustomer().then((value) => CustomerData(
            value['id'], value['email'], value['description'], value['name'])),
        child: EditCustomerForm(),
      ),
    );
  }
}

class CustomerData {
  final String id;
  final String email;
  final String description;
  final String name;

  CustomerData(this.id, this.email, this.description, this.name);
}

class EditCustomerForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final CustomerData customerData = Provider.of(context);
    if (customerData == null) return Container();

    final nameController = TextEditingController(text: customerData.id);
    final emailController = TextEditingController(text: customerData.email);
    final phoneController = TextEditingController(text: customerData.name);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            children: <Widget>[
              TextField(
                controller: nameController,
                readOnly: true,
                decoration: InputDecoration(labelText: "Name"),
              ),
              TextField(
                controller: emailController,
                readOnly: true,
                decoration: InputDecoration(labelText: "Email"),
              ),
              TextField(
                controller: phoneController,
                readOnly: true,
                enableInteractiveSelection: false,
                decoration: InputDecoration(labelText: "Phone"),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FlatButton.icon(
                    icon: Icon(Icons.power_settings_new),
                    label: Text('Logout'),
                    onPressed: () {
                      FirebaseAuth.instance
                          .signOut()
                          .then((value) =>
                              Navigator.of(context).popAndPushNamed('/login'))
                          .catchError(
                              (error) => showErrorDialog(context, error));
                      RestartWidget.restartApp(context);
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
