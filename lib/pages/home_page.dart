import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:otp_generator/code_service.dart';
import 'package:otp_generator/main.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String seed = "JBSWY3DPEHPK3PXP";
    print("home was rebuilt");
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            children: [
              Consumer(
                builder: (BuildContext context, WidgetRef ref, Widget? child) {
                  final String timeLeft = ref.watch(timerProvider).timeLeft.toString();
                  return Text(timeLeft);
                },
              ),
              CodeTextWidget(seed: seed)
            ],
          )
        ),
      ),
    );
  }
}

class CodeTextWidget extends StatelessWidget {
  final String seed;
  const CodeTextWidget({Key? key, required this.seed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("code was rebuilt");
    String code = CodeService.getCode(seed);
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        int timeLeft = ref.watch(timerProvider).timeLeft;
        print('code consumer rebuilt');
        if (timeLeft == 30) {
          code = CodeService.getCode(seed);
        }
        return Text(code);
      },
    );
  }
}
