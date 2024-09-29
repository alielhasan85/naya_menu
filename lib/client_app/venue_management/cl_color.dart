import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naya_menu/client_app/venue_management/cl_color_picker.dart';
import 'package:naya_menu/theme/app_theme.dart';
import 'package:naya_menu/client_app/notifier.dart'; // Import the provider

class ColorPaletteWidget extends ConsumerWidget {
  const ColorPaletteWidget({super.key});

  Widget _buildColorOption(
    BuildContext context,
    String label,
    Color color,
    ValueChanged<Color> onColorChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 14)),
          GestureDetector(
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
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: AppTheme.grey),
              ),
            ),
          ),
        ],
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
      surfaceTintColor: AppTheme.grey,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Customize Colors', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 16),
            _buildColorOption(
              context,
              'Background Color',
              backgroundColor,
              (newColor) {
                // Update the background color in the provider
                ref.read(venueProvider.notifier).updateDesignAndDisplay(
                    'backgroundColor', _colorToHex(newColor));
              },
            ),
            _buildColorOption(
              context,
              'Highlight Color',
              highlightColor,
              (newColor) {
                // Update color in provider
                // Update the highlight color in the provider
                ref.read(venueProvider.notifier).updateDesignAndDisplay(
                    'highlightColor', _colorToHex(newColor));
              },
            ),
            _buildColorOption(
              context,
              'Text Color',
              textColor,
              (newColor) {
                // Update color in provider
                ref
                    .read(venueProvider.notifier)
                    .updateDesignAndDisplay('textColor', _colorToHex(newColor));
              },
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
