import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:otp_generator/dialogs/pin_code_dialog.dart';
import 'package:otp_generator/providers/providers.dart';
import 'package:otp_generator/providers/search_seed_notifier.dart';
import 'package:otp_generator/resources/strings.dart';

class AppBarFullWidget extends StatelessWidget with PreferredSizeWidget{
  const AppBarFullWidget({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        const AppBarWidget(),
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

class AppBarWidget extends StatelessWidget {
  const AppBarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FocusNode focusNode = FocusNode();
    return Consumer(
      builder: (BuildContext context, WidgetRef ref ,Widget? child) {
        final SearchModel searching = ref.watch(searchSeedProvider);
        return AppBar(
          title: searching.isSearching
              ? TextField(
                  focusNode: focusNode,
                  enableSuggestions: false,
                  maxLines: 1,
                  autocorrect: false,
                  onChanged: (value) {
                    ref.watch(searchSeedProvider.notifier).searchSeed(value);
                  },
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: TitleStrings.searchSeed,
                  ),
                )
              : const Text(SystemStrings.appTitle),
                  elevation: 0,
          actions: [
            IconButton(
              onPressed: () {
                ref.watch(searchSeedProvider.notifier).openSearchBar();
                if (searching.isSearching) {
                  focusNode.unfocus();
                } else {
                  focusNode.requestFocus();
                }
              },
              icon: searching.isSearching ? const  Icon(Icons.clear) : const Icon(Icons.search)
            ),
            IconButton(
              onPressed: () {
                PinCodeDialog.showPinCodeDialog(context: context);
              },
              icon: const Icon(Icons.more_vert),
            )
          ],
        );
      }
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