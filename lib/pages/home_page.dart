import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:otp_generator/main.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timeLeft = ref.watch(timerProvider).timeLeft;
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Text(timeLeft.toString())
        ),
      ),
    );
  }
}


