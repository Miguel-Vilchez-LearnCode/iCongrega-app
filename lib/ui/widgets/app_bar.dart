import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icongrega/theme/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    required this.title,
    this.backgroundColor,
    this.elevation = 4,
    this.shadowColor = Colors.black45,
    this.centerTitle = true,
    this.showBack = true,
    this.onBack,
    this.actions,
    this.leading,
  });

  final String title;
  final Color? backgroundColor;
  final double elevation;
  final Color shadowColor;
  final bool centerTitle;

  // Back behavior
  final bool showBack;
  final VoidCallback? onBack;

  // Optional extra widgets
  final List<Widget>? actions;
  final Widget? leading;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.primary,
      elevation: elevation,
      shadowColor: shadowColor,
      centerTitle: centerTitle,
      leading:
          leading ??
          (showBack
              ? IconButton(
                  icon: Icon(Icons.arrow_back, color: AppColors.botDark),
                  onPressed: onBack ?? () => Navigator.of(context).pop(),
                )
              : null),
      title: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.botDark,
        ),
      ),
      actions: actions,
    );
  }
}
