import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:otp_generator/providers/providers.dart';
import 'package:otp_generator/resources/strings.dart';
import 'package:otp_generator/utils/khazix.dart';
import 'package:otp_generator/utils/route_generator.dart';
import 'package:otp_generator/widgets/simple_app_bar_widget.dart';
import 'package:otp_generator/widgets/validate_button_widget.dart';

class PinCodeScreen extends StatelessWidget {
  PinCodeScreen({Key? key}) : super(key: key);
  String password = "";
  @override
  Widget build(BuildContext context) {
    final FocusNode _focusNode = FocusNode();
    _focusNode.requestFocus();
    return Scaffold(
      appBar: const SimpleAppBarWidget(title: SystemStrings.appTitle,),
      body: Center(
        child: SingleChildScrollView(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(flex: 1,),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(SystemStrings.enterYourPINCode),
                    PasswordTextFieldPageWidget(
                      focusNode: _focusNode,
                      onChange: (value) {
                        password = value;
                      }
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Consumer(
                          builder: (BuildContext context, WidgetRef ref, Widget? child) {
                            final String khazix = ref.watch(pinCodeProvider);
                            return ValidateButtonWidget(
                              text: TitleStrings.unlock,
                              onValidate: () {
                                if (password == Khazix.decryptPin(encrypt.Encrypted.from64(khazix))) {
                                  Navigator.of(context).pushReplacementNamed(homePage);
                                } else {
                                  SystemNavigator.pop();
                                }
                              },
                            );
                          }
                        )
                      ],
                    )
                  ],
                ),
              ),
              const Spacer(flex: 1,)
            ]
          ),
        ),
      ),
    );
  }
}

class PasswordTextFieldPageWidget extends StatelessWidget {
  final FocusNode focusNode;
  final Function(String) onChange;
  const PasswordTextFieldPageWidget({
    Key? key,
    required this.focusNode,
    required this.onChange
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: focusNode,
      autocorrect: false,
      textAlign: TextAlign.center,
      obscureText: true,
      onChanged: (value) {
        onChange(value);
      },
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
    );
  }
}
