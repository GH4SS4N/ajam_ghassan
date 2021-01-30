import 'package:ajam/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AjamDropdown extends StatefulWidget {
  List<String> options;
  AjamDropdown({@required this.options});

  @override
  _AjamDropdown createState() => _AjamDropdown(options: options);
}

class _AjamDropdown extends State<AjamDropdown> {
  List<String> options;
  String dropdownValue;
  _AjamDropdown({@required this.options});

  @override
  void initState() {
    // TODO: implement initState
    dropdownValue = options[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      //icon: Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: TextStyle(color: Colors.black),
      underline: Container(
        height: 2,
        color: orange,
      ),
      onChanged: (String newValue) {
        setState(() {
          dropdownValue = newValue;
        });
      },
      items: options.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
