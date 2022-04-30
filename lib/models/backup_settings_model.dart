import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:otp_generator/dialogs/decrypt_type_in_password_dialog.dart';
import 'package:otp_generator/dialogs/encrypt_type_in_password_dialog.dart';
import 'package:otp_generator/providers/providers.dart';
import 'package:otp_generator/utils/file_utils.dart';
import 'package:otp_generator/utils/snackbar_utils.dart';
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
      importClearFile(context, ref);
    }
  );

  static final BackupSettingsModel importEncryptedBackup = BackupSettingsModel(
    title: BackupSettingsModelStrings.importEncryptedBackupTitle,
    description: BackupSettingsModelStrings.importEncryptedBackupDescription,
    function: (context, ref) {
      importEncryptedFile(context);
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
    String date = FileUtils.getDateFormatFileName();
    String fileName = "$date${FileUtils.jsonExt}";
    Directory? directory;
    try{
      if (Platform.isAndroid) {
        if (await _requestPermission(Permission.manageExternalStorage)) {
          directory = Directory(FileUtils.rootPath);
          print(directory.path);
        }
      }
      File saveFile = File(directory!.path + "$fileName");
      print(saveFile.path);
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }
      if (await directory.exists()) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String content = jsonEncode(prefs.getStringList(SharedPreferencesStrings.savedSeeds));
        saveFile.create(recursive: true);
        saveFile.writeAsStringSync(content);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("saved to ${directory.path}")));
        print(saveFile.readAsStringSync());
      }
      return false;
    } catch(e) {
      return false;
    }
  }

  static void importClearFile(BuildContext context, WidgetRef ref) async{
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ["json"]);
    if (result != null) {
      File file = File(result.files.single.path!);
      try {
        print(file.readAsStringSync());
        ref.watch(seedsProvider.notifier).importJson(jsonDecode(file.readAsStringSync()), context);
      } catch(e) {
        print(e);
        SnackBarUtils.errorSnackBar(context);
      }
    }
  }

  static void importEncryptedFile(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.any);
    if (result != null && result.files.single.extension == "aes") {
      File file = File(result.files.single.path!);
      return DecryptTypeInPasswordDialog.showDecryptTypeInPasswordDialog(context: context, file: file);
    } else {
      SnackBarUtils.errorSnackBar(context);
    }
  }

  static void exportEncryptedFile(BuildContext context) async{
    if (await _requestPermission(Permission.manageExternalStorage)) {
      return EncryptTypeInPasswordDialog.showEncryptTypeInPasswordDialog(context: context);
    }
  }
}