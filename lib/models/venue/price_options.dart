class PriceOptions {
  final bool displayPrices;
  final String displayCurrency;
  final bool displayCurrencyFraction;
  final String menuCurrency;

  PriceOptions({
    required this.displayPrices,
    required this.displayCurrency,
    required this.displayCurrencyFraction,
    required this.menuCurrency,
  });

  // Convert PriceOptions to a map
  Map<String, dynamic> toMap() {
    return {
      'displayPrices': displayPrices,
      'displayCurrency': displayCurrency,
      'displayCurrencyFraction': displayCurrencyFraction,
      'menuCurrency': menuCurrency,
    };
  }

  // Create PriceOptions from a map
  factory PriceOptions.fromMap(Map<String, dynamic> data) {
    return PriceOptions(
      displayPrices: data['displayPrices'],
      displayCurrency: data['displayCurrency'],
      displayCurrencyFraction: data['displayCurrencyFraction'],
      menuCurrency: data['menuCurrency'],
    );
  }
}
