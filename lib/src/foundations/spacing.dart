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

  static const double iconSmall = 20;
  static const double iconMedium = 40;
  static const double iconLarge = 60;

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

  static const insetSmallHorizontal = EdgeInsets.symmetric(horizontal: small);
  static const insetMediumHorizontal = EdgeInsets.symmetric(horizontal: medium);
  static const insetMediumVertical = EdgeInsets.symmetric(vertical: medium);
  static const insetMediumWithFab = EdgeInsets.fromLTRB(
    medium,
    medium,
    medium,
    fabClearance,
  );
}

/// Spacing and dimension tokens exposed through [ThanksTheme].
///
/// [ThanksSpacing] remains the internal source used to construct the
/// production theme. Consumers should read these values through
/// `ThanksTheme.of(context).spacing`.
@immutable
class ThanksSpacingTokens {
  const ThanksSpacingTokens({
    required this.extraSmall,
    required this.small,
    required this.medium,
    required this.radiusSmall,
    required this.radiusMedium,
    required this.radiusFull,
    required this.iconSmall,
    required this.iconMedium,
    required this.iconLarge,
    required this.appBarHeight,
    required this.inputHeight,
    required this.buttonHeight,
    required this.navigationDrawerWidthLeft,
    required this.navigationDrawerWidthRight,
    required this.viewHeightMinimum,
    required this.formWidthMinimum,
    required this.formWidthMaximum,
    required this.fabClearance,
    required this.contentWidthForm,
    required this.contentWidthWorkspace,
    required this.inputFieldWidthFilter,
  });

  static const defaults = ThanksSpacingTokens(
    extraSmall: ThanksSpacing.extraSmall,
    small: ThanksSpacing.small,
    medium: ThanksSpacing.medium,
    radiusSmall: ThanksSpacing.radiusSmall,
    radiusMedium: ThanksSpacing.radiusMedium,
    radiusFull: ThanksSpacing.radiusFull,
    iconSmall: ThanksSpacing.iconSmall,
    iconMedium: ThanksSpacing.iconMedium,
    iconLarge: ThanksSpacing.iconLarge,
    appBarHeight: ThanksSpacing.appBarHeight,
    inputHeight: ThanksSpacing.inputHeight,
    buttonHeight: ThanksSpacing.buttonHeight,
    navigationDrawerWidthLeft: ThanksSpacing.navigationDrawerWidthLeft,
    navigationDrawerWidthRight: ThanksSpacing.navigationDrawerWidthRight,
    viewHeightMinimum: ThanksSpacing.viewHeightMinimum,
    formWidthMinimum: ThanksSpacing.formWidthMinimum,
    formWidthMaximum: ThanksSpacing.formWidthMaximum,
    fabClearance: ThanksSpacing.fabClearance,
    contentWidthForm: ThanksSpacing.contentWidthForm,
    contentWidthWorkspace: ThanksSpacing.contentWidthWorkspace,
    inputFieldWidthFilter: ThanksSpacing.inputFieldWidthFilter,
  );

  final double extraSmall;
  final double small;
  final double medium;
  final double radiusSmall;
  final double radiusMedium;
  final double radiusFull;
  final double iconSmall;
  final double iconMedium;
  final double iconLarge;
  final double appBarHeight;
  final double inputHeight;
  final double buttonHeight;
  final double navigationDrawerWidthLeft;
  final double navigationDrawerWidthRight;
  final double viewHeightMinimum;
  final double formWidthMinimum;
  final double formWidthMaximum;
  final double fabClearance;
  final FitSize contentWidthForm;
  final FitSize contentWidthWorkspace;
  final double inputFieldWidthFilter;

  EdgeInsets get inputContentPadding => EdgeInsets.symmetric(
    horizontal: medium,
    vertical: (inputHeight - medium) / 2,
  );

  SizedBox get spaceExtraSmall => SizedBox.square(dimension: extraSmall);
  SizedBox get spaceSmall => SizedBox.square(dimension: small);
  SizedBox get spaceMedium => SizedBox.square(dimension: medium);

  EdgeInsets get insetExtraSmall => EdgeInsets.all(extraSmall);
  EdgeInsets get insetSmall => EdgeInsets.all(small);
  EdgeInsets get insetSmallHorizontal =>
      EdgeInsets.symmetric(horizontal: small);
  EdgeInsets get insetMedium => EdgeInsets.all(medium);
  EdgeInsets get insetMediumHorizontal =>
      EdgeInsets.symmetric(horizontal: medium);
  EdgeInsets get insetMediumVertical => EdgeInsets.symmetric(vertical: medium);
  EdgeInsets get insetSmallWithLeftMedium =>
      EdgeInsets.fromLTRB(medium, small, small, small);
  EdgeInsets get insetMediumWithFab =>
      EdgeInsets.fromLTRB(medium, medium, medium, fabClearance);
}
