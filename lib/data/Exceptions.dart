import 'package:flutter/material.dart';

class AjamException implements Exception {
  final String header;
  final String body;

  AjamException(this.header, [this.body]);

  @override
  String toString() => this.header + ": " + this.body + ".";
}

class UnsupportedVersion extends AjamException {
  UnsupportedVersion()
      : super("الرجاء تحديث التطبيق",
            "هذه النسخة من التطبيق غير مدعومة بعد الآن .");
}

class CouldNotConnect extends AjamException {
  CouldNotConnect()
      : super(
          'خطأ في الاتصال',
          'تأكد من اتصال الانترنت',
        );
}

class WrongOTP extends AjamException {
  WrongOTP()
      : super(
          'الرمز خاطئ'
          'أعد إدخال الرمز الصحيح',
        );
}

class OTPExpired extends AjamException {
  OTPExpired()
      : super(
          'انتهت مدة الرمز'
          'الرجاء طلب رمز تأكيد جديد',
        );
}

void exceptionSnackbar(context, AjamException exception) {
  Scaffold.of(context).showSnackBar(SnackBar(
    content: exception.body == null
        ? Text(exception.header)
        : Column(
            mainAxisSize: MainAxisSize.min,
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(exception.header,
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text(exception.body),
            ],
          ),
  ));
}
