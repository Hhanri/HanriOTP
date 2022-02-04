import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:otp_generator/providers/seeds_notifier.dart';
import 'package:otp_generator/providers/providers.dart';

class ListViewWidget extends StatelessWidget {
  const ListViewWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        final shortTimeLeft = ref.watch(timerProvider.select((value) => value.timeLeft <= 10)); //timeLeft below 10 => true, timeLeft reloads to 30 => false; 2 changes watched, so 2 rebuilds when needed
        final List<SeedModel> seeds = ref.watch(seedsProvider);
        List<String> codes = SeedModel.getListCodes(seeds);
        return ReorderableListView.builder(
          physics: const ClampingScrollPhysics() ,
          itemBuilder: (BuildContext context, int index) {
            return CodeCardWidget(
              key: Key(seeds[index].title + seeds[index].seed),
              code: codes[index],
              index: index,
              seed: seeds[index],
              shortTimeLeft: shortTimeLeft,
            );
          },
          itemCount: seeds.length,
          onReorder: (int oldIndex, int newIndex) {
            ref.watch(seedsProvider.notifier).swapSeeds(oldIndex, newIndex, seeds[oldIndex]);
          },
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
    print('code rebuilt ${seed.title}');
    return ListTile(
      title: Text(
        code,
        style: TextStyle(
          color: shortTimeLeft ? Colors.red : Colors.white
        ),
      ),
      subtitle: Text(seed.title),
      trailing: FittedBox(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            CopyButtonWidget(code: code),
            MoreButtonWidget(seed: seed, index: index)
          ],
        ),
      )
    );
  }
}

class CopyButtonWidget extends StatelessWidget {
  final String code;
  const CopyButtonWidget({
    Key? key,
    required this.code
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: (){
        Clipboard.setData(ClipboardData(text: code));
      },
      icon: const Icon(Icons.copy),
      tooltip: 'Copy to clipboard',
    );
  }
}

class MoreButtonWidget extends StatelessWidget {
  final SeedModel seed;
  final int index;
  const MoreButtonWidget({
    Key? key,
    required this.seed,
    required this.index
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {  },
      icon: const Icon(Icons.more_vert),
      tooltip: 'More',
    );
  }
}
