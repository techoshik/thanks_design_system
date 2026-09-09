import 'package:flutter/material.dart';

import '../foundations/colors.dart';
import '../foundations/spacing.dart';

/// The semantic colour treatment applied to a [ThanksStatusBadge].
///
/// Each tone maps to a dedicated background/foreground/border triple from
/// [ThanksColors], keeping badge colours consistent with the design system's
/// semantic colour vocabulary.
enum ThanksBadgeTone {
  /// Green — active, complete, or successful states (e.g. *Published*).
  success,

  /// Amber — attention or transitional states (e.g. *Draft*, *Pending*).
  warning,

  /// Red — blocked, failed, or terminal states (e.g. *Archived*, *Rejected*).
  danger,

  /// Grey — inactive or de-emphasised states (e.g. *Inactive*, *Closed*).
  neutral,

  /// Brand blue — highlighted or in-progress states (e.g. *Submitted*).
  primary,
}

/// The size preset controlling padding and text scale of a [ThanksStatusBadge].
enum ThanksBadgeSize {
  /// Compact pill — suitable for table rows, list tiles, and inline chips.
  ///
  /// Padding: [ThanksSpacing.extraSmall] vertical × [ThanksSpacing.small]
  /// horizontal. Text: [TextTheme.labelMedium]. Icon size: 12.
  small,

  /// Standard pill — suitable for cards and prominent status indicators.
  ///
  /// Padding: [ThanksSpacing.small] vertical × [ThanksSpacing.medium]
  /// horizontal. Text: [TextTheme.labelLarge]. Icon size: 14.
  medium,
}

/// A compact, read-only status indicator pill from the Thanks design system.
///
/// Use [ThanksStatusBadge] to communicate the semantic state of a record
/// (e.g. *active*, *draft*, *archived*) anywhere in a Thanks application.
/// The badge enforces design-system colour tokens through [ThanksBadgeTone]
/// and delegates icon colouring to [IconTheme] so callers provide unstyled
/// icon widgets.
///
/// ```dart
/// ThanksStatusBadge(
///   label: 'Published',
///   tone: ThanksBadgeTone.success,
///   icon: const Icon(Icons.check_circle_outline),
/// )
/// ```
///
/// See also:
/// - [ThanksBadgeTone] for the available semantic colour treatments.
/// - [ThanksBadgeSize] for the two size presets; defaults to [ThanksBadgeSize.small].
class ThanksStatusBadge extends StatelessWidget {
  /// Creates a [ThanksStatusBadge].
  ///
  /// [label] and [tone] are required. [size] defaults to
  /// [ThanksBadgeSize.small]. [icon] is optional; pass an unstyled [Icon]
  /// widget — the badge wraps it in an [IconTheme] that applies the correct
  /// foreground colour automatically.
  const ThanksStatusBadge({
    required this.label,
    required this.tone,
    this.icon,
    this.size = ThanksBadgeSize.small,
    super.key,
  });

  /// The text displayed inside the badge.
  final String label;

  /// The semantic colour treatment applied to the badge surface and text.
  final ThanksBadgeTone tone;

  /// An optional leading icon widget.
  ///
  /// Pass an unstyled [Icon] (without an explicit [Icon.color]); the badge
  /// wraps it in an [IconTheme] that applies the tone's foreground colour.
  final Widget? icon;

  /// Controls the padding and text scale of the badge.
  ///
  /// Defaults to [ThanksBadgeSize.small].
  final ThanksBadgeSize size;

  // ---------------------------------------------------------------------------
  // Internal colour resolution
  // ---------------------------------------------------------------------------

  /// Resolves the three design-system colours for [tone].
  ({Color background, Color foreground, Color border}) get _colours =>
      switch (tone) {
        ThanksBadgeTone.success => (
          background: ThanksColors.successBackground,
          foreground: ThanksColors.success,
          border: ThanksColors.successBorder,
        ),
        ThanksBadgeTone.warning => (
          background: ThanksColors.warningBackground,
          foreground: ThanksColors.warning,
          border: ThanksColors.warningBorder,
        ),
        ThanksBadgeTone.danger => (
          background: ThanksColors.dangerBackground,
          foreground: ThanksColors.danger,
          border: ThanksColors.dangerBorder,
        ),
        ThanksBadgeTone.neutral => (
          background: ThanksColors.surface2,
          foreground: ThanksColors.textSecondary,
          border: ThanksColors.border,
        ),
        ThanksBadgeTone.primary => (
          background: ThanksColors.primary50,
          foreground: ThanksColors.primary500,
          border: ThanksColors.primary100,
        ),
      };

  /// Resolves the padding preset for [size].
  EdgeInsets get _padding => switch (size) {
    ThanksBadgeSize.small => const EdgeInsets.symmetric(
      horizontal: ThanksSpacing.small,
    ),
    ThanksBadgeSize.medium => const EdgeInsets.symmetric(
      vertical: ThanksSpacing.extraSmall,
      horizontal: ThanksSpacing.medium,
    ),
  };

  /// Resolves the icon size for [size].
  double get _iconSize => switch (size) {
    ThanksBadgeSize.small => 12,
    ThanksBadgeSize.medium => 14,
  };

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colours = _colours;

    final labelStyle = switch (size) {
      ThanksBadgeSize.small => textTheme.labelMedium,
      ThanksBadgeSize.medium => textTheme.labelLarge,
    };

    Widget content = Text(
      label,
      style: labelStyle?.copyWith(color: colours.foreground),
    );

    if (icon != null) {
      content = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconTheme(
            data: IconThemeData(color: colours.foreground, size: _iconSize),
            child: icon!,
          ),
          ThanksSpacing.spaceExtraSmall,
          content,
        ],
      );
    }

    return Container(
      padding: _padding,
      decoration: BoxDecoration(
        color: colours.background,
        border: Border.all(color: colours.border),
        borderRadius: BorderRadius.circular(ThanksSpacing.radiusFull),
      ),
      child: content,
    );
  }
}
