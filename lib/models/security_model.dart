import 'package:equatable/equatable.dart';

class SecurityModel extends Equatable{
  final String value;
  final String title;

  const SecurityModel({
    required this.value,
    required this.title
  });

  static List<SecurityModel> features = [
    const SecurityModel(value: "None", title: "None"),
    const SecurityModel(value: "PIN", title: "Pin Code")
  ];

  @override
  // TODO: implement props
  List<Object?> get props => [title, value];
}