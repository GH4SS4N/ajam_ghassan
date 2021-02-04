import 'package:flutter/material.dart';

class HttpException implements Exception {
  final String message;

  HttpException(this.message); // Pass your message in constructor.

  @override
  String toString() {
    return message;
  }
}

final couldNotConnect = HttpException('تأكد من اتصال الانترنت');
final wrongOTP = HttpException("الرمز خاطئ");
final otpExpired = HttpException('انتهت مدة الرمز');
final wrongPassword = HttpException('كلمة المرور خاطئة');

void exceptionSnackbar(context, HttpException e) {
  Scaffold.of(context).showSnackBar(SnackBar(content: Text(e.message)));
}
