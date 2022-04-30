import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:otp_generator/pages/home_page.dart';
import 'package:otp_generator/pages/pin_code_page.dart';
import 'package:otp_generator/providers/providers.dart';
import 'package:otp_generator/resources/strings.dart';
import 'package:otp_generator/utils/route_generator.dart';

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
      ref.watch(pinCodeProvider.notifier).loadInitialState();
      ref.watch(timerProvider.notifier).start();
      ref.watch(seedsProvider.notifier).loadInitialState();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: SystemStrings.appTitle,
      onGenerateRoute: RouteGenerator.generateRoute,
      initialRoute: "/",
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      home: ref.watch(pinCodeProvider) == "" ? const HomeScreen() : PinCodeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}