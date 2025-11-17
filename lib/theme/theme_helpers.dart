import 'package:flutter/material.dart';
import 'app_palette.dart';

extension ThemeHelpers on BuildContext {
  ColorScheme get colors => Theme.of(this).colorScheme;

  AppPalette get palette {
    final ext = Theme.of(this).extension<AppPalette>();
    if (ext != null) return ext;
    // Fallback: construct from colorScheme when extension missing
    return AppPalette.light().copyWith(
      // best-effort: map primary/surface variants
      primaryLight: colors.primary,
      primaryDark: colors.primary,
    );
  }
}
