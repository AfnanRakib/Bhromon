import 'package:flutter/material.dart';

final lightTheme = ThemeData(
    colorScheme: ThemeData.light().colorScheme.copyWith(
        primary: Colors.amber,
        onPrimary: Colors.black,
        secondary: Colors.amberAccent,
        onSecondary: Colors.white));
final darkTheme = ThemeData.dark().copyWith(
    colorScheme: ThemeData.dark().colorScheme.copyWith(
        primary: Colors.black54,
        onPrimary: Colors.white,
        secondary: Colors.greenAccent,
        onSecondary: Colors.white));
