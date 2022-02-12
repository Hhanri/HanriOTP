import 'package:flutter/material.dart';
import 'package:otp_generator/dialogs/add_and_edit_seed_dialog.dart';
import 'package:otp_generator/models/algorithm_model.dart';
import 'package:otp_generator/models/seed_model.dart';
import 'package:otp_generator/resources/strings.dart';
import 'package:otp_generator/utils/app_config.dart';
import 'package:otp_generator/utils/snackbar_utils.dart';
import 'package:otp_generator/widgets/simple_app_bar_widget.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRCodeScanScreen extends StatelessWidget {
  const QRCodeScanScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: SimpleAppBarWidget(title: SystemStrings.scanQRCode),
      body: QRScannerView(),
    );
  }
}

class QRScannerView extends StatefulWidget {
  const QRScannerView({Key? key}) : super(key: key);

  @override
  State<QRScannerView> createState() => _QRScannerViewState();
}

class _QRScannerViewState extends State<QRScannerView> {
  QRViewController? controller;
  final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');
  @override
  Widget build(BuildContext context) {
    return QRView(
      key: _qrKey,
      onQRViewCreated: onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: Theme.of(context).colorScheme.secondary,
        cutOutSize: AppConfig.screenWidth(context)*0.8,
        borderWidth: 10,
        borderLength: 20,
        borderRadius: 10
      ),
    );
  }

  void onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((barcode) {
      String? scheme = Uri.parse(barcode.code!).scheme;
      String? host = Uri.parse(barcode.code!).host;
      String? seed = Uri.parse(barcode.code!).queryParameters[SeedModelStrings.secret];
      String title = Uri.parse(barcode.code!).pathSegments[0];
      String algorithm = Uri.parse(barcode.code!).queryParameters[SeedModelStrings.algorithm] ?? AlgorithmModel.defaultAlgo.name;
      if (scheme == SeedModelStrings.scheme && host == SeedModelStrings.host && seed != null) {
        SeedModel newSeed = SeedModel(seed: seed, title: title, algorithm: AlgorithmModel.algorithms.singleWhere((element) => element.name == algorithm));
        Navigator.of(context).pop();
        AddAndEditSeedDialog.showAddAndEditSeedDialog(context: context, previousSeed: newSeed, adding: true);
      } else {
        SnackBarUtils.wrongQRCodeSnackBar(context);
      }
    });
  }
}
