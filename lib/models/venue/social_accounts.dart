class SocialAccounts {
  final String? instagram;
  final String? facebook;
  final String? website;
  final String? twitter;
  final String? foursquare;
  final String? tripAdvisor;
  final String? snapchat;
  final String? zomato;
  final String? tiktok;
  final String? spotify;
  final String? whatsapp;

  SocialAccounts({
    this.instagram,
    this.facebook,
    this.website,
    this.twitter,
    this.foursquare,
    this.tripAdvisor,
    this.snapchat,
    this.zomato,
    this.tiktok,
    this.spotify,
    this.whatsapp,
  });

  // Convert SocialAccounts to a map
  Map<String, dynamic> toMap() {
    return {
      'instagram': instagram,
      'facebook': facebook,
      'website': website,
      'twitter': twitter,
      'foursquare': foursquare,
      'tripAdvisor': tripAdvisor,
      'snapchat': snapchat,
      'zomato': zomato,
      'tiktok': tiktok,
      'spotify': spotify,
      'whatsapp': whatsapp,
    };
  }

  // Create SocialAccounts from a map
  factory SocialAccounts.fromMap(Map<String, dynamic> data) {
    return SocialAccounts(
      instagram: data['instagram'],
      facebook: data['facebook'],
      website: data['website'],
      twitter: data['twitter'],
      foursquare: data['foursquare'],
      tripAdvisor: data['tripAdvisor'],
      snapchat: data['snapchat'],
      zomato: data['zomato'],
      tiktok: data['tiktok'],
      spotify: data['spotify'],
      whatsapp: data['whatsapp'],
    );
  }
}
