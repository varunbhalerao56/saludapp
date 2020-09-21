import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TransactionalEmail extends StatefulWidget {
  @override
  createState() => _TransactionalEmailState();
}

class _TransactionalEmailState extends State<TransactionalEmail> {
  final HttpsCallable callable = CloudFunctions.instance.getHttpsCallable(
    functionName: 'genericEmail',
  );

  final FirebaseAuth auth = FirebaseAuth.instance;

  FirebaseUser user;

  String emailAddress = 'varunbhalerao05@gmail.com';

  @override
  initState() {
    super.initState();
    auth.onAuthStateChanged.listen((u) {
      setState(() => user = u);
    });
  }

  sendEmail() {
    return callable.call({
      'text': 'Sending email with Flutter and SendGrid is fun!',
      'subject': 'Email from Flutter'
    }).then((res) => print(res.data));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Send Email with SendGrid and Flutter'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (user != null) ...[
              Text('$user'),
              FlatButton(child: Text('SignOut'), onPressed: auth.signOut),
              FlatButton(
                  child: Text('Send Email with Callable Function'),
                  onPressed: sendEmail)
            ] else ...[
              FlatButton(
                  child: Text('Login'),
                  onPressed: () => auth.createUserWithEmailAndPassword(
                      email: emailAddress, password: 'demoPass23'))
            ]
          ],
        ),
      ),
    );
  }
}
