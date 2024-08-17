import 'package:flutter/material.dart';
import 'package:naya_menu/theme/app_theme.dart'; // Import your AppTheme

//input field flexible to use in all the app

class InputField extends StatelessWidget {
  final String? label; // Made label optional
  final String hintText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextCapitalization textCapitalization;
  final bool labelAboveField; // Property to control label position

  InputField({
    this.label, // Label is now optional
    required this.hintText,
    required this.controller,
    this.validator,
    this.onChanged,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.textCapitalization = TextCapitalization.none,
    this.labelAboveField =
        false, // Default value is false (label on the same row)
  });

  @override
  Widget build(BuildContext context) {
    // Use the theme's input decoration theme
    final inputDecoration = InputDecoration(
      border: AppTheme.inputDecorationTheme.border,
      focusedBorder: AppTheme.inputDecorationTheme.focusedBorder,
      enabledBorder: AppTheme.inputDecorationTheme.enabledBorder,
      contentPadding: AppTheme.inputDecorationTheme.contentPadding ??
          const EdgeInsets.all(10.0),
      hintText: hintText,
      hintStyle: AppTheme.inputDecorationTheme.hintStyle ??
          const TextStyle(fontSize: 14.0),
      filled: AppTheme.inputDecorationTheme.filled ?? true,
      fillColor: AppTheme.inputDecorationTheme.fillColor ?? Colors.blue.shade50,
    );

    return labelAboveField
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (label != null && label!.isNotEmpty)
                Text(
                  label!,
                  textAlign: TextAlign.left,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium, // Use theme text style
                ),
              if (label != null && label!.isNotEmpty)
                const SizedBox(height: 8.0),
              TextFormField(
                controller: controller,
                keyboardType: keyboardType,
                textCapitalization: textCapitalization,
                style: const TextStyle(fontSize: 15.0),
                decoration: inputDecoration,
                validator: validator,
                onChanged: onChanged,
                obscureText: obscureText,
              ),
            ],
          )
        : Row(
            children: <Widget>[
              if (label != null && label!.isNotEmpty)
                SizedBox(
                  width: 100.0,
                  child: Text(
                    label!,
                    textAlign: TextAlign.left,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium, // Use theme text style
                  ),
                ),
              if (label != null && label!.isNotEmpty)
                const SizedBox(
                  width: 10.0,
                ),
              Expanded(
                child: TextFormField(
                  controller: controller,
                  keyboardType: keyboardType,
                  textCapitalization: textCapitalization,
                  style: const TextStyle(fontSize: 15.0),
                  decoration: inputDecoration,
                  validator: validator,
                  onChanged: onChanged,
                  obscureText: obscureText,
                ),
              ),
            ],
          );
  }
}
