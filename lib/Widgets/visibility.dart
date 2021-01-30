import 'package:ajam/Widgets/CustomSwetcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class AjamVisibility extends StatefulWidget {
  String apeer = "";
  String disapeer = "";

  AjamVisibility({@required this.apeer, @required this.disapeer});
  @override
  _AjamVisibility createState() =>
      _AjamVisibility(apeer: apeer, disapeer: disapeer);
}

class _AjamVisibility extends State<AjamVisibility> {
  bool state = true;
  String apeer = "";
  String disapeer = "";

  _AjamVisibility({@required this.apeer, @required this.disapeer});
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    // var globalHight = 50.0;
    // var globalWidth = MediaQuery.of(context).size.width * 0.9;

    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
            child: Text(
              "حالة الظهور",
              style: TextStyle(color: darkblue, fontSize: 20),
            ),
          ),
        ],
      ),
      CustomSwutcher(apeer: apeer, disapeer: disapeer)
    ]);
  }
}
