import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:otp_generator/providers/code_notifier.dart';
import 'package:otp_generator/providers/providers.dart';

class ListViewWidget extends StatelessWidget {
  const ListViewWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        final refreshTiming = ref.watch(timerProvider.select((value) => value.timeLeft == 30));
        final shortTimeLeft = ref.watch(timerProvider.select((value) => value.timeLeft < 11));
        final List<SeedModel> seeds = ref.watch(seedsProvider);
        List<String> codes = SeedModel.getListCodes(seeds);
        return ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return CodeCardWidget(
              code: codes[index],
              index: index,
              seed: seeds[index],
              shortTimeLeft: shortTimeLeft,
            );
          },
          itemCount: seeds.length,
        );
      },
    );
  }
}

class CodeCardWidget extends StatelessWidget{
  final SeedModel seed;
  final String code;
  final int index;
  final bool shortTimeLeft;
  const CodeCardWidget({
    Key? key,
    required this.code,
    required this.index,
    required this.seed,
    required this.shortTimeLeft
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('code rebuilt');
    return ListTile(
      title: Text(
        code,
        style: TextStyle(
          color: shortTimeLeft ? Colors.red : Colors.white
        ),
      ),
      subtitle: Text(seed.title),
    );
  }
}
