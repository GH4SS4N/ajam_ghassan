//import 'dart:html';

import 'dart:io';

import 'package:ajam/Widgets/CustomSwetcher.dart';
import 'package:ajam/Widgets/ajamDropdownMenu.dart';
import 'package:ajam/Widgets/visibility.dart';
import 'package:ajam/main.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EditableMenu extends StatefulWidget {
  @override
  _EditableMenu createState() => _EditableMenu();
}

class _EditableMenu extends State<EditableMenu> {
  bool editingObject = false;
  File file;

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        var globalHight = 50.0;
        var globalWidth = MediaQuery.of(context).size.width * 0.9;
        return AlertDialog(
          // title: Text('AlertDialog Title'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 23, 0),
                      child: Column(
                        children: [
                          Text(
                            "اسم التصنيف",
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
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('اضافة'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('الغاء'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
    return Container(
      height: double.infinity,
      //color: orange,
      child: Stack(
        children: [
          Container(
            height: 800,
            child: ListView(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.08,
                  width: double.maxFinite,
                  //color: Colors.amber,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return Container(
                          alignment: Alignment.center,
                          //color: orange,
                          padding: EdgeInsets.all(8),
                          margin: EdgeInsets.all(8),
                          child: Text(" data $index "),
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    spreadRadius: 1,
                                    blurRadius: 1,
                                    offset: Offset(0, 3))
                              ],
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(45)),
                              border: Border.all(color: grey.withOpacity(0.5))),
                        );
                      }),
                ),
                Container(
                    color: darkgrey.withOpacity(0.2),
                    margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
                    height: 900, //MediaQuery.of(context).size.height * 0.9,
                    width: double.infinity,
                    child: ListView.builder(
                        itemCount: 100,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.fromLTRB(0, 0, 0, 2),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Container(
                                      height: 80,
                                      width: 80,
                                      // margin: EdgeInsets.all(8),
                                      color: Colors.amber,
                                    ),
                                  ),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.68,
                                  // color: green,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "data $index",
                                            style: TextStyle(fontSize: 20),
                                          ),
                                          Text("data $index"),
                                        ],
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            " $index",
                                            style: TextStyle(fontSize: 20),
                                          ),
                                          Text("SAR"),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            height: 100,
                            width: double.maxFinite,
                            color: Colors.white,
                          );
                        }))
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                //alignment: Alignment.center,
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                    color: orange,
                    borderRadius: BorderRadius.all(Radius.circular(50))),
                //  color: orange,
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      editingObject = true;
                    });

                    print("item addition to the menu ");
                  },
                  icon: Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
              ),
            ),
          ),
          AnimatedContainer(
            color: Colors.white,
            height: editingObject ? double.maxFinite : 1,
            duration: Duration(milliseconds: 50),
            child: editingObject
                ? SingleChildScrollView(
                    child: Container(
                      child: Stack(
                        children: [
                          Container(
                            height: 800,
                            // color: Colors.amber,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () {
                                    filePicker();
                                  },
                                  child: Container(
                                      alignment: Alignment.center,
                                      color: lightgrey,
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.6,
                                      width: MediaQuery.of(context).size.width,
                                      child: file == null
                                          ? Icon(
                                              Icons.image,
                                              color: orange,
                                            )
                                          : Image.file(
                                              file,
                                              fit: BoxFit.contain,
                                            )),
                                ),
                                Stack(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 0, 23, 0),
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
                                      width: globalWidth,
                                      child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              25, 10, 25, 0),
                                          child: TextField(
                                            cursorColor: orange,
                                          )),
                                      decoration: BoxDecoration(
                                          color: Colors.grey.withOpacity(0.3),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(50))),
                                    ),
                                  ],
                                ),
                                Stack(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 0, 23, 0),
                                      child: Column(
                                        children: [
                                          Text(
                                            "وصف المنتج",
                                            style: TextStyle(color: orange),
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: globalHight * 2,
                                      width: globalWidth,
                                      child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              25, 10, 25, 0),
                                          child: TextField(
                                            cursorColor: orange,
                                          )),
                                      decoration: BoxDecoration(
                                          color: Colors.grey.withOpacity(0.3),
                                          borderRadius: BorderRadius.all(
                                              Radius.lerp(Radius.circular(20),
                                                  Radius.circular(20), 10))),
                                    ),
                                  ],
                                ),

                                //
                                Container(
                                  width: globalWidth,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Stack(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 0, 23, 0),
                                            child: Column(
                                              children: [
                                                Text(
                                                  "السعر",
                                                  style:
                                                      TextStyle(color: orange),
                                                )
                                              ],
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.fromLTRB(
                                                13, 0, 0, 0),
                                            padding: const EdgeInsets.fromLTRB(
                                                25, 10, 25, 0),
                                            height: globalHight,
                                            width: globalWidth * 0.3,
                                            child: TextField(
                                              cursorColor: orange,
                                            ),
                                            decoration: BoxDecoration(
                                                color: Colors.grey
                                                    .withOpacity(0.3),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(50))),
                                          ),
                                        ],
                                      ),
                                      Text("ريال")
                                    ],
                                  ),
                                ),
                                CustomSwutcher(
                                    apeer: 'متوفر', disapeer: "غير متوفر"),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 0, 8, 0),
                                      child: Text(
                                        "تصنيف المنتج",
                                        style: TextStyle(
                                            color: darkblue, fontSize: 20),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  width: globalWidth,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        // color: lightgrey,
                                        height: globalHight,
                                        width: globalWidth,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.fromLTRB(
                                                  13, 0, 13, 0),
                                              child: AjamDropdown(
                                                options: [
                                                  "اي شي",
                                                  "مقبلات",
                                                  "موالح",
                                                  "حلا"
                                                ],
                                              ),
                                              // color: Colors.amber,
                                              height: globalHight * 0.8,
                                              width: globalWidth * 0.78,
                                              decoration: BoxDecoration(
                                                  color: Colors.grey
                                                      .withOpacity(0.3),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(50))),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                _showMyDialog();
                                                print(
                                                    "line 373 === اضفه تصنيف");
                                              },
                                              child: Container(
                                                height: globalHight * 0.8,
                                                width: globalWidth * 0.2,
                                                child: Center(
                                                  child: Text(
                                                    "اضافه تصنيف",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                decoration: BoxDecoration(
                                                    color: orange,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                50))),
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),

                                AjamVisibility(
                                  apeer: 'مدرج',
                                  disapeer: "غير مدرج",
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        // TODO: الدعم الفني
                                      },
                                      child: Container(
                                        margin:
                                            EdgeInsets.fromLTRB(0, 15, 0, 15),
                                        height: globalHight,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.97,
                                        child: Center(
                                            child: Text(
                                          "اضافه المنتج ",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.03),
                                        )),
                                        decoration: BoxDecoration(
                                            color: orange,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(50))),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                    color: orange,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50))),
                                //  color: orange,
                                child: IconButton(
                                  alignment: Alignment.center,
                                  onPressed: () {
                                    setState(() {
                                      editingObject = false;
                                    });

                                    print("item addition to the menu ");
                                  },
                                  icon: Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Container(),
          )
        ],
      ),
    );
  }
}
