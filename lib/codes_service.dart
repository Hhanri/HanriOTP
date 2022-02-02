import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:otp/otp.dart';

class CodeNotifier extends StateNotifier<List<CodeModel>> {
  CodeNotifier() : super(_initialState);

  static final _initialState =
    [
      CodeModel("JBSWY3DPEHPK3PXP", CodesServices().getCode("JBSWY3DPEHPK3PXP")),
      CodeModel("JBSWY3DPEHPK3PXP", CodesServices().getCode("JBSWY3DPEHPK3PXP")),
    ];

  void refreshCodes() {
    state = [
      CodeModel("JBSWY3DPEHPK3PXP", CodesServices().getCode("JBSWY3DPEHPK3PXP")),
      CodeModel("JBSWY3DPEHPK3PXP", CodesServices().getCode("JBSWY3DPEHPK3PXP")),
    ];
  }
}

class CodesServices{
  String getCodes(CodeModel codeModel) {
    String seed = codeModel.seed;
    String code = getCode(seed);
    return code;
  }
  String getCode(String seed) {
    return OTP.generateTOTPCodeString(seed, DateTime.now().millisecondsSinceEpoch, isGoogle: true, interval: 30);
  }
}

class CodeModel {
  final String seed;
  final String code;
  CodeModel(this.seed, this.code);
}