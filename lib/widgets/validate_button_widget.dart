import 'package:flutter/material.dart';

class ValidateButtonWidget extends StatelessWidget {
  final VoidCallback onValidate;
  final String text;
  const ValidateButtonWidget({
    Key? key,
    required this.onValidate,
    required this.text,
  }) :  super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        onValidate();
      },
      child: Text(text)
    );
  }
}