import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:saludsingapore/helpers/export_helper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/services.dart';

import 'login_page.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUp createState() => _SignUp();
}

class _SignUp extends State<SignUp> {
  bool eye = true;

  void _toggle() {
    setState(() {
      eye = !eye;
    });
  }

  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _nameTextController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.transparent));
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: true,
      appBar: new AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: <Widget>[
          new Padding(
            padding: const EdgeInsets.fromLTRB(0, 15, 20, 0),
            child: new FlatButton(
              child: new Text(
                "Log In",
                style: new TextStyle(color: Colors.grey, fontSize: 17),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Login()),
                );
              },
              highlightColor: Colors.black,
              shape: StadiumBorder(),
            ),
          ),
        ],
      ),
      body: new SingleChildScrollView(
        child: new Container(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Form(
            key: _formKey,
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                new Text(
                  "Sign up",
                  style:
                      new TextStyle(fontSize: 25, fontWeight: FontWeight.w800),
                ),
                new SizedBox(
                  height: 70,
                ),
                new TextField(
                  controller: _emailTextController,
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  decoration: new InputDecoration(
                    // hintText: "Email",
                    labelText: "Email",
                  ),
                ),
                new SizedBox(
                  height: 30,
                ),
                new TextFormField(
                  controller: _nameTextController,
                  keyboardType: TextInputType.text,
                  autocorrect: false,
                  decoration: new InputDecoration(
                    // hintText: "Email",
                    labelText: "Name",
                  ),
                ),
                new SizedBox(
                  height: 30,
                ),
                new TextFormField(
                  controller: _passwordTextController,
                  keyboardType: TextInputType.text,
                  autocorrect: false,
                  decoration: new InputDecoration(
                    labelText: "Password",
                    suffixIcon: new GestureDetector(
                      child: new Icon(
                        Icons.remove_red_eye,
                      ),
                      onTap: _toggle,
                    ),
                  ),
                  obscureText: eye,
                ),
                new SizedBox(
                  height: 30,
                ),
                new SizedBox(
                  height: 50,
                  child: new RaisedButton(
                    child: new Text("Sign up",
                        style: new TextStyle(color: Colors.white)),
                    color: Colors.black,
                    elevation: 15.0,
                    shape: StadiumBorder(),
                    splashColor: Colors.white54,
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        final email = _emailTextController.text;
                        final password = _passwordTextController.text;
                        final displayName = _nameTextController.text;
                        final firebaseAuth = FirebaseAuth.instance;
                        await firebaseAuth
                            .createUserWithEmailAndPassword(
                          email: email,
                          password: password,
                        )
                            .then((authResult) async {
                          final userId = authResult.user.uid;
                          Firestore.instance.document('user/$userId').setData(
                            {
                              'id': userId,
                              'displayName': displayName,
                              'email': email,
                              'seller': 'buyer'
                            },
                          );
                          FirebaseUser user =
                              await FirebaseAuth.instance.currentUser();
                          UserUpdateInfo userUpdateInfo = new UserUpdateInfo();
                          userUpdateInfo.displayName = displayName;
                          user.updateProfile(userUpdateInfo);

                          final HttpsCallable callable =
                              CloudFunctions.instance.getHttpsCallable(
                            functionName: "updateUser",
                          );
                          final DocumentSnapshot getuserdoc = await Firestore
                              .instance
                              .collection('user')
                              .document(userId)
                              .get();

                          dynamic response = callable.call(<String, dynamic>{
                            'name': displayName,
                            'customer': getuserdoc.data['stripeId']
                            //replace param1 with the name of the parameter in the Cloud Function and the value you want to insert
                          }).catchError((onError) {
                            //Handle your error here if the function failed
                          });
                        }).catchError(
                                (error) => showErrorDialog(context, error));
                      }
                    },
                  ),
                ),
                new Container(
                  padding: const EdgeInsets.fromLTRB(0, 30, 0, 30),
                  child: new Text(
                    "Or sign up with social account",
                    textAlign: TextAlign.center,
                  ),
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new SizedBox(
                      height: 50,
                      width: 165,
                      child: new OutlineButton(
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new Icon(
                              FontAwesomeIcons.facebookF,
                              size: 20,
                            ),
                            new SizedBox(
                              width: 5,
                            ),
                            new Text("Facebook",
                                style: new TextStyle(color: Colors.black)),
                          ],
                        ),
                        shape: StadiumBorder(),
                        highlightedBorderColor: Colors.black,
                        borderSide: BorderSide(color: Colors.black),
                        onPressed: () {},
                      ),
                    ),
                    new SizedBox(
                      width: 20,
                    ),
                    new SizedBox(
                      height: 50,
                      width: 165,
                      child: new OutlineButton(
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new Icon(
                              FontAwesomeIcons.twitter,
                              size: 20,
                            ),
                            new SizedBox(
                              width: 5,
                            ),
                            new Text("Twitter",
                                style: new TextStyle(color: Colors.black)),
                          ],
                        ),
                        shape: StadiumBorder(),
                        highlightedBorderColor: Colors.black,
                        borderSide: BorderSide(color: Colors.black),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
                new SizedBox(height: 60),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

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
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              final email = _emailTextController.text;
                              final password = _passwordTextController.text;
                              final displayName = _nameTextController.text;
                              final address = _addressTextController.text;
                              final firebaseAuth = FirebaseAuth.instance;
                              await firebaseAuth
                                  .createUserWithEmailAndPassword(
                                email: email,
                                password: password,
                              )
                                  .then((authResult) async {
                                final userId = authResult.user.uid;
                                Firestore.instance
                                    .document('user/$userId')
                                    .setData(
                                  {
                                    'id': userId,
                                    'displayName': displayName,
                                    'address': address,
                                    'email': email,
                                    'seller': 'buyer'
                                  },
                                );
                                FirebaseUser user =
                                    await FirebaseAuth.instance.currentUser();
                                UserUpdateInfo userUpdateInfo =
                                    new UserUpdateInfo();
                                userUpdateInfo.displayName = displayName;
                                user.updateProfile(userUpdateInfo);

                                final HttpsCallable callable =
                                    CloudFunctions.instance.getHttpsCallable(
                                  functionName: "updateUser",
                                );
                                final DocumentSnapshot getuserdoc =
                                    await Firestore.instance
                                        .collection('user')
                                        .document(userId)
                                        .get();

                                dynamic response =
                                    callable.call(<String, dynamic>{
                                  'name': displayName,
                                  'customer': getuserdoc.data['stripeId']
                                  //replace param1 with the name of the parameter in the Cloud Function and the value you want to insert
                                }).catchError((onError) {
                                  //Handle your error here if the function failed
                                });
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
