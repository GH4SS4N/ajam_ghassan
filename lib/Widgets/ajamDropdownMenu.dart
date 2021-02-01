import 'package:ajam/main.dart';
import 'package:flutter/material.dart';

class AjamDropdown extends StatefulWidget {
  List<String> options;
  double width;
  AjamDropdown({@required this.options, this.width});

  @override
  _AjamDropdown createState() => _AjamDropdown(options: options, width: width);
}

class _AjamDropdown extends State<AjamDropdown> {
  List<String> options;
  String dropdownValue;
  double width;
  _AjamDropdown({@required this.options, this.width});

  @override
  void initState() {
    // TODO: implement initState
    dropdownValue = options[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24),
      child: DropdownButton<String>(
        dropdownColor: Theme.of(context).primaryColor,
        isExpanded: true,
        value: dropdownValue,
        items: options
            .map(
              (String item) => DropdownMenuItem<String>(
                child: Text(
                  item,
                ),
                value: item,
              ),
            )
            .toList(),
        isDense: true,
        underline: Container(),
        onChanged: (String newValue) {
          setState(() {
            dropdownValue = newValue;
          });
        },
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(50)),
          border: Border.all(color: lightgrey)),
    );
  }
}
