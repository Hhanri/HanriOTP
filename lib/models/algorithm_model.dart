import 'package:otp/otp.dart';

class AlgorithmModel {
  static const List<Algorithm> algorithms = [
    Algorithm.SHA1,
    Algorithm.SHA256,
    Algorithm.SHA512
  ];

  static Algorithm getAlgorithm(String name) {
    return AlgorithmModel.algorithms.singleWhere((element) => element.name == name);
  }

  static const Algorithm defaultAlgo = Algorithm.SHA1;

  static String defaultAlgoTitle = "${Algorithm.SHA1.name} (default)";
}