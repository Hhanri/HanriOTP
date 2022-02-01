part of 'timer_bloc.dart';

abstract class TimerState extends Equatable {
  final int duration;
  const TimerState(this.duration);@override
  List<Object> get props => [duration];

}

class TimerRunningState extends TimerState {
  const TimerRunningState(int duration) : super(duration);
}
