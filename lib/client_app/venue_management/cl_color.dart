import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naya_menu/client_app/venue_management/cl_color_picker.dart';
import 'package:naya_menu/theme/app_theme.dart';
import 'package:naya_menu/client_app/notifier.dart'; // Import the provider

class ColorPaletteWidget extends ConsumerWidget {
  const ColorPaletteWidget({Key? key}) : super(key: key);

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
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(6)),
          color: color, // Current selected color
          border: Border.all(
            color: AppTheme.grey, // Border color
            width: 1.2, // Border width
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Access the venue provider to get the current colors
    final venue = ref.watch(venueProvider);
    final designAndDisplay = venue?.designAndDisplay ?? {};

    // Retrieve colors from the designAndDisplay map and convert Hex to Color
    Color backgroundColor = designAndDisplay.containsKey('backgroundColor')
        ? _hexToColor(designAndDisplay['backgroundColor'])
        : Colors.blue; // Default color

    Color highlightColor = designAndDisplay.containsKey('highlightColor')
        ? _hexToColor(designAndDisplay['highlightColor'])
        : Colors.blue; // Default color

    Color textColor = designAndDisplay.containsKey('textColor')
        ? _hexToColor(designAndDisplay['textColor'])
        : Colors.white; // Default color

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
                          const Text('Background Color'),
                          _buildColorPicker(
                            context,
                            'Background Color',
                            backgroundColor,
                            (newColor) {
                              // Update the background color in the provider
                              ref
                                  .read(venueProvider.notifier)
                                  .updateDesignAndDisplay(
                                      'backgroundColor', _colorToHex(newColor));
                            },
                          ),
                        ],
                      ),
                    ),
                    TableCell(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Highlight Color'),
                          _buildColorPicker(
                            context,
                            'Highlight Color',
                            highlightColor,
                            (newColor) {
                              // Update the highlight color in the provider
                              ref
                                  .read(venueProvider.notifier)
                                  .updateDesignAndDisplay(
                                      'highlightColor', _colorToHex(newColor));
                            },
                          ),
                        ],
                      ),
                    ),
                    TableCell(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Text Color'),
                          _buildColorPicker(
                            context,
                            'Text Color',
                            textColor,
                            (newColor) {
                              // Update the text color in the provider
                              ref
                                  .read(venueProvider.notifier)
                                  .updateDesignAndDisplay(
                                      'textColor', _colorToHex(newColor));
                            },
                          ),
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

  // Utility method to convert a Color to a hex string
  String _colorToHex(Color color) {
    return '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
  }

  // Utility method to convert a hex string to a Color object
  Color _hexToColor(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
