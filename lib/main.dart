import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otp_generator/pages/home_page.dart';
import 'package:otp_generator/ticker.dart';
import 'package:otp_generator/timer_bloc/timer_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OTP Generator',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
        create: (context) => TimerBloc(ticker: Ticker()),
        child: const HomeScreen(),
      ),
    );
  }
}

