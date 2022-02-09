import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:otp_generator/models/security_model.dart';

class PinCodeNotifier extends StateNotifier<String>{
  PinCodeNotifier() : super(_initialState);

  static const String _initialState = "";

  void changePassword(String newPassword) {
    state = newPassword;
    SecurityPinCodeModel.savePassword(newPassword);
  }

  void resetPassword() {
    state = _initialState;
    SecurityPinCodeModel.resetPassword();
  }

  void loadInitialState() async {
    state = await SecurityPinCodeModel.loadPassword();
  }
}