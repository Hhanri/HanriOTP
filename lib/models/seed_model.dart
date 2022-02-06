import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:otp/otp.dart';
import 'package:otp_generator/resources/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SeedModel extends Equatable{
  final String seed;
  final String title;
  final Algorithm algorithm;
  const SeedModel({required this.seed, required this.title, required this.algorithm});

  static Map<String, dynamic> toMap(SeedModel seedModel) => {
    SeedModelStrings.seed: seedModel.seed,
    SeedModelStrings.title: seedModel.title,
    SeedModelStrings.algorithm: seedModel.algorithm
  };

  factory SeedModel.fromJson(Map<String, dynamic> jsonData){
    return SeedModel(
        seed: jsonData[SeedModelStrings.seed],
        title: jsonData[SeedModelStrings.title],
        algorithm: jsonData[SeedModelStrings.algorithm]
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

  static String getCode({required String seed,required  Algorithm algorithm}) {
    return OTP.generateTOTPCodeString(
        seed,
        DateTime.now().millisecondsSinceEpoch,
        isGoogle: true,
        algorithm: algorithm,
        interval: 30
    );
  }
  static List<String> getListCodes(List<SeedModel> seeds) {
    List<String> codesList = [];
    for (int i = 0; i < seeds.length; i++) {
      codesList.insert(i, getCode(seed: seeds[i].seed, algorithm: seeds[i].algorithm));
    }
    return codesList;
  }

  @override
  List<String> get props => [seed, title];
}