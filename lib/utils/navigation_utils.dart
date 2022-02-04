import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:otp_generator/providers/providers.dart';
import 'package:otp_generator/providers/seeds_notifier.dart';

class NavigationUtils {
  static void showAddSeedDialog({required BuildContext context}) {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return const AlertDialogWidget();
      },
    );
  }
}

class AlertDialogWidget extends StatelessWidget {
  const AlertDialogWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    String _seed = "";
    String _description = "";
    return AlertDialog(
      title: const Text("Add a Seed"),
      /*
      content: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormFieldWidget(
              field: _description,
              fieldTitle: "Description"
            ),
            TextFormFieldWidget(
              field: _seed,
              fieldTitle: "Seed"
            ),
          ],
        ),
      ),

       */
      actions: [
        ValidateButtonWidget(
          formKey: _formKey,
          seed: _seed,
          description: _description,
          clearOnValidate: () {
            _seed = "";
            _description = "";
          },
        )
      ],
    );
  }
}

class ValidateButtonWidget extends StatelessWidget {
  String seed;
  String description;
  final GlobalKey<FormState> formKey;
  final VoidCallback clearOnValidate;
  ValidateButtonWidget({
    Key? key,
    required this.seed,
    required this.description,
    required this.formKey,
    required this.clearOnValidate
  }) :  super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef watch, child) {
        return TextButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                print("Seed: $seed ,description: $description");
                watch.watch(seedsProvider.notifier).addSeed(SeedModel(seed: seed, title: description));
                clearOnValidate();
              }
            },
            child: const Text("Add")
        );
      },
    );
  }
}

class TextFormFieldWidget extends StatelessWidget {
  String field;
  final String fieldTitle;
  TextFormFieldWidget({
    Key? key,
    required this.field,
    required this.fieldTitle
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(fieldTitle),
        TextFormField(
          onChanged: (value) {
            field = value;
          },
          validator: (String? value) {
            if (value == null || value == "") {
              return "Fill this field";
            } else {
              return null;
            }
          },
        )
      ],
    );
  }
}
