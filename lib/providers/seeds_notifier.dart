import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:otp/otp.dart';
import 'package:otp_generator/resources/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SeedsNotifier extends StateNotifier<List<SeedModel>> {
  SeedsNotifier() : super(_initialState);

  static final List<SeedModel> _initialState = [];

  void loadInitialState() async{
    state = await SeedModel.loadSavedSeeds();
    print(state);
  }

  void addSeed(SeedModel newSeed) {
    state = [...state, newSeed];
    SeedModel.saveSeeds(state);
  }

  void modifySeed(SeedModel oldSeed, SeedModel newSeed) {
    List<SeedModel> temporaryState = [...state];
    temporaryState[temporaryState.indexOf(oldSeed)] = newSeed;
    state = temporaryState;
    SeedModel.saveSeeds(state);
  }

  void swapSeeds(int oldIndex, int newIndex, SeedModel seed) {
    final int index = newIndex > oldIndex ? newIndex - 1 : newIndex;
    List<SeedModel> temporaryState = [...state];
    temporaryState.removeAt(oldIndex);
    temporaryState.insert(index, seed);
    state = temporaryState;
    SeedModel.saveSeeds(state);
    printSeeds();
  }

  void removeSeed(SeedModel seed) {
    state = state.where((element) => element != seed).toList();
    SeedModel.saveSeeds(state);
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

  static Map<String, dynamic>toMap(SeedModel seedModel) => {
    SeedModelStrings.seed: seedModel.seed,
    SeedModelStrings.title: seedModel.title
  };

  factory SeedModel.fromJson(Map<String, dynamic> jsonData){
    return SeedModel(
      seed: jsonData[SeedModelStrings.seed]!,
      title: jsonData[SeedModelStrings.title]!
    );
  }

  static List<SeedModel> getSeedModelList(List<Map<String,dynamic>> jsonData) {
    List<SeedModel> seedsList = [];
    for (Map<String,dynamic> element in jsonData) {
      seedsList.add(SeedModel.fromJson(element));
    }
    return seedsList;
  }

  static List<String> getSeedMapStringList(List<SeedModel> seedModelData) {
    List<String> seedsMapList = [];
    for (SeedModel element in seedModelData) {
      seedsMapList.add(jsonEncode(SeedModel.toMap(element)));
    }
    return seedsMapList;
  }

  static Future<List<SeedModel>> loadSavedSeeds() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? mapList = prefs.getStringList(SharedPreferencesStrings.savedSeeds);
    List<Map<String, dynamic>> seedModelMapList = [];
    for (String element in mapList ?? []) {
      seedModelMapList.add(jsonDecode(element));
    }
    return getSeedModelList(seedModelMapList);
  }

  static void saveSeeds(List<SeedModel> seedModelList) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList(SharedPreferencesStrings.savedSeeds, getSeedMapStringList(seedModelList));
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