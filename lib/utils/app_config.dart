import 'package:flutter/cupertino.dart';

class AppConfig {
  static double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }
}