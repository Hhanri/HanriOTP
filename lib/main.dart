import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:otp_generator/code_notifier.dart';
import 'package:otp_generator/codes_service.dart';
import 'package:otp_generator/pages/home_page.dart';
import 'package:otp_generator/ticker.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: MyApp()
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OTP Generator',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen2(),
    );
  }
}

final timerProvider = StateNotifierProvider<TimerNotifier, TimerModel>(
  (ref) => TimerNotifier()
);

final seedsProvider = Provider<String>(
    (ref) => "JBSWY3DPEHPK3PXP"
);

final codesNotifierProvider = StateNotifierProvider(
  (ref) => CodeNotifier2(ref.watch(seedsProvider))
);