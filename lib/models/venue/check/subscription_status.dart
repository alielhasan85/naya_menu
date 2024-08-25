class SubscriptionStatus {
  final DateTime dateOfCreation;
  final DateTime renewalDate;
  final double subscriptionPrice;
  final String currency;

  SubscriptionStatus({
    required this.dateOfCreation,
    required this.renewalDate,
    required this.subscriptionPrice,
    required this.currency,
  });

  // Convert SubscriptionStatus to a map
  Map<String, dynamic> toMap() {
    return {
      'dateOfCreation': dateOfCreation.toIso8601String(),
      'renewalDate': renewalDate.toIso8601String(),
      'subscriptionPrice': subscriptionPrice,
      'currency': currency,
    };
  }

  // Create SubscriptionStatus from a map
  factory SubscriptionStatus.fromMap(Map<String, dynamic> data) {
    return SubscriptionStatus(
      dateOfCreation: DateTime.parse(data['dateOfCreation']),
      renewalDate: DateTime.parse(data['renewalDate']),
      subscriptionPrice: data['subscriptionPrice'],
      currency: data['currency'],
    );
  }
}
