import 'package:otp_generator/resources/strings.dart';

class MoreSettingsMenuItem{
  final String text;
  const MoreSettingsMenuItem({required this.text});

  static final List<MoreSettingsMenuItem> items = [
    backup,
    settings,
  ];

  static const MoreSettingsMenuItem backup = MoreSettingsMenuItem(text: SystemStrings.backup);

  static const MoreSettingsMenuItem settings = MoreSettingsMenuItem(text: SystemStrings.settings);
}