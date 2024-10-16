import 'package:flutter/material.dart';

class AppTheme {
  // Colors extracted from the image
  static const Color background = Color(0xFFF0F2F5);
  static const Color primaryColor = Color(0xFF2E4857);
  static const Color secondaryColor = Color(0xFF4E6776);
  static const Color accentColor = Color(0xFFFF5E1E);
  static const Color textPrimary = Color(0xFF2E4857);
  static const Color white = Color(0xFFFFFFFF);
  static const Color grey = Color(0xFFE0E0E0);
  static const Color grey2 = Color(0xFFDAD5CF);
  static const Color lightGreen = Color(0xFFd3f1a7);
  static const Color lightPeach = Color(0xFFFEC195);

  // Text Colors
  static const Color darkText = textPrimary;
  static const Color lightText = Color(0xFF4B4B4B);
  static const Color deactivatedText = Color(0xFF4B4B4B);

  // Miscellaneous Colors
  static const Color chipBackground = Color(0xFFEEF1F3);
  static const String fontName = 'WorkSans';

  // Text theme
  static const TextTheme textTheme = TextTheme(
    headlineMedium: display1,
    headlineSmall: headline,
    titleSmall: subtitle,
    bodyMedium: body2,
    bodyLarge: body1,
    bodySmall: caption,
  );

  static const TextStyle titleAureola = TextStyle(
    fontFamily: 'CinzelDecorative',
    fontWeight: FontWeight.bold,
    fontSize: 48,
    letterSpacing: 0.4,
    height: 0.9,
    color: AppTheme.primaryColor,
  );

  static const TextStyle titlePlatform = TextStyle(
    fontFamily: 'comme',
    fontWeight:
        FontWeight.normal, // You can adjust the font weight or style here
    fontSize: 46, // Same font size to keep consistency
    letterSpacing: 0.4,
    height: 0.8,
    color: AppTheme.accentColor, // Apply a different color or style
  );

  static const TextStyle display1 = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 36,
    letterSpacing: 0.4,
    height: 0.9,
    color: darkText,
  );

  static const TextStyle headline = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 24,
    letterSpacing: 0.27,
    color: darkText,
  );

  static const TextStyle subtitle = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    letterSpacing: 0.1,
    color: darkText,
  );

  static const TextStyle body2 = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    letterSpacing: 0.2,
    color: darkText,
  );

  static const TextStyle body1 = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 16,
    letterSpacing: -0.05,
    color: darkText,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 12,
    letterSpacing: 0.2,
    color: lightText,
  );

  // Button style
  static final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
    backgroundColor: AppTheme.accentColor,
    foregroundColor: AppTheme.white,
    textStyle: const TextStyle(
      fontFamily: fontName,
      fontWeight: FontWeight.bold,
      fontSize: 16,
    ),
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  );

  // InputDecoration Theme
  static final InputDecorationTheme inputDecorationTheme = InputDecorationTheme(
    filled: true,
    fillColor: AppTheme.chipBackground,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppTheme.grey),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppTheme.grey),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppTheme.accentColor),
    ),
    labelStyle: const TextStyle(
      fontFamily: fontName,
      color: AppTheme.darkText,
      fontSize: 16,
    ),
    hintStyle: const TextStyle(
      fontFamily: fontName,
      color: AppTheme.lightText,
      fontSize: 14,
    ),
    contentPadding: const EdgeInsets.all(6.0), // Adjust content padding here
  );

  // InputDecoration Theme
  static final InputDecoration inputDecoration = InputDecoration(
    filled: true,
    fillColor: AppTheme.chipBackground,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppTheme.grey),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppTheme.grey),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppTheme.accentColor),
    ),
    labelStyle: const TextStyle(
      fontFamily: fontName,
      color: AppTheme.darkText,
      fontSize: 16,
    ),
    hintStyle: const TextStyle(
      fontFamily: fontName,
      color: AppTheme.lightText,
      fontSize: 14,
    ),
    contentPadding: const EdgeInsets.all(10.0), // Adjust content padding here
  );

  // AppBar theme
  static AppBarTheme appBarTheme = const AppBarTheme(
    backgroundColor: AppTheme.white,
    elevation: 0,
    iconTheme: IconThemeData(color: AppTheme.primaryColor),
    titleTextStyle: TextStyle(
      fontFamily: fontName,
      color: AppTheme.primaryColor,
      fontWeight: FontWeight.bold,
      fontSize: 20,
    ),
  );

  // Icon theme
  static IconThemeData iconTheme = const IconThemeData(
    color: AppTheme.darkText,
    size: 24,
  );

  // Apply the theme to the app
  static ThemeData themeData(BuildContext context) {
    return ThemeData(
      primaryColor: AppTheme.primaryColor,
      scaffoldBackgroundColor: AppTheme.background,
      textTheme: AppTheme.textTheme,
      buttonTheme: ButtonThemeData(
        buttonColor: AppTheme.accentColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        textTheme: ButtonTextTheme.primary,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(style: AppTheme.buttonStyle),
      inputDecorationTheme: AppTheme.inputDecorationTheme,
      appBarTheme: AppTheme.appBarTheme,
      iconTheme: AppTheme.iconTheme,
      colorScheme: ColorScheme.fromSwatch().copyWith(
        background: AppTheme.background,
        primary: AppTheme.primaryColor,
        onPrimary: AppTheme.white,
      ),
    );
  }
}
