import 'package:base32/encodings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:otp/otp.dart';
import 'package:otp_generator/models/algorithm_model.dart';
import 'package:otp_generator/models/seed_model.dart';
import 'package:otp_generator/providers/providers.dart';
import 'package:otp_generator/resources/strings.dart';
import 'package:otp_generator/utils/app_config.dart';
import 'package:otp_generator/utils/snackbar_utils.dart';
import 'package:otp_generator/widgets/validate_button_widget.dart';

class AddAndEditSeedDialog {
  static void showAddAndEditSeedDialog({required BuildContext context, required SeedModel previousSeed, required bool adding}) {
    FocusScope.of(context).unfocus();
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return AddAndEditSeedAlertDialog(previousSeed: previousSeed, adding: adding,);
      },
    );
  }
}

class AddAndEditSeedAlertDialog extends StatelessWidget {
  final SeedModel previousSeed;
  final bool adding;
  const AddAndEditSeedAlertDialog({
    Key? key,
    required this.previousSeed,
    required this.adding
  }) : super(key: key);
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    TextEditingController _seedController = TextEditingController()..text = previousSeed.seed;
    TextEditingController _titleController = TextEditingController()..text = Uri.decodeQueryComponent(previousSeed.title);
    Algorithm _algorithm = previousSeed.algorithm;
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        return AlertDialog(
          title: Text(adding ? TitleStrings.addSeed : TitleStrings.editSeed),
          content: Form(
            key: _formKey,
            child: SizedBox(
              width: AppConfig.screenWidth(context),
              child: SingleChildScrollView(
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      AddAndEditSeedTextFormFieldWidget(
                        controller: _titleController,
                        fieldTitle: TitleStrings.description,
                        isBase32: false,
                      ),
                      AddAndEditSeedTextFormFieldWidget(
                        controller: _seedController,
                        fieldTitle: TitleStrings.seed,
                        isBase32: true,
                      ),
                      SelectAlgorithmRowWidget(
                        onChange: (value) {
                          _algorithm = value;
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
            ValidateButtonWidget(
              text: adding ? SystemStrings.add : SystemStrings.edit,
              onValidate: () {
                if (_formKey.currentState!.validate()) {
                  final SeedModel newSeed = SeedModel(seed: _seedController.text, title: Uri.encodeQueryComponent(_titleController.text), algorithm: _algorithm);
                  Navigator.of(context).pop();
                  if (!ref.watch(seedsProvider).contains(newSeed)) {
                    if (adding) {
                      ref.watch(seedsProvider.notifier).addSeed(newSeed);
                    } else {
                      ref.watch(seedsProvider.notifier).editSeed(previousSeed, newSeed);
                    }
                  } else {
                    SnackBarUtils.alreadyExistsSnackBar(context);
                  }
                }
              },
            )
          ],
        );
      }
    );
  }
}

class AddAndEditSeedTextFormFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String fieldTitle;
  final bool isBase32;
  AddAndEditSeedTextFormFieldWidget({
    Key? key,
    required this.fieldTitle,
    required this.isBase32,
    required this.controller,
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
            controller: controller,
            textAlign: TextAlign.end,
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
        AlgorithmDropDownMenuWidget(
          onChange: (value) {
            onChange(value);
          },
          initialAlgo: initialAlgo,
        )
      ],
    );
  }
}


class AlgorithmDropDownMenuWidget extends StatefulWidget {
  final Algorithm initialAlgo;
  final Function(Algorithm) onChange;
  const AlgorithmDropDownMenuWidget({
    Key? key,
    required this.onChange,
    required this.initialAlgo,
  }) : super(key: key);

  @override
  State<AlgorithmDropDownMenuWidget> createState() => _AlgorithmDropDownMenuWidgetState();
}

class _AlgorithmDropDownMenuWidgetState extends State<AlgorithmDropDownMenuWidget> {
  late Algorithm _selectedAlgo;
  @override
  void initState() {
    _selectedAlgo = widget.initialAlgo;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return DropdownButton<Algorithm>(
      elevation: 0,
      alignment: Alignment.centerRight,
      items: AlgorithmModel.algorithms.map(buildItem).toList(),
      value: _selectedAlgo,
      onChanged: (value) {
        setState(() {
          _selectedAlgo = value!;
        });
        widget.onChange(_selectedAlgo);
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
