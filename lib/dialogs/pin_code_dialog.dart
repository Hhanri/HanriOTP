import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:otp_generator/models/security_model.dart';
import 'package:otp_generator/providers/providers.dart';
import 'package:otp_generator/resources/strings.dart';
import 'package:otp_generator/widgets/cancel_button_widget.dart';
import 'package:otp_generator/widgets/validate_button_widget.dart';
import 'package:flutter/services.dart';

class PinCodeDialog {

  static void showPinCodeDialog({required BuildContext context}) {
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return const PinCodeAlertDialog();
      }
    );
  }

}

class PinCodeAlertDialog extends ConsumerStatefulWidget {
  const PinCodeAlertDialog({Key? key}) : super(key: key);

  @override
  _PinCodeAlertDialogState createState() => _PinCodeAlertDialogState();
}

class _PinCodeAlertDialogState extends ConsumerState<PinCodeAlertDialog> {
  final List<SecurityModel> values = SecurityModel.features;
  SecurityModel selectedValue = SecurityModel.noneModel;
  String password = "";
  String confirmedPassword = "";
  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    return AlertDialog(
      title: const Text(TitleStrings.security),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
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
                PasswordTextFieldDialogWidget(
                  hintText: TitleStrings.password,
                  onChange: (value) {
                    password = value;
                  },
                  isEnabled: selectedValue == values[0] ? false : true,
                  validator: (value) {
                    if (password != confirmedPassword) {
                      return SystemStrings.passwordsNotMatching;
                    } else {
                      return null;
                    }
                  },
                ),
                PasswordTextFieldDialogWidget(
                  hintText: TitleStrings.confirmPassword,
                  onChange: (value) {
                    confirmedPassword = value;
                  },
                  isEnabled: selectedValue == values[0] ? false : true,
                  validator: (value) {
                    if (password != confirmedPassword) {
                      return SystemStrings.passwordsNotMatching;
                    } else {
                      return null;
                    }
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
              text: SystemStrings.save,
              onValidate: () {
                if (selectedValue == SecurityModel.noneModel) {
                  ref.watch(pinCodeProvider.notifier).resetPassword();
                  Navigator.of(context).pop();
                } else if (selectedValue == SecurityModel.pinCodeModel) {
                  if (_formKey.currentState!.validate() && password.isNotEmpty && confirmedPassword.isNotEmpty) {
                    print(selectedValue);
                    ref.watch(pinCodeProvider.notifier).changePassword(password);
                    Navigator.of(context).pop();
                  }
                }
              }
            );
          }
        )
      ],
    );
  }
}

class PasswordTextFieldDialogWidget extends StatefulWidget {
  final bool isEnabled;
  final String hintText;
  final Function(String) validator;
  final Function(String) onChange;
  const PasswordTextFieldDialogWidget({
    Key? key,
    required this.isEnabled,
    required this.hintText,
    required this.validator,
    required this.onChange
  }) : super(key: key);

  @override
  State<PasswordTextFieldDialogWidget> createState() => _PasswordTextFieldDialogWidgetState();
}

class _PasswordTextFieldDialogWidgetState extends State<PasswordTextFieldDialogWidget> {
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
        String? response = widget.validator(value!);
        return response;
      },
      keyboardType: TextInputType.number,
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
          currentValue = widget.selectedValue;
        });
      },
      title: Text(widget.value.title),
    );
  }
}