// to be checked carefully
///

class MenuItem {
  final String itemId;
  final String itemName;
  final String description;
  final double price;
  final String imageUrl; // URL to the item's image
  final bool isAvailable; // Availability status
  final List<String> dietaryTags; // E.g., ['Vegetarian', 'Gluten-Free']
  final List<String> availability; // New field for item availability

  MenuItem({
    required this.itemId,
    required this.itemName,
    this.description = '',
    required this.price,
    this.imageUrl = '',
    this.isAvailable = true,
    this.dietaryTags = const [],
    this.availability = const [
      'dine-in',
      'takeaway',
      'delivery'
    ], // Default to all
  });

  Map<String, dynamic> toMap() {
    return {
      'itemId': itemId,
      'itemName': itemName,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'isAvailable': isAvailable,
      'dietaryTags': dietaryTags,
      'availability': availability,
    };
  }

  factory MenuItem.fromMap(Map<String, dynamic> map) {
    return MenuItem(
      itemId: map['itemId'],
      itemName: map['itemName'],
      description: map['description'] ?? '',
      price: (map['price'] as num).toDouble(),
      imageUrl: map['imageUrl'] ?? '',
      isAvailable: map['isAvailable'] ?? true,
      dietaryTags: List<String>.from(map['dietaryTags'] ?? []),
      availability: List<String>.from(
          map['availability'] ?? ['dine-in', 'takeaway', 'delivery']),
    );
  }

  MenuItem copyWith({
    String? itemId,
    String? itemName,
    String? description,
    double? price,
    String? imageUrl,
    bool? isAvailable,
    List<String>? dietaryTags,
    List<String>? availability,
  }) {
    return MenuItem(
      itemId: itemId ?? this.itemId,
      itemName: itemName ?? this.itemName,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      isAvailable: isAvailable ?? this.isAvailable,
      dietaryTags: dietaryTags ?? this.dietaryTags,
      availability: availability ?? this.availability,
    );
  }
}
