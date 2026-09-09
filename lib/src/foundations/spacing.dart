import 'package:flutter/widgets.dart';
import 'package:fit_it/fit_it.dart';

/// Standard dimensions used throughout Thanks applications.
abstract final class ThanksSpacing {
  static const double extraSmall = 4.0;
  static const double small = 8.0;
  static const double medium = 16.0;

  static const double radiusSmall = small;
  static const double radiusMedium = medium;
  static const double radiusFull = 100;

  static const double appBarHeight = 64;
  static const double inputHeight = 40;
  static const double buttonHeight = inputHeight - 8;

  static const double navigationDrawerWidthLeft = 260;
  static const double navigationDrawerWidthRight = 360;
  static const double viewHeightMinimum = 304;
  static const double formWidthMinimum = 300;
  static const double formWidthMaximum = 450;
  static const double fabClearance = 132;

  /// Centered maximum width for forms, editors, and focused detail content.
  static const FitSize contentWidthForm = FitSize.tablet;

  /// Centered maximum width for operational lists and workspace content.
  static const FitSize contentWidthWorkspace = FitSize.desktop;

  static const double inputFieldWidthFilter = 240;

  static const inputContentPadding = EdgeInsets.symmetric(
    horizontal: medium,
    vertical: (inputHeight - medium) / 2,
  );
  static const dialogConstraints = BoxConstraints(minWidth: 350, maxWidth: 600);

  static const spaceExtraSmall = SizedBox.square(dimension: extraSmall);
  static const spaceSmall = SizedBox.square(dimension: small);
  static const spaceMedium = SizedBox.square(dimension: medium);

  static const insetExtraSmall = EdgeInsets.all(extraSmall);
  static const insetSmall = EdgeInsets.all(small);
  static const insetSmallWithLeftMedium = EdgeInsets.fromLTRB(
    medium,
    small,
    small,
    small,
  );
  static const insetMedium = EdgeInsets.all(medium);
  static final insetMediumTop0 = insetMedium.copyWith(top: 0);
  static final insetMediumBottom0 = insetMedium.copyWith(bottom: 0);

  static const insetExtraSmallHorizontal = EdgeInsets.symmetric(
    horizontal: extraSmall,
  );
  static const insetSmallHorizontal = EdgeInsets.symmetric(horizontal: small);
  static const insetMediumHorizontal = EdgeInsets.symmetric(horizontal: medium);
  static const insetMediumVertical = EdgeInsets.symmetric(vertical: medium);
  static const insetMediumWithFab = EdgeInsets.fromLTRB(
    medium,
    medium,
    medium,
    fabClearance,
  );
  static const insetPageVertical = EdgeInsets.only(
    top: medium,
    bottom: fabClearance,
  );
}
