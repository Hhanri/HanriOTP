import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:otp_generator/ticker.dart';

part 'timer_event.dart';
part 'timer_state.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  final int _duration = Ticker.getRemainingTime();
  final Ticker ticker;

  TimerBloc({required this.ticker}) : super(TimerRunningState(Ticker.getRemainingTime())) {
    StreamSubscription? _tickerSubscription;

    on<Start>((event, emit) async{
      emit(TimerRunningState(_duration));
      _tickerSubscription?.cancel();
      _tickerSubscription = ticker.tick().listen((event) {
        add(Tick(duration: _duration));
      });
    });
  }
}
