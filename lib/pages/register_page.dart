import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:saludsingapore/helpers/export_helper.dart';
class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController _emailTextController = TextEditingController();
    TextEditingController _passwordTextController = TextEditingController();
    TextEditingController _nameTextController = TextEditingController();
    TextEditingController _addressTextController = TextEditingController();
    final _formKey = GlobalKey<FormState>();
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade100,
      body: Center(
        child: SizedBox(
          height: 500,
          width: 400,
          child: Material(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Welcome!',
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    SizedBox(height: 25),
                    TextFormField(
                      controller: _nameTextController,
                      validator: (value) =>
                      value.isEmpty ? 'Please enter a name' : null,
                      decoration: InputDecoration(
                        labelText: 'Name',
                      ),
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      controller: _addressTextController,
                      validator: (value) =>
                      value.isEmpty ? 'Please enter a address' : null,
                      decoration: InputDecoration(
                        labelText: 'Address',
                      ),
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      controller: _emailTextController,
                      validator: validateEmail,
                      decoration: InputDecoration(
                        labelText: 'Email',
                      ),
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      obscureText: true,
                      controller: _passwordTextController,
                      validator: (value) =>
                      value.isEmpty ? 'Please enter a password' : null,
                      decoration: InputDecoration(
                        labelText: 'Password',
                      ),
                    ),
                    Spacer(),
                    Row(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () =>
                              Navigator.of(context).pushNamed('/login'),
                          child: Text(
                            'I have an account',
                            style: TextStyle(color: Colors.blueAccent),
                          ),
                        ),
                        Spacer(),
                        FlatButton(
                          color: Colors.blueAccent,
                          child: Text(
                            'Register',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              final email = _emailTextController.text;
                              final password = _passwordTextController.text;
                              final name = _nameTextController.text;
                              final address = _addressTextController.text;
                              final firebaseAuth = FirebaseAuth.instance;
                              firebaseAuth
                                  .createUserWithEmailAndPassword(
                                email: email,
                                password: password,
                              )
                                  .then((authResult) {
                                final userId = authResult.user.uid;
                                Firestore.instance
                                    .document('user/$userId')
                                    .setData({'id' : userId, 'name': name, 'address': address, 'email': email, 'seller' : 'buyer'});
                                Navigator.of(context).pushNamed('/home');
                              }).catchError((error) =>
                                  showErrorDialog(context, error));
                            }
                          },
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
