import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TimerNotifier extends StateNotifier<TimerModel>{
  TimerNotifier() : super(_initialState);

  static final _initialState = TimerModel(Ticker.getRemainingTime());

  final Ticker _ticker = Ticker();
  StreamSubscription<int>? _tickerSubscription;

  void start() {
    _startTimer();
  }

  void _startTimer() {
    _tickerSubscription?.cancel();
    _tickerSubscription =
      _ticker.tick().listen((duration) {
        state = TimerModel(duration);
      });
    state = TimerModel(Ticker.getRemainingTime());
  }

  @override
  void dispose() {
    _tickerSubscription?.cancel();
    super.dispose();
  }
}

class Ticker {
  Stream<int> tick() {
    return Stream.periodic(const Duration(seconds: 1), (_) => getRemainingTime());
  }
  static int getRemainingTime() {
    return 30 - (DateTime.now().millisecondsSinceEpoch ~/ Duration.millisecondsPerSecond)%30;
  }
}

class TimerModel {
  final int timeLeft;
  TimerModel(this.timeLeft);
}