import 'package:equatable/equatable.dart';
import 'package:otp_generator/resources/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SecurityModel extends Equatable{
  final String value;
  final String title;

  const SecurityModel({
    required this.value,
    required this.title
  });

  static const SecurityModel noneModel = SecurityModel(value: SecurityModelStrings.noneValue, title: SecurityModelStrings.noneTitle);
  static const SecurityModel pinCodeModel = SecurityModel(value: SecurityModelStrings.pinCodeValue, title: SecurityModelStrings.pinCodeTitle);

  static List<SecurityModel> features = [
    noneModel,
    pinCodeModel
  ];

  static Future<String> loadPassword() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("Password") ?? "";
  }

  static void savePassword(String newPassword) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("Password", newPassword);
  }

  static void resetPassword() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("Password", "");
  }

  @override
  // TODO: implement props
  List<Object?> get props => [title, value];
}