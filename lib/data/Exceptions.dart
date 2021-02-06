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
final otpExpired = HttpException('انتهت مدة الرمز , سيتم إرسال رمز آخر');
final wrongPassword = HttpException('كلمة المرور خاطئة');
final noPasswordMatch = HttpException('كلمات المرور ليست متطابقة');
final provideImages = HttpException("يجب إضافة جميع الصور");

void exceptionSnackbar(context, HttpException e) {
  Scaffold.of(context).showSnackBar(SnackBar(content: Text(e.message)));
}
