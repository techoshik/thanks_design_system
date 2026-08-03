import 'package:flutter/material.dart';

/// Colour values that remain consistent across Thanks brands.
abstract final class ThanksColors {
  static const success = Color(0xFF1B7F43);
  static const warning = Color(0xFFB45309);
  static const error = Color(0xFFBA1A1A);
  static const surface = Color(0xFFFFFFFF);
  static const onSurface = Color(0xFF1B1B1F);
  static const outline = Color(0xFF74777F);
}

/// Brand-specific colours used to build a [ThanksTheme].
@immutable
class ThanksBrand {
  const ThanksBrand({
    required this.primary,
    required this.primaryContainer,
    required this.onPrimaryContainer,
  });

  static const defaultBrand = ThanksBrand(
    primary: Color(0xFF0757F2),
    primaryContainer: Color(0xFFE8F0FF),
    onPrimaryContainer: Color(0xFF092A5E),
  );

  final Color primary;
  final Color primaryContainer;
  final Color onPrimaryContainer;
}
