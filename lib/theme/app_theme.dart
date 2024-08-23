// import 'package:flutter/material.dart';

// class AppTheme {
//   AppTheme._();

//   static const Color notWhite = Color(0xFFEDF0F2);
//   static const Color nearlyWhite = Color(0xFFFEFEFE);
//   static const Color white = Color(0xFFFFFFFF);
//   static const Color nearlyBlack = Color(0xFF213333);
//   static const Color grey = Color(0xFF3A5160);
//   static const Color darkGrey = Color(0xFF313A44);

//   static const Color darkText = Color(0xFF253840);
//   static const Color darkerText = Color(0xFF17262A);
//   static const Color lightText = Color(0xFF4A6572);
//   static const Color deactivatedText = Color(0xFF767676);
//   static const Color dismissibleBackground = Color(0xFF364A54);
//   static const Color chipBackground = Color(0xFFEEF1F3);
//   static const Color spacer = Color(0xFFF2F2F2);
//   static const String fontName = 'WorkSans';

//   static const TextTheme textTheme = TextTheme(
//     headlineMedium: display1,
//     headlineSmall: headline,
//     titleLarge: title,
//     titleSmall: subtitle,
//     bodyMedium: body2,
//     bodyLarge: body1,
//     bodySmall: caption,
//   );

//   static const TextStyle display1 = TextStyle(
//     // h4 -> display1
//     fontFamily: fontName,
//     fontWeight: FontWeight.bold,
//     fontSize: 36,
//     letterSpacing: 0.4,
//     height: 0.9,
//     color: darkerText,
//   );

//   static const TextStyle headline = TextStyle(
//     // h5 -> headline
//     fontFamily: fontName,
//     fontWeight: FontWeight.bold,
//     fontSize: 24,
//     letterSpacing: 0.27,
//     color: darkerText,
//   );

//   static const TextStyle title = TextStyle(
//     // h6 -> title
//     fontFamily: fontName,
//     fontWeight: FontWeight.bold,
//     fontSize: 16,
//     letterSpacing: 0.18,
//     color: darkerText,
//   );

//   static const TextStyle subtitle = TextStyle(
//     // subtitle2 -> subtitle
//     fontFamily: fontName,
//     fontWeight: FontWeight.w400,
//     fontSize: 14,
//     letterSpacing: -0.04,
//     color: darkText,
//   );

//   static const TextStyle body2 = TextStyle(
//     // body1 -> body2
//     fontFamily: fontName,
//     fontWeight: FontWeight.w400,
//     fontSize: 14,
//     letterSpacing: 0.2,
//     color: darkText,
//   );

//   static const TextStyle body1 = TextStyle(
//     // body2 -> body1
//     fontFamily: fontName,
//     fontWeight: FontWeight.w400,
//     fontSize: 16,
//     letterSpacing: -0.05,
//     color: darkText,
//   );

//   static const TextStyle caption = TextStyle(
//     // Caption -> caption
//     fontFamily: fontName,
//     fontWeight: FontWeight.w400,
//     fontSize: 12,
//     letterSpacing: 0.2,
//     color: lightText,
//   );

//   // Button style
//   static final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
//     backgroundColor: AppTheme.grey,
//     foregroundColor: AppTheme.white,
//     textStyle: const TextStyle(
//       fontFamily: fontName,
//       fontWeight: FontWeight.bold,
//       fontSize: 16,
//     ),
//     padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.circular(8),
//     ),
//   );

//   // Input decoration theme
//   static final InputDecorationTheme inputDecorationTheme = InputDecorationTheme(
//     filled: true,
//     fillColor: AppTheme.chipBackground,
//     border: OutlineInputBorder(
//       borderRadius: BorderRadius.circular(8),
//       borderSide: BorderSide(color: AppTheme.grey),
//     ),
//     enabledBorder: OutlineInputBorder(
//       borderRadius: BorderRadius.circular(8),
//       borderSide: BorderSide(color: AppTheme.grey),
//     ),
//     focusedBorder: OutlineInputBorder(
//       borderRadius: BorderRadius.circular(8),
//       borderSide: BorderSide(color: AppTheme.darkText),
//     ),
//     labelStyle: TextStyle(
//       fontFamily: fontName,
//       color: AppTheme.darkText,
//       fontSize: 16,
//     ),
//     hintStyle: TextStyle(
//       fontFamily: fontName,
//       color: AppTheme.lightText,
//       fontSize: 14,
//     ),
//   );

//   // AppBar theme
//   static final AppBarTheme appBarTheme = AppBarTheme(
//     backgroundColor: AppTheme.notWhite,
//     elevation: 0,
//     iconTheme: IconThemeData(color: AppTheme.darkText),
//     titleTextStyle: TextStyle(
//       fontFamily: fontName,
//       color: AppTheme.darkText,
//       fontWeight: FontWeight.bold,
//       fontSize: 20,
//     ),
//   );

//   // Icon theme
//   static final IconThemeData iconTheme = IconThemeData(
//     color: AppTheme.darkText,
//     size: 24,
//   );

//   static ThemeData themeData(BuildContext context) {
//     return ThemeData(
//       primaryColor: AppTheme.grey,
//       scaffoldBackgroundColor: AppTheme.nearlyWhite,
//       textTheme: AppTheme.textTheme,
//       buttonTheme: ButtonThemeData(
//         buttonColor: AppTheme.grey,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(8),
//         ),
//         textTheme: ButtonTextTheme.primary,
//       ),
//       elevatedButtonTheme: ElevatedButtonThemeData(style: AppTheme.buttonStyle),
//       inputDecorationTheme: AppTheme.inputDecorationTheme,
//       appBarTheme: AppTheme.appBarTheme,
//       iconTheme: AppTheme.iconTheme,
//       colorScheme: ColorScheme.fromSwatch().copyWith(
//         background: AppTheme.nearlyWhite,
//         primary: AppTheme.grey,
//         onPrimary: AppTheme.white,
//       ),
//     );
//   }
// }

/*


Color Palette Extraction:
Background Color:

Hex Code: #F9F4F1 (light beige)
Primary Text Color (Dark Blue Text):

Hex Code: #223843
Accent Text Color (Orange "Delicious" Text):

Hex Code: #FF5C00
Button Background Color (Login Button):

Hex Code: #FF5C00 (Same as the orange accent)
Button Text Color:

Hex Code: #FFFFFF (white)
Secondary Background Color (Header, Buttons Background):

Hex Code: #3D5365 (dark teal)
Secondary Accent Color (Green Box):

Hex Code: #D5E6BC (light green)
Outline and Divider Colors:

Hex Code: #E3E3E3 (light grey)
Additional Accent Color (Light Peach Box):

Hex Code: #FBD6C6 (light peach)*/

import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  // Colors extracted from the image
  static const Color background = Color(0xFFF9F4F1); // Light beige (background)
  static const Color primaryColor =
      Color(0xFF3D5365); // Dark teal (header, button background)
  static const Color accentColor =
      Color(0xFFFF5C00); // Orange (text "Delicious", login button)
  static const Color textPrimary = Color(0xFF223843); // Dark blue text
  static const Color white = Color(0xFFFFFFFF); // White (common usage)
  static const Color grey =
      Color(0xFFE3E3E3); // Light grey (outlines, dividers)
  static const Color lightGreen =
      Color(0xFFD5E6BC); // Light green (secondary accent)
  static const Color lightPeach =
      Color(0xFFFBD6C6); // Light peach (additional accent)

  // Text Colors
  static const Color darkText = textPrimary;
  static const Color darkerText = textPrimary;
  static const Color lightText =
      Color(0xFF4A6572); // This color can remain as is for less emphasis text
  static const Color deactivatedText =
      Color(0xFF767676); // Could be used for disabled text

  // Miscellaneous Colors
  static const Color dismissibleBackground =
      Color(0xFF364A54); // No direct match, can stay
  static const Color chipBackground =
      Color(0xFFEEF1F3); // Could be updated to `lightGreen` or `lightPeach`
  static const Color spacer = Color(
      0xFFF2F2F2); // This is close to the background but can remain as a neutral spacer
  static const String fontName = 'WorkSans';

  static const TextTheme textTheme = TextTheme(
    headlineMedium: display1,
    headlineSmall: headline,
    titleLarge: title,
    titleSmall: subtitle,
    bodyMedium: body2,
    bodyLarge: body1,
    bodySmall: caption,
  );

  static const TextStyle display1 = TextStyle(
    // h4 -> display1
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 36,
    letterSpacing: 0.4,
    height: 0.9,
    color: darkText,
  );

  static const TextStyle headline = TextStyle(
    // h5 -> headline
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 24,
    letterSpacing: 0.27,
    color: darkText,
  );

  static const TextStyle title = TextStyle(
    // h6 -> title
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 16,
    letterSpacing: 0.18,
    color: darkText,
  );

  static const TextStyle subtitle = TextStyle(
    // subtitle2 -> subtitle
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    letterSpacing: -0.04,
    color: darkText,
  );

  static const TextStyle body2 = TextStyle(
    // body1 -> body2
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    letterSpacing: 0.2,
    color: darkText,
  );

  static const TextStyle body1 = TextStyle(
    // body2 -> body1
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 16,
    letterSpacing: -0.05,
    color: darkText,
  );

  static const TextStyle caption = TextStyle(
    // Caption -> caption
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 12,
    letterSpacing: 0.2,
    color: lightText,
  );

  // Button style
  static final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
    backgroundColor: AppTheme.accentColor, // Updated to orange
    foregroundColor: AppTheme.white, // White text on button
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

  // Input decoration theme
  static final InputDecorationTheme inputDecorationTheme = InputDecorationTheme(
    filled: true,
    fillColor:
        AppTheme.chipBackground, // Can be updated to lightGreen or lightPeach
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppTheme.grey), // Light grey
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppTheme.grey), // Light grey
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide:
          const BorderSide(color: AppTheme.accentColor), // Dark blue text color
    ),
    labelStyle: const TextStyle(
      fontFamily: fontName,
      color: AppTheme.darkText,
      fontSize: 16,
    ),
    hintStyle: const TextStyle(
      fontFamily: fontName,
      color: AppTheme.lightText, // Keep the same for less emphasis
      fontSize: 14,
    ),
  );

  // AppBar theme
  static AppBarTheme appBarTheme = const AppBarTheme(
    backgroundColor: AppTheme.background, // Light beige
    elevation: 0,
    iconTheme: IconThemeData(color: AppTheme.darkText), // Dark blue text color
    titleTextStyle: TextStyle(
      fontFamily: fontName,
      color: AppTheme.darkText,
      fontWeight: FontWeight.bold,
      fontSize: 20,
    ),
  );

  // Icon theme
  static IconThemeData iconTheme = const IconThemeData(
    color: AppTheme.darkText, // Dark blue text color
    size: 24,
  );

  static ThemeData themeData(BuildContext context) {
    return ThemeData(
      primaryColor: AppTheme.primaryColor, // Dark teal
      scaffoldBackgroundColor: AppTheme.background, // Light beige
      textTheme: AppTheme.textTheme,
      buttonTheme: ButtonThemeData(
        buttonColor: AppTheme.accentColor, // Orange
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
        background: AppTheme.background, // Light beige
        primary: AppTheme.primaryColor, // Dark teal
        onPrimary: AppTheme.white, // White
      ),
    );
  }
}
