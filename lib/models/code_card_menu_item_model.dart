import 'package:otp_generator/resources/strings.dart';

class CodeCardMenuItem{
  final String text;
  const CodeCardMenuItem({required this.text});

  static final List<CodeCardMenuItem> items = [
    modify,
    delete,
  ];

  static const CodeCardMenuItem modify = CodeCardMenuItem(text: SystemStrings.edit);

  static const CodeCardMenuItem delete = CodeCardMenuItem(text: SystemStrings.delete);
}