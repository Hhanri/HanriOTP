class Ticker {

  Stream<int> tick() {
    return Stream.periodic(const Duration(seconds: 1), (_) => getRemainingTime()).take(30);
  }

  static int getRemainingTime() {
    return 30 - (DateTime.now().millisecondsSinceEpoch ~/ Duration.millisecondsPerSecond)%30;
  }
}