import 'dart:io';

import 'package:ajam/Widgets/ajamDropdownMenu.dart';
import 'package:ajam/data/Captain.dart';
import 'package:ajam/data/Exceptions.dart';
import 'package:ajam/data/Store.dart';
import 'package:ajam/main.dart';
import 'package:ajam/signup/MainPage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:ajam/data/requests.dart';

import '../staticData.dart';

class SignupSteps extends ConsumerWidget {
  @override
  Widget build(context, watch) {
    final step = watch(signupStepProvider).state;
    final currentUser = watch(currentUserProvider).state;

    return SafeArea(
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          resizeToAvoidBottomPadding: false,
          body: Column(
            children: [
              Material(
                elevation: 5,
                child: Container(
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
                            step == SignupStep.profile ||
                                    step == SignupStep.done
                                ? Text(currentUser.get("name") ?? "")
                                : Container(),
                            SizedBox(
                              width: step == SignupStep.profile ||
                                      step == SignupStep.done
                                  ? 20
                                  : 0,
                            ),
                            Text(currentUser.username),
                          ],
                        ),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border(),
                            borderRadius:
                                BorderRadius.all(Radius.circular(50))),
                      ),
                    ],
                  ),
                ),
              ),
              step == SignupStep.login
                  ? Ajamlogin()
                  : step == SignupStep.form
                      ? AjamForm()
                      : step == SignupStep.verification
                          ? AjamVerification()
                          : step == SignupStep.profile
                              ? AjamProfile()
                              : AjamDone(),
            ],
          ),
        ),
      ),
    );
  }
}

final _otp = StateProvider<String>((ref) => "");

class AjamVerification extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final loading = watch(loadingProvider).state;

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
                    onChanged: (text) => context.read(_otp).state = text,
                    maxLength: 4,
                    maxLengthEnforced: true,
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
                ],
              ),
            ),
            InkWell(
              onTap: loading
                  ? null
                  : () async {
                      context.read(loadingProvider).state = true;

                      var username =
                          context.read(currentUserProvider).state.username;
                      var password = context.read(_otp).state;

                      try {
                        await otpVerify(username, password);
                        context.read(signupStepProvider).state =
                            SignupStep.profile;
                      } catch (e) {
                        exceptionSnackbar(context, e);
                      }

                      context.read(loadingProvider).state = false;
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
                            "تأكيد",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                  ],
                ),
                decoration: BoxDecoration(
                  color: darkblue,
                  border: Border(),
                  borderRadius: BorderRadius.all(
                    Radius.circular(50),
                  ),
                ),
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
              child: Column(
                children: [
                  TextFormField(
                    obscureText: true,
                    onChanged: (text) =>
                        context.read(currentUserProvider).state.password = text,
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
              onTap: loading
                  ? null
                  : () async {
                      // set loading to true
                      context.read(loadingProvider).state = true;

                      try {
                        final newUser = await loginAndRequestOTP(
                            context.read(currentUserProvider).state);
                        context.read(currentUserProvider).state = newUser;
                        context.read(signupStepProvider).state =
                            SignupStep.verification;
                      } catch (e) {
                        exceptionSnackbar(context, e);
                      }
                      context.read(loadingProvider).state = false;
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
  }
}

class AjamProfile extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final accountType = watch(accountTypeProvider).state;

    return Expanded(
      child: accountType == AccountType.captain
          ? CaptainProfile()
          : StoreProfile(),
    );
  }
}

final StateProvider storeProvider = StateProvider<Store>((ref) {
  final user = ref.watch(currentUserProvider).state;

  getStoreTypes().then((types) {
    ref.read(storeTypesProvider).state = types;

    getStoredStore(user).then((store) {
      ref.read(storeTypeSelectedProvider).state = store.storeType?.get("name");
      ref.read(storeProvider).state = store;
    });
  });

  return null;
});

class StoreProfile extends ConsumerWidget {
  final _formKey = GlobalKey<FormState>();
  Future<File> filePicker() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg'],
    );

    if (result != null) {
      return File(result.files.single.path);
    } else
      return null;
  }

  Future validate(BuildContext context) async {
    if (_formKey.currentState.validate()) {
      final store = context.read(storeProvider).state;

      print("STORE BITCH");
      print(store);

      if (store.logo == null) {
        exceptionSnackbar(context, provideImages);
        return;
      }

      final storeTypes = context.read(storeTypesProvider).state;
      final selectedType = context.read(storeTypeSelectedProvider).state;
      store.storeType =
          storeTypes.firstWhere((type) => type.get("name") == selectedType);

      try {
        await saveParseObject(store);
        context.read(signupStepProvider).state = SignupStep.done;
      } catch (e) {
        print(e);
        exceptionSnackbar(context, e);
      }
    }
  }

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final store = watch(storeProvider).state;
    final loading = watch(loadingProvider).state;

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: store == null
            ? Center(child: CircularProgressIndicator())
            : Column(
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
                          height: 80,
                          // color: Colors.red,
                          child: Stack(
                            children: [
                              ClipOval(
                                child: CircleAvatar(
                                  minRadius: 35,
                                  backgroundColor: darkblue,
                                  child: store.logo == null
                                      ? Icon(Icons.image)
                                      : Image.file(store.logo.file),
                                ),
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
                                        filePicker().then((file) {
                                          if (file != null)
                                            context.read(storeProvider).state =
                                                store..logo = ParseFile(file);
                                        });
                                      }),
                                  decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 2,
                                          blurRadius: 7,
                                          offset: Offset(0,
                                              3), // changes position of shadow
                                        ),
                                      ],
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(50))),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text("الشعار"),
                        SizedBox(height: 30),
                        Form(
                          key: _formKey,
                          child: TextFormField(
                            onChanged: (text) =>
                                context.read(storeProvider).state.name = text,
                            validator: (value) {
                              if (value.isEmpty) return "يجب إدخال اسم للمتجر";
                            },
                            initialValue: store.name,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.store),
                              hintText: "اسم المتجر",
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50),
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor),
                              ),
                              errorBorder: OutlineInputBorder(
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
                        ),
                        SizedBox(
                          height: 30,
                        ),

                        //dropdown (countries)
                        AjamDropdown(
                          options: context
                              .read(storeTypesProvider)
                              .state
                              .map<String>((e) => e.get("name"))
                              .toList(),
                          selectedState: storeTypeSelectedProvider,
                        ),
                        // Expanded(child: null),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: loading
                        ? null
                        : () async {
                            context.read(loadingProvider).state = true;
                            await validate(context);
                            context.read(loadingProvider).state = false;
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
                                  " حفظ ",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
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

final StateProvider<Captain> captainProvider = StateProvider<Captain>((ref) {
  final user = ref.watch(currentUserProvider).state;

  getStoredCaptain(user).then((captain) {
    ref.read(captainProvider).state = captain;
  });

  return null;
});

class CaptainProfile extends ConsumerWidget {
  final _formKey = GlobalKey<FormState>();

  Future<File> filePicker() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg'],
    );
    if (result != null) {
      return File(result.files.single.path);
    } else
      return null;
  }

  Future validate(BuildContext context) async {
    if (_formKey.currentState.validate()) {
      final captain = context.read(captainProvider).state;

      try {
        if (captain.photo == null ||
            captain.carBack == null ||
            captain.carFront == null ||
            captain.carInside == null) {
          throw provideImages;
        }

        await saveParseObject(captain);
        context.read(signupStepProvider).state = SignupStep.done;
      } catch (e) {
        exceptionSnackbar(context, e);
      }
    }
  }

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final captain = watch(captainProvider).state;
    final loading = watch(loadingProvider).state;

    return SingleChildScrollView(
        child: Container(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: captain == null
          ? Center(child: CircularProgressIndicator())
          : Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
                  child: Column(
                    children: [
                      Text("لنقم باضافة معلومات عضويتك"),
                      SizedBox(height: 30),
                      Container(
                        width: 80,
                        height: 80,
                        child: Stack(
                          children: [
                            ClipOval(
                              child: CircleAvatar(
                                minRadius: 35,
                                backgroundColor: green,
                                child: captain.photo == null
                                    ? Icon(Icons.image, color: Colors.white)
                                    : Image.file(
                                        captain.photo.file,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              child: Container(
                                height: 20,
                                width: 20,
                                padding: EdgeInsets.fromLTRB(2, 0, 0, 2),
                                child: IconButton(
                                  color: green,
                                  icon: Icon(
                                    Icons.create_sharp,
                                    size: 10,
                                  ),
                                  onPressed: () => filePicker().then(
                                    (file) {
                                      if (file != null)
                                        context.read(captainProvider).state =
                                            captain..photo = ParseFile(file);
                                    },
                                  ),
                                ),
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
                      Text("الصوره الشخصيه"),
                      SizedBox(height: 12),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              onChanged: (text) => context
                                  .read(captainProvider)
                                  .state = captain..idNumber = text,
                              validator: (value) {
                                if (value.isEmpty) return "يجب إدخال قيمة";
                              },
                              initialValue: captain.idNumber ?? "",
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.perm_identity),
                                hintText: "رقم الهوية/الإقامة",
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50),
                                  borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor),
                                ),
                                errorBorder: OutlineInputBorder(
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
                            SizedBox(height: 12),
                            TextFormField(
                              onChanged: (text) => context
                                  .read(captainProvider)
                                  .state = captain..iban = text,
                              validator: (value) =>
                                  value.isEmpty ? "يجب إدخال قيمة" : null,
                              initialValue: captain.iban ?? "",
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.money),
                                hintText: "رقم حساب البنك IBAN",
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50),
                                  borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor),
                                ),
                                errorBorder: OutlineInputBorder(
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
                          ],
                        ),
                      ),
                      SizedBox(height: 30),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 13, vertical: 13),
                              child: Text("صور السياره"),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      width: 80,
                                      child: Stack(
                                        children: [
                                          Container(
                                            width: 80,
                                            height: 80,
                                            color: green,
                                            child: captain.carFront == null
                                                ? Icon(Icons.image,
                                                    color: Colors.white)
                                                : Image.file(
                                                    captain.carFront.file),
                                          ),
                                          Positioned(
                                            bottom: 0,
                                            left: 0,
                                            child: Container(
                                              height: 20,
                                              width: 20,
                                              padding: EdgeInsets.fromLTRB(
                                                  2, 0, 0, 2),
                                              child: IconButton(
                                                //iconSize: 15,
                                                color: green,
                                                icon: Icon(
                                                  Icons.create_sharp,
                                                  size: 10,
                                                ),
                                                onPressed: () =>
                                                    filePicker().then(
                                                  (file) {
                                                    if (file != null)
                                                      context
                                                          .read(captainProvider)
                                                          .state = captain
                                                        ..carFront =
                                                            ParseFile(file);
                                                  },
                                                ),
                                              ),
                                              decoration: BoxDecoration(
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey
                                                          .withOpacity(0.5),
                                                      spreadRadius: 2,
                                                      blurRadius: 7,
                                                      offset: Offset(0,
                                                          3), // changes position of shadow
                                                    ),
                                                  ],
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(50))),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text("الأمام"),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Container(
                                      width: 80,
                                      // color: Colors.red,
                                      child: Stack(
                                        children: [
                                          Container(
                                            width: 80,
                                            height: 80,
                                            color: green,
                                            child: captain.carBack == null
                                                ? Icon(Icons.image,
                                                    color: Colors.white)
                                                : Image.file(
                                                    captain.carBack.file),
                                          ),
                                          Positioned(
                                            bottom: 0,
                                            left: 0,
                                            child: Container(
                                              height: 20,
                                              width: 20,
                                              padding: EdgeInsets.fromLTRB(
                                                  2, 0, 0, 2),
                                              child: IconButton(
                                                //iconSize: 15,
                                                color: green,
                                                icon: Icon(
                                                  Icons.create_sharp,
                                                  size: 10,
                                                ),
                                                onPressed: () =>
                                                    filePicker().then(
                                                  (file) {
                                                    if (file != null)
                                                      context
                                                          .read(captainProvider)
                                                          .state = captain
                                                        ..carBack =
                                                            ParseFile(file);
                                                  },
                                                ),
                                              ),
                                              decoration: BoxDecoration(
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey
                                                          .withOpacity(0.5),
                                                      spreadRadius: 2,
                                                      blurRadius: 7,
                                                      offset: Offset(0,
                                                          3), // changes position of shadow
                                                    ),
                                                  ],
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(50))),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text("الخلف"),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Container(
                                      width: 80,
                                      // color: Colors.red,
                                      child: Stack(
                                        children: [
                                          Container(
                                            width: 80,
                                            height: 80,
                                            color: green,
                                            child: captain.carInside == null
                                                ? Icon(Icons.image,
                                                    color: Colors.white)
                                                : Image.file(
                                                    captain.carInside.file),
                                          ),
                                          Positioned(
                                            bottom: 0,
                                            left: 0,
                                            child: Container(
                                              height: 20,
                                              width: 20,
                                              padding: EdgeInsets.fromLTRB(
                                                  2, 0, 0, 2),
                                              child: IconButton(
                                                //iconSize: 15,
                                                color: green,
                                                icon: Icon(
                                                  Icons.create_sharp,
                                                  size: 10,
                                                ),
                                                onPressed: () =>
                                                    filePicker().then(
                                                  (file) {
                                                    if (file != null)
                                                      context
                                                          .read(captainProvider)
                                                          .state = captain
                                                        ..carInside =
                                                            ParseFile(file);
                                                  },
                                                ),
                                              ),
                                              decoration: BoxDecoration(
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey
                                                          .withOpacity(0.5),
                                                      spreadRadius: 2,
                                                      blurRadius: 7,
                                                      offset: Offset(0,
                                                          3), // changes position of shadow
                                                    ),
                                                  ],
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(50))),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text("الداخل"),
                                  ],
                                ),
                                //iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                InkWell(
                  onTap: loading
                      ? null
                      : () async {
                          context.read(loadingProvider).state = true;
                          await validate(context);
                          context.read(loadingProvider).state = false;
                        },
                  child: Container(
                    //width: ,
                    height: 60,
                    margin: EdgeInsets.all(20),
                    padding: EdgeInsets.fromLTRB(10, 3, 10, 3),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        loading
                            ? CircularProgressIndicator()
                            : Text(
                                "حفظ",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
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
    ));
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
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                "شريكنا العزيز لعرض منتجاتك بشكل أفضل نود منك تحميل صور المنتج بشكل واضح وبخلفية بيضاء وسوف نساعدك على تحسينها وعرضها بشكل رائع",
                style: TextStyle(color: darkgrey),
                textAlign: TextAlign.center,
              ),
            ),
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
          ],
        ),
      ),
    );
  }
}

class AjamDone extends ConsumerWidget {
  @override
  Widget build(BuildContext context, watch) {
    final accountType = watch(accountTypeProvider).state;

    return Expanded(
      child: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
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
                    accountType == AccountType.captain
                        ? "تم حفظ ملفك"
                        : "تم حفظ بيانات متجرك بنجاح",
                    style: TextStyle(fontSize: 20, color: darkblue),
                  ),
                ],
              ),
              Text(
                "نقوم الآن بتسجيل الشركاء و بناء قاعدة البيانات\nترقبونا قريبا",
                style: TextStyle(color: darkgrey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AjamAppBar extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final accountType = watch(accountTypeProvider).state;
    final signupStep = watch(signupStepProvider).state;

    return Container(
      padding: EdgeInsets.fromLTRB(13, 0, 0, 0),
      height: 60,
      child: Row(
        children: [
          signupStep == SignupStep.form || signupStep == SignupStep.verification
              ? Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 13, 0),
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                      context.read(loadingProvider).state = false;
                    },
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: Theme.of(context).primaryColor,
                      size: 40,
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.fromLTRB(13, 0, 5, 0),
                  child: IconButton(
                    onPressed: () {
                      logout();
                      context.read(loadingProvider).state = false;
                      context.read(currentUserProvider).state =
                          ParseUser("", "", "");
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.logout,
                      color: Theme.of(context).primaryColor,
                      size: 40,
                    ),
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

final _passwordMatchProvider = StateProvider<String>((ref) => "");
final RegExp emailRegex = new RegExp(
  r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$",
  caseSensitive: false,
  multiLine: false,
);

class AjamForm extends ConsumerWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final loading = watch(loadingProvider).state;

    Future submit(BuildContext context) async {
      if (_formKey.currentState.validate()) {
        final user = context.read(currentUserProvider).state;
        final match = context.read(_passwordMatchProvider).state;

        if (user.password != match) {
          exceptionSnackbar(context, noPasswordMatch);
        } else {
          user.set("country", context.read(countrySelectedProvider).state);
          user.set("city", context.read(citySelectedProvider).state);

          try {
            final user = await signupAndRequestOTP(
                context.read(currentUserProvider).state);
            context.read(currentUserProvider).state = user;
            context.read(_passwordMatchProvider).dispose();
            context.read(signupStepProvider).state = SignupStep.verification;
          } catch (e) {
            exceptionSnackbar(context, e);
          }
        }
      }
    }

    return Expanded(
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(30),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  validator: (value) {
                    if (value.isNotEmpty) {
                      context
                          .read(currentUserProvider)
                          .state
                          .set("name", value);
                      return null;
                    }

                    return 'يجب إدخال الاسم الكامل';
                  },
                  initialValue:
                      context.read(currentUserProvider).state.get("name"),
                  decoration: InputDecoration(
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide:
                          BorderSide(color: Theme.of(context).primaryColor),
                    ),
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
                  validator: (value) => value.isEmpty || value.length < 8
                      ? "يجب إدخال كلمة مرور من 8 حروف على الأقل"
                      : null,
                  onChanged: (value) {
                    context.read(currentUserProvider).state.password = value;
                  },
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  // maxLength: 10,
                  // maxLengthEnforced: true,
                  decoration: InputDecoration(
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide:
                          BorderSide(color: Theme.of(context).primaryColor),
                    ),
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
                  validator: (value) {
                    if (value.isEmpty || value.length < 8) {
                      return "يجب إدخال كلمة مرور من 8 حروف على الأقل";
                    } else {
                      context.read(_passwordMatchProvider).state = value;
                      return null;
                    }
                  },
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  // maxLength: 10,
                  // maxLengthEnforced: true,
                  decoration: InputDecoration(
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide:
                          BorderSide(color: Theme.of(context).primaryColor),
                    ),
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
                  options: countries,
                  selectedState: countrySelectedProvider,
                ),
                SizedBox(
                  height: 30,
                ),
                //contries dropDown
                AjamDropdown(
                  options: cities,
                  selectedState: citySelectedProvider,
                ),
                SizedBox(
                  height: 30,
                ),
                //email
                TextFormField(
                  validator: (value) {
                    if (value.length == 0) return null;
                    if (RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(value)) {
                      context.read(currentUserProvider).state.emailAddress =
                          value;
                    }

                    return "الرجاء إدخال بريد إلكتروني صحيح";
                  },
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
                  onTap: loading
                      ? null
                      : () async {
                          context.read(loadingProvider).state = true;
                          await submit(context);
                          context.read(loadingProvider).state = false;
                        },
                  child: Container(
                    //width: ,
                    height: 60,
                    margin: EdgeInsets.all(20),
                    padding: EdgeInsets.fromLTRB(10, 3, 10, 3),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: loading
                          ? [CircularProgressIndicator()]
                          : [
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
    }
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
                    : Stack(
                        children: [
                          Image.file(
                            image,
                            fit: BoxFit.cover,
                            width: 300,
                            height: 150,
                          ),
                          Text("review"),
                          Text("review content"),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
