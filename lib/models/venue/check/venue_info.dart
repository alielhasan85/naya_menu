class VenueInfo {
  final String venueName;
  final String venueId;
  final String? logoUrl;
  final String address;
  final String city;
  final String country;
  final String? state;
  final String? zipCode;
  final String phoneNumber;
  final String timezone;
  final Map<String, double>? locationCoordinates;

  VenueInfo({
    required this.venueName,
    required this.venueId,
    this.logoUrl,
    required this.address,
    required this.city,
    required this.country,
    this.state,
    this.zipCode,
    required this.phoneNumber,
    required this.timezone,
    this.locationCoordinates,
  });

  // Convert VenueInfo to a map
  Map<String, dynamic> toMap() {
    return {
      'venueName': venueName,
      'venueId': venueId,
      'logoUrl': logoUrl,
      'address': address,
      'city': city,
      'country': country,
      'state': state,
      'zipCode': zipCode,
      'phoneNumber': phoneNumber,
      'timezone': timezone,
      'locationCoordinates': locationCoordinates,
    };
  }

  // Create VenueInfo from a map
  factory VenueInfo.fromMap(Map<String, dynamic> data) {
    return VenueInfo(
      venueName: data['venueName'],
      venueId: data['venueId'],
      logoUrl: data['logoUrl'],
      address: data['address'],
      city: data['city'],
      country: data['country'],
      state: data['state'],
      zipCode: data['zipCode'],
      phoneNumber: data['phoneNumber'],
      timezone: data['timezone'],
      locationCoordinates: data['locationCoordinates'] != null
          ? Map<String, double>.from(data['locationCoordinates'])
          : null,
    );
  }
}
