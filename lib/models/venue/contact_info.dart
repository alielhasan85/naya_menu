class ContactInfo {
  final String phoneNumber;
  final String? website;

  ContactInfo({
    required this.phoneNumber,
    this.website,
  });

  // Convert ContactInfo to a map
  Map<String, dynamic> toMap() {
    return {
      'phoneNumber': phoneNumber,
      'website': website,
    };
  }

  // Create ContactInfo from a map
  factory ContactInfo.fromMap(Map<String, dynamic> data) {
    return ContactInfo(
      phoneNumber: data['phoneNumber'],
      website: data['website'],
    );
  }
}
