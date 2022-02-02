import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:otp_generator/code_notifier.dart';
import 'package:otp_generator/main.dart';

/*
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {

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
    final codes = ref.watch(codesProvider);
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            children: [
              Text(
                timeLeft.toString()
              ),
              Text(() {
                if (timeLeft == 30) {
                  ref.watch(codesProvider.notifier).refreshCodes();
                }
                return codes[0].code;
              }())
            ],
          )
        ),
      ),
    );
  }
}

 */


class HomeScreen2 extends ConsumerStatefulWidget {
  const HomeScreen2({Key? key}) : super(key: key);

  @override
  _HomeScreen2State createState() => _HomeScreen2State();
}

class _HomeScreen2State extends ConsumerState<HomeScreen2> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      ref.watch(timerProvider.notifier).start();
      ref.watch(codesNotifierProvider.notifier).refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Consumer(
                builder: (context, watch, child) {
                  final int timeLeft = watch.watch(timerProvider).timeLeft;
                  return Text(timeLeft.toString());
                },
              ),
              Consumer(
                builder: (context, watch, child) {
                  final state = watch.watch(codesNotifierProvider);
                  if (state is CodeLoaded) {
                    if (watch.watch(timerProvider).timeLeft == 30) {
                      watch.watch(codesNotifierProvider.notifier).refresh();
                    }
                    return Text(state.code);
                  }
                  return const CircularProgressIndicator();
                },
              )
            ],
          )
        ),
      ),
    );
  }
}
