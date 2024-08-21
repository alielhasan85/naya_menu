class Category {
  final String id;
  final String title;
  final String imageUrl;
  final String? description;
  final int order;

  Category({
    required this.id,
    required this.title,
    required this.imageUrl,
    this.description,
    required this.order,
  });

  // Convert Category object to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'imageUrl': imageUrl,
      'description': description,
      'order': order,
    };
  }

  // Create a Category object from a map
  factory Category.fromMap(Map<String, dynamic> data, String documentId) {
    return Category(
      id: documentId,
      title: data['title'],
      imageUrl: data['imageUrl'],
      description: data['description'],
      order: data['order'],
    );
  }

  // Add copyWith method
  Category copyWith({
    String? id,
    String? title,
    String? imageUrl,
    String? description,
    int? order,
  }) {
    return Category(
      id: id ?? this.id,
      title: title ?? this.title,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
      order: order ?? this.order,
    );
  }
}
