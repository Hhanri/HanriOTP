import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:otp/otp.dart';

abstract class CodeState {
  const CodeState();
}
class CodeInitial extends CodeState {
}

class CodeLoading extends CodeState {
}

class CodeLoaded extends CodeState {
  final String code;
  CodeLoaded(this.code);
}

class CodeNotifier2 extends StateNotifier<CodeState> {
  final String seed;
  CodeNotifier2(this.seed) : super(CodeInitial());

  void refresh() {
    state = CodeLoading();
    final String newCode = getCode(seed);
    state = CodeLoaded(newCode);
  }
  String getCode(String seed) {
    return OTP.generateTOTPCodeString(seed, DateTime.now().millisecondsSinceEpoch, isGoogle: true, interval: 30);
  }
}