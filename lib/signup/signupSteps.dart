//import 'dart:html';

import 'package:ajam/Widgets/ajamDropdownMenu.dart';
import 'package:ajam/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../staticData.dart';

class SignupSteps extends StatefulWidget {
  @override
  _SignupSteps createState() => _SignupSteps();
}

class _SignupSteps extends State<SignupSteps> {
  bool sms = false;
  String phoneNumber = "0583082201";
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        resizeToAvoidBottomPadding: true,
        body: Column(
          children: [
            Material(
              elevation: 5,
              child: Container(
                height: 360,
                width: double.infinity,
                color: lightgrey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      height: 60,
                      //color: grey,
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: Icon(
                              Icons.arrow_back_ios,
                              color: orange,
                              size: 40,
                            ),
                          ),
                          Expanded(
                              child: Text(
                            "حساب صاحب متجر",
                            style: TextStyle(
                                color: orange,
                                fontFamily: "Questv1",
                                fontSize: 20),
                          )),
                          Icon(
                            Icons.store,
                            color: orange,
                            size: 40,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 120,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset("assets/img/arabic.png"),
                          Image.asset("assets/img/shape.png"),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(20),
                      padding: EdgeInsets.fromLTRB(10, 3, 10, 3),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(phoneNumber),
                          SizedBox(
                            width: 20,
                          ),
                          Icon(
                            Icons.create_rounded,
                            color: darkgrey,
                          )
                        ],
                      ),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(),
                          borderRadius: BorderRadius.all(Radius.circular(50))),
                      //color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
                child: sms
                    ? SizedBox(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(),
                              Text("تم ارسال رمز التفعيل الى هاتفك "),
                              Container(
                                child: Column(
                                  children: [
                                    TextField(
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(Icons.phone_android),
                                        //icon: Icon(Icons.phone),
                                        hintText: "رمز التفعيل ",
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .primaryColor),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          borderSide:
                                              BorderSide(color: lightgrey),
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                        onPressed: () {
                                          sms = false;
                                          setState(() {});
                                        },
                                        child: Text('اعاده ارسال '))
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: () {},
                                child: Container(
                                  //width: ,
                                  height: 60,
                                  margin: EdgeInsets.all(20),
                                  padding: EdgeInsets.fromLTRB(10, 3, 10, 3),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        " تسجيل ",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                    ],
                                  ),
                                  decoration: BoxDecoration(
                                      color: darkblue,
                                      border: Border(),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(50))),
                                  //color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : SingleChildScrollView(
                        child: Container(
                          padding: EdgeInsets.all(30),
                          child: Column(
                            children: [
                              TextFormField(
                                // maxLength: 10,
                                // maxLengthEnforced: true,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.account_circle),
                                  //icon: Icon(Icons.phone),
                                  hintText: "الاسم الكامل ",
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(50),
                                    borderSide: BorderSide(
                                        color: Theme.of(context).primaryColor),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(50),
                                    borderSide: BorderSide(color: lightgrey),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              //password\
                              TextFormField(
                                // maxLength: 10,
                                // maxLengthEnforced: true,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.lock),
                                  //icon: Icon(Icons.phone),
                                  hintText: "كلمه المرور ",
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(50),
                                    borderSide: BorderSide(
                                        color: Theme.of(context).primaryColor),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(50),
                                    borderSide: BorderSide(color: lightgrey),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              // another password
                              TextFormField(
                                // maxLength: 10,
                                // maxLengthEnforced: true,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.lock_outline),
                                  hintText: "تاكيد كلمه المرور",
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(50),
                                    borderSide: BorderSide(
                                        color: Theme.of(context).primaryColor),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(50),
                                    borderSide: BorderSide(color: lightgrey),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),

                              //dropdown (countries)
                              AjamDropdown(options: countries),
                              SizedBox(
                                height: 30,
                              ),
                              //contries dropDown
                              AjamDropdown(options: cities),
                              SizedBox(
                                height: 30,
                              ),
                              //email
                              TextFormField(
                                // maxLength: 10,
                                // maxLengthEnforced: true,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.email),
                                  //icon: Icon(Icons.phone),
                                  hintText: "البريد الالكتروني (اختياري) ",
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(50),
                                    borderSide: BorderSide(
                                        color: Theme.of(context).primaryColor),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(50),
                                    borderSide: BorderSide(color: lightgrey),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              InkWell(
                                onTap: () {
                                  sms = true;
                                  setState(() {});
                                },
                                child: Container(
                                  //width: ,
                                  height: 60,
                                  margin: EdgeInsets.all(20),
                                  padding: EdgeInsets.fromLTRB(10, 3, 10, 3),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        " التالي ",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                    ],
                                  ),
                                  decoration: BoxDecoration(
                                      color: darkblue,
                                      border: Border(),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(50))),
                                  //color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ))
          ],
        ),
      ),
    );
  }
}
