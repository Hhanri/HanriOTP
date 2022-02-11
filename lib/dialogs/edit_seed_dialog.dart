import 'package:base32/encodings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:otp/otp.dart';
import 'package:otp_generator/models/algorithm_model.dart';
import 'package:otp_generator/models/seed_model.dart';
import 'package:otp_generator/providers/providers.dart';
import 'package:otp_generator/resources/strings.dart';
import 'package:otp_generator/utils/app_config.dart';
import 'package:otp_generator/widgets/validate_button_widget.dart';

class EditSeedDialog {

  static void showEditSeedDialog({required BuildContext context, required SeedModel previousSeed}) {
    FocusScope.of(context).unfocus();
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return EditSeedAlertDialog(previousSeed: previousSeed,);
      },
    );
  }
}

class EditSeedAlertDialog extends StatelessWidget {
  final SeedModel previousSeed;
  const EditSeedAlertDialog({
    Key? key,
    required this.previousSeed
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    String _seed = previousSeed.seed;
    String _title = Uri.decodeQueryComponent(previousSeed.title);
    Algorithm _algorithm = previousSeed.algorithm;
    return AlertDialog(
      title: const Text(TitleStrings.addSeed),
      content: Form(
        key: _formKey,
        child: SizedBox(
          width: AppConfig.screenWidth(context),
          child: SingleChildScrollView(
            child: IntrinsicHeight(
              child: Column(
                children: [
                  EditSeedTextFormFieldWidget(
                    field: _title,
                    fieldTitle: TitleStrings.description,
                    valueChanged: (value) {
                      _title = value;
                      print(_title);
                    },
                    isBase32: false,
                    initialValue: _title,
                  ),
                  EditSeedTextFormFieldWidget(
                    field: _seed,
                    fieldTitle: TitleStrings.seed,
                    valueChanged: (value) {
                      _seed = value;
                    },
                    isBase32: true,
                    initialValue: _seed,
                  ),
                  SelectAlgorithmRowWidget(
                    onChange: (value) {
                      _algorithm = value;
                      print(_algorithm);
                    },
                    initialAlgo: _algorithm,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      actions: [
        Consumer(
          builder: (BuildContext context, WidgetRef ref, Widget? child) {
            return ValidateButtonWidget(
              text: SystemStrings.edit,
              onValidate: () {
                if (_formKey.currentState!.validate()) {
                  print("Seed: $_seed, description: $_title, $_algorithm");
                  ref.watch(seedsProvider.notifier).editSeed(previousSeed, SeedModel(seed: _seed, title: Uri.encodeQueryComponent(_title), algorithm: _algorithm));
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

class EditSeedTextFormFieldWidget extends StatelessWidget {
  String field;
  final String fieldTitle;
  final ValueChanged valueChanged;
  final bool isBase32;
  final String initialValue;
  EditSeedTextFormFieldWidget({
    Key? key,
    required this.field,
    required this.fieldTitle,
    required this.valueChanged,
    required this.isBase32,
    required this.initialValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(fieldTitle),
        Expanded(
          child: TextFormField(
            initialValue: initialValue,
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

class SelectAlgorithmRowWidget extends StatelessWidget {
  final Algorithm initialAlgo;
  final Function(Algorithm) onChange;
  const SelectAlgorithmRowWidget({
    Key? key,
    required this.onChange,
    required this.initialAlgo
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          TitleStrings.algorithm
        ),
        EditAlgorithmDropDownMenuWidget(
          onChange: (value) {
            onChange(value);
          },
          initialAlgo: initialAlgo,
        )
      ],
    );
  }
}


class EditAlgorithmDropDownMenuWidget extends StatefulWidget {
  final Algorithm initialAlgo;
  final Function(Algorithm) onChange;
  const EditAlgorithmDropDownMenuWidget({
    Key? key,
    required this.onChange,
    required this.initialAlgo,
  }) : super(key: key);

  @override
  State<EditAlgorithmDropDownMenuWidget> createState() => _EditAlgorithmDropDownMenuWidgetState();
}

class _EditAlgorithmDropDownMenuWidgetState extends State<EditAlgorithmDropDownMenuWidget> {
  Algorithm? _selectedAlgo;
  @override
  Widget build(BuildContext context) {
    print("dropdown menu rebuilt");
    return DropdownButton<Algorithm>(
      elevation: 0,
      alignment: Alignment.centerRight,
      items: AlgorithmModel.algorithms.map(buildItem).toList(),
      value: _selectedAlgo ?? widget.initialAlgo,
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
