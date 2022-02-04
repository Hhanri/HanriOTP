import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:otp/otp.dart';

class SeedsNotifier extends StateNotifier<List<SeedModel>> {
  SeedsNotifier() : super(_initialState);

  static final List<SeedModel> _initialState = //loadSavedSeeds
    [
      const SeedModel(seed: "JBSWY3DPEHPK3PXP", title: "seed 1"),
      const SeedModel(seed: "JBSWY3DPEHPK3PXP", title: "seed 2"),
      const SeedModel(seed: "JBSWY3DPEHPK3PXP", title: "seed 3"),
    ];

  void addSeed(SeedModel newSeed) {
    state = [...state, newSeed];
    //saveSeeds
  }

  void modifySeed(SeedModel oldSeed, SeedModel newSeed) {
    List<SeedModel> temporaryState = [...state];
    temporaryState[temporaryState.indexOf(oldSeed)] = newSeed;
    state = temporaryState;
    //saveSeeds
  }

  void swapSeeds(int oldIndex, int newIndex, SeedModel seed) {
    final int index = newIndex > oldIndex ? newIndex - 1 : newIndex;
    List<SeedModel> temporaryState = [...state];
    temporaryState.removeAt(oldIndex);
    temporaryState.insert(index, seed);
    state = temporaryState;
    //saveSeeds
    printSeeds();
  }

  void removeSeed(SeedModel seed) {
    state = state.where((element) => element != seed).toList();
    //saveSeeds
  }

  void printSeeds() {
    for (var element in state) {
      print(element.title);
    }
  }

}

class SeedModel extends Equatable{
  final String seed;
  final String title;
  const SeedModel({required this.seed, required this.title});

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

  @override
  List<String> get props => [seed, title];
}