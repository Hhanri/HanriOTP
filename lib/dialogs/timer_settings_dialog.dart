import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:otp_generator/models/timer_settings_model.dart';
import 'package:otp_generator/resources/strings.dart';
import 'package:otp_generator/widgets/cancel_button_widget.dart';
import 'package:otp_generator/widgets/validate_button_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:otp_generator/providers/providers.dart';

class TimerSettingsDialog {
  static void showTimerSettingsDialog({required BuildContext context}) {
    FocusScope.of(context).unfocus();
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return const TimerSettingsAlertDialog();
      },
    );
  }
}

class TimerSettingsAlertDialog extends ConsumerStatefulWidget {
  const TimerSettingsAlertDialog({Key? key}) : super(key: key);

  @override
  _TimerSettingsAlertDialogState createState() => _TimerSettingsAlertDialogState();
}

class _TimerSettingsAlertDialogState extends ConsumerState<TimerSettingsAlertDialog> {
  final List<TimerSettingsModel> values = TimerSettingsModel.timers;
  TimerSettingsModel selectedValue = TimerSettingsModel.timer30;
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
                  return TimerSelectableSetting(
                    value: values[index],
                    selectedValue: selectedValue,
                    onChange: (value) {
                      setState(() {
                        selectedValue = value;
                      });
                    },
                  );
                }),

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
              onValidate: () async{
                final SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setInt(SharedPreferencesStrings.savedTimer, selectedValue.timer);
                ref.watch(timerProvider.notifier).start();
                Navigator.of(context).pop();
              }
            );
          }
        )
      ],
    );
  }
}

class TimerSelectableSetting extends StatefulWidget {
  final TimerSettingsModel value;
  final TimerSettingsModel selectedValue;
  final Function(TimerSettingsModel) onChange;
  const TimerSelectableSetting({
    Key? key,
    required this.value,
    required this.selectedValue,
    required this.onChange
  }) : super(key: key);

  @override
  State<TimerSelectableSetting> createState() => _TimerSelectableSettingState();
}

class _TimerSelectableSettingState extends State<TimerSelectableSetting> {
  TimerSettingsModel? currentValue;
  @override
  Widget build(BuildContext context) {
    return RadioListTile<TimerSettingsModel>(
      value: currentValue == null ? widget.value : currentValue!,
      groupValue: widget.selectedValue,
      onChanged: (value) {
        widget.onChange(value!);
        setState(() {
          currentValue = widget.selectedValue;
        });
      },
      title: Text("${widget.value.timer} seconds"),
    );
  }
}
