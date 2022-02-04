import 'package:flutter/material.dart';
import 'package:otp_generator/widgets/app_bar_widget.dart';
import 'package:otp_generator/widgets/floating_action_button_widget.dart';
import 'package:otp_generator/widgets/list_view_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("home was rebuilt");
    return const SafeArea(
      child: Scaffold(
        appBar: AppBarWidget(),
        body: ListViewWidget(),
        floatingActionButton: FloatingActionButtonWidget(),
      ),
    );
  }
}