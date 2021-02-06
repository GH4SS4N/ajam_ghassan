import 'dart:io';

import 'package:ajam/Widgets/ajamDropdownMenu.dart';
import 'package:ajam/data/Captain.dart';
import 'package:ajam/data/Exceptions.dart';
import 'package:ajam/data/Store.dart';
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

final signupStepProvider = StateProvider<SignupStep>((ref) => SignupStep.login);

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
      ),
    );
  }
}

final _otp = StateProvider<String>((ref) => "");

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
              onTap: () {
                var username = context.read(currentUserProvider).state.username;
                var password = context.read(_otp).state;
                otpVerify(username, password)
                    .then((value) => context.read(signupStepProvider).state =
                        SignupStep.profile)
                    .catchError((e) => exceptionSnackbar(context, e));
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

                login(context.read(currentUserProvider).state)
                    .then(
                      (newUser) {
                        context.read(currentUserProvider).state = newUser;
                        context.read(signupStepProvider).state =
                            SignupStep.profile;
                      },
                    )
                    // if there was an error loging-in or requesting an OTP
                    .catchError((e) => exceptionSnackbar(context, e))
                    // when everything is done, set loading to false
                    .whenComplete(
                      () => context.read(loadingProvider).state = false,
                    );
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

final StateProvider<Store> storeProvider = StateProvider<Store>((ref) {
  getStoreTypes().then((types) {
    ref.read(storeTypesProvider).state = types;

    getStoredStore(ref.watch(currentUserProvider).state).then((store) {
      print("Store store type!");
      print(store.storeType);
      ref.read(storeTypeSelectedProvider).state = store.storeType.get("name");
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
      if (store.logo == null) {
        exceptionSnackbar(context, provideImages);
        return;
      }

      final storeTypes = context.read(storeTypesProvider).state;
      final selectedType = context.read(storeTypeSelectedProvider).state;
      store.storeType =
          storeTypes.firstWhere((type) => type.get("name") == selectedType);

      try {
        final newStore = await saveParseObject(store);
        context.read(storeProvider).state = newStore;
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

    return Container(
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
                  onTap: () {
                    context.read(loadingProvider).state = true;
                    validate(context);
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
    );
  }
}

final captainProvider = StateProvider<Captain>((ref) {
  final newCaptain = Captain();
  newCaptain.user = ref.read(currentUserProvider).state;

  return newCaptain;
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

        final newCaptain = await saveParseObject(captain);
        context.read(captainProvider).state = newCaptain;
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
        child: watch(storedCaptainProvider).when(
          data: (storedCaptain) {
            if (storedCaptain != null)
              context.read(captainProvider).state = storedCaptain;
            return Column(
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
                        child: Stack(
                          children: [
                            ClipOval(
                              child: CircleAvatar(
                                minRadius: 35,
                                backgroundColor: green,
                                child: captain.photo == null
                                    ? Icon(Icons.image, color: Colors.white)
                                    : Image.file(captain.photo.file),
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
                                    onPressed: () {
                                      filePicker().then((file) =>
                                          context.read(captainProvider).state =
                                              captain..photo = ParseFile(file));
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
                                                  onPressed: () {
                                                    filePicker().then((file) =>
                                                        context
                                                            .read(
                                                                captainProvider)
                                                            .state = captain
                                                          ..carFront =
                                                              ParseFile(file));
                                                  }),
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
                                                  onPressed: () {
                                                    filePicker().then((file) =>
                                                        context
                                                            .read(
                                                                captainProvider)
                                                            .state = captain
                                                          ..carBack =
                                                              ParseFile(file));
                                                  }),
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
                                                  onPressed: () {
                                                    filePicker().then((file) =>
                                                        context
                                                            .read(
                                                                captainProvider)
                                                            .state = captain
                                                          ..carInside =
                                                              ParseFile(file));
                                                  }),
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
                  onTap: () async {
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
            );
          },
          error: (e, stack) {
            print(e);
            print(stack);
            exceptionSnackbar(context, e);
            return Center(child: Icon(Icons.error));
          },
          loading: () => Center(child: CircularProgressIndicator()),
        ),
      ),
    );
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
    final signup_Step = watch(signupStepProvider).state;

    return Container(
      padding: EdgeInsets.fromLTRB(13, 0, 0, 0),
      height: 60,
      child: Row(
        children: [
          signup_Step == SignupStep.form ||
                  signup_Step == SignupStep.verification
              ? Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 13, 0),
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
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
    void submit(BuildContext context) {
      if (_formKey.currentState.validate()) {
        final user = context.read(currentUserProvider).state;
        final match = context.read(_passwordMatchProvider).state;

        if (user.password != match) {
          exceptionSnackbar(context, noPasswordMatch);
        } else {
          user.set("country", context.read(countrySelectedProvider).state);
          user.set("city", context.read(citySelectedProvider).state);
          signupAndRequestOTP(context.read(currentUserProvider).state)
              .then((user) {
            context.read(currentUserProvider).state = user;
            context.read(_passwordMatchProvider).dispose();
            context.read(signupStepProvider).state = SignupStep.verification;
          }).catchError((e) => exceptionSnackbar(context, e));
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
                  validator: (value) {
                    if (value.isEmpty || value.length < 8) {
                      return "يجب إدخال كلمة مرور من 8 حروف على الأقل";
                    } else {
                      context.read(currentUserProvider).state.password = value;
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
                  onTap: () => submit(context),
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
