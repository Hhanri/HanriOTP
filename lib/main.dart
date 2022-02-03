import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

class MyApp extends ConsumerStatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      ref.watch(timerProvider.notifier).start();
    });
  }

  @override
  Widget build(BuildContext context) {
    print("my app was rebuilt");
    return MaterialApp(
      title: 'OTP Generator',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}

final timerProvider = StateNotifierProvider<TimerNotifier, TimerModel>(
  (ref) => TimerNotifier()
);