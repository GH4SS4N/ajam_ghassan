import 'package:ajam/data/Exceptions.dart';
import 'package:ajam/data/requests.dart';
import 'package:ajam/signup/signupSteps.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../main.dart';

enum AccountType { captain, owner, none }

final accountTypeProvider =
    StateProvider<AccountType>((ref) => AccountType.captain);

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          color: Color(0xffedeef2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // this adds space for taller screens
              ConstrainedBox(constraints: BoxConstraints(maxHeight: 24)),
              Header(),
              Text(
                "نقوم الآن بتسجيل الشركاء و بناء قاعدة البيانات\nترقبونا قريبا",
                style: TextStyle(color: darkgrey),
                textAlign: TextAlign.center,
              ),
              AccountTypeList(),
              FlatButton(
                onPressed: () => launch("https://twitter.com/ajam_sa"),
                color: darkblue,
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(50.0),
                ),
                child: Text(
                  "اتصل بنا على تويتر",
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class AccountTypeList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "اختر نوع الحساب",
          style: TextStyle(
              fontSize: 25, fontWeight: FontWeight.bold, color: darkblue),
        ),
        SizedBox(height: 12),
        SizedBox(
          height: 275,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 6),
            scrollDirection: Axis.horizontal,
            children: [
              AccountTypeCard(
                imageName: "assets/img/store.png",
                color: orange,
                header: "صاحب متجر",
                body:
                    "اقترب من عملائك , وضاعف المبيعات , ودعنا نهتم بالتوصيل .",
                iconData: Icons.store,
                accountType: AccountType.owner,
              ),
              AccountTypeCard(
                imageName: "assets/img/captain.png",
                color: green,
                header: "كابتن",
                body: "اختر رحلات توصيل المنتجات حسب المسافة والسعر بكل ثقة .",
                iconData: Icons.directions_car,
                accountType: AccountType.captain,
              )
            ],
          ),
        ),
      ],
    );
  }
}

final loadingProvider = StateProvider<bool>((ref) => false);

class AccountAlertDialog extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final accountType = watch(accountTypeProvider).state;
    final consumeLoading = watch(loadingProvider);

    return AlertDialog(
      contentPadding: EdgeInsets.only(right: 12, left: 12, top: 12),
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.login, color: Theme.of(context).primaryColor, size: 50),
          Text(
            accountType == AccountType.owner ? "حساب صاحب متجر" : "حساب كابتن",
            style:
                TextStyle(color: Theme.of(context).primaryColor, fontSize: 20),
          ),
        ],
      ),
      content: TextField(
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ], // Only numbers can be entered
        maxLength: 9,
        maxLengthEnforced: true,
        onChanged: (text) {
          final readUser = context.read(currentUserProvider);
          readUser.state = readUser.state..username = text;
        },
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.account_circle),
          //icon: Icon(Icons.phone),
          hintText: "501231234",
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide(color: Theme.of(context).primaryColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide(color: lightgrey),
          ),
        ),
      ),
      actions: [
        FlatButton(
          onPressed: () {
            // set loading to true
            consumeLoading.state = true;
            // get phone number which is username
            final username = context.read(currentUserProvider).state.username;
            userByPhoneNumber(username).then(
              (user) {
                // set loading to false
                consumeLoading.state = false;
                context.read(signupStepProvider).state =
                    user == null ? SignupStep.form : SignupStep.login;
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SignupSteps(),
                    ));
              },
            ).catchError((e) => exceptionSnackbar(context, e));
          },
          color: darkblue,
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(50.0),
          ),
          child: !consumeLoading.state
              ? Text("التالي", style: TextStyle(color: Colors.white))
              : SizedBox(
                  height: 20, width: 20, child: CircularProgressIndicator()),
        )
      ],
    );
  }
}

class Header extends StatelessWidget {
  const Header({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "مرحبا بك في تطبيق ",
          style: TextStyle(fontSize: 20, color: darkgrey),
        ),
        SizedBox(height: 12),
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
      ],
    );
  }
}

class AccountTypeCard extends StatelessWidget {
  final AccountType accountType;
  final IconData iconData;
  final String header;
  final String body;
  final String imageName;
  final Color color;

  AccountTypeCard({
    this.accountType,
    this.imageName,
    this.iconData,
    this.header,
    this.body,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    // constrain the width of the card
    return InkWell(
      onTap: () {
        context.read(accountTypeProvider).state = accountType;
        showDialog(
          context: context,
          builder: (_) => AccountAlertDialog(),
        );
      },
      child: SizedBox(
        width: 300,
        // cards are like container but with elevation maybe
        child: Card(
          margin: EdgeInsets.symmetric(horizontal: 6),
          color: color,
          // this Column lays out the image and card body below
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // adds circular borders to the top of the image
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5),
                  topRight: Radius.circular(5),
                ),
                child: Image.asset(
                  imageName,
                  fit: BoxFit.cover,
                  width: 300,
                  height: 150,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                // lays out the text and then the icon to the left
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // the text is expanded because we want it to take all the
                    // horizontal space it needs, pushing the icon to the end
                    Expanded(
                      // lays out the header and the body below it
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            header,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 24,
                            ),
                          ),
                          Text(body, style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                    // this icon has a fixed size. While its sibling, the
                    // expanded widget, will fill the remaining space
                    Icon(this.iconData, size: 60, color: Colors.white),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
