import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import 'package:naya_menu/theme/app_theme.dart'; // Your custom theme

import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class PhoneNumberInput extends StatefulWidget {
  final TextEditingController controller;
  final TextEditingController countryCodeController;
  final String? Function(String?)? validator;

  const PhoneNumberInput({
    required this.controller,
    required this.countryCodeController,
    this.validator,
    Key? key,
  }) : super(key: key);

  @override
  _PhoneNumberInputState createState() => _PhoneNumberInputState();
}

class _PhoneNumberInputState extends State<PhoneNumberInput> {
  @override
  void initState() {
    super.initState();
    // Initialize the phone number field with the country code
    widget.controller.text = '${widget.countryCodeController.text} ';
  }

  @override
  Widget build(BuildContext context) {
    final inputDecoration = InputDecoration(
      border: AppTheme.inputDecorationTheme.border,
      focusedBorder: AppTheme.inputDecorationTheme.focusedBorder,
      enabledBorder: AppTheme.inputDecorationTheme.enabledBorder,
      contentPadding: AppTheme.inputDecorationTheme.contentPadding ??
          const EdgeInsets.all(10.0),
      hintText: 'Enter your phone number',
      hintStyle: AppTheme.inputDecorationTheme.hintStyle ??
          const TextStyle(fontSize: 14.0),
      filled: AppTheme.inputDecorationTheme.filled ?? true,
      fillColor: AppTheme.inputDecorationTheme.fillColor ?? Colors.blue.shade50,
    );

    return TextFormField(
      controller: widget.controller,
      keyboardType: TextInputType.phone,
      decoration: inputDecoration,
      validator: widget.validator,
      onChanged: (value) {
        // Ensure the country code stays at the beginning without repetition
        if (!value.startsWith(widget.countryCodeController.text)) {
          final newText =
              '${widget.countryCodeController.text} ${value.replaceAll(widget.countryCodeController.text, '').trim()}';
          widget.controller.value = TextEditingValue(
            text: newText,
            selection: TextSelection.fromPosition(
              TextPosition(offset: newText.length),
            ),
          );
        }
      },
    );
  }
}
