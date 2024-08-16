import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class InputField extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextCapitalization textCapitalization;
  final bool labelAboveField; // New property to control label position

  InputField({
    required this.label,
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
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: HexColor('#69639f'), width: 2),
    );

    return labelAboveField
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                label,
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 8.0),
              TextFormField(
                controller: controller,
                keyboardType: keyboardType,
                textCapitalization: textCapitalization,
                style: const TextStyle(fontSize: 15.0),
                decoration: InputDecoration(
                  border: border,
                  focusedBorder: border,
                  enabledBorder: border,
                  contentPadding: const EdgeInsets.all(10.0),
                  hintText: hintText,
                  filled: true,
                  fillColor: Colors.blue.shade50,
                ),
                validator: validator,
                onChanged: onChanged,
                obscureText: obscureText,
              ),
            ],
          )
        : Row(
            children: <Widget>[
              SizedBox(
                width: 100.0,
                child: Text(
                  label,
                  textAlign: TextAlign.left,
                ),
              ),
              const SizedBox(
                width: 10.0,
              ),
              Expanded(
                child: TextFormField(
                  controller: controller,
                  keyboardType: keyboardType,
                  textCapitalization: textCapitalization,
                  style: const TextStyle(fontSize: 15.0),
                  decoration: InputDecoration(
                    border: border,
                    focusedBorder: border,
                    enabledBorder: border,
                    contentPadding: const EdgeInsets.all(10.0),
                    hintText: hintText,
                    filled: true,
                    fillColor: Colors.blue.shade50,
                  ),
                  validator: validator,
                  onChanged: onChanged,
                  obscureText: obscureText,
                ),
              ),
            ],
          );
  }
}
