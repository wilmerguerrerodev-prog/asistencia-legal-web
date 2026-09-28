import 'package:flutter/material.dart';

ThemeData dark = ThemeData(
  fontFamily: 'Ubuntu',
  dividerTheme: const DividerThemeData(
    color: Color(0xFFC0BFBF),
  ),
  primaryColor: const Color(0xFF010D15),
  primaryColorLight: const Color(0xFF1A202C),
  primaryColorDark: const Color(0xFF081F2F),
  secondaryHeaderColor: const Color(0xFF6BA7F3),

  disabledColor: const Color(0xFF8797AB),
  scaffoldBackgroundColor: const Color(0xFF151515),
  brightness: Brightness.dark,
  hintColor: const Color(0xFFC0BFBF),
  focusColor: const Color(0xFF484848),
  hoverColor: const Color(0x400461A5),
  shadowColor: const Color(0x33e2f1ff),
  cardColor: const Color(0xFF10324A),
  textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(
      foregroundColor: const Color(0xFFFFFFFF))), colorScheme: const ColorScheme.dark(primary: Color(0xFF056AB4), secondary: Color(0xFFf57d00), tertiary: (Color(0xFFFF6767))).copyWith(surface: const Color(0xff010D15)).copyWith(error: const Color(0xFFdd3135)),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Color(0xFFF8FAFC)),
    bodyMedium: TextStyle(color: Color(0xFFE2E8F0)),
    bodySmall: TextStyle(color: Color(0xFF94A3B8)),
    titleLarge: TextStyle(color: Color(0xFFFFFFFF)),
    titleMedium: TextStyle(color: Color(0xFFF8FAFC)),
    titleSmall: TextStyle(color: Color(0xFFE2E8F0)),
    labelLarge: TextStyle(color: Color(0xFFF8FAFC)),
    labelMedium: TextStyle(color: Color(0xFFCBD5E1)),
    labelSmall: TextStyle(color: Color(0xFF94A3B8)),
  ),
);

// semi-dark-light-color