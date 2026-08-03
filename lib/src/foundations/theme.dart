import 'package:flutter/material.dart';

import 'colors.dart';
import 'spacing.dart';
import 'typography.dart';

/// Creates Material themes from shared foundations and a selected brand.
abstract final class ThanksTheme {
  static ThemeData light({ThanksBrand brand = ThanksBrand.defaultBrand}) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: brand.primary,
      brightness: Brightness.light,
    ).copyWith(
      primary: brand.primary,
      primaryContainer: brand.primaryContainer,
      onPrimaryContainer: brand.onPrimaryContainer,
      error: ThanksColors.error,
      surface: ThanksColors.surface,
      onSurface: ThanksColors.onSurface,
      outline: ThanksColors.outline,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: ThanksTypography.textTheme,
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(
          horizontal: ThanksSpacing.medium,
          vertical: ThanksSpacing.small,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(0, ThanksSpacing.controlHeight),
          padding: const EdgeInsets.symmetric(horizontal: ThanksSpacing.medium),
        ),
      ),
      cardTheme: const CardThemeData(
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
      ),
    );
  }
}
