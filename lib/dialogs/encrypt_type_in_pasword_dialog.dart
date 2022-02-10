import 'dart:convert';

import 'package:aes_crypt_null_safe/aes_crypt_null_safe.dart';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:otp_generator/resources/strings.dart';
import 'package:otp_generator/widgets/validate_button_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EncryptTypeInPasswordDialog {
  static void showEncryptTypeInPasswordDialog({required BuildContext context}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    FocusScope.of(context).unfocus();
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return EncryptTypeInPasswordAlertDialog(file: jsonEncode(prefs.getStringList(SharedPreferencesStrings.savedSeeds)));
      },
    );
  }
}

class EncryptTypeInPasswordAlertDialog extends StatelessWidget {
  final String file;
  const EncryptTypeInPasswordAlertDialog({
    Key? key,
    required this.file,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String password = "";
    return AlertDialog(
      title: Text(SystemStrings.password),
      content: TypeInPasswordTextFieldWidget(
        onChange: (value) {
          password = value;
        },
      ),
      actions: [
        ValidateButtonWidget(
          onValidate: (){
            final AesCrypt crypt = AesCrypt();
            crypt.setPassword(password);
            String date = DateFormat('yyyy-MM-dd_HH:mm:ss').format(DateTime.now());
            String fileName = "/storage/emulated/0/HanriOTP/$date.json.aes";
            crypt.encryptTextToFileSync(file, fileName, utf16: true);
          },
          text: SystemStrings.ok
        )
      ],
    );
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
