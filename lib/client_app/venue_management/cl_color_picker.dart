import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart'; // Import the color picker package

class CustomColorPickerDialog extends StatefulWidget {
  final Color initialColor;
  final ValueChanged<Color> onColorChanged;

  const CustomColorPickerDialog({
    required this.initialColor,
    required this.onColorChanged,
    Key? key,
  }) : super(key: key);

  @override
  _CustomColorPickerDialogState createState() =>
      _CustomColorPickerDialogState();
}

class _CustomColorPickerDialogState extends State<CustomColorPickerDialog> {
  late Color currentColor;
  late TextEditingController hexController;

  @override
  void initState() {
    super.initState();
    currentColor = widget.initialColor;
    hexController = TextEditingController(
      text:
          '#${widget.initialColor.value.toRadixString(16).substring(2).toUpperCase()}',
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Pick a color'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            ColorPicker(
              pickerColor: currentColor,
              onColorChanged: (Color newColor) {
                setState(() {
                  currentColor = newColor;
                  hexController.text =
                      '#${newColor.value.toRadixString(16).substring(2).toUpperCase()}';
                });
              },
              showLabel: true,
              pickerAreaHeightPercent: 0.8,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: hexController,
              decoration: const InputDecoration(
                labelText: 'Hex Color',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (value) {
                if (RegExp(r'^#([A-Fa-f0-9]{6})$').hasMatch(value)) {
                  setState(() {
                    currentColor = Color(
                        int.parse(value.substring(1), radix: 16) + 0xFF000000);
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Invalid hex color code.')),
                  );
                }
              },
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          child: const Text('Select'),
          onPressed: () {
            widget.onColorChanged(currentColor);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
