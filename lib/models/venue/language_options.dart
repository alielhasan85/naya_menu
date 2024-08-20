class LanguageOptions {
  final String defaultLanguage;
  final List<String> additionalLanguages;

  LanguageOptions({
    required this.defaultLanguage,
    this.additionalLanguages = const [],
  });

  // Convert LanguageOptions to a map
  Map<String, dynamic> toMap() {
    return {
      'defaultLanguage': defaultLanguage,
      'additionalLanguages': additionalLanguages,
    };
  }

  // Create LanguageOptions from a map
  factory LanguageOptions.fromMap(Map<String, dynamic> data) {
    return LanguageOptions(
      defaultLanguage: data['defaultLanguage'],
      additionalLanguages: List<String>.from(data['additionalLanguages']),
    );
  }
}
