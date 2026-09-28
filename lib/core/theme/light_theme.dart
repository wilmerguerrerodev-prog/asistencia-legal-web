import 'package:flutter/material.dart';

ThemeData light = ThemeData(
  fontFamily: 'Ubuntu',
  dividerTheme: const DividerThemeData(
    color: Color(0x40C0BFBF),
  ),
  primaryColor: const Color(0xFF056AB4),
  primaryColorLight: const Color(0xFFF0F4F8),
  primaryColorDark: const Color(0xFF10324A),
  secondaryHeaderColor: const Color(0xFF248BFF),


  disabledColor: const Color(0xFF8797AB),
  scaffoldBackgroundColor: const Color(0xffE7F0FC),
  brightness: Brightness.light,
  hintColor: const Color(0xFFC0BFBF),
  focusColor: const Color(0xFFFFF9E5),
  hoverColor: const Color(0xFFF1F7FC),
  shadowColor: const Color(0x211B7FED),
  cardColor: Colors.white,
  dividerColor: const Color(0xFFC0BFBF),
  textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(foregroundColor: const Color(0xFF0461A5))),
  colorScheme: const ColorScheme.light(
      primary: Color(0xFF056AB4),
      secondary: Color(0xFFFF9900),
      tertiary: Color(0xFFd35221)).copyWith(surface: const Color(0xffFCFCFC)).copyWith(error: const Color(0xFFFF6767)),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Color(0xFF1E293B)),
    bodyMedium: TextStyle(color: Color(0xFF334155)),
    bodySmall: TextStyle(color: Color(0xFF64748B)),
    titleLarge: TextStyle(color: Color(0xFF0F172A)),
    titleMedium: TextStyle(color: Color(0xFF1E293B)),
    titleSmall: TextStyle(color: Color(0xFF334155)),
    labelLarge: TextStyle(color: Color(0xFF1E293B)),
    labelMedium: TextStyle(color: Color(0xFF475569)),
    labelSmall: TextStyle(color: Color(0xFF64748B)),
  ),
  // colorScheme: const ColorScheme.light(
  //     primary: Colors.white,
  //     secondary: Color(0xFFFF9681),
  //     primaryContainer: Colors.white,
  //     tertiary: Colors.white,),
);