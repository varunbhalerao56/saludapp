import 'package:flutter/material.dart';
import 'package:saludsingapore/DropDown/dropdown.dart';
import 'package:saludsingapore/helpers/clientDataSource.dart';

class DropDownPage extends StatefulWidget {
  final int dropDownItems;
  final List<Map> values;

  const DropDownPage({Key key, this.values, this.dropDownItems})
      : super(key: key);

  @override
  _DropDownPageState createState() => _DropDownPageState(dropDownItems, values);
}

class _DropDownPageState extends State<DropDownPage> {
  List<String> _myActivity;
  String _myActivityResult;
  final formKey = new GlobalKey<FormState>();

  final int dropDownItems;
  final List<Map> values;

  _DropDownPageState(this.dropDownItems, this.values);

  @override
  void initState() {
    super.initState();
    _myActivity = [];
    _myActivityResult = '';
  }

  _saveForm() {
    var form = formKey.currentState;
    String temp = ' ';
    if (form.validate()) {
      form.save();
      setState(() {
        for (int i = 0; i < dropDownItems; i++)
          temp = temp + _myActivity[i] + ', ';
        _myActivityResult = temp;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    for (int i = 0; i < dropDownItems; i++) _myActivity.add('');

    return Center(
      child: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            for (int i = 0; i < dropDownItems; i++) buildContainer(i),
            Container(
              padding: EdgeInsets.all(8),
              child: RaisedButton(
                child: Text('Save'),
                onPressed: () {
                  if (_myActivity[0] == '') {
                    _myActivityResult = 'ABS ';
                  } else {
                    _saveForm();
                  }
                },
              ),
            ),
            Container(
              child: Text(_myActivityResult),
            )
          ],
        ),
      ),
    );
  }

  buildContainer(int i) {
    return Container(
      padding: EdgeInsets.all(8),
      child: DropDownFormField(
        titleText: 'My workout',
        hintText: 'Please choose one',
        value: _myActivity[i],
        onSaved: (value) {
          setState(() {
            _myActivity[i] = value;
          });
        },
        onChanged: (value) {
          setState(() {
            _myActivity[i] = value;
          });
        },
        dataSource: [
          {
            "display": "Running",
            "value": "Running",
          },
          {
            "display": "Climbing",
            "value": "Climbing",
          },
          {
            "display": "Walking",
            "value": "Walking",
          },
          {
            "display": "Swimming",
            "value": "Swimming",
          },
          {
            "display": "Soccer Practice",
            "value": "Soccer Practice",
          },
          {
            "display": "Baseball Practice",
            "value": "Baseball Practice",
          },
          {
            "display": "Football Practice",
            "value": "Football Practice",
          },
        ],
        textField: 'display',
        valueField: 'value',
      ),
    );
  }
}
