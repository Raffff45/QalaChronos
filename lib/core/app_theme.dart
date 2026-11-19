import 'package:flutter/material.dart';

const gold = Color(0xFFC6AD7C);
const darkBg = Color(0xFF101C19);
const panelBg = Color(0xFF1A3029);

ThemeData buildAppTheme() {
  return ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    scaffoldBackgroundColor: darkBg,
    colorScheme: const ColorScheme.dark(
      primary: gold,
      onPrimary: darkBg,
      surface: panelBg,
    ),
    appBarTheme: const AppBarTheme(backgroundColor: darkBg),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: const Color(0xFF0C1714),
      indicatorColor: gold.withValues(alpha: 0.16),
      iconTheme: WidgetStateProperty.resolveWith(
        (states) => IconThemeData(
          color: states.contains(WidgetState.selected)
              ? gold
              : Colors.white.withValues(alpha: 0.6),
        ),
      ),
      labelTextStyle: WidgetStateProperty.resolveWith(
        (states) => TextStyle(
          fontSize: 12,
          color: states.contains(WidgetState.selected)
              ? gold
              : Colors.white.withValues(alpha: 0.6),
        ),
      ),
    ),
  );
}