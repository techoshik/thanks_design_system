import 'package:flutter/material.dart';

/// The production type scale, backed by the package-provided DM Sans font.
abstract final class ThanksTypography {
  static const fontFamily = 'DM Sans';
  static const fontPackage = 'thanks_design_system';

  static TextStyle _style({
    required double size,
    FontWeight weight = FontWeight.w400,
    double? height,
    double? letterSpacing,
    Color? color,
  }) =>
      TextStyle(
        fontFamily: fontFamily,
        package: fontPackage,
        fontSize: size,
        fontWeight: weight,
        height: height,
        letterSpacing: letterSpacing,
        color: color,
      );

  static TextTheme get textTheme => TextTheme(
        displayLarge: _style(size: 57, letterSpacing: -0.25),
        displayMedium: _style(size: 45),
        displaySmall: _style(size: 36),
        headlineLarge: _style(size: 32, letterSpacing: -0.32),
        headlineMedium: _style(
          size: 28,
          letterSpacing: -0.56,
          color: Colors.black87,
        ),
        headlineSmall: _style(size: 24, letterSpacing: -0.24),
        titleLarge: _style(
          size: 22,
          weight: FontWeight.w600,
          letterSpacing: -0.22,
          color: Colors.black87,
        ),
        titleMedium: _style(
          size: 16,
          weight: FontWeight.w600,
          color: Colors.black87,
        ),
        titleSmall: _style(size: 14, weight: FontWeight.w600),
        bodyLarge: _style(size: 14, height: 1.6),
        bodyMedium: _style(size: 14, height: 1.6),
        bodySmall: _style(size: 12, height: 1.5),
        labelLarge: _style(
          size: 12,
          weight: FontWeight.w500,
          letterSpacing: 0.24,
          color: Colors.black45,
        ),
        labelMedium: _style(
          size: 11,
          weight: FontWeight.w500,
          letterSpacing: 0.22,
          color: Colors.black45,
        ),
        labelSmall: _style(size: 11, color: Colors.black45),
      );

  static TextStyle get mono => const TextStyle(
        fontFamily: 'monospace',
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: Colors.black87,
      );
}
