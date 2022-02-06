import 'package:base32/encodings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:otp_generator/providers/providers.dart';
import 'package:otp_generator/providers/seeds_notifier.dart';
import 'package:otp_generator/resources/strings.dart';

class AddSeedDialog {

  static void showAddSeedDialog({required BuildContext context}) {
    FocusScope.of(context).unfocus();
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
    String _title = "";
    return AlertDialog(
      title: const Text(TitleStrings.addSeed),
      content: Form(
        key: _formKey,
        child: IntrinsicHeight(
          child: Column(
            children: [
              AddSeedTextFormFieldWidget(
                field: _title,
                fieldTitle: TitleStrings.description,
                valueChanged: (value) {
                  _title = value;
                  print(_title);
                },
                isBase32: false,
              ),
              AddSeedTextFormFieldWidget(
                field: _seed,
                fieldTitle: TitleStrings.seed,
                valueChanged: (value) {
                  _seed = value;
                }, isBase32: true,
              ),
            ],
          ),
        ),
      ),
      actions: [
        Consumer(
          builder: (BuildContext context, WidgetRef ref, Widget? child) {
            return ValidateButtonWidget(
              onValidate: () {
                if (_formKey.currentState!.validate()) {
                  print("Seed: $_seed ,description: $_title");
                  ref.watch(seedsProvider.notifier).addSeed(SeedModel(seed: _seed, title: _title));
                  _seed = "";
                  _title = "";
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
      child: const Text(SystemStrings.add)
    );
  }
}

class AddSeedTextFormFieldWidget extends StatelessWidget {
  String field;
  final String fieldTitle;
  final ValueChanged valueChanged;
  final bool isBase32;
  AddSeedTextFormFieldWidget({
    Key? key,
    required this.field,
    required this.fieldTitle,
    required this.valueChanged,
    required this.isBase32
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
            textAlign: TextAlign.end,
            onChanged: (value) {
              valueChanged(value);
            },
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return SystemStrings.emptyField;
              }
              if (isBase32) {
                if (value.length % 2 != 0 || !EncodingUtils.getRegex(Encoding.standardRFC4648).hasMatch(value)){
                  return SystemStrings.wrongCodeFormat;
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
