import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otp_generator/timer_bloc/timer_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: BlocConsumer<TimerBloc, TimerState>(
            listener: (context, state){
              if (state.duration == 30) {
                BlocProvider.of<TimerBloc>(context).add(Refresh());
              }
            },
            builder: (context, state) {
              String remainingTime = state.duration.toString();
              List<String> _seeds = BlocProvider.of<TimerBloc>(context).seeds;
              List<String> _codes = BlocProvider.of<TimerBloc>(context).codes;
              if (_seeds.isEmpty) {
                return const Center(child: Text('add your codes'),);
              }
              if (state is TimerRunningState && _codes.isNotEmpty) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BlocBuilder<TimerBloc, TimerState>(
                      builder: (context, state) {
                        return Text('${state.duration}');
                      },
                    ),
                    ...List.generate(
                      _seeds.length,
                      (index) => Text(_codes[index])
                    )
                  ],
                );
              }
              return const Center(child: CircularProgressIndicator());
            },
          )
        ),
      ),
    );
  }
}
