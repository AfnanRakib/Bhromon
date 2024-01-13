import 'package:flutter/material.dart';

class ColorSys {
  static Color primary = Color.fromRGBO(52, 43, 37, 1);
  static Color gray = Color.fromRGBO(137, 137, 137, 1);
  static Color secoundry = Color.fromRGBO(198, 116, 27, 1);
  static Color secoundryLight = Color.fromRGBO(90, 185, 141, 1);
}

class Strings {
  static var stepOneTitle = "Farm Driving";
  static var stepOneContent = "There are all kinds of equipment to build your farm better harvest";
  static var stepTwoTitle = "Plant Growing";
  static var stepTwoContent = "Be part of the agriculture and gives your team the  power you need to do your best";
  static var stepThreeTitle = "Fast Harvesting";
  static var stepThreeContent = "Your will be proud to be part of agriculture and it’s harvest";
}

class Constants {
  static String appName = "Bhromon";

  //Colors for theme
  static Color lightPrimary = Color(0xfffcfcff);
  static Color darkPrimary = Colors.black;
  static Color lightAccent = Colors.blueGrey[900]!;
  static Color darkAccent = Colors.white;
  static Color lightBG = Color(0xfffcfcff);
  static Color darkBG = Colors.black;
  static Color badgeColor = Colors.red;

  static ThemeData lightTheme = ThemeData(
    primaryColor: lightPrimary,
    hintColor: lightAccent,
    scaffoldBackgroundColor: lightBG,
    appBarTheme: AppBarTheme(
      elevation: 0,
      toolbarTextStyle: TextTheme(
        titleLarge: TextStyle(
          color: darkBG,
          fontSize: 18.0,
          fontWeight: FontWeight.w800,
        ),
      ).bodyMedium, titleTextStyle: TextTheme(
        titleLarge: TextStyle(
          color: darkBG,
          fontSize: 18.0,
          fontWeight: FontWeight.w800,
        ),
      ).titleLarge,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: darkPrimary,
    hintColor: darkAccent,
    scaffoldBackgroundColor: darkBG,
    appBarTheme: AppBarTheme(
      elevation: 0,
      toolbarTextStyle: TextTheme(
        titleLarge: TextStyle(
          color: lightBG,
          fontSize: 18.0,
          fontWeight: FontWeight.w800,
        ),
      ).bodyMedium, titleTextStyle: TextTheme(
      titleLarge: TextStyle(
        color: lightBG,
        fontSize: 18.0,
        fontWeight: FontWeight.w800,
      ),
    ).titleLarge,
    ),
  );
}
