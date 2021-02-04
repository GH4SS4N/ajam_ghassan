import 'dart:io';

import 'package:ajam/Widgets/ajamDropdownMenu.dart';
import 'package:ajam/data/Exceptions.dart';
import 'package:ajam/data/requests.dart';
import 'package:ajam/main.dart';
import 'package:ajam/signup/MainPage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

import '../staticData.dart';

enum SignupStep { login, form, verification, profile, done }

final signupStepProvider = StateProvider<SignupStep>((ref) => SignupStep.form);

//context.read(signupStepProvider).state = SignupStep.verification;

class SignupSteps extends ConsumerWidget {
  @override
  Widget build(context, watch) {
    final step = watch(signupStepProvider).state;
    final currentUser = watch(currentUserProvider).state;

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        resizeToAvoidBottomPadding: false,
        body: Column(
          children: [
            Material(
              elevation: 5,
              child: Container(
                height: step == SignupStep.profile || step == SignupStep.done
                    ? 130
                    : 300,
                width: double.infinity,
                color: lightgrey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AjamAppBar(),
                    step == SignupStep.profile || step == SignupStep.done
                        ? Container()
                        : SizedBox(
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
                          Text(currentUser.username),
                          SizedBox(
                            width: 20,
                          ),
                          step == SignupStep.profile || step == SignupStep.done
                              ? Text(currentUser.get("name"))
                              : Icon(
                                  Icons.create_rounded,
                                  color: darkgrey,
                                )
                        ],
                      ),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(),
                          borderRadius: BorderRadius.all(Radius.circular(50))),
                    ),
                  ],
                ),
              ),
            ),
            step == SignupStep.login || step == SignupStep.verification
                ? step == SignupStep.login
                    ? Ajamlogin()
                    : AjamVerification()
                : step == SignupStep.profile || step == SignupStep.done
                    ? step == SignupStep.done
                        ? AjamDone()
                        : AjamProfile()
                    : step == SignupStep.verification
                        ? AjamVerification()
                        : AjamForm()
          ],
        ),
      ),
    );
  }
}

class AjamVerification extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final accountType = watch(accountTypeProvider).state;
    return Expanded(
      child: Padding(
        padding: EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(),
            Text("تم إرسال رمز تفعيل إلى هاتفك "),
            Container(
              child: Column(
                children: [
                  TextField(
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ], // Only numbers can be entered
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.phone_android),
                      hintText: "رمز التفعيل ",
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide:
                            BorderSide(color: Theme.of(context).primaryColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: BorderSide(color: lightgrey),
                      ),
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        context.read(signupStepProvider).state =
                            SignupStep.form;
                      },
                      child: Text('اعاده ارسال '))
                ],
              ),
            ),
            InkWell(
              onTap: () {
                context.read(signupStepProvider).state = SignupStep.profile;
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
                      "تسجيل",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                    color: darkblue,
                    border: Border(),
                    borderRadius: BorderRadius.all(Radius.circular(50))),
                //color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Ajamlogin extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final loading = watch(loadingProvider).state;

    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Spacer(),
            Container(
              // color: orange,
              child: Column(
                children: [
                  TextFormField(
                    obscureText: true,
                    onChanged: (text) =>
                        context.read(currentUserProvider).state.password = text,
                    // maxLength: 10,
                    // maxLengthEnforced: true,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock),
                      //icon: Icon(Icons.phone),
                      hintText: "كلمه المرور ",
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide:
                            BorderSide(color: Theme.of(context).primaryColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: BorderSide(color: lightgrey),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
            InkWell(
              onTap: () {
                // set loading to true
                context.read(loadingProvider).state = true;

                // login current user
                login(context.read(currentUserProvider).state)
                    // then update the user and request OTP
                    .then(
                      (loggedUser) {
                        context.read(currentUserProvider).state = loggedUser;

                        return otpRequest(loggedUser.username);
                      },
                    )
                    // then to the verification step
                    .then((nothing) => context.read(signupStepProvider).state =
                        SignupStep.verification)
                    // if there was an error loging-in or requesting an OTP
                    .catchError((e) async {
                      // check if the user was logged in
                      if (await ParseUser.currentUser() != null)
                        // log them out
                        logout(context.read(currentUserProvider).state);
                      // then throw the error
                      exceptionSnackbar(context, e);
                    })
                    // when everything is done, set loading to false
                    .whenComplete(
                        () => context.read(loadingProvider).state = false);
              },
              child: Container(
                height: 60,
                margin: EdgeInsets.all(20),
                padding: EdgeInsets.fromLTRB(10, 3, 10, 3),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    loading
                        ? CircularProgressIndicator()
                        : Text(
                            "تسجيل الدخول",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                  ],
                ),
                decoration: BoxDecoration(
                    color: darkblue,
                    border: Border(),
                    borderRadius: BorderRadius.all(Radius.circular(50))),
                //color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
    ;
  }
}

class AjamProfile extends ConsumerWidget {
  File file;

  Future<void> filePicker() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg'],
    );

    if (result != null) {
      file = File(result.files.single.path);
      // state provider for the images
      print(file.toString());
    } else {
      // User canceled the picker
    }
    //
  }

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final accountType = watch(accountTypeProvider).state;

    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
              child: Column(
                children: [
                  Text("لنقم باضافة بعض معلومات المتجر"),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    width: 80,
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
                  Text("الشعار (اختياري)"),
                  SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    // maxLength: 10,
                    // maxLengthEnforced: true,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.store),
                      hintText: "اسم المتجر",
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide:
                            BorderSide(color: Theme.of(context).primaryColor),
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
                  AjamDropdown(
                    optionsState: storeTypesProvider,
                    selectedState: storeTypeSelectedProvider,
                  ),
                  // Expanded(child: null),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                context.read(signupStepProvider).state = SignupStep.done;
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
                      " حفظ ",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                    color: darkblue,
                    border: Border(),
                    borderRadius: BorderRadius.all(Radius.circular(50))),
                //color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AjamDone extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final accountType = watch(accountTypeProvider).state;

    return OwnerDone();
  }
}

class OwnerDone extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              height: 275,
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 6),
                scrollDirection: Axis.horizontal,
                children: [ImageCard(), ImageCard()],
              ),
            ),
            Container(
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: Theme.of(context).primaryColor,
                    size: 50,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    "تم حفظ بيانات متجرك بنجاح",
                    style: TextStyle(fontSize: 20, color: darkblue),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 13),
              child: Column(
                children: [
                  Text(
                    "نقوم الان بتسجيل الشركاء وبناء قاعدة البايانات",
                    style: TextStyle(color: darkgrey),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text("ترقبو افتتاح المتاجر بتاريخ 15\2\2021",
                      style: TextStyle(color: darkgrey))
                ],
              ),
            ),
            Container()
          ],
        ),
      ),
    );
  }
}

class AjamAppBar extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final accountType = watch(accountTypeProvider).state;
    final signup_Step = watch(signupStepProvider).state;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      height: 60,
      child: Row(
        children: [
          signup_Step == SignupStep.form ||
                  signup_Step == SignupStep.verification
              ? IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Theme.of(context).primaryColor,
                    size: 40,
                  ),
                )
              : IconButton(
                  onPressed: () {
                    context.read(signupStepProvider).state = SignupStep.form;
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.logout,
                    color: Theme.of(context).primaryColor,
                    size: 40,
                  ),
                ),
          Expanded(
              child: accountType == AccountType.owner
                  ? Text(
                      "حساب صاحب متجر",
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontFamily: "Questv1",
                          fontSize: 20),
                    )
                  : Text(
                      "حساب كابتن",
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontFamily: "Questv1",
                          fontSize: 20),
                    )),
          Icon(
            accountType == AccountType.owner
                ? Icons.store
                : Icons.directions_car,
            color: Theme.of(context).primaryColor,
            size: 40,
          ),
        ],
      ),
    );
  }
}

class AjamForm extends ConsumerWidget {
  final _formKey = GlobalKey<FormState>();
  void validate() {
    if (_formKey.currentState.validate()) {}
  }

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final accountType = watch(accountTypeProvider).state;
    String name;
    String password;
    String email;

    return Expanded(
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(30),
          child: Form(
            child: Column(
              children: [
                TextFormField(
                  // maxLength: 10,
                  // maxLengthEnforced: true,
                  // name
                  validator: (value) {},
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.account_circle),
                    //icon: Icon(Icons.phone),
                    hintText: "الاسم الكامل ",
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide:
                          BorderSide(color: Theme.of(context).primaryColor),
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
                //password\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
                TextFormField(
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  // maxLength: 10,
                  // maxLengthEnforced: true,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    //icon: Icon(Icons.phone),
                    hintText: "كلمه المرور ",
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide:
                          BorderSide(color: Theme.of(context).primaryColor),
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
                // another password\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
                TextFormField(
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  // maxLength: 10,
                  // maxLengthEnforced: true,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock_outline),
                    hintText: "تاكيد كلمه المرور",
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide:
                          BorderSide(color: Theme.of(context).primaryColor),
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
                AjamDropdown(
                  staticOptions: countries,
                  selectedState: countrySelectedProvider,
                ),
                SizedBox(
                  height: 30,
                ),
                //contries dropDown
                AjamDropdown(
                  staticOptions: cities,
                  selectedState: citySelectedProvider,
                ),
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
                      borderSide:
                          BorderSide(color: Theme.of(context).primaryColor),
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
                    context.read(signupStepProvider).state =
                        SignupStep.verification;
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
                          " تسجيل ",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ],
                    ),
                    decoration: BoxDecoration(
                        color: darkblue,
                        border: Border(),
                        borderRadius: BorderRadius.all(Radius.circular(50))),
                    //color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ImageCard extends StatelessWidget {
  File image;
  bool approved;
  String review;
  ImageCard({this.approved, this.image, this.review});

  Future<void> filePicker() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg'],
    );

    if (result != null) {
      image = File(result.files.single.path);
      // state provider for the images
      print(image.toString());
    } else {
      // User canceled the picker
    }
    //
  }

  @override
  Widget build(BuildContext context) {
    // constrain the width of the card
    return InkWell(
      onTap: () {
        // context.read(accountTypeProvider).state = accountType;
        filePicker();
      },
      child: SizedBox(
        width: 300,
        // cards are like container but with elevation maybe
        child: Card(
          margin: EdgeInsets.symmetric(horizontal: 6),
          color: grey,
          // this Column lays out the image and card body below
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              // adds circular borders to the top of the image
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5),
                  topRight: Radius.circular(5),
                ),
                child: image == null
                    ? Center(
                        child: Icon(Icons.image_not_supported),
                      )
                    : Image.file(
                        image,
                        fit: BoxFit.cover,
                        width: 300,
                        height: 150,
                      ),
              ),
              // Padding(
              //   padding: const EdgeInsets.all(12.0),
              //   // lays out the text and then the icon to the left
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       // the text is expanded because we want it to take all the
              //       // horizontal space it needs, pushing the icon to the end
              //       Expanded(
              //         // lays out the header and the body below it
              //         child: Column(
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: [
              //             Text(
              //               header,
              //               style: TextStyle(
              //                 fontWeight: FontWeight.bold,
              //                 color: Colors.white,
              //                 fontSize: 24,
              //               ),
              //             ),
              //             Text(body, style: TextStyle(color: Colors.white)),
              //           ],
              //         ),
              //       ),
              //       // this icon has a fixed size. While its sibling, the
              //       // expanded widget, will fill the remaining space
              //       Icon(this.iconData, size: 60, color: Colors.white),
              //     ],
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}

//lllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllll
