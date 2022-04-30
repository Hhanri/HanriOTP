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
    FocusScope.of(context).unfocus();
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
  final List<SecurityPinCodeModel> values = SecurityPinCodeModel.features;
  SecurityPinCodeModel selectedValue = SecurityPinCodeModel.noneModel;
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
                  return PinCodeSelectableSetting(
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
                if (selectedValue == SecurityPinCodeModel.noneModel) {
                  ref.watch(pinCodeProvider.notifier).resetPassword();
                  Navigator.of(context).pop();
                } else if (selectedValue == SecurityPinCodeModel.pinCodeModel) {
                  if (_formKey.currentState!.validate() && password.isNotEmpty && confirmedPassword.isNotEmpty) {
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

class PinCodeSelectableSetting extends StatefulWidget {
  final SecurityPinCodeModel value;
  final SecurityPinCodeModel selectedValue;
  final Function(SecurityPinCodeModel) onChange;
  const PinCodeSelectableSetting({
    Key? key,
    required this.value,
    required this.selectedValue,
    required this.onChange
  }) : super(key: key);

  @override
  State<PinCodeSelectableSetting> createState() => _PinCodeSelectableSettingState();
}

class _PinCodeSelectableSettingState extends State<PinCodeSelectableSetting> {
  SecurityPinCodeModel? currentValue;
  @override
  Widget build(BuildContext context) {
    return RadioListTile<SecurityPinCodeModel>(
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