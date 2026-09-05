import 'package:flutter/material.dart';

import '../foundations/colors.dart';
import '../foundations/spacing.dart';

/// A centered empty state sliver that fills the remaining viewport.
///
/// Designed for use in [CustomScrollView] or [ThanksScaffold] to display an
/// empty or not-found state that stays vertically and horizontally centered in
/// the available page area below app bars and filters.
///
/// At least one of [icon], [title], [subtitle], or [action] must be provided.
class ThanksSliverEmptyState extends StatelessWidget {
  const ThanksSliverEmptyState({
    super.key,
    this.icon,
    this.title,
    this.subtitle,
    this.action,
    this.titleStyle,
    this.subtitleStyle,
    this.padding = ThanksSpacing.insetMedium,
    this.maxWidth = 400.0,
  }) : assert(
         icon != null || title != null || subtitle != null || action != null,
         'At least one of icon, title, subtitle, or action must be provided.',
       );

  /// An optional icon or visual asset displayed at the top.
  final Widget? icon;

  /// An optional headline string.
  final String? title;

  /// An optional descriptive subtitle string.
  final String? subtitle;

  /// An optional action button or widget displayed at the bottom.
  final Widget? action;

  /// An optional custom [TextStyle] for the [title].
  final TextStyle? titleStyle;

  /// An optional custom [TextStyle] for the [subtitle].
  final TextStyle? subtitleStyle;

  /// The padding around the empty state content.
  final EdgeInsetsGeometry padding;

  /// The maximum horizontal width for the content column.
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    final effectiveTitleStyle =
        titleStyle ??
        textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: ThanksColors.textPrimary,
        ) ??
        const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: ThanksColors.textPrimary,
        );

    final effectiveSubtitleStyle =
        subtitleStyle ??
        textTheme.bodyMedium?.copyWith(
          color: ThanksColors.textSecondary,
        ) ??
        const TextStyle(
          fontSize: 14,
          color: ThanksColors.textSecondary,
        );

    return SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Padding(
            padding: padding,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) icon!,
                if (icon != null &&
                    (title != null || subtitle != null || action != null))
                  ThanksSpacing.spaceMedium,
                if (title != null)
                  Text(
                    title!,
                    style: effectiveTitleStyle,
                    textAlign: TextAlign.center,
                  ),
                if (title != null && subtitle != null) ThanksSpacing.spaceSmall,
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: effectiveSubtitleStyle,
                    textAlign: TextAlign.center,
                  ),
                if (action != null &&
                    (icon != null || title != null || subtitle != null))
                  const SizedBox(height: 20),
                if (action != null) action!,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
