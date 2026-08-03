import 'package:flutter/widgets.dart';

/// Standard dimensions used throughout Thanks applications.
abstract final class ThanksSpacing {
  static const double small = 8;
  static const double medium = 16;
  static const double large = 24;

  static const double radiusSmall = 8;
  static const double radiusLarge = 16;
  static const double radiusFull = 100;

  static const double appBarHeight = 64;
  static const double navigationDrawerWidth = 260;
  static const double rightNavigationDrawerWidth = 344;
  static const double viewHeightMinimum = 304;
  static const double formWidthMinimum = 300;
  static const double formWidthMaximum = 450;
  static const double fabClearance = 100;
  static const double inputHeight = 40;
  static const double inputHeightSmall = 32;

  static const inputContentPadding = EdgeInsets.symmetric(
    horizontal: medium,
    vertical: (inputHeight - medium) / 2,
  );
  static const dialogConstraints = BoxConstraints(
    minWidth: 350,
    maxWidth: 600,
  );

  static const spaceSmall = SizedBox.square(dimension: small);
  static const spaceMedium = SizedBox.square(dimension: medium);
  static const spaceLarge = SizedBox.square(dimension: large);

  static const insetSmall = EdgeInsets.symmetric(
    horizontal: small,
    vertical: small / 2,
  );
  static const insetSmallWithLeftMedium = EdgeInsets.fromLTRB(
    medium,
    small,
    small,
    small,
  );
  static const insetMedium = EdgeInsets.symmetric(
    horizontal: medium,
    vertical: medium / 2,
  );
  static final insetMediumTop0 = insetMedium.copyWith(top: 0);
  static final insetMediumBottom0 = insetMedium.copyWith(bottom: 0);
  static const insetLarge = EdgeInsets.symmetric(
    horizontal: large,
    vertical: large / 2,
  );

  static const insetSmallSymmetric = EdgeInsets.all(small);
  static const insetMediumSymmetric = EdgeInsets.all(medium);
  static const insetLargeSymmetric = EdgeInsets.all(large);
  static const insetSmallHorizontal = EdgeInsets.symmetric(horizontal: small);
  static const insetMediumHorizontal = EdgeInsets.symmetric(
    horizontal: medium,
  );
  static const insetLargeHorizontal = EdgeInsets.symmetric(horizontal: large);
  static const insetLargeVertical = EdgeInsets.symmetric(vertical: large);
  static const insetMediumVertical = EdgeInsets.symmetric(vertical: medium);
  static const insetLargeWithFab = EdgeInsets.fromLTRB(
    large,
    large,
    large,
    fabClearance,
  );
  static const insetPageVertical = EdgeInsets.only(
    top: large,
    bottom: fabClearance,
  );

  // Compatibility aliases retained during package adoption.
  static const double xSmall = small;
  static const double xLarge = 32;
  static const double controlHeight = inputHeight;
}
