import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:saludsingapore/helpers/export_helper.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Login extends StatefulWidget {
  @override
  _Login createState() => _Login();
}

class _Login extends State<Login> {
  bool eye = true;

  void _toggle() {
    setState(() {
      eye = !eye;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.transparent));

    TextEditingController _emailTextController = TextEditingController();
    TextEditingController _passwordTextController = TextEditingController();
    final _formKey = GlobalKey<FormState>();
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
                "Sign up",
                style: new TextStyle(color: Colors.grey, fontSize: 17),
              ),
              onPressed: () {
                Navigator.pop(context);
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
                  "Log in",
                  style:
                      new TextStyle(fontSize: 25, fontWeight: FontWeight.w800),
                ),
                new SizedBox(
                  height: 70,
                ),
                new TextFormField(
                  controller: _emailTextController,
                  validator: validateEmail,
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
                    child: new Text("Log in",
                        style: new TextStyle(color: Colors.white)),
                    color: Colors.black,
                    elevation: 15.0,
                    shape: StadiumBorder(),
                    splashColor: Colors.white54,
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        final email = _emailTextController.text;
                        final password = _passwordTextController.text;
                        final firebaseAuth = FirebaseAuth.instance;
                        firebaseAuth
                            .signInWithEmailAndPassword(
                          email: email,
                          password: password,
                        )
                            .then((_) {
                          Navigator.of(context).pushNamed('/home');
                        }).catchError(
                                (error) => showErrorDialog(context, error));
                      }
                    },
                  ),
                ),
                new Container(
                  padding: const EdgeInsets.fromLTRB(0, 30, 0, 30),
                  child: new Text(
                    "Or sign in with social account",
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
                new SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController _emailTextController = TextEditingController();
    TextEditingController _passwordTextController = TextEditingController();
    final _formKey = GlobalKey<FormState>();
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade100,
      body: Center(
        child: SizedBox(
          height: 400,
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
                      'Welcome back!',
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    SizedBox(height: 25),
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
                              Navigator.of(context).pushNamed('/register'),
                          child: Text(
                            'Create Account',
                            style: TextStyle(color: Colors.blueAccent),
                          ),
                        ),
                        Spacer(),
                        FlatButton(
                          color: Colors.blueAccent,
                          child: Text(
                            'Login',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              final email = _emailTextController.text;
                              final password = _passwordTextController.text;
                              final firebaseAuth = FirebaseAuth.instance;
                              firebaseAuth
                                  .signInWithEmailAndPassword(
                                email: email,
                                password: password,
                              )
                                  .then((_) {
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
