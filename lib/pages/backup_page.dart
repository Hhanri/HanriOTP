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
      body: BackupSettingsBody(items: BackupSettingsModel.items,),
    );
  }
}

class BackupSettingsBody extends StatelessWidget {
  final List<BackupSettingsModel> items;
  const BackupSettingsBody({
    Key? key,
    required this.items
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      physics: const ClampingScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        return Consumer(
          builder: (BuildContext context, WidgetRef ref, Widget? child) {
            return ListTile(
              title: Text(items[index].title),
              subtitle: Text(items[index].description),
              onTap: () {
                items[index].function(context, ref);
              }
            );
          }
        );
      },
    );
  }
}
