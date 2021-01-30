import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class CustomSwutcher extends StatefulWidget {
  String apeer = "";
  String disapeer = "";

  CustomSwutcher({@required this.apeer, @required this.disapeer});
  @override
  _CustomSwutcher createState() =>
      _CustomSwutcher(apeer: apeer, disapeer: disapeer);
}

class _CustomSwutcher extends State<CustomSwutcher> {
  var _state = true;
  String apeer = "";
  String disapeer = "";

  _CustomSwutcher({@required this.apeer, @required this.disapeer});
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    var globalHight = 50.0;
    var globalWidth = MediaQuery.of(context).size.width * 0.9;

    return Container(
      width: globalWidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            // color: lightgrey,
            //  height: globalHight,
            width: globalWidth * 0.65,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      _state = true;
                    });
                  },
                  child: Container(
                    //  height: globalHight * 0.7,
                    width: globalWidth * 0.3,
                    decoration: BoxDecoration(
                        border: _state ? null : Border.all(color: Colors.grey),
                        color: _state ? orange : Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(50))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.check,
                          color: _state ? Colors.white : orange,
                        ),
                        Text(
                          apeer,
                          style: TextStyle(
                              fontSize: 15,
                              color: _state ? Colors.white : Colors.black),
                        )
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      _state = false;
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                    // color: Colors.amber,
                    //height: globalHight * 0.7,
                    width: globalWidth * 0.25,
                    decoration: BoxDecoration(
                        border: _state ? Border.all(color: Colors.grey) : null,
                        color: _state ? Colors.white : orange,
                        borderRadius: BorderRadius.all(Radius.circular(50))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.do_not_disturb,
                          color: _state ? orange : Colors.white,
                        ),
                        Text(
                          disapeer,
                          style: TextStyle(
                              fontSize: 15,
                              color: _state ? Colors.black : Colors.white),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
