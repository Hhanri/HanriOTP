import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:otp_generator/resources/strings.dart';
import 'package:otp_generator/utils/khazix.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SecurityPinCodeModel extends Equatable{
  final String value;
  final String title;

  const SecurityPinCodeModel({
    required this.value,
    required this.title
  });

  static const SecurityPinCodeModel noneModel = SecurityPinCodeModel(value: SecurityModelStrings.noneValue, title: SecurityModelStrings.noneTitle);
  static const SecurityPinCodeModel pinCodeModel = SecurityPinCodeModel(value: SecurityModelStrings.pinCodeValue, title: SecurityModelStrings.pinCodeTitle);

  static List<SecurityPinCodeModel> features = [
    noneModel,
    pinCodeModel
  ];

  static Future<String> loadPassword() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("Password") ?? "";
  }

  static void savePassword(String newPassword) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("Password", Khazix.encryptPin(newPassword).base64);
  }

  static void resetPassword() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("Password", "");
  }

  @override
  // TODO: implement props
  List<Object?> get props => [title, value];
}