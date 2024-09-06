class VenueModel {
  final String venueId;
  final String venueName;
  final String userId; // Add the userId field here
  final String logoUrl;
  final Map<String, dynamic> address;
  final Map<String, dynamic> contact;
  final List<String> languageOptions;
  final Map<String, dynamic> socialAccounts;
  final Map<String, dynamic> operations;
  final Map<String, dynamic> qrCodes;
  final Map<String, dynamic> designAndDisplay;
  final Map<String, dynamic> priceOptions;

  VenueModel({
    required this.venueId,
    required this.venueName,
    required this.userId, // Required userId
    this.logoUrl = '', // Default empty string if no logo is provided
    required this.address,
    required this.contact,
    this.languageOptions = const ['English'], // Default to English
    this.socialAccounts = const {}, // Default to empty map
    this.operations = const {}, // Default to empty map
    this.qrCodes = const {}, // Default to empty map
    this.designAndDisplay = const {}, // Default to empty map
    this.priceOptions = const {}, // Default to empty map
  });

  // Convert a VenueModel into a Map. The keys must correspond to the names of the fields in Firestore.
  Map<String, dynamic> toMap() {
    return {
      'venueId': venueId,
      'venueName': venueName,
      'userId': userId, // Ensure to add userId in the map
      'logoUrl': logoUrl,
      'address': address,
      'contact': contact,
      'languageOptions': languageOptions,
      'socialAccounts': socialAccounts,
      'operations': operations,
      'qrCodes': qrCodes,
      'designAndDisplay': designAndDisplay,
      'priceOptions': priceOptions,
    };
  }

  // Create a VenueModel from a Map (from Firestore).
  factory VenueModel.fromMap(Map<String, dynamic> map, String venueId) {
    return VenueModel(
      venueId: venueId,
      venueName: map['venueName'],
      userId: map['userId'], // Read the userId from the map
      logoUrl: map['logoUrl'],
      address: Map<String, dynamic>.from(map['address']),
      contact: Map<String, dynamic>.from(map['contact']),
      languageOptions: List<String>.from(map['languageOptions'] ?? ['English']),
      socialAccounts: Map<String, dynamic>.from(map['socialAccounts']),
      operations: Map<String, dynamic>.from(map['operations']),
      qrCodes: Map<String, dynamic>.from(map['qrCodes']),
      designAndDisplay: Map<String, dynamic>.from(map['designAndDisplay']),
      priceOptions: Map<String, dynamic>.from(map['priceOptions']),
    );
  }

  // Example of how to create a VenueModel instance for a specific venue
  VenueModel copyWith({
    String? venueId,
    String? venueName,
    String? userId, // Add userId here for copying
    String? logoUrl,
    Map<String, dynamic>? address,
    Map<String, dynamic>? contact,
    List<String>? languageOptions,
    Map<String, dynamic>? socialAccounts,
    Map<String, dynamic>? operations,
    Map<String, dynamic>? qrCodes,
    Map<String, dynamic>? designAndDisplay,
    Map<String, dynamic>? priceOptions,
  }) {
    return VenueModel(
      venueId: venueId ?? this.venueId,
      venueName: venueName ?? this.venueName,
      userId: userId ?? this.userId, // Ensure the userId is preserved
      logoUrl: logoUrl ?? this.logoUrl,
      address: address ?? this.address,
      contact: contact ?? this.contact,
      languageOptions: languageOptions ?? this.languageOptions,
      socialAccounts: socialAccounts ?? this.socialAccounts,
      operations: operations ?? this.operations,
      qrCodes: qrCodes ?? this.qrCodes,
      designAndDisplay: designAndDisplay ?? this.designAndDisplay,
      priceOptions: priceOptions ?? this.priceOptions,
    );
  }
}
