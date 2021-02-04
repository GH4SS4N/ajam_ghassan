import 'dart:io';

import 'package:ajam/Widgets/CustomSwetcher.dart';
import 'package:ajam/Widgets/ajamDropdownMenu.dart';
import 'package:ajam/Widgets/visibility.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_range_picker/time_range_picker.dart';

import 'main.dart';

class InfoPage extends StatefulWidget {
  @override
  _InfoPage createState() => _InfoPage();
}

class _InfoPage extends State<InfoPage> {
  TimeRange result;
  File file;
  @override
  initState() {
    // TODO: implement initState
    result = TimeRange(
        startTime: TimeOfDay(hour: 0, minute: 0),
        endTime: TimeOfDay(hour: 0, minute: 0));
    super.initState();
  }

  Future<void> filePicker() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg'],
    );

    if (result != null) {
      file = File(result.files.single.path);
      print(file.toString());
    } else {
      // User canceled the picker
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var globalHight = 50.0;
    var globalWidth = MediaQuery.of(context).size.width * 0.9;

    // TODO: implement build
    return SingleChildScrollView(
      child: Container(
        height: 800,
        width: double.infinity,
        //color: green,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                  child: Text(
                    "معلومات اساسيه",
                    style: TextStyle(color: darkblue, fontSize: 20),
                  ),
                ),
              ],
            ),
            Container(
              width: globalWidth,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // restorant profile photo
                  Container(
                    // color: Colors.red,
                    child: Stack(
                      children: [
                        ClipOval(
                          child: CircleAvatar(
                              minRadius: 35,
                              backgroundColor: darkblue,
                              child: file == null
                                  ? Container()
                                  : SizedBox(
                                      child: Image.file(
                                        file,
                                        fit: BoxFit.fill,
                                      ),
                                      height: 80,
                                      width: 80,
                                    )),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          child: Container(
                            height: 20,
                            width: 20,
                            padding: EdgeInsets.fromLTRB(2, 0, 0, 2),
                            child: IconButton(
                                //iconSize: 15,
                                color: orange,
                                icon: Icon(
                                  Icons.create_sharp,
                                  size: 10,
                                ),
                                onPressed: () {
                                  filePicker();
                                }),
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 7,
                                    offset: Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ],
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50))),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // restorant name
                  Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 23, 0),
                        child: Column(
                          children: [
                            Text(
                              "الاسم",
                              style: TextStyle(color: orange),
                            )
                          ],
                        ),
                      ),
                      Container(
                        height: globalHight,
                        width: globalWidth * 0.78,
                        child: Padding(
                            padding: const EdgeInsets.fromLTRB(25, 10, 25, 0),
                            child: TextField(
                              cursorColor: orange,
                            )),
                        decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.3),
                            borderRadius:
                                BorderRadius.all(Radius.circular(50))),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Container(
              width: globalWidth,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // location widget
                  Container(
                    height: globalHight,
                    width: globalWidth * 0.18,
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.3),
                        borderRadius: BorderRadius.all(Radius.circular(50))),
                  ),
                  //phone number
                  Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 23, 0),
                        child: Column(
                          children: [
                            Text(
                              "رقم الجوال",
                              style: TextStyle(color: orange),
                            )
                          ],
                        ),
                      ),
                      Container(
                        height: globalHight,
                        width: globalWidth * 0.38,
                        child: Padding(
                            padding: const EdgeInsets.fromLTRB(25, 10, 25, 0),
                            child: TextField(
                              cursorColor: orange,
                            )),
                        decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.3),
                            borderRadius:
                                BorderRadius.all(Radius.circular(50))),
                      ),
                    ],
                  ),
                  // food kind
                  Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 23, 0),
                        child: Column(
                          children: [
                            Text(
                              "النوع",
                              style: TextStyle(color: orange),
                            )
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          print(
                              "change the restorant kind == infopage line 190");
                        },
                        child: Container(
                          height: globalHight,
                          width: globalWidth * 0.38,
                          child: Center(
                            child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(25, 10, 25, 0),
                                child: AjamDropdown(staticOptions: [
                                  'سفر',
                                  'بنشري',
                                  'بقايل',
                                  'مطاعم'
                                ])),
                          ),
                          decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.3),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50))),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 23, 0),
                      child: Column(
                        children: [
                          Text(
                            "الموقع الالكتروني",
                            style: TextStyle(color: orange),
                          )
                        ],
                      ),
                    ),
                    Container(
                      height: globalHight,
                      width: globalWidth,
                      child: Padding(
                          padding: const EdgeInsets.fromLTRB(25, 10, 25, 0),
                          child: TextField(
                            cursorColor: orange,
                          )),
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.3),
                          borderRadius: BorderRadius.all(Radius.circular(50))),
                    ),
                  ],
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                  child: Text(
                    "ساعات العمل",
                    style: TextStyle(color: darkblue, fontSize: 20),
                  ),
                ),
              ],
            ),
            Container(
              width: globalWidth,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // working time
                  InkWell(
                    onTap: () {
                      showTimeRangePicker(
                        fromText: "من",
                        toText: "الى",
                        onStartChange: (y) {
                          setState(() {
                            result.startTime = y;
                          });
                        },
                        onEndChange: (x) {
                          setState(() {
                            result.endTime = x;
                          });
                        },
                        strokeColor: orange,
                        handlerColor: orange,
                        context: context,
                      );
                    },
                    child: Container(
                      height: globalHight,
                      width: globalWidth * 0.3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "السبت",
                            style: TextStyle(color: orange),
                          ),
                          Text(
                            result.startTime.format(context) +
                                " -" +
                                result.endTime.format(context),
                            style: TextStyle(fontSize: 11),
                          )
                        ],
                      ),
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.3),
                          borderRadius: BorderRadius.all(Radius.circular(50))),
                    ),
                  ),
                  //phone number
                  InkWell(
                    onTap: () {
                      showTimeRangePicker(
                        fromText: "من",
                        toText: "الى",
                        onStartChange: (y) {
                          setState(() {
                            result.startTime = y;
                          });
                        },
                        onEndChange: (x) {
                          setState(() {
                            result.endTime = x;
                          });
                        },
                        strokeColor: orange,
                        handlerColor: orange,
                        context: context,
                      );
                    },
                    child: Container(
                      height: globalHight,
                      width: globalWidth * 0.3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "الاحد",
                            style: TextStyle(color: orange),
                          ),
                          Text(
                            result.startTime.format(context) +
                                " -" +
                                result.endTime.format(context),
                            style: TextStyle(fontSize: 11),
                          )
                        ],
                      ),
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.3),
                          borderRadius: BorderRadius.all(Radius.circular(50))),
                    ),
                  ),
                  // food kind
                  InkWell(
                    onTap: () {
                      showTimeRangePicker(
                        fromText: "من",
                        toText: "الى",
                        onStartChange: (y) {
                          setState(() {
                            result.startTime = y;
                          });
                        },
                        onEndChange: (x) {
                          setState(() {
                            result.endTime = x;
                          });
                        },
                        strokeColor: orange,
                        handlerColor: orange,
                        context: context,
                      );
                    },
                    child: Container(
                      height: globalHight,
                      width: globalWidth * 0.3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "الاثنين",
                            style: TextStyle(color: orange),
                          ),
                          Text(
                            result.startTime.format(context) +
                                " -" +
                                result.endTime.format(context),
                            style: TextStyle(fontSize: 11),
                          )
                        ],
                      ),
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.3),
                          borderRadius: BorderRadius.all(Radius.circular(50))),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: globalWidth,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // location widget
                  InkWell(
                    onTap: () {
                      showTimeRangePicker(
                        fromText: "من",
                        toText: "الى",
                        onStartChange: (y) {
                          setState(() {
                            result.startTime = y;
                          });
                        },
                        onEndChange: (x) {
                          setState(() {
                            result.endTime = x;
                          });
                        },
                        strokeColor: orange,
                        handlerColor: orange,
                        context: context,
                      );
                    },
                    child: Container(
                      height: globalHight,
                      width: globalWidth * 0.3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "الثلاثاء",
                            style: TextStyle(color: orange),
                          ),
                          Text(
                            result.startTime.format(context) +
                                " -" +
                                result.endTime.format(context),
                            style: TextStyle(fontSize: 11),
                          )
                        ],
                      ),
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.3),
                          borderRadius: BorderRadius.all(Radius.circular(50))),
                    ),
                  ),
                  //phone number
                  InkWell(
                    onTap: () {
                      showTimeRangePicker(
                        fromText: "من",
                        toText: "الى",
                        onStartChange: (y) {
                          setState(() {
                            result.startTime = y;
                          });
                        },
                        onEndChange: (x) {
                          setState(() {
                            result.endTime = x;
                          });
                        },
                        strokeColor: orange,
                        handlerColor: orange,
                        context: context,
                      );
                    },
                    child: Container(
                      height: globalHight,
                      width: globalWidth * 0.3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "الاربعاء",
                            style: TextStyle(color: orange),
                          ),
                          Text(
                            result.startTime.format(context) +
                                " -" +
                                result.endTime.format(context),
                            style: TextStyle(fontSize: 11),
                          )
                        ],
                      ),
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.3),
                          borderRadius: BorderRadius.all(Radius.circular(50))),
                    ),
                  ),
                  // food kind
                  InkWell(
                    onTap: () {
                      showTimeRangePicker(
                        fromText: "من",
                        toText: "الى",
                        onStartChange: (y) {
                          setState(() {
                            result.startTime = y;
                          });
                        },
                        onEndChange: (x) {
                          setState(() {
                            result.endTime = x;
                          });
                        },
                        strokeColor: orange,
                        handlerColor: orange,
                        context: context,
                      );
                    },
                    child: Container(
                      height: globalHight,
                      width: globalWidth * 0.3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "الخميس",
                            style: TextStyle(color: orange),
                          ),
                          Text(
                            result.startTime.format(context) +
                                " -" +
                                result.endTime.format(context),
                            style: TextStyle(fontSize: 11),
                          )
                        ],
                      ),
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.3),
                          borderRadius: BorderRadius.all(Radius.circular(50))),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: globalWidth,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      showTimeRangePicker(
                        fromText: "من",
                        toText: "الى",
                        onStartChange: (y) {
                          setState(() {
                            result.startTime = y;
                          });
                        },
                        onEndChange: (x) {
                          setState(() {
                            result.endTime = x;
                          });
                        },
                        strokeColor: orange,
                        handlerColor: orange,
                        context: context,
                      );
                    },
                    child: Container(
                      height: globalHight,
                      width: globalWidth * 0.3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "الجمعه",
                            style: TextStyle(color: orange),
                          ),
                          Text(
                            result.startTime.format(context) +
                                " -" +
                                result.endTime.format(context),
                            style: TextStyle(fontSize: 11),
                          )
                        ],
                      ),
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.3),
                          borderRadius: BorderRadius.all(Radius.circular(50))),
                    ),
                  ),
                  Container(
                    height: globalHight,
                    width: globalWidth * 0.3,
                    decoration: BoxDecoration(
                        // color: Colors.grey.withOpacity(0.3),
                        borderRadius: BorderRadius.all(Radius.circular(50))),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.04737,
                    width: globalWidth * 0.28,
                    decoration: BoxDecoration(
                        //  color: Colors.grey.withOpacity(0.3),
                        borderRadius: BorderRadius.all(Radius.circular(50))),
                  ),
                ],
              ),
            ),
            AjamVisibility(apeer: "مدرج", disapeer: "مخفي"),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                      child: Text(
                        "خيار استقبال الطلب",
                        style: TextStyle(color: darkblue, fontSize: 20),
                      ),
                    ),
                  ],
                ),
                CustomSwutcher(apeer: "ساعات العمل", disapeer: "يدوي")
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    // TODO: الدعم الفني
                  },
                  child: Container(
                    margin: EdgeInsets.fromLTRB(0, 15, 0, 15),
                    height: globalHight,
                    width: MediaQuery.of(context).size.width * 0.97,
                    child: Center(
                        child: Text(
                      "تواصل مع الدعم الفني",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: MediaQuery.of(context).size.height * 0.03),
                    )),
                    decoration: BoxDecoration(
                        color: darkblue,
                        borderRadius: BorderRadius.all(Radius.circular(50))),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
