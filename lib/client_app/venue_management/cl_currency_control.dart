import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:naya_menu/client_app/notifier.dart';

class CurrencyControl extends ConsumerStatefulWidget {
  const CurrencyControl({Key? key}) : super(key: key);

  @override
  _CurrencyControlState createState() => _CurrencyControlState();
}

class _CurrencyControlState extends ConsumerState<CurrencyControl> {
  late bool priceDisplay;

  @override
  void initState() {
    super.initState();

    // Initialize the local priceDisplay state from the provider
    final venue = ref.read(venueProvider);
    priceDisplay = venue?.priceOptions['priceDisplay'] ?? true;
  }

  @override
  Widget build(BuildContext context) {
    final venue = ref.watch(venueProvider);
    final venueNotifier = ref.read(venueProvider.notifier);

    // Get country from venue provider
    final String country = venue?.address['country'] ?? '';

    // Initialize currency based on country if not set already
    final String selectedCurrency = venue?.priceOptions['currency'] ??
        getCurrencyCodeFromCountry(country) ??
        'USD';

    late bool displayCurrencySign =
        venue?.priceOptions['displayCurrencySign'] ?? true;
    late bool displayCurrencyFraction =
        venue?.priceOptions['displayCurrencyFraction'] ?? true;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        // CheckboxListTile for price display
        CheckboxListTile(
          value: priceDisplay,
          onChanged: (bool? value) {
            setState(() {
              priceDisplay = value!;
            });
            venueNotifier.updatePriceOption('priceDisplay', value);
          },
          title: const Text('Display Prices'),
          subtitle: const Text('Hide or display prices on the menu'),
        ),
        if (priceDisplay) ...[
          const SizedBox(height: 10),
          // Row for Currency Picker and Switches
          Row(
            children: [
              // "Select Currency:" text
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 14),
                child: const Text(
                  'Select Currency: ',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              // GestureDetector for the currency picker
              GestureDetector(
                onTap: () {
                  showCurrencyPicker(
                    context: context,
                    showFlag: false,
                    showSearchField: true,
                    onSelect: (Currency currency) {
                      venueNotifier.updatePriceOption(
                          'currency', currency.code);
                      venueNotifier.updatePriceOption(
                          'currencySymbol', currency.symbol);
                    },
                  );
                },
                child: Row(
                  children: [
                    // Box for the currency code
                    Container(
                      width: 50,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
                      child: Text(
                        selectedCurrency,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),

                    // Box for the currency symbol
                    Container(
                      width: 50,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
                      child: Text(
                        venue?.priceOptions['currencySymbol'] ?? '\$',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 10), // Add some space between rows

          // CheckboxListTile for price display
          CheckboxListTile(
            value: displayCurrencySign,
            onChanged: (bool? value) {
              setState(() {
                displayCurrencySign = value!;
              });
              venueNotifier.updatePriceOption('displayCurrencySign', value);
            },
            title: const Text('Display currency sign'),
            subtitle: const Text(
                'The currency sign will be displayed nearby the prices on the menu'),
          ),

          const SizedBox(height: 10),

          // CheckboxListTile for price display
          CheckboxListTile(
            value: displayCurrencyFraction,
            onChanged: (bool? value) {
              setState(() {
                displayCurrencyFraction = value!;
              });
              venueNotifier.updatePriceOption('displayCurrencyFraction', value);
            },
            title: const Text('Display currency fraction'),
            subtitle: const Text('Show/Hide fraction of prices ex. 7.00'),
          ),

          const SizedBox(height: 10),

          // Row for switches with better alignment
        ],
      ],
    );
  }

  // Helper function to get currency code based on the country
  String? getCurrencyCodeFromCountry(String countryCode) {
    switch (countryCode) {
      case 'US':
        return 'USD';
      case 'GB':
        return 'GBP';
      case 'EU':
        return 'EUR';
      case 'JP':
        return 'JPY';
      case 'IN':
        return 'INR';
      // Add more country codes and their currency codes as needed
      default:
        return null;
    }
  }

  // A helper widget to create consistent switch columns
  Widget _buildSwitchColumn({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(title, style: const TextStyle(fontSize: 14)),
        Switch.adaptive(
          value: value,
          onChanged: onChanged,
          activeColor: Colors.blueAccent, // Customize the switch color
        ),
      ],
    );
  }
}
