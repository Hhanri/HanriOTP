import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:otp/otp.dart';
import 'package:otp_generator/ticker.dart';

part 'timer_event.dart';
part 'timer_state.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {

  int duration = Ticker.getRemainingTime();
  final Ticker ticker;
  final List<String> seeds = ["JBSWY3DPEHPK3PXP", "JBSWY3DPEHPK3PXP"];
  final List<String> codes = [];

  TimerBloc({required this.ticker}) : super(TimerRunningState(Ticker.getRemainingTime())) {

    StreamSubscription? _tickerSubscription;
    void getCodes() {
      for (int i = 0; i < seeds.length; i++) {
        codes.insert(i, OTP.generateTOTPCodeString(seeds[i], DateTime.now().millisecondsSinceEpoch, algorithm: Algorithm.SHA1, interval: 30, isGoogle: true));
      }
    }

    on<Refresh>((event, emit) async {
      getCodes();
    });

    on<Start>((event, emit) async{
      getCodes();
      emit(TimerRunningState(duration));
      _tickerSubscription?.cancel();
      _tickerSubscription = ticker.tick().listen((event) {
        add(Tick(duration: event));
      });
    });

    on<Tick>((event, emit) async {
      duration = Ticker.getRemainingTime();
    });
    add(Start());

    @override
    Future<void> close() {
      _tickerSubscription?.cancel();
      return super.close();
    }
  }
}
