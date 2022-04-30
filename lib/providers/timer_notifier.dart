import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:otp_generator/models/timer_settings_model.dart';
import 'package:otp_generator/resources/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TimerNotifier extends StateNotifier<TimerModel>{
  TimerNotifier() : super(_initialState);

  static final _initialState = TimerModel(timeLeft: Ticker.getRemainingTime(30), timer: TimerSettingsModel.timer30.timer);

  final Ticker _ticker = Ticker();
  StreamSubscription<int>? _tickerSubscription;

  void start()async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int timer = prefs.getInt(SharedPreferencesStrings.savedTimer) ?? 30;
    _startTimer(timer);
  }

  void _startTimer(int timer) {
    _tickerSubscription?.cancel();
    _tickerSubscription =
      _ticker.tick(timer).listen((duration) {
        state = TimerModel(timeLeft: Ticker.getRemainingTime(timer), timer: timer);
      });
  }

  void changeTimer(int newTimer) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(SharedPreferencesStrings.savedTimer, newTimer) ;
    start();
  }

  @override
  void dispose() {
    _tickerSubscription?.cancel();
    super.dispose();
  }
}

class Ticker {
  Stream<int> tick(int timer) {
    return Stream.periodic(const Duration(seconds: 1), (_) => getRemainingTime(timer));
  }
  static int getRemainingTime(int timer) {
    return timer - (DateTime.now().millisecondsSinceEpoch ~/ Duration.millisecondsPerSecond)%timer;
  }
}

class TimerModel {
  final int timeLeft;
  final int timer;
  TimerModel({required this.timeLeft, required this.timer});
}