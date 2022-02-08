import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:otp_generator/resources/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BackupSettingsModel {
  final String title;
  final String description;
  final Function(BuildContext) function;

  BackupSettingsModel({
    required this.title,
    required this.description,
    required this.function
  });

  static final List<BackupSettingsModel> items = [
    exportClearBackup,
    importClearBackup
  ];

  static final BackupSettingsModel exportClearBackup = BackupSettingsModel(
    title: BackupSettingsModelStrings.exportClearBackupTitle,
    description: BackupSettingsModelStrings.exportClearBackupDescription,
    function: (context) async{
      print("export backup");
      await saveFile(context);
    }
  );

  static final BackupSettingsModel importClearBackup = BackupSettingsModel(
    title: BackupSettingsModelStrings.importClearBackupTitle,
    description: BackupSettingsModelStrings.importClearBackupDescription,
    function: (context) async {
      print("import backup");
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
  static Future<bool> saveFile(BuildContext context) async {
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
}