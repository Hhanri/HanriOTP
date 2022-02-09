import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:otp_generator/models/seed_model.dart';

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

  void importJson(List jsonData, BuildContext context) async {
    List<String> mapList = jsonData.cast<String>();
    List<Map<String, dynamic>> seedModelMapList = [];
    try {
      for (String element in mapList) {
        seedModelMapList.add(jsonDecode(element));
      }
      if (seedModelMapList.isNotEmpty) {
        state = SeedModel.getSeedModelList(seedModelMapList);
        SeedModel.saveSeeds(state);
      }
    } catch(e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("An error has occurred")));
    }
  }

  void editSeed(SeedModel oldSeed, SeedModel newSeed) {
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

  void resetSeeds() {
    state = [];
  }

  void printSeeds() {
    for (var element in state) {
      print(element.title);
    }
  }
}