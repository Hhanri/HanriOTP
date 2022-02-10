import 'package:base32/encodings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:otp/otp.dart';
import 'package:otp_generator/models/algorithm_model.dart';
import 'package:otp_generator/models/seed_model.dart';
import 'package:otp_generator/providers/providers.dart';
import 'package:otp_generator/resources/strings.dart';
import 'package:otp_generator/widgets/cancel_button_widget.dart';
import 'package:otp_generator/widgets/validate_button_widget.dart';

class AddSeedDialog {

  static void showAddSeedDialog({required BuildContext context}) {
    FocusScope.of(context).unfocus();
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return const AddSeedAlertDialog();
      },
    );
  }
}

class AddSeedAlertDialog extends StatelessWidget {
  const AddSeedAlertDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    String _seed = "";
    String _title = "";
    Algorithm _algorithm = AlgorithmModel.defaultAlgo;
    return AlertDialog(
      title: const Text(TitleStrings.addSeed),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
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
                AddSelectAlgorithmRowWidget(
                  onChange: (value) {
                    _algorithm = value;
                    print(_algorithm);
                  },
                )
              ],
            ),
          ),
        ),
      ),
      actions: [
        const CancelButtonWidget(),
        Consumer(
          builder: (BuildContext context, WidgetRef ref, Widget? child) {
            return ValidateButtonWidget(
              text: SystemStrings.add,
              onValidate: () {
                if (_formKey.currentState!.validate()) {
                  print("Seed: $_seed, description: $_title, algo: $_algorithm");
                  ref.watch(seedsProvider.notifier).addSeed(SeedModel(seed: _seed, title: Uri.encodeQueryComponent(_title), algorithm: _algorithm));
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
            enableSuggestions: false,
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

class AddSelectAlgorithmRowWidget extends StatelessWidget {
  final Function(Algorithm) onChange;
  const AddSelectAlgorithmRowWidget({
    Key? key,
    required this.onChange
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Text(
                TitleStrings.algorithm
            )
        ),
        AlgorithmDropDownMenuWidget(
            onChange: (value) {
              onChange(value);
            }
        )
      ],
    );
  }
}


class AlgorithmDropDownMenuWidget extends StatefulWidget {
  final Function(Algorithm) onChange;
  const AlgorithmDropDownMenuWidget({
    Key? key,
    required this.onChange,
  }) : super(key: key);

  @override
  State<AlgorithmDropDownMenuWidget> createState() => _AlgorithmDropDownMenuWidgetState();
}

class _AlgorithmDropDownMenuWidgetState extends State<AlgorithmDropDownMenuWidget> {
  Algorithm? _selectedAlgo = AlgorithmModel.defaultAlgo;
  @override
  Widget build(BuildContext context) {
    print("dropdown menu rebuilt");
    return DropdownButton<Algorithm>(
      elevation: 0,
      alignment: Alignment.centerRight,
      items: AlgorithmModel.algorithms.map(buildItem).toList(),
      value: _selectedAlgo,
      onChanged: (value) {
        widget.onChange(value ?? AlgorithmModel.defaultAlgo);
        setState(() {
          _selectedAlgo = value;
        });
      },
    );
  }

  DropdownMenuItem<Algorithm> buildItem(Algorithm item) {
    return DropdownMenuItem<Algorithm>(
      value: item,
      child: Text(item == AlgorithmModel.defaultAlgo ? AlgorithmModel.defaultAlgoTitle : item.name),
    );
  }
}
