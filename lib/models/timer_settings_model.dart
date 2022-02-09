import 'package:equatable/equatable.dart';

class TimerSettingsModel extends Equatable {
  final int timer;
  const TimerSettingsModel({required this.timer});

  static final List<TimerSettingsModel> timers = [timer30, timer60];

  static const timer30 = TimerSettingsModel(timer: 30);
  static const timer60 = TimerSettingsModel(timer: 60);

  @override
  // TODO: implement props
  List<Object?> get props => [timer];
}