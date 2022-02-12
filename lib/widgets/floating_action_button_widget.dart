import 'package:flutter/material.dart';
import 'package:otp_generator/dialogs/add_and_edit_seed_dialog.dart';
import 'package:otp_generator/models/seed_model.dart';

class FloatingActionButtonWidget extends StatelessWidget {
  const FloatingActionButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        AddAndEditSeedDialog.showAddAndEditSeedDialog(context: context, previousSeed: SeedModel.emptySeedModel, adding: true);
      },
      child: const Icon(Icons.add),
    );
  }
}
