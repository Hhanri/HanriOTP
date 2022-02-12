import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:otp_generator/models/more_settings_model.dart';
import 'package:otp_generator/providers/providers.dart';
import 'package:otp_generator/providers/search_seed_notifier.dart';
import 'package:otp_generator/resources/strings.dart';
import 'package:otp_generator/utils/route_generator.dart';

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
            final int timer = ref.watch(timerProvider).timer;
            return LinearProgressBarWidget(timeLeft: timeLeft, timer: timer,);
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
            const AppBardMoreButtonWidget()
          ],
        );
      }
    );
  }
}

class AppBardMoreButtonWidget extends StatelessWidget {
  const AppBardMoreButtonWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? child) {
          return PopupMenuButton<MoreSettingsMenuItem>(
              tooltip: SystemStrings.more,
              elevation: 0,
              onSelected: (item) {
                switch (item) {
                  case MoreSettingsMenuItem.backup : Navigator.of(context).pushNamed(backupPage); break;
                  case MoreSettingsMenuItem.settings : Navigator.of(context).pushNamed(settingsPage); break;
                }
              },
              itemBuilder: (context) {
                return [...MoreSettingsMenuItem.items.map(buildItem)];
              }
          );
        }
    );
  }

  PopupMenuItem<MoreSettingsMenuItem> buildItem(MoreSettingsMenuItem item) {
    return PopupMenuItem<MoreSettingsMenuItem>(
      value: item,
      child: Text(item.text),
    );
  }
}


class LinearProgressBarWidget extends StatelessWidget {
  final int timeLeft;
  final int timer;
  const LinearProgressBarWidget({
    Key? key,
    required this.timeLeft,
    required this.timer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      value: timeLeft.toDouble()/timer,
      color: timeLeft < 11 ? Colors.red : Colors.yellow,
      backgroundColor: Colors.transparent,
    );
  }
}