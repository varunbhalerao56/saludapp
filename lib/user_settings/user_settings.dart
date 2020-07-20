
import 'package:flutter/material.dart';
import 'package:saludsingapore/models/export_models.dart';
import 'package:provider/provider.dart';

class userSettingsPage extends StatelessWidget {
  const userSettingsPage({
    Key key, this.user,
  }) : super(key: key);
  final user ;

  @override
  Widget build(BuildContext context) {


    return
      Container(
          child: Column(
            children: <Widget>[
              Text(user.email),
              Text(user.name),
              Text(user.address),
            ],
          ),


    );
  }
}