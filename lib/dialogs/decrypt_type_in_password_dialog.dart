import 'dart:convert';
import 'dart:io';
import 'package:aes_crypt_null_safe/aes_crypt_null_safe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:otp_generator/resources/strings.dart';
import 'package:otp_generator/utils/snackbar_utils.dart';
import 'package:otp_generator/widgets/validate_button_widget.dart';
import 'package:otp_generator/providers/providers.dart';

class DecryptTypeInPasswordDialog {
  static void showDecryptTypeInPasswordDialog({required BuildContext context, required File file}) async {
    FocusScope.of(context).unfocus();
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return DecryptTypeInPasswordAlertDialog(file: file);
      },
    );
  }
}

class DecryptTypeInPasswordAlertDialog extends StatelessWidget {
  final File file;
  const DecryptTypeInPasswordAlertDialog({
    Key? key,
    required this.file,
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
        Consumer(
          builder: (BuildContext context, WidgetRef ref, Widget? child) {
            return ValidateButtonWidget(
              onValidate: () {
                importEncryptedFile(password, file, ref, context);
                Navigator.of(context).pop();
              },
              text: SystemStrings.ok
            );
          }
        )
      ],
    );
  }

  void importEncryptedFile(String password, File file, WidgetRef ref, BuildContext context) async {
    final AesCrypt crypt = AesCrypt();
    crypt.setPassword(password);
    try {
      final String decryptedBackup = crypt.decryptTextFromFileSync(file.path, utf16: true);
      ref.watch(seedsProvider.notifier).importJson(jsonDecode(decryptedBackup), context);
    } catch (e) {
      SnackBarUtils.errorSnackBar(context);
    }
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
