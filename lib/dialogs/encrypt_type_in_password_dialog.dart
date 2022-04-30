import 'dart:convert';
import 'dart:io';
import 'package:aes_crypt_null_safe/aes_crypt_null_safe.dart';
import 'package:flutter/material.dart';
import 'package:otp_generator/resources/strings.dart';
import 'package:otp_generator/utils/file_utils.dart';
import 'package:otp_generator/utils/snackbar_utils.dart';
import 'package:otp_generator/widgets/validate_button_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EncryptTypeInPasswordDialog {
  static void showEncryptTypeInPasswordDialog({required BuildContext context}) async {
    FocusScope.of(context).unfocus();
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return const EncryptTypeInPasswordAlertDialog();
      },
    );
  }
}

class EncryptTypeInPasswordAlertDialog extends StatelessWidget {
  const EncryptTypeInPasswordAlertDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
        String password = "";
    return AlertDialog(
      title: const Text(SystemStrings.password),
      content: TypeInPasswordTextFieldWidget(
        onChange: (value) {
          password = value;
        },
      ),
      actions: [
        ValidateButtonWidget(
          onValidate: () {
            try {
              exportEncryptedFile(password, context);
              Navigator.of(context).pop();
            } catch (e) {
              SnackBarUtils.errorSnackBar(context);
            }
          },
          text: SystemStrings.ok
        )
      ],
    );
  }

  void exportEncryptedFile(String password, BuildContext context) async {
    final AesCrypt crypt = AesCrypt();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    crypt.setPassword(password);
    final Directory? directory = await getExternalStorageDirectory();

    String file = jsonEncode(prefs.getStringList(SharedPreferencesStrings.savedSeeds));
    String date = FileUtils.getDateFormatFileName();
    String fileName = "${directory!.path}$date${FileUtils.jsonExt}${FileUtils.aesExt}";
    crypt.encryptTextToFileSync(file, fileName, utf16: true);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("saved to ${directory.path}")));
  }
}

class TypeInPasswordTextFieldWidget extends StatelessWidget {
  final Function(String) onChange;
  const TypeInPasswordTextFieldWidget({
    Key? key,
    required this.onChange
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: true,
      onChanged: (value) {
        onChange(value);
      },
    );
  }
}
