import 'package:equatable/equatable.dart';
import 'package:otp_generator/resources/strings.dart';

class SecurityModel extends Equatable{
  final String value;
  final String title;

  const SecurityModel({
    required this.value,
    required this.title
  });

  static List<SecurityModel> features = [
    const SecurityModel(value: SecurityModelStrings.noneValue, title: SecurityModelStrings.noneTitle),
    const SecurityModel(value: SecurityModelStrings.pinCodeValue, title: SecurityModelStrings.pinCodeTitle)
  ];

  @override
  // TODO: implement props
  List<Object?> get props => [title, value];
}