import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:otp/otp.dart';

class CodeNotifier extends StateNotifier<List<CodeModel>> {
  CodeNotifier() : super(_initialState);

  static final List<CodeModel> _initialState = //loadSavedSeeds
    [
      CodeModel(seed: "JBSWY3DPEHPK3PXP", title: "seed 1"),
      CodeModel(seed: "JBSWY3DPEHPK3PXP", title: "seed 2")
    ];

  void addSeed(CodeModel newSeed) {
    state.add(newSeed);
    //saveSeeds
  }

  void modifySeed(int index, newSeed) {
    state[index] = newSeed;
    //saveSeeds
  }

}

class CodeModel {
  final String seed;
  final String title;
  CodeModel({required this.seed, required this.title});

  static Map<String, String>toMap(CodeModel codeModel) => {
    "seed": codeModel.seed,
    "title": codeModel.title
  };

  factory CodeModel.fromJson(Map<String, String> jsonData){
    return CodeModel(
      seed: jsonData["seed"]!,
      title: jsonData["title"]!
    );
  }

  static String getCode(String seed) {
    return OTP.generateTOTPCodeString(seed, DateTime.now().millisecondsSinceEpoch, isGoogle: true, interval: 30);
  }
}