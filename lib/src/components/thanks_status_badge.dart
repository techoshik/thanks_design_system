import 'package:flutter/material.dart';

import '../foundations/spacing.dart';
import '../foundations/theme.dart';

/// The semantic colour treatment applied to a [ThanksStatusBadge].
///
/// Each tone maps to a dedicated background/foreground/border triple from
/// [ThanksTheme], keeping badge colours consistent with the active theme.
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
  ({Color background, Color foreground, Color border}) _colours(
    BuildContext context,
  ) {
    final theme = ThanksTheme.of(context);
    return switch (tone) {
      ThanksBadgeTone.success => (
        background: theme.success.subtle,
        foreground: theme.success.main,
        border: theme.success.border,
      ),
      ThanksBadgeTone.warning => (
        background: theme.warning.subtle,
        foreground: theme.warning.main,
        border: theme.warning.border,
      ),
      ThanksBadgeTone.danger => (
        background: theme.error.subtle,
        foreground: theme.error.main,
        border: theme.error.border,
      ),
      ThanksBadgeTone.neutral => (
        background: theme.surface.hover,
        foreground: theme.textSecondary,
        border: theme.borderSubtle,
      ),
      ThanksBadgeTone.primary => (
        background: theme.primary.subtle,
        foreground: theme.primary.main,
        border: theme.primary.border,
      ),
    };
  }

  /// Resolves the padding preset for [size].
  EdgeInsets _padding(BuildContext context) {
    final spacing = ThanksTheme.of(context).spacing;
    return switch (size) {
      ThanksBadgeSize.small => EdgeInsets.symmetric(horizontal: spacing.small),
      ThanksBadgeSize.medium => EdgeInsets.symmetric(
        vertical: spacing.extraSmall,
        horizontal: spacing.medium,
      ),
    };
  }

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
    final colours = _colours(context);

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
      padding: _padding(context),
      decoration: BoxDecoration(
        color: colours.background,
        border: Border.all(color: colours.border),
        borderRadius: BorderRadius.circular(ThanksSpacing.radiusFull),
      ),
      child: content,
    );
  }
}
