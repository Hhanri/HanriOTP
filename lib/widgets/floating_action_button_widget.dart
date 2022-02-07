import 'package:flutter/material.dart';
import 'package:otp_generator/dialogs/add_seed_dialog.dart';

class FloatingActionButtonWidget extends StatelessWidget {
  const FloatingActionButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        AddSeedDialog.showAddSeedDialog(context: context);
      },
      child: const Icon(Icons.add),
    );
  }
}
