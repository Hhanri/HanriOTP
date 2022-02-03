import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:otp/otp.dart';

class SeedsNotifier extends StateNotifier<List<SeedModel>> {
  SeedsNotifier() : super(_initialState);

  static final List<SeedModel> _initialState = //loadSavedSeeds
    [
      SeedModel(seed: "JBSWY3DPEHPK3PXP", title: "seed 1"),
      SeedModel(seed: "JBSWY3DPEHPK3PXP", title: "seed 1"),
      SeedModel(seed: "JBSWY3DPEHPK3PXP", title: "seed 1"),
      SeedModel(seed: "JBSWY3DPEHPK3PXP", title: "seed 1"),
      SeedModel(seed: "JBSWY3DPEHPK3PXP", title: "seed 1"),
      SeedModel(seed: "JBSWY3DPEHPK3PXP", title: "seed 1"),
      SeedModel(seed: "JBSWY3DPEHPK3PXP", title: "seed 1"),
      SeedModel(seed: "JBSWY3DPEHPK3PXP", title: "seed 1"),
      SeedModel(seed: "JBSWY3DPEHPK3PXP", title: "seed 1"),
      SeedModel(seed: "JBSWY3DPEHPK3PXP", title: "seed 2")
    ];

  void addSeed(SeedModel newSeed) {
    state.add(newSeed);
    //saveSeeds
  }

  void modifySeed(int index, newSeed) {
    state[index] = newSeed;
    //saveSeeds
  }

}

class SeedModel {
  final String seed;
  final String title;
  SeedModel({required this.seed, required this.title});

  static Map<String, String>toMap(SeedModel seedModel) => {
    "seed": seedModel.seed,
    "title": seedModel.title
  };

  factory SeedModel.fromJson(Map<String, String> jsonData){
    return SeedModel(
      seed: jsonData["seed"]!,
      title: jsonData["title"]!
    );
  }

  static String getCode(String seed) {
    return OTP.generateTOTPCodeString(seed, DateTime.now().millisecondsSinceEpoch, isGoogle: true, interval: 30);
  }
  static List<String> getListCodes(List<SeedModel> seeds) {
    List<String> codesList = [];
    for (int i = 0; i < seeds.length; i++) {
      codesList.insert(i, getCode(seeds[i].seed));
    }
    return codesList;
  }
}