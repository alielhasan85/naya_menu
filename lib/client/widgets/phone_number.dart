import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import 'package:naya_menu/theme/app_theme.dart'; // Your custom theme

class PhoneNumberInput extends StatefulWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const PhoneNumberInput({required this.controller, this.validator, Key? key})
      : super(key: key);

  @override
  _PhoneNumberInputState createState() => _PhoneNumberInputState();
}

class _PhoneNumberInputState extends State<PhoneNumberInput> {
  String selectedCountryCode = '+1'; // Default to US
  String selectedFlagEmoji = '🇺🇸'; // Default to US flag

  void _openCountryPickerDialog(BuildContext context) {
    showCountryPicker(
      context: context,
      showPhoneCode: true, // Show phone code alongside country name
      onSelect: (Country country) {
        setState(() {
          selectedCountryCode = '+${country.phoneCode}';
          selectedFlagEmoji = country.flagEmoji; // Set the selected flag emoji
        });
        widget.controller.text =
            '$selectedCountryCode '; // Initialize with country code
      },
    );
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

    return Row(
      children: [
        GestureDetector(
          onTap: () => _openCountryPickerDialog(context),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(
                color: AppTheme.inputDecorationTheme.border!.borderSide.color,
                width: AppTheme.inputDecorationTheme.border!.borderSide.width,
              ),
              borderRadius: BorderRadius.circular(12),
              color: AppTheme.inputDecorationTheme.fillColor ??
                  Colors.blue.shade50,
            ),
            child: Row(
              children: [
                Text(
                  '$selectedFlagEmoji $selectedCountryCode',
                  style: TextStyle(fontSize: 16),
                ),
                Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: TextFormField(
            controller: widget.controller,
            keyboardType: TextInputType.phone,
            decoration: inputDecoration,
            validator: widget.validator,
          ),
        ),
      ],
    );
  }
}
