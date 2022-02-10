import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:otp_generator/dialogs/encrypt_type_in_pasword_dialog.dart';
import 'package:otp_generator/providers/providers.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:otp_generator/resources/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';

class BackupSettingsModel {
  final String title;
  final String description;
  final Function(BuildContext, WidgetRef) function;

  BackupSettingsModel({
    required this.title,
    required this.description,
    required this.function
  });

  static final List<BackupSettingsModel> clearBackupItems = [
    exportClearBackup,
    importClearBackup
  ];

  static final List<BackupSettingsModel> encryptedBackupItems = [
    exportEncryptedBackup,
    importEncryptedBackup
  ];

  static final BackupSettingsModel exportClearBackup = BackupSettingsModel(
    title: BackupSettingsModelStrings.exportClearBackupTitle,
    description: BackupSettingsModelStrings.exportClearBackupDescription,
    function: (context, ref) async {
      print("export backup");
      await exportClearFile(context);
    }
  );

  static final BackupSettingsModel importClearBackup = BackupSettingsModel(
    title: BackupSettingsModelStrings.importClearBackupTitle,
    description: BackupSettingsModelStrings.importClearBackupDescription,
    function: (context, ref) {
      print("import backup");
      importClearFile(context, ref, false);
    }
  );

  static final BackupSettingsModel importEncryptedBackup = BackupSettingsModel(
    title: BackupSettingsModelStrings.importEncryptedBackupTitle,
    description: BackupSettingsModelStrings.importEncryptedBackupDescription,
    function: (context, ref) {

    }
  );

  static final BackupSettingsModel exportEncryptedBackup = BackupSettingsModel(
      title: BackupSettingsModelStrings.exportEncryptedBackupTitle,
      description: BackupSettingsModelStrings.exportEncryptedBackupDescription,
      function: (context, ref) {
        print("export encrypted backup");
        exportEncryptedFile(context);
      }
  );

  static Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    }
    return false;
  }
  static Future<bool> exportClearFile(BuildContext context) async {
    String date = DateFormat('yyyy-MM-dd_HH:mm:ss').format(DateTime.now());
    String fileName = "$date.json";
    Directory? directory;
    try{
      if (Platform.isAndroid) {
        if (await _requestPermission(Permission.storage)) {
          directory = Directory("/storage/emulated/0/HanriOTP");
          print(directory.path);
        }
      }
      File saveFile = File(directory!.path + "/$fileName");
      print(saveFile.path);
      if (!await directory.exists()) {
        await directory.create(recursive: true);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("saved to ${directory.path}")));

      }
      if (await directory.exists()) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String content = jsonEncode(prefs.getStringList(SharedPreferencesStrings.savedSeeds));
        saveFile.writeAsStringSync(content);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("saved to ${directory.path}")));
        print(saveFile.readAsStringSync());
      }
      return false;
    } catch(e) {
      return false;
    }
  }

  static void importClearFile(BuildContext context, WidgetRef ref, bool isEncrypted) async{
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ["json"]);
    if (result != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      File file = File(result.files.single.path!);
      try {
        print(file.readAsStringSync());
        ref.watch(seedsProvider.notifier).importJson(jsonDecode(file.readAsStringSync()), context);
      } catch(e) {
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("An error has occurred")));
      }
    }
  }

  static void exportEncryptedFile(BuildContext context) async{
    if (await _requestPermission(Permission.storage)) {
      return EncryptTypeInPasswordDialog.showEncryptTypeInPasswordDialog(context: context);
    }
  }
}