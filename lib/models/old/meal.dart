enum Currency { USD, QAR, SAR, LBP }

enum MealSize { Small, Medium, Large }

class Meal {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final double price;
  final Currency currency;
  final List<String> categories;
  final List<String>? ingredients;
  final MealSize? size;
  final bool hasAdditions;
  final bool isAvailable;

  Meal({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.currency,
    required this.categories,
    this.ingredients,
    this.size,
    required this.hasAdditions,
    required this.isAvailable,
  });

  // Convert Meal object to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'price': price,
      'currency': currency.toString().split('.').last,
      'categories': categories,
      'ingredients': ingredients,
      'size': size?.toString().split('.').last,
      'hasAdditions': hasAdditions,
      'isAvailable': isAvailable,
    };
  }

  // Create a Meal object from a map
  factory Meal.fromMap(Map<String, dynamic> data, String documentId) {
    return Meal(
      id: documentId,
      title: data['title'],
      description: data['description'],
      imageUrl: data['imageUrl'],
      price: data['price'],
      currency: Currency.values
          .firstWhere((e) => e.toString().split('.').last == data['currency']),
      categories: List<String>.from(data['categories']),
      ingredients: data['ingredients'] != null
          ? List<String>.from(data['ingredients'])
          : null,
      size: data['size'] != null
          ? MealSize.values
              .firstWhere((e) => e.toString().split('.').last == data['size'])
          : null,
      hasAdditions: data['hasAdditions'],
      isAvailable: data['isAvailable'],
    );
  }
}
