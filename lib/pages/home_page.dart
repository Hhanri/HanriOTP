import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:otp_generator/main.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreen2State createState() => _HomeScreen2State();
}

class _HomeScreen2State extends ConsumerState<HomeScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      ref.watch(timerProvider.notifier).start();
    });
  }

  @override
  Widget build(BuildContext context) {
    final timeLeft = ref.watch(timerProvider).timeLeft;
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Text(
            timeLeft.toString()
          )
        ),
      ),
    );
  }
}
