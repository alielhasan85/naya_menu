import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import 'package:naya_menu/theme/app_theme.dart'; // Ensure this imports your theme

class PhoneNumberInput extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const PhoneNumberInput({required this.controller, this.validator, Key? key})
      : super(key: key);

  void _openCountryPickerDialog(BuildContext context) {
    showCountryPicker(
      context: context,
      showPhoneCode: true, // Show phone code alongside country name
      onSelect: (Country country) {
        controller.text = '+${country.phoneCode}'; // Set phone code
      },
      countryListTheme: CountryListThemeData(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
        inputDecoration: InputDecoration(
          hintText: 'Search your country',
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        searchTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 18,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Define InputDecoration based on your theme
    final inputDecoration = InputDecoration(
      border: AppTheme.inputDecorationTheme.border,
      focusedBorder: AppTheme.inputDecorationTheme.focusedBorder,
      enabledBorder: AppTheme.inputDecorationTheme.enabledBorder,
      contentPadding: AppTheme.inputDecorationTheme.contentPadding ??
          const EdgeInsets.all(10.0),
      hintText: 'Enter your phone number', // Customize the hint text as needed
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
                  controller.text.isNotEmpty ? controller.text : '+1',
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
            controller: controller,
            keyboardType: TextInputType.phone,
            decoration: inputDecoration,
            validator: validator,
          ),
        ),
      ],
    );
  }
}
