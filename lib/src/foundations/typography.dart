import 'package:flutter/material.dart';

/// Typography helpers that consistently use the package-provided DM Sans font.
abstract final class ThanksTypography {
  static const fontFamily = 'DM Sans';
  static const fontPackage = 'thanks_design_system';

  static TextTheme textTheme = const TextTheme().apply(
    fontFamily: fontFamily,
    package: fontPackage,
  );
}
