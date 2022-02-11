import 'package:flutter/material.dart';
import 'package:otp_generator/resources/strings.dart';

class SnackBarUtils {
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> errorSnackBar(BuildContext context) {
    return ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(SystemStrings.anErrorHasOccurred)));
  }
}