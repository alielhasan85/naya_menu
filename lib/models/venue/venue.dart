class Venue {
  String id;
  final String ownerId;
  final String name;

  Venue({
    required this.id,
    required this.ownerId,
    required this.name,
  });

  // Convert Venue object to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'ownerId': ownerId,
      'name': name,
    };
  }

  // Create a Venue object from a map
  factory Venue.fromMap(Map<String, dynamic> data, String documentId) {
    return Venue(
      id: documentId,
      ownerId: data['ownerId'],
      name: data['name'],
    );
  }
}
