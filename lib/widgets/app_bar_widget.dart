import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:otp_generator/providers/providers.dart';

class AppBarWidget extends StatelessWidget with PreferredSizeWidget{
  const AppBarWidget({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        AppBar(
          title: const Text("OTP Generator"),
          elevation: 0,
        ),
        Consumer(
          builder: (BuildContext context, WidgetRef ref, Widget? child) {
            final int timeLeft = ref.watch(timerProvider).timeLeft;
            return LinearProgressBarWidget(timeLeft: timeLeft);
          },
        ),
      ]
    );
  }
}

class LinearProgressBarWidget extends StatelessWidget {
  const LinearProgressBarWidget({
    Key? key,
    required this.timeLeft,
  }) : super(key: key);

  final int timeLeft;

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      value: timeLeft.toDouble()/30,
      color: timeLeft < 11 ? Colors.red : Colors.yellow,
      backgroundColor: Colors.transparent,
    );
  }
}