import 'package:flutter/material.dart';

import '../foundations/spacing.dart';

/// A standard content section container with consistent vertical spacing
/// and optional header with title, subtitle, and trailing action.
class ThanksSection extends StatelessWidget {
  const ThanksSection({
    super.key,
    this.title,
    this.subtitle,
    this.trailing,
    required this.child,
    this.verticalPadding = ThanksSpacing.medium,
  });

  /// Optional section title rendered using [TextTheme.titleMedium].
  final String? title;

  /// Optional subtitle rendered below [title] using [TextTheme.bodySmall].
  final String? subtitle;

  /// Optional action widget aligned to the trailing side of the header.
  final Widget? trailing;

  /// The primary content of this section.
  final Widget child;

  /// Vertical padding applied to the top and bottom of this section.
  ///
  /// Defaults to [ThanksSpacing.medium] (16.0), which creates an additive
  /// 32.0 gap between consecutive sections.
  final double verticalPadding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasHeader = title != null || subtitle != null || trailing != null;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: verticalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (hasHeader) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (title != null)
                        Text(title!, style: theme.textTheme.titleMedium),
                      if (subtitle != null) ...[
                        const SizedBox(height: ThanksSpacing.extraSmall),
                        Text(
                          subtitle!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (trailing != null) ...[
                  const SizedBox(width: ThanksSpacing.small),
                  trailing!,
                ],
              ],
            ),
            const SizedBox(height: ThanksSpacing.small),
          ],
          child,
        ],
      ),
    );
  }
}
