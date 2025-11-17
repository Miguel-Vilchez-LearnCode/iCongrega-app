import 'package:flutter/material.dart';
import 'package:icongrega/theme/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:icongrega/providers/theme_provider.dart';
import 'package:icongrega/theme/theme_helpers.dart';

class ThemeToggleButton extends StatelessWidget {
  final bool showLabel;
  final IconData? lightIcon;
  final IconData? darkIcon;
  final IconData? systemIcon;
  final String? lightLabel;
  final String? darkLabel;
  final String? systemLabel;

  const ThemeToggleButton({
    super.key,
    this.showLabel = false,
    this.lightIcon = Icons.light_mode,
    this.darkIcon = Icons.dark_mode,
    this.systemIcon = Icons.brightness_auto,
    this.lightLabel = 'Claro',
    this.darkLabel = 'Oscuro',
    this.systemLabel = 'Sistema',
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return PopupMenuButton<ThemeMode>(
          icon: Icon(
            _getCurrentIcon(themeProvider.themeMode),
            color: context.colors.onSurface,
          ),
          onSelected: themeProvider.setThemeMode,
          itemBuilder: (context) => [
            PopupMenuItem(
              value: ThemeMode.light,
              child: Row(
                children: [
                  Icon(lightIcon, color: context.colors.background),
                  if (showLabel) ...[
                    const SizedBox(width: 8),
                    Text(lightLabel ?? 'Claro'),
                  ],
                ],
              ),
            ),
            PopupMenuItem(
              value: ThemeMode.dark,
              child: Row(
                children: [
                  Icon(darkIcon, color: context.colors.background),
                  if (showLabel) ...[
                    const SizedBox(width: 8),
                    Text(darkLabel ?? 'Oscuro'),
                  ],
                ],
              ),
            ),
            PopupMenuItem(
              value: ThemeMode.system,
              child: Row(
                children: [
                  Icon(systemIcon, color: context.colors.background),
                  if (showLabel) ...[
                    const SizedBox(width: 8),
                    Text(systemLabel ?? 'Sistema'),
                  ],
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  IconData _getCurrentIcon(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return lightIcon ?? Icons.light_mode_outlined;
      case ThemeMode.dark:
        return darkIcon ?? Icons.dark_mode_outlined;
      case ThemeMode.system:
        return systemIcon ?? Icons.brightness_auto_outlined;
    }
  }
}

class ThemeToggleSwitch extends StatelessWidget {
  final bool showLabel;
  final String? lightLabel;
  final String? darkLabel;

  const ThemeToggleSwitch({
    super.key,
    this.showLabel = true,
    this.lightLabel = 'Claro',
    this.darkLabel = 'Oscuro',
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Switch(
              value: themeProvider.isDarkMode,
              onChanged: (value) {
                if (value) {
                  themeProvider.setDarkTheme();
                } else {
                  themeProvider.setLightTheme();
                }
              },
              activeColor: AppColors.neutralMidDark,
            ),
          ],
        );
      },
    );
  }
}

class ThemeToggleChip extends StatelessWidget {
  final bool showLabel;
  final String? lightLabel;
  final String? darkLabel;
  final String? systemLabel;

  const ThemeToggleChip({
    super.key,
    this.showLabel = true,
    this.lightLabel = 'Claro',
    this.darkLabel = 'Oscuro',
    this.systemLabel = 'Sistema',
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Wrap(
          spacing: 8,
          children: [
            _buildChip(
              context,
              themeProvider,
              ThemeMode.light,
              lightLabel ?? 'Claro',
              Icons.light_mode,
            ),
            _buildChip(
              context,
              themeProvider,
              ThemeMode.dark,
              darkLabel ?? 'Oscuro',
              Icons.dark_mode,
            ),
            _buildChip(
              context,
              themeProvider,
              ThemeMode.system,
              systemLabel ?? 'Sistema',
              Icons.brightness_auto,
            ),
          ],
        );
      },
    );
  }

  Widget _buildChip(
    BuildContext context,
    ThemeProvider themeProvider,
    ThemeMode mode,
    String label,
    IconData icon,
  ) {
    final isSelected = themeProvider.themeMode == mode;

    return FilterChip(
      label: showLabel ? Text(label) : const SizedBox.shrink(),
      avatar: Icon(icon, size: 16),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          themeProvider.setThemeMode(mode);
        }
      },
      selectedColor: context.colors.primary.withOpacity(0.2),
      checkmarkColor: context.colors.primary,
      labelStyle: TextStyle(
        color: isSelected ? context.colors.primary : context.colors.onSurface,
      ),
    );
  }
}
