import 'package:flutter/material.dart';
import 'package:otp_generator/resources/strings.dart';

class CancelButtonWidget extends StatelessWidget {
  const CancelButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: const Text(TitleStrings.cancel),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }
}
