import 'package:flutter/material.dart';
import 'package:naya_menu/models/country.dart';

class PhoneNumberInput extends StatefulWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const PhoneNumberInput({required this.controller, this.validator, Key? key})
      : super(key: key);

  @override
  _PhoneNumberInputState createState() => _PhoneNumberInputState();
}

class _PhoneNumberInputState extends State<PhoneNumberInput> {
  Country? selectedCountry;

  @override
  void initState() {
    super.initState();
    selectedCountry = countries.first; // Default to the first country
  }

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey, width: 2),
    );

    return Row(
      children: [
        DropdownButton<Country>(
          value: selectedCountry,
          onChanged: (Country? newValue) {
            setState(() {
              selectedCountry = newValue!;
            });
          },
          items: countries.map<DropdownMenuItem<Country>>((Country country) {
            return DropdownMenuItem<Country>(
              value: country,
              child: Row(
                children: [
                  Text(country.dialCode),
                  const SizedBox(width: 8),
                  Text(country.name),
                ],
              ),
            );
          }).toList(),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: TextFormField(
            controller: widget.controller,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              border: border,
              focusedBorder: border,
              enabledBorder: border,
              contentPadding: const EdgeInsets.all(10.0),
              hintText: 'Enter your phone number',
              filled: true,
              fillColor: Colors.blue.shade50,
            ),
            validator: widget.validator,
            onChanged: (value) {
              if (selectedCountry != null) {
                widget.controller.text = '${selectedCountry!.dialCode} $value';
              }
            },
          ),
        ),
      ],
    );
  }
}
