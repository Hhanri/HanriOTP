import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:otp_generator/providers/code_notifier.dart';
import 'package:otp_generator/providers/timer_notifier.dart';

final timerProvider = StateNotifierProvider<TimerNotifier, TimerModel>(
    (ref) => TimerNotifier()
);
final seedsProvider = StateNotifierProvider<SeedsNotifier, List<SeedModel>>(
    (ref) => SeedsNotifier()
);