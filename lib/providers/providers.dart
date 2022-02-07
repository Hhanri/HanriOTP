import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:otp_generator/models/seed_model.dart';
import 'package:otp_generator/providers/pin_code_notifier.dart';
import 'package:otp_generator/providers/search_seed_notifier.dart';
import 'package:otp_generator/providers/seeds_notifier.dart';
import 'package:otp_generator/providers/timer_notifier.dart';

final StateNotifierProvider<TimerNotifier, TimerModel>  timerProvider = StateNotifierProvider<TimerNotifier, TimerModel>(
    (ref) => TimerNotifier()
);
final StateNotifierProvider<SeedsNotifier, List<SeedModel>> seedsProvider = StateNotifierProvider<SeedsNotifier, List<SeedModel>>(
    (ref) => SeedsNotifier()
);

final StateNotifierProvider<SearchSeedNotifier, SearchModel> searchSeedProvider = StateNotifierProvider<SearchSeedNotifier, SearchModel>(
    (ref) => SearchSeedNotifier()
);

final StateNotifierProvider<PinCodeNotifier, String> pinCodeNotifier = StateNotifierProvider<PinCodeNotifier, String>(
    (ref) => PinCodeNotifier()
);