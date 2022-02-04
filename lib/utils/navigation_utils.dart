import 'package:base32/encodings.dart';
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
      content: Form(
        key: _formKey,
        child: IntrinsicHeight(
          child: Column(
            children: [
              TextFormFieldWidget(
                field: _description,
                fieldTitle: "Description",
                valueChanged: (value) {
                  _description = value;
                  print(_description);
                }, type: '',
              ),
              TextFormFieldWidget(
                field: _seed,
                fieldTitle: "Seed",
                valueChanged: (value) {
                  _seed = value;
                }, type: 'seed',
              ),
            ],
          ),
        ),
      ),
      actions: [
        Consumer(
          builder: (context, watch, child) {
            return ValidateButtonWidget(
              onValidate: () {
                if (_formKey.currentState!.validate()) {
                  print("Seed: $_seed ,description: $_description");
                  watch.watch(seedsProvider.notifier).addSeed(SeedModel(seed: _seed, title: _description));
                  _seed = "";
                  _description = "";
                  Navigator.of(context).pop();
                }
              },
            );
          }
        )
      ],
    );
  }
}

class ValidateButtonWidget extends StatelessWidget {
  final VoidCallback onValidate;
  const ValidateButtonWidget({
    Key? key,
    required this.onValidate,
  }) :  super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        onValidate();
      },
      child: const Text("Add")
    );
  }
}

class TextFormFieldWidget extends StatelessWidget {
  String field;
  final String fieldTitle;
  final ValueChanged valueChanged;
  final String type;
  TextFormFieldWidget({
    Key? key,
    required this.field,
    required this.fieldTitle,
    required this.valueChanged,
    required this.type
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Text(fieldTitle)
        ),
        Expanded(
          child: TextFormField(
            onChanged: (value) {
              valueChanged(value);
            },
            validator: (String? value) {
              if (value == null || value == "") {
                return "Fill this field";
              }
              if (type == "seed") {
                if (value.length % 2 != 0 || !EncodingUtils.getRegex(Encoding.standardRFC4648).hasMatch(value)){
                  return "Wrong Code";
                } else {
                  return null;
                }
              }
               else {
                return null;
              }
            },
          ),
        )
      ],
    );
  }
}