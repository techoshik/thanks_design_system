import 'package:fit_it/fit_it.dart';
import 'package:flutter/material.dart';

export 'package:fit_it/fit_it.dart' show FitContainer, FitIt, FitSize;

import '../foundations/spacing.dart';

/// A standard content section container with consistent vertical spacing,
/// responsive horizontal gutters, optional maximum width constraints,
/// and optional header with title, subtitle, and trailing action.
class ThanksSection extends StatelessWidget {
  const ThanksSection({
    super.key,
    this.title,
    this.subtitle,
    this.trailing,
    required this.child,
    this.verticalPadding = ThanksSpacing.medium,
    this.maxWidth = ThanksSpacing.contentWidthWorkspace,
    this.enableGutter = true,
    this.backgroundColor,
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

  /// The maximum size constraint for the section content, using [FitContainer].
  ///
  /// Defaults to [ThanksSpacing.contentWidthWorkspace]. Pass `null` to allow content
  /// to expand unconstrained horizontally.
  final FitSize? maxWidth;

  /// Whether to apply horizontal responsive gutter padding to the content.
  ///
  /// Defaults to `true` (16.0 on mobile/tablet, 32.0 on desktop).
  final bool enableGutter;

  /// An optional background color that fills the entire width of the section,
  /// extending edge-to-edge across the gutters.
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasHeader = title != null || subtitle != null || trailing != null;

    Widget content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (hasHeader) ...[
          ListTile(
            title: Text(title ?? '', style: theme.textTheme.titleMedium),
            subtitle: subtitle != null
                ? Text(
                    subtitle!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  )
                : null,
            trailing: trailing,
          ),
          ThanksSpacing.spaceExtraSmall,
        ],
        child,
      ],
    );

    if (enableGutter) {
      content = Padding(
        padding: EdgeInsets.symmetric(horizontal: _horizontalGutter(context)),
        child: content,
      );
    }

    if (maxWidth != null) {
      content = FitContainer(maxFitSize: maxWidth, child: content);
    }

    content = Padding(
      padding: EdgeInsets.symmetric(vertical: verticalPadding),
      child: content,
    );

    if (backgroundColor != null) {
      content = Container(
        color: backgroundColor,
        width: double.infinity,
        child: content,
      );
    }

    return content;
  }

  double _horizontalGutter(BuildContext context) {
    final size = FitSize.parse(MediaQuery.sizeOf(context).width);
    return size.isDesktopOrAbove
        ? ThanksSpacing.medium * 4
        : size.isTabletOrAbove
        ? ThanksSpacing.medium * 2
        : ThanksSpacing.medium;
  }
}
