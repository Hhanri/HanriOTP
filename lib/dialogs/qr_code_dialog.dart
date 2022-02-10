import 'package:flutter/material.dart';
import 'package:otp_generator/models/seed_model.dart';
import 'package:otp_generator/resources/strings.dart';
import 'package:otp_generator/widgets/validate_button_widget.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRCodeDialog {
  static void showQRCodeDialog({required BuildContext context, required SeedModel seed}) {
    FocusScope.of(context).unfocus();
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return QRCodeAlertDialog(seed: seed);
      },
    );
  }
}

class QRCodeAlertDialog extends StatelessWidget {
  final SeedModel seed;
  const QRCodeAlertDialog({
    Key? key,
    required this.seed
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(SystemStrings.qrCode),
      content: IntrinsicHeight(
        child: SizedBox(
          height: 300,
          width: 300,
          child: QrImage(
            data: SeedModel.getLink(seed: seed).toString(),
            size: 300,
            backgroundColor: Colors.white,
          ),
        ),
      ),
      actions: [
        ValidateButtonWidget(
          onValidate: () {
            Navigator.of(context).pop();
          },
          text: SystemStrings.ok
        )
      ],
    );
  }
}
