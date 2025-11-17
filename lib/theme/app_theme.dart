import 'package:flutter/material.dart';
import 'color_schemes.dart';
import 'app_palette.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    colorScheme: lightColorScheme,
    useMaterial3: true,
    extensions: <ThemeExtension<dynamic>>[
      AppPalette.light(),
    ],
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: lightColorScheme.primary,
        foregroundColor: lightColorScheme.onPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
  scaffoldBackgroundColor: lightColorScheme.surface,
    appBarTheme: AppBarTheme(
      backgroundColor: lightColorScheme.surface,
      foregroundColor: lightColorScheme.onSurface,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: lightColorScheme.onSurface),
      titleTextStyle: TextStyle(
        color: lightColorScheme.onSurface,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    ),
    cardTheme: CardThemeData(
      color: lightColorScheme.surface,
      elevation: 1,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    iconTheme: IconThemeData(color: lightColorScheme.onSurface),
  );

  static ThemeData darkTheme = ThemeData(
    colorScheme: darkColorScheme,
    useMaterial3: true,
    extensions: <ThemeExtension<dynamic>>[
      AppPalette.dark(),
    ],
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: darkColorScheme.primary,
        foregroundColor: darkColorScheme.onPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
  scaffoldBackgroundColor: darkColorScheme.surface,
    appBarTheme: AppBarTheme(
      backgroundColor: darkColorScheme.surface,
      foregroundColor: darkColorScheme.onSurface,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: darkColorScheme.onSurface),
      titleTextStyle: TextStyle(
        color: darkColorScheme.onSurface,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    ),
    cardTheme: CardThemeData(
      color: darkColorScheme.surface,
      elevation: 1,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    iconTheme: IconThemeData(color: darkColorScheme.onSurface),
  );
}
