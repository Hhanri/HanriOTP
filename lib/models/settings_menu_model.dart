import 'package:flutter/material.dart';
import 'package:otp_generator/dialogs/pin_code_dialog.dart';
import 'package:otp_generator/dialogs/timer_settings_dialog.dart';
import 'package:otp_generator/resources/strings.dart';

class SettingsMenuModel {
  final String title;
  final Function(BuildContext) onTap;

  SettingsMenuModel({
    required this.title,
    required this.onTap
  });

  static final List<SettingsMenuModel> settings = [
    timer,
    pinCode
  ];

  static final SettingsMenuModel pinCode = SettingsMenuModel(
      title: SettingsMenuModelString.pinCode ,
      onTap: (context) {
        PinCodeDialog.showPinCodeDialog(context: context);
      }
  );

  static final SettingsMenuModel timer = SettingsMenuModel(
    title: SettingsMenuModelString.timer ,
    onTap: (context) {
      TimerSettingsDialog.showTimerSettingsDialog(context: context);
    }
  );
}