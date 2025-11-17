import 'package:flutter/material.dart';
import 'app_colors.dart';
// import 'package:icongrega/theme/color_schemes.dart';

@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  // Brand
  final Color primaryLight;
  final Color primaryDark;
  final Color primaryHoverLight;
  final Color primaryHoverDark;
  final Color light;
  final Color dark;

  // Semantic
  final Color dangerLight;
  final Color dangerDark;
  final Color dangerHoverLight;
  final Color dangerHoverDark;
  final Color warningLight;
  final Color warningDark;
  final Color warningHoverLight;
  final Color warningHoverDark;
  final Color infoLight;
  final Color infoDark;
  final Color infoHoverLight;
  final Color infoHoverDark;
  final Color successLight;
  final Color successDark;
  final Color successHoverLight;
  final Color successHoverDark;

  // Background tiers
  final Color botLight;
  final Color botDark;
  final Color midLight;
  final Color midDark;
  final Color topLight;
  final Color topDark;

  // Neutral
  final Color neutralPrimaryLight;
  final Color neutralPrimaryDark;
  final Color neutralSecondaryLight;
  final Color neutralSecondaryDark;
  final Color neutralMidLight;
  final Color neutralMidDark;
  final Color neutralBlack;
  final Color neutralWhite;

  const AppPalette({
    // Brand
    required this.primaryLight,
    required this.primaryDark,
    required this.primaryHoverLight,
    required this.primaryHoverDark,
    required this.light,
    required this.dark,
    // Semantic
    required this.dangerLight,
    required this.dangerDark,
    required this.dangerHoverLight,
    required this.dangerHoverDark,
    required this.warningLight,
    required this.warningDark,
    required this.warningHoverLight,
    required this.warningHoverDark,
    required this.infoLight,
    required this.infoDark,
    required this.infoHoverLight,
    required this.infoHoverDark,
    required this.successLight,
    required this.successDark,
    required this.successHoverLight,
    required this.successHoverDark,
    // Background tiers
    required this.botLight,
    required this.botDark,
    required this.midLight,
    required this.midDark,
    required this.topLight,
    required this.topDark,
    // Neutral
    required this.neutralPrimaryLight,
    required this.neutralPrimaryDark,
    required this.neutralSecondaryLight,
    required this.neutralSecondaryDark,
    required this.neutralMidLight,
    required this.neutralMidDark,
    required this.neutralBlack,
    required this.neutralWhite,
  });

  factory AppPalette.light() => const AppPalette(
        primaryLight: AppColors.primaryLight,
        primaryDark: AppColors.primaryDark,
        primaryHoverLight: AppColors.primaryHoverLight,
        primaryHoverDark: AppColors.primaryHoverDark,
        light: AppColors.light,
        dark: AppColors.dark,
        dangerLight: AppColors.dangerLight,
        dangerDark: AppColors.dangerDark,
        dangerHoverLight: AppColors.dangerHoverLight,
        dangerHoverDark: AppColors.dangerHoverDark,
        warningLight: AppColors.warningLight,
        warningDark: AppColors.warningDark,
        warningHoverLight: AppColors.warningHoverLight,
        warningHoverDark: AppColors.warningHoverDark,
        infoLight: AppColors.infoLight,
        infoDark: AppColors.infoDark,
        infoHoverLight: AppColors.infoHoverLight,
        infoHoverDark: AppColors.infoHoverDark,
        successLight: AppColors.successLight,
        successDark: AppColors.successDark,
        successHoverLight: AppColors.successHoverLight,
        successHoverDark: AppColors.successHoverDark,
        botLight: AppColors.botLight,
        botDark: AppColors.botDark,
        midLight: AppColors.midLight,
        midDark: AppColors.midDark,
        topLight: AppColors.topLight,
        topDark: AppColors.topDark,
        neutralPrimaryLight: AppColors.neutralPrimaryLight,
        neutralPrimaryDark: AppColors.neutralPrimaryDark,
        neutralSecondaryLight: AppColors.neutralSecondaryLight,
        neutralSecondaryDark: AppColors.neutralSecondaryDark,
        neutralMidLight: AppColors.neutralMidLight,
        neutralMidDark: AppColors.neutralMidDark,
        neutralBlack: AppColors.neutralBlack,
        neutralWhite: AppColors.neutralWhite,
      );

  factory AppPalette.dark() => const AppPalette(
        primaryLight: AppColors.primaryLight,
        primaryDark: AppColors.primaryDark,
        primaryHoverLight: AppColors.primaryHoverLight,
        primaryHoverDark: AppColors.primaryHoverDark,
        light: AppColors.light,
        dark: AppColors.dark,
        dangerLight: AppColors.dangerLight,
        dangerDark: AppColors.dangerDark,
        dangerHoverLight: AppColors.dangerHoverLight,
        dangerHoverDark: AppColors.dangerHoverDark,
        warningLight: AppColors.warningLight,
        warningDark: AppColors.warningDark,
        warningHoverLight: AppColors.warningHoverLight,
        warningHoverDark: AppColors.warningHoverDark,
        infoLight: AppColors.infoLight,
        infoDark: AppColors.infoDark,
        infoHoverLight: AppColors.infoHoverLight,
        infoHoverDark: AppColors.infoHoverDark,
        successLight: AppColors.successLight,
        successDark: AppColors.successDark,
        successHoverLight: AppColors.successHoverLight,
        successHoverDark: AppColors.successHoverDark,
        botLight: AppColors.botLight,
        botDark: AppColors.botDark,
        midLight: AppColors.midLight,
        midDark: AppColors.midDark,
        topLight: AppColors.topLight,
        topDark: AppColors.topDark,
        neutralPrimaryLight: AppColors.neutralPrimaryLight,
        neutralPrimaryDark: AppColors.neutralPrimaryDark,
        neutralSecondaryLight: AppColors.neutralSecondaryLight,
        neutralSecondaryDark: AppColors.neutralSecondaryDark,
        neutralMidLight: AppColors.neutralMidLight,
        neutralMidDark: AppColors.neutralMidDark,
        neutralBlack: AppColors.neutralBlack,
        neutralWhite: AppColors.neutralWhite,
      );

  @override
  AppPalette copyWith({
    Color? primaryLight,
    Color? primaryDark,
    Color? primaryHoverLight,
    Color? primaryHoverDark,
    Color? light,
    Color? dark,
    Color? dangerLight,
    Color? dangerDark,
    Color? dangerHoverLight,
    Color? dangerHoverDark,
    Color? warningLight,
    Color? warningDark,
    Color? warningHoverLight,
    Color? warningHoverDark,
    Color? infoLight,
    Color? infoDark,
    Color? infoHoverLight,
    Color? infoHoverDark,
    Color? successLight,
    Color? successDark,
    Color? successHoverLight,
    Color? successHoverDark,
    Color? botLight,
    Color? botDark,
    Color? midLight,
    Color? midDark,
    Color? topLight,
    Color? topDark,
    Color? neutralPrimaryLight,
    Color? neutralPrimaryDark,
    Color? neutralSecondaryLight,
    Color? neutralSecondaryDark,
    Color? neutralMidLight,
    Color? neutralMidDark,
    Color? neutralBlack,
    Color? neutralWhite,
  }) {
    return AppPalette(
      primaryLight: primaryLight ?? this.primaryLight,
      primaryDark: primaryDark ?? this.primaryDark,
      primaryHoverLight: primaryHoverLight ?? this.primaryHoverLight,
      primaryHoverDark: primaryHoverDark ?? this.primaryHoverDark,
      light: light ?? this.light,
      dark: dark ?? this.dark,
      dangerLight: dangerLight ?? this.dangerLight,
      dangerDark: dangerDark ?? this.dangerDark,
      dangerHoverLight: dangerHoverLight ?? this.dangerHoverLight,
      dangerHoverDark: dangerHoverDark ?? this.dangerHoverDark,
      warningLight: warningLight ?? this.warningLight,
      warningDark: warningDark ?? this.warningDark,
      warningHoverLight: warningHoverLight ?? this.warningHoverLight,
      warningHoverDark: warningHoverDark ?? this.warningHoverDark,
      infoLight: infoLight ?? this.infoLight,
      infoDark: infoDark ?? this.infoDark,
      infoHoverLight: infoHoverLight ?? this.infoHoverLight,
      infoHoverDark: infoHoverDark ?? this.infoHoverDark,
      successLight: successLight ?? this.successLight,
      successDark: successDark ?? this.successDark,
      successHoverLight: successHoverLight ?? this.successHoverLight,
      successHoverDark: successHoverDark ?? this.successHoverDark,
      botLight: botLight ?? this.botLight,
      botDark: botDark ?? this.botDark,
      midLight: midLight ?? this.midLight,
      midDark: midDark ?? this.midDark,
      topLight: topLight ?? this.topLight,
      topDark: topDark ?? this.topDark,
      neutralPrimaryLight: neutralPrimaryLight ?? this.neutralPrimaryLight,
      neutralPrimaryDark: neutralPrimaryDark ?? this.neutralPrimaryDark,
      neutralSecondaryLight: neutralSecondaryLight ?? this.neutralSecondaryLight,
      neutralSecondaryDark: neutralSecondaryDark ?? this.neutralSecondaryDark,
      neutralMidLight: neutralMidLight ?? this.neutralMidLight,
      neutralMidDark: neutralMidDark ?? this.neutralMidDark,
      neutralBlack: neutralBlack ?? this.neutralBlack,
      neutralWhite: neutralWhite ?? this.neutralWhite,
    );
  }

  @override
  AppPalette lerp(ThemeExtension<AppPalette>? other, double t) {
    if (other is! AppPalette) return this;
    return AppPalette(
      primaryLight: Color.lerp(primaryLight, other.primaryLight, t)!,
      primaryDark: Color.lerp(primaryDark, other.primaryDark, t)!,
      primaryHoverLight: Color.lerp(primaryHoverLight, other.primaryHoverLight, t)!,
      primaryHoverDark: Color.lerp(primaryHoverDark, other.primaryHoverDark, t)!,
      light: Color.lerp(light, other.light, t)!,
      dark: Color.lerp(dark, other.dark, t)!,
      dangerLight: Color.lerp(dangerLight, other.dangerLight, t)!,
      dangerDark: Color.lerp(dangerDark, other.dangerDark, t)!,
      dangerHoverLight: Color.lerp(dangerHoverLight, other.dangerHoverLight, t)!,
      dangerHoverDark: Color.lerp(dangerHoverDark, other.dangerHoverDark, t)!,
      warningLight: Color.lerp(warningLight, other.warningLight, t)!,
      warningDark: Color.lerp(warningDark, other.warningDark, t)!,
      warningHoverLight: Color.lerp(warningHoverLight, other.warningHoverLight, t)!,
      warningHoverDark: Color.lerp(warningHoverDark, other.warningHoverDark, t)!,
      infoLight: Color.lerp(infoLight, other.infoLight, t)!,
      infoDark: Color.lerp(infoDark, other.infoDark, t)!,
      infoHoverLight: Color.lerp(infoHoverLight, other.infoHoverLight, t)!,
      infoHoverDark: Color.lerp(infoHoverDark, other.infoHoverDark, t)!,
      successLight: Color.lerp(successLight, other.successLight, t)!,
      successDark: Color.lerp(successDark, other.successDark, t)!,
      successHoverLight: Color.lerp(successHoverLight, other.successHoverLight, t)!,
      successHoverDark: Color.lerp(successHoverDark, other.successHoverDark, t)!,
      botLight: Color.lerp(botLight, other.botLight, t)!,
      botDark: Color.lerp(botDark, other.botDark, t)!,
      midLight: Color.lerp(midLight, other.midLight, t)!,
      midDark: Color.lerp(midDark, other.midDark, t)!,
      topLight: Color.lerp(topLight, other.topLight, t)!,
      topDark: Color.lerp(topDark, other.topDark, t)!,
      neutralPrimaryLight: Color.lerp(neutralPrimaryLight, other.neutralPrimaryLight, t)!,
      neutralPrimaryDark: Color.lerp(neutralPrimaryDark, other.neutralPrimaryDark, t)!,
      neutralSecondaryLight: Color.lerp(neutralSecondaryLight, other.neutralSecondaryLight, t)!,
      neutralSecondaryDark: Color.lerp(neutralSecondaryDark, other.neutralSecondaryDark, t)!,
      neutralMidLight: Color.lerp(neutralMidLight, other.neutralMidLight, t)!,
      neutralMidDark: Color.lerp(neutralMidDark, other.neutralMidDark, t)!,
      neutralBlack: Color.lerp(neutralBlack, other.neutralBlack, t)!,
      neutralWhite: Color.lerp(neutralWhite, other.neutralWhite, t)!,
    );
  }
}
