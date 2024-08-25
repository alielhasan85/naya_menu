class ThemeData {
  final String backgroundColor;
  final String textColor;
  final String highlightColor;
  final bool caloriesOption;

  final WelcomePageCustomization welcomePageCustomization;

  ThemeData({
    required this.backgroundColor,
    required this.textColor,
    required this.highlightColor,
    this.caloriesOption = false,
    required this.welcomePageCustomization,
  });

  // Convert ThemeData to a map
  Map<String, dynamic> toMap() {
    return {
      'backgroundColor': backgroundColor,
      'textColor': textColor,
      'highlightColor': highlightColor,
      'caloriesOption': caloriesOption,
      'welcomePageCustomization': welcomePageCustomization.toMap(),
    };
  }

  // Create ThemeData from a map
  factory ThemeData.fromMap(Map<String, dynamic> data) {
    return ThemeData(
      backgroundColor: data['backgroundColor'],
      textColor: data['textColor'],
      highlightColor: data['highlightColor'],
      caloriesOption: data['caloriesOption'],
      welcomePageCustomization:
          WelcomePageCustomization.fromMap(data['welcomePageCustomization']),
    );
  }
}

class WelcomePageCustomization {
  final bool displayWelcomePage;
  final bool displayVenueName;
  final bool googleReviewButton;
  final String welcomeMessage;
  final bool customLandingPage;

  WelcomePageCustomization({
    required this.displayWelcomePage,
    required this.displayVenueName,
    required this.googleReviewButton,
    required this.welcomeMessage,
    required this.customLandingPage,
  });

  // Convert WelcomePageCustomization to a map
  Map<String, dynamic> toMap() {
    return {
      'displayWelcomePage': displayWelcomePage,
      'displayVenueName': displayVenueName,
      'googleReviewButton': googleReviewButton,
      'welcomeMessage': welcomeMessage,
      'customLandingPage': customLandingPage,
    };
  }

  // Create WelcomePageCustomization from a map
  factory WelcomePageCustomization.fromMap(Map<String, dynamic> data) {
    return WelcomePageCustomization(
      displayWelcomePage: data['displayWelcomePage'],
      displayVenueName: data['displayVenueName'],
      googleReviewButton: data['googleReviewButton'],
      welcomeMessage: data['welcomeMessage'],
      customLandingPage: data['customLandingPage'],
    );
  }
}
