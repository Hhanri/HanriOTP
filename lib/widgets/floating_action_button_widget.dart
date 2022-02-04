import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:otp_generator/providers/providers.dart';
import 'package:otp_generator/providers/seeds_notifier.dart';

import '../utils/navigation_utils.dart';

class FloatingActionButtonWidget extends StatelessWidget {
  const FloatingActionButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        NavigationUtils.showAddSeedDialog(context: context);
      },
      child: const Icon(Icons.add),
    );
  }
}
