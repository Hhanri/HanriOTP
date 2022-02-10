import 'package:flutter/material.dart';
import 'package:otp_generator/pages/backup_page.dart';
import 'package:otp_generator/pages/home_page.dart';
import 'package:otp_generator/pages/pin_code_page.dart';
import 'package:otp_generator/pages/settings_page.dart';

class RouteGenerator {

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch(settings.name) {
      case homePage : return MaterialPageRoute(builder: (_) => const HomeScreen());
      case settingsPage : return MaterialPageRoute(builder: (_) => const SettingsScreen());
      case backupPage : return MaterialPageRoute(builder: (_) => const BackupScreen());
      case pinCodePage : return MaterialPageRoute(builder: (_) => PinCodeScreen());
      default : return MaterialPageRoute(builder: (_) => const HomeScreen());
    }
  }
}

const String homePage = "/HomePage";
const String settingsPage = "/SettingsPage";
const String backupPage = "/BackupPage";
const String pinCodePage = "/PinCode";