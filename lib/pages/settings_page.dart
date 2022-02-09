import 'package:flutter/material.dart';
import 'package:otp_generator/models/settings_menu_model.dart';
import 'package:otp_generator/resources/strings.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(SystemStrings.settings),
      ),
      body: ListView.builder(
        itemCount: SettingsMenuModel.settings.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(SettingsMenuModel.settings[index].title),
            onTap: () {
              SettingsMenuModel.settings[index].onTap(context);
            },
          );
        },
      ),
    );
  }
}
