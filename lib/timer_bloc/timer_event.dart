part of 'timer_bloc.dart';

abstract class TimerEvent extends Equatable {
  const TimerEvent();
  @override
  List<Object> get props => [];
}

class Start extends TimerEvent {
  final int duration;
  const Start({required this.duration});
}

class Refresh extends TimerEvent {
}

class Tick extends TimerEvent {
  final int duration;
  const Tick({required this.duration});
}