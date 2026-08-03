import 'package:flutter/material.dart';

/// Shared colour tokens used by Thanks applications.
abstract final class ThanksColors {
  static const primary50 = Color(0xFFEBF0FD);
  static const primary100 = Color(0xFFC5D5F8);
  static const primary200 = Color(0xFF8FAEF0);
  static const primary400 = Color(0xFF4F78E0);
  static const primary500 = Color(0xFF1B4FD8);
  static const primary600 = Color(0xFF1435A8);
  static const primary800 = Color(0xFF0D2278);
  static const primary950 = Color(0xFF060F44);

  static const pageBackground = Color(0xFFF7F6F3);
  static const border = Color(0xFFE2DFD8);
  static const borderStrong = Color(0xFFC8C4BB);
  static const surface = Color(0xFFFFFFFF);
  static const surface2 = Color(0xFFF0EEE9);

  static const textPrimary = Colors.black87;
  static const textSecondary = Colors.black54;
  static const textMuted = Colors.black45;

  static const success = Color(0xFF1A7A4A);
  static const successBackground = Color(0xFFE8F7EE);
  static const successBorder = Color(0xFFB2DDCA);
  static const warning = Color(0xFF8A5A00);
  static const warningBackground = Color(0xFFFFF4D9);
  static const warningBorder = Color(0xFFFFDB80);
  static const danger = Color(0xFFB92B2B);
  static const dangerBackground = Color(0xFFFDEAEA);
  static const dangerBorder = Color(0xFFF4C0C0);
}

/// Brand-specific colours used to build a [ThanksTheme].
@immutable
class ThanksBrand {
  const ThanksBrand({
    required this.primary,
    required this.primaryContainer,
    required this.onPrimaryContainer,
    this.secondary,
  });

  static const defaultBrand = ThanksBrand(
    primary: ThanksColors.primary500,
    primaryContainer: ThanksColors.primary50,
    onPrimaryContainer: ThanksColors.textPrimary,
    secondary: ThanksColors.primary400,
  );

  final Color primary;
  final Color primaryContainer;
  final Color onPrimaryContainer;
  final Color? secondary;
}
