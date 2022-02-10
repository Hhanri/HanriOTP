import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:otp_generator/models/backup_settings_model.dart';
import 'package:otp_generator/resources/strings.dart';

class BackupScreen extends StatelessWidget {
  const BackupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(SystemStrings.backup),
      ),
      body: BackupSettingsBody(
        clearBackupItems: BackupSettingsModel.clearBackupItems,
        encryptedBackupItems: BackupSettingsModel.encryptedBackupItems,
      ),
    );
  }
}

class BackupSettingsBody extends StatelessWidget {
  final List<BackupSettingsModel> clearBackupItems;
  final List<BackupSettingsModel> encryptedBackupItems;
  const BackupSettingsBody({
    Key? key,
    required this.clearBackupItems,
    required this.encryptedBackupItems
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const DividerWidget(text: "Clear Backup"),
          ...List.generate(clearBackupItems.length, (index) {
            final BackupSettingsModel currentItem = clearBackupItems[index];
            return Consumer(
              builder: (BuildContext context, WidgetRef ref, Widget? child) {
                return ListTile(
                  title: Text(currentItem.title),
                  subtitle: Text(currentItem.description),
                  onTap: () {
                    currentItem.function(context, ref);
                  }
                );
              }
            );
          }),
          const DividerWidget(text: "Encrypted Backup"),
          ...List.generate(encryptedBackupItems.length, (index) {
            final BackupSettingsModel currentItem = encryptedBackupItems[index];
            return Consumer(
              builder: (BuildContext context, WidgetRef ref, Widget? child) {
                return ListTile(
                  title: Text(currentItem.title),
                  subtitle: Text(currentItem.description),
                  onTap: () {
                    currentItem.function(context, ref);
                  }
                );
              }
            );
          }),
        ],
      ),
    );
  }
}

class DividerWidget extends StatelessWidget {
  final String text;
  const DividerWidget({
    Key? key,
    required this.text
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Expanded(child: Divider(color: Colors.white, thickness: 2,)),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 16
            ),
          )
        ),
        const Expanded(child: Divider(color: Colors.white, thickness: 2,))
      ],
    );
  }
}
