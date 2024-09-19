import 'package:flutter/material.dart';
import 'package:naya_menu/client_app/venue_management/cl_color_picker.dart';

class ColorPaletteWidget extends StatelessWidget {
  final Color primaryColor;
  final Color secondaryColor;
  final Color backgroundColor;
  final Color cardColor;
  final Color textColor;
  final Color buttonColor;
  final ValueChanged<Color> onPrimaryColorChanged;
  final ValueChanged<Color> onSecondaryColorChanged;
  final ValueChanged<Color> onBackgroundColorChanged;
  final ValueChanged<Color> onCardColorChanged;
  final ValueChanged<Color> onTextColorChanged;
  final ValueChanged<Color> onButtonColorChanged;

  const ColorPaletteWidget({
    required this.primaryColor,
    required this.secondaryColor,
    required this.backgroundColor,
    required this.cardColor,
    required this.textColor,
    required this.buttonColor,
    required this.onPrimaryColorChanged,
    required this.onSecondaryColorChanged,
    required this.onBackgroundColorChanged,
    required this.onCardColorChanged,
    required this.onTextColorChanged,
    required this.onButtonColorChanged,
    Key? key,
  }) : super(key: key);

  Widget _buildColorPicker(BuildContext context, String label, Color color,
      ValueChanged<Color> onColorChanged) {
    return GestureDetector(
      onTap: () => showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomColorPickerDialog(
            initialColor: color,
            onColorChanged: onColorChanged,
          );
        },
      ),
      child: Container(
        height: 50,
        width: 50,
        color: color,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Color Palette',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Table(
                columnWidths: const {
                  0: FixedColumnWidth(150),
                  1: FixedColumnWidth(150),
                  2: FixedColumnWidth(150),
                },
                children: [
                  TableRow(children: [
                    TableCell(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Primary Color'),
                          _buildColorPicker(context, 'Primary Color',
                              primaryColor, onPrimaryColorChanged),
                        ],
                      ),
                    ),
                    TableCell(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Secondary Color'),
                          _buildColorPicker(context, 'Secondary Color',
                              secondaryColor, onSecondaryColorChanged),
                        ],
                      ),
                    ),
                    TableCell(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Background Color'),
                          _buildColorPicker(context, 'Background Color',
                              backgroundColor, onBackgroundColorChanged),
                        ],
                      ),
                    ),
                  ]),
                  TableRow(children: [
                    TableCell(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Card Color'),
                          _buildColorPicker(context, 'Card Color', cardColor,
                              onCardColorChanged),
                        ],
                      ),
                    ),
                    TableCell(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Text Color'),
                          _buildColorPicker(context, 'Text Color', textColor,
                              onTextColorChanged),
                        ],
                      ),
                    ),
                    TableCell(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Button Color'),
                          _buildColorPicker(context, 'Button Color',
                              buttonColor, onButtonColorChanged),
                        ],
                      ),
                    ),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
