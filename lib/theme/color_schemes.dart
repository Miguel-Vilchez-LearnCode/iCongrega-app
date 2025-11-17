import 'package:flutter/material.dart';
import 'app_colors.dart';

final lightColorScheme = ColorScheme.light(
  primary: AppColors.primaryLight,
  onPrimary: Colors.black,
  secondary: AppColors.infoLight,
  onSecondary: Colors.white,
  surface: AppColors.botLight,
  onSurface: AppColors.neutralSecondaryLight,
  error: AppColors.dangerLight,
  onError: Colors.white,
  surfaceContainer: AppColors.midLight,
  background: Colors.black,
  shadow: Colors.black12,
  outline: Colors.black12,
  outlineVariant: AppColors.neutralMidDark,
  surfaceVariant: AppColors.topLight,
);

final darkColorScheme = ColorScheme.dark(
  primary: AppColors.primaryDark,
  onPrimary: Colors.black,
  secondary: AppColors.infoDark,
  onSecondary: Colors.black,
  surface: AppColors.botDark,
  onSurface: AppColors.neutralWhite,
  error: AppColors.dangerDark,
  onError: Colors.black,
  surfaceContainer: AppColors.midDark,
  background: Colors.white,
  shadow: const Color.fromARGB(12, 255, 255, 255),
  outline: Colors.white12,
  outlineVariant: Colors.white12,
  surfaceVariant: AppColors.topDark,
);
