import 'dart:async';

import 'package:flutter/material.dart';
import 'package:otp/otp.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

String getOTPCode(){
  return OTP.generateTOTPCodeString("JBSWY3DPEHPK3PXP", DateTime.now().millisecondsSinceEpoch, algorithm: Algorithm.SHA1, interval: 30, isGoogle: true);
}

int getRemainingTime() {
  return 30 - (DateTime.now().millisecondsSinceEpoch ~/ Duration.millisecondsPerSecond)%30;
}
class _MyHomePageState extends State<MyHomePage> {

  Timer? timer;
  int remainingTime = getRemainingTime();
  String code = getOTPCode();
  @override
  void initState() {
    code = OTP.generateTOTPCodeString("JBSWY3DPEHPK3PXP", DateTime.now().millisecondsSinceEpoch, algorithm: Algorithm.SHA1, interval: 30, isGoogle: true);
    remainingTime = OTP.remainingSeconds(interval: 30);
    super.initState();
    startTimer();
  }
  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      getCurrentTimer();
    });
  }
  void getCurrentTimer() {
    setState(() {
      code = getOTPCode();
      remainingTime = getRemainingTime();
      print(remainingTime);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(code),
            Text(remainingTime.toString()),
            TextButton(
              onPressed: () {
                String tempCode = getOTPCode();
                setState(() {
                  code = tempCode;
                });
              },
              child: const Text(
                "generate code"
              )
            ),
          ],
        ),
      ),
    );
  }
}
