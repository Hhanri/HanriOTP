import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:otp_generator/models/security_model.dart';
import 'package:otp_generator/resources/strings.dart';
import 'package:otp_generator/widgets/cancel_button_widget.dart';
import 'package:otp_generator/widgets/validate_button_widget.dart';
import 'package:flutter/services.dart';

class PinCodeAlertDialog extends StatefulWidget {
  const PinCodeAlertDialog({Key? key}) : super(key: key);

  @override
  State<PinCodeAlertDialog> createState() => _PinCodeAlertDialogState();
}

class _PinCodeAlertDialogState extends State<PinCodeAlertDialog> {
  @override
  Widget build(BuildContext context) {
    final List<SecurityModel> values = SecurityModel.features;
    SecurityModel selectedValue = values[0];
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    String password = "";
    String confirmedPassword = "";
    return AlertDialog(
      title: const Text(TitleStrings.security),
      content: Form(
        key: _formKey,
        child: IntrinsicHeight(
          child: Column(
            children: [
              ...List.generate(values.length, (index) {
                return SelectableSetting(
                  value: values[index],
                  selectedValue: selectedValue,
                  onChange: (value) {
                    setState(() {
                      selectedValue = value;
                    });
                  },
                );
              }),
              PasswordTextFieldWidget(
                hintText: TitleStrings.password,
                otherField: confirmedPassword,
                thisField: password,
                onChange: (value) {
                  password = value;
                },
                isEnabled: selectedValue == values[0] ? false : true
              ),
              PasswordTextFieldWidget(
                hintText: TitleStrings.confirmPassword,
                otherField: password,
                thisField: confirmedPassword,
                onChange: (value) {
                  confirmedPassword = value;
                },
                isEnabled: selectedValue == values[0] ? false : true
              )
            ],
          ),
        ),
      ),
      actions: [
        const CancelButtonWidget(),
        Consumer(
          builder: (BuildContext context, WidgetRef ref, Widget? child) {
            return ValidateButtonWidget(
              text: SystemStrings.save,
              onValidate: () {
                if (_formKey.currentState!.validate()) {
                  print(selectedValue);
                }
              }
            );
          }
        )
      ],
    );
  }
}

class PasswordTextFieldWidget extends StatefulWidget {
  final bool isEnabled;
  final String hintText;
  final String otherField;
  final String thisField;
  final Function(String) onChange;
  const PasswordTextFieldWidget({
    Key? key,
    required this.hintText,
    required this.otherField,
    required this.thisField,
    required this.onChange,
    required this.isEnabled
  }) : super(key: key);

  @override
  State<PasswordTextFieldWidget> createState() => _PasswordTextFieldWidgetState();
}

class _PasswordTextFieldWidgetState extends State<PasswordTextFieldWidget> {
  bool isHidden = true;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enableSuggestions: false,
      enabled: widget.isEnabled,
      decoration: InputDecoration(
        hintText: widget.hintText,
        icon: IconButton(
          icon: Icon(isHidden ? Icons.visibility : Icons.visibility_off),
          onPressed: () {
            setState(() {
              isHidden = !isHidden;
            });
          },
        )
      ),
      obscureText: isHidden,
      onChanged: (value) {
        widget.onChange(value);
      },
      validator: (value) {
        if (widget.otherField != widget.thisField) {
          return SystemStrings.passwordsNotMatching;
        } else {
          return null;
        }
      },
      keyboardType: const TextInputType.numberWithOptions(),
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
    );
  }
}

class SelectableSetting extends StatefulWidget {
  final SecurityModel value;
  final SecurityModel selectedValue;
  final Function(SecurityModel) onChange;
  const SelectableSetting({
    Key? key,
    required this.value,
    required this.selectedValue,
    required this.onChange
  }) : super(key: key);

  @override
  State<SelectableSetting> createState() => _SelectableSettingState();
}

class _SelectableSettingState extends State<SelectableSetting> {
  SecurityModel? currentValue;
  @override
  Widget build(BuildContext context) {
    return RadioListTile<SecurityModel>(
      value: currentValue == null ? widget.value : currentValue!,
      groupValue: widget.selectedValue,
      onChanged: (value) {
        widget.onChange(value!);
        setState(() {
          currentValue = value;
        });
      },
      title: Text(widget.value.title),
    );
  }
}