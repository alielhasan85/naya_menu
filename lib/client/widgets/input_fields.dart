import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final bool obscureText; // New property

  InputField({
    required this.label,
    required this.hintText,
    required this.controller,
    this.validator,
    this.onChanged,
    this.obscureText = false, // Default value
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        // double fieldWidth = ResponsiveHelper.isMobile(context)
        //     ? MediaQuery.of(context).size.width / 1.5
        //     : ResponsiveHelper.isTablet(context)
        //         ? MediaQuery.of(context).size.width / 2.5
        //         : MediaQuery.of(context).size.width / 3.7;

        return Row(
          children: <Widget>[
            SizedBox(
              width: 70.0,
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
                style: const TextStyle(fontSize: 15.0),
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(10.0),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue.shade50),
                        borderRadius: BorderRadius.circular(5.0)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue.shade50),
                        borderRadius: BorderRadius.circular(5.0)),
                    hintText: hintText,
                    filled: true,
                    fillColor: Colors.blue.shade50),
                validator: validator,
                onChanged: onChanged,
                obscureText: obscureText, // Use the property
              ),
            ),
          ],
        );
      },
    );
  }
}
