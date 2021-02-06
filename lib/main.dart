import 'package:ajam/EditableMenu.dart';
import 'package:ajam/Infopage.dart';
import 'package:ajam/data/Exceptions.dart';
import 'package:ajam/data/requests.dart';
import 'package:ajam/signup/MainPage.dart';
import 'package:ajam/signup/signupSteps.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

import 'signup/MainPage.dart';
//import 'package:time_range_picker/time_range_picker.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

const green = Color(0xff37cb41);
const lightgrey = Color(0xffe5e5e5);
const darkblue = Color(0xff13264e);
const grey = Color(0xffa4a4a4);
const darkgrey = Color(0xff707070);
const orange = Color(0xfff16408);

class MyApp extends ConsumerWidget {
  // This widget is the root of your application.
  @override
  Widget build(context, watch) {
    final accountType = watch(accountTypeProvider).state;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child,
        );
      },
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Questv1',
        primaryColor: accountType == AccountType.captain ? green : orange,
        buttonBarTheme: ButtonBarThemeData(
          alignment: MainAxisAlignment.center,
        ),
      ),
      home: watch(connectionProvider).when(
        data: (parse) => MainPage(),
        loading: () =>
            Container(child: Center(child: CircularProgressIndicator())),
        error: (e, stack) {
          return Scaffold(
              body: Container(child: Center(child: Text(e.toString()))));
        },
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: lightgrey,
            bottom: TabBar(
              labelColor: orange,
              indicatorColor: orange,
              tabs: [
                Tab(
                    text: "سجل التعريف",
                    icon: Icon(
                      Icons.account_circle,
                      color: orange,
                    )),
                Tab(
                    text: "منتجاتي",
                    icon: Icon(
                      Icons.shopping_bag,
                      color: orange,
                    )),
                Tab(
                    text: "الاشتراكات",
                    icon: Icon(
                      Icons.description_sharp,
                      color: orange,
                    )),
              ],
            ),
            //centerTitle: true,
            title: Text(
              "متجري",
              style: TextStyle(color: orange),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.fromLTRB(19, 0, 0, 0),
                child: IconButton(
                    icon: Icon(
                      Icons.store_mall_directory,
                      color: orange,
                      size: 50,
                    ),
                    onPressed: () {}),
              )
            ],
            //  iconTheme: IconTheme(data: null, child: null),//Icon(Icons.store_mall_directory),
          ),
          body: TabBarView(
            children: [
              InfoPage(),
              EditableMenu(),
              Container(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "نقوم الآن بتسجيل الشركاء و بناء قاعدة البيانات ",
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        "نقوم الآن بتسجيل الشركاء و بناء قاعدة البيانات\nترقبونا قريبا",
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
          // This trailing comma makes auto-formatting nicer for build methods.
          ),
    );
  }
}
