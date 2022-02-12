import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:otp_generator/dialogs/add_and_edit_seed_dialog.dart';
import 'package:otp_generator/models/seed_model.dart';
import 'package:otp_generator/resources/strings.dart';
import 'package:otp_generator/utils/route_generator.dart';

class FloatingActionButtonWidget extends StatelessWidget {
  const FloatingActionButtonWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      spaceBetweenChildren: 8,
      spacing: 12,
      children: [
        SpeedDialChild(
          child: const Icon(Icons.qr_code_2),
          label: SystemStrings.addFromQRCode,
          onTap: () {
            Navigator.of(context).pushNamed(qrCodeScanPage);
          }
        ),
        SpeedDialChild(
          child: const Icon(Icons.text_fields),
          label: SystemStrings.addManually,
          onTap: () {
            AddAndEditSeedDialog.showAddAndEditSeedDialog(
              context: context,
              previousSeed: SeedModel.emptySeedModel,
              adding: true
            );
          }
        ),
      ],
    );
  }
}


