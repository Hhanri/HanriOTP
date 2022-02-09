import 'package:flutter/material.dart';
import 'package:otp_generator/dialogs/pin_code_dialog.dart';
import 'package:otp_generator/dialogs/timer_settings_dialog.dart';
import 'package:otp_generator/resources/strings.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(SystemStrings.settings),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text("Pin Code"),
            onTap: () {
              PinCodeDialog.showPinCodeDialog(context: context);
            },
          ),
          ListTile(
            title: const Text("Timer"),
            onTap: () {
              TimerSettingsDialog.showTimerSettingsDialog(context: context);
            },
          )
        ],
      ),
    );
  }
}
