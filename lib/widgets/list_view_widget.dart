import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:otp_generator/dialogs/add_and_edit_seed_dialog.dart';
import 'package:otp_generator/dialogs/qr_code_dialog.dart';
import 'package:otp_generator/models/code_card_menu_item_model.dart';
import 'package:otp_generator/models/seed_model.dart';
import 'package:otp_generator/providers/search_seed_notifier.dart';
import 'package:otp_generator/providers/providers.dart';
import 'package:otp_generator/resources/strings.dart';

class ListViewWidget extends StatelessWidget {
  const ListViewWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        final bool shortTimeLeft = ref.watch(timerProvider.select((value) => value.timeLeft <= 10)); //timeLeft below 10 => true, timeLeft reloads to 30 => false; 2 changes watched, so 2 rebuilds when needed
        final int timer = ref.watch(timerProvider.select((value) => value.timer));
        final SearchModel searching = ref.watch(searchSeedProvider);
        if (searching.searchedSeed.isNotEmpty && searching.isSearching) {
          final List<SeedModel> seeds = ref.watch(seedsProvider).where((element) => element.title.toLowerCase().contains(searching.searchedSeed.toLowerCase())).toList();
          return SimpleListViewWidget(seeds: seeds, shortTimeLeft: shortTimeLeft, timer: timer,);
        } else {
          final List<SeedModel> seeds = ref.watch(seedsProvider);
          if (seeds.isEmpty) {
            return const Center(child: Text(SystemStrings.noSeedAdded));
          } else {
            return ReorderableListViewWidget(
              timer: timer,
              seeds: seeds,
              shortTimeLeft: shortTimeLeft,
              onReorder: (oldIndex, newIndex) {
                ref.watch(seedsProvider.notifier).swapSeeds(oldIndex, newIndex, seeds[oldIndex]);
              },
            );
          }
        }
      },
    );
  }
}

class SimpleListViewWidget extends StatelessWidget {
  final int timer;
  final List<SeedModel> seeds;
  final bool shortTimeLeft;
  const SimpleListViewWidget({
    Key? key,
    required this.timer,
    required this.seeds,
    required this.shortTimeLeft
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> codes = SeedModel.getListCodes(seeds: seeds, timer: timer);
    return ListView.builder(
      itemCount: seeds.length,
      itemBuilder: (BuildContext context, int index) {
        return CodeCardWidget(
          code: codes[index],
          index: index,
          seed: seeds[index],
          shortTimeLeft: shortTimeLeft);
      }
    );
  }
}

class ReorderableListViewWidget extends StatelessWidget {
  final int timer;
  final List<SeedModel> seeds;
  final bool shortTimeLeft;
  final Function(int,int) onReorder;
  const ReorderableListViewWidget({
    Key? key,
    required this.seeds,
    required this.shortTimeLeft,
    required this.onReorder,
    required this.timer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> codes = SeedModel.getListCodes(seeds: seeds, timer: timer);
    return ReorderableListView.builder(
      physics: const ClampingScrollPhysics() ,
      itemBuilder: (BuildContext context, int index) {
        return CodeCardWidget(
          key: Key(seeds[index].title + seeds[index].seed + index.toString()),
          code: codes[index],
          index: index,
          seed: seeds[index],
          shortTimeLeft: shortTimeLeft,
        );
      },
      itemCount: seeds.length,
      onReorder: (int oldIndex, int newIndex) {
        onReorder(oldIndex, newIndex);
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
      subtitle: Text(Uri.decodeQueryComponent(seed.title)),
      trailing: FittedBox(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            CopyButtonWidget(code: code),
            CodeCardMoreButtonWidget(seed: seed)
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
      tooltip: SystemStrings.copyToClipBoard,
    );
  }
}

class CodeCardMoreButtonWidget extends StatelessWidget {
  final SeedModel seed;
  const CodeCardMoreButtonWidget({
    Key? key,
    required this.seed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        return PopupMenuButton<CodeCardMenuItem>(
          tooltip: SystemStrings.more,
          elevation: 0,
          onSelected: (item) {
            switch (item) {
              case CodeCardMenuItem.delete : ref.watch(seedsProvider.notifier).removeSeed(seed); break;
              case CodeCardMenuItem.modify : AddAndEditSeedDialog.showAddAndEditSeedDialog(context: context, previousSeed: seed, adding: false); break;
              case CodeCardMenuItem.showQRCode : QRCodeDialog.showQRCodeDialog(context: context, seed: seed);
            }
          },
          itemBuilder: (context) {
            return [...CodeCardMenuItem.items.map(buildItem)];
          }
        );
      }
    );
  }

  PopupMenuItem<CodeCardMenuItem> buildItem(CodeCardMenuItem item) {
    return PopupMenuItem<CodeCardMenuItem>(
      value: item,
      child: Text(item.text),
    );
  }
}