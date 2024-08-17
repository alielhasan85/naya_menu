import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:naya_menu/theme/app_theme.dart'; // Import your AppTheme

class PhoneNumberInput extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(PhoneNumber?)? validator; // Adjusted the type

  const PhoneNumberInput({required this.controller, this.validator, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final inputDecoration = InputDecoration(
      border: AppTheme.inputDecorationTheme.border,
      focusedBorder: AppTheme.inputDecorationTheme.focusedBorder,
      enabledBorder: AppTheme.inputDecorationTheme.enabledBorder,
      contentPadding: AppTheme.inputDecorationTheme.contentPadding ??
          const EdgeInsets.all(10.0),
      isCollapsed: true,
      hintText: 'Enter your phone number', // Customize the hint text as needed
      hintStyle: AppTheme.inputDecorationTheme.hintStyle ??
          const TextStyle(fontSize: 14.0),
      filled: AppTheme.inputDecorationTheme.filled ?? true,
      fillColor: AppTheme.inputDecorationTheme.fillColor ?? Colors.blue.shade50,
    );

    return SizedBox(
      width: 500,
      child: IntlPhoneField(
        controller: controller,
        decoration: inputDecoration,
        style: TextStyle(fontSize: 15.0),
        initialCountryCode: 'US', // Set your default country code
        onChanged: (phone) {
          // Handle phone number changes if needed
        },
        onSaved: (phone) {
          controller.text = phone?.completeNumber ?? '';
        },
        validator: validator,
        disableLengthCheck: true, // Use the provided validator
      ),
    );
  }
}
