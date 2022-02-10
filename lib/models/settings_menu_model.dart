import 'package:flutter/material.dart';
import 'package:otp_generator/dialogs/pin_code_dialog.dart';
import 'package:otp_generator/dialogs/timer_settings_dialog.dart';
import 'package:otp_generator/resources/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    onTap: (context) async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final int currentTimer = prefs.getInt(SharedPreferencesStrings.savedTimer) ?? 30;
      TimerSettingsDialog.showTimerSettingsDialog(context: context, selectedTimer: currentTimer);
    }
  );
}