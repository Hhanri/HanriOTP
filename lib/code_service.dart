import 'package:otp/otp.dart';

class CodeService {
  static String getCode(String seed) {
    return OTP.generateTOTPCodeString(seed, DateTime.now().millisecondsSinceEpoch, isGoogle: true, interval: 30);
  }
}