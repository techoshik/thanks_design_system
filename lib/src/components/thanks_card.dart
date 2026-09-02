import 'package:flutter/material.dart';

import '../foundations/colors.dart';
import '../foundations/spacing.dart';
import '../foundations/theme.dart';

/// The visual surface treatment used by [ThanksCard].
enum ThanksCardVariant {
  /// Transparent background and no border. Useful for logical grouping without
  /// visual boundaries.
  none,

  /// Solid surface background with no border.
  filled,

  /// Transparent background with an outline border.
  outlined,

  /// Solid surface background with an outline border.
  filledOutlined,
}

/// Spacing preset sizes for [ThanksCard] padding and margin.
enum ThanksCardSpacing {
  /// Zero spacing (`0px`).
  none,

  /// Compact spacing (`8px`).
  small,

  /// Standard spacing (`16px`).
  medium;

  /// Returns the corresponding symmetric [EdgeInsets].
  EdgeInsets get insets => switch (this) {
        ThanksCardSpacing.none => EdgeInsets.zero,
        ThanksCardSpacing.small => const EdgeInsets.all(ThanksSpacing.small),
        ThanksCardSpacing.medium => const EdgeInsets.all(ThanksSpacing.medium),
      };
}

/// The placement of the title, subtitle, and actions relative to the card surface.
enum ThanksCardHeaderPosition {
  /// Places the header outside and above the card surface container.
  ///
  /// **When to use [outside]:**
  /// - **Page & Form Sections**: Use for section-level groupings (e.g., "Personal
  ///   Details", "Security & Login", "Billing Information").
  /// - **Settings Screens**: Where a label and descriptive subtitle sit above
  ///   an inset card container holding form controls or list items.
  /// - **Main Page Cards**: Keeps the card surface clean and focused on content
  ///   without visual competition from header elements.
  outside,

  /// Places the header inside the card surface container, above the content child.
  ///
  /// **When to use [inside]:**
  /// - **Self-Contained Tiles & Widgets**: Metric cards, KPI tiles, pricing plan
  ///   cards, and dashboard overview items.
  /// - **Interactive & Tappable Cards**: Cards with [onTap] callbacks where the
  ///   header needs to be part of the interactive surface with hover/tap ripples.
  /// - **Grid & List Items**: Multiple cards arranged in a grid or list where
  ///   each card is an independent entity.
  /// - **Nested Sub-Cards**: When a card is placed inside a larger outer main card.
  inside,
}

/// A standard card surface for Thanks applications.
///
/// Can be used as a top-level page card or nested within other cards.
/// Supports [variant] surface styling (`none`, `filled`, `outlined`, `filledOutlined`),
/// customizable [padding] and [margin] spacing presets, [onTap] interactions,
/// and header placement via [headerPosition] (`outside` or `inside`).
///
/// Use [ThanksCardHeaderPosition.outside] for page sections and form groups, or
/// [ThanksCardHeaderPosition.inside] for self-contained tiles, interactive cards,
/// and nested widgets.
class ThanksCard extends StatelessWidget {
  const ThanksCard({
    required this.child,
    super.key,
    this.title,
    this.subtitle,
    this.actions = const [],
    this.headerPosition = ThanksCardHeaderPosition.outside,
    this.variant = ThanksCardVariant.none,
    this.padding = ThanksCardSpacing.none,
    this.margin = ThanksCardSpacing.none,
    this.customPadding,
    this.customMargin,
    this.showDivider = false,
    this.borderRadius,
    this.onTap,
  });

  /// The primary content rendered inside the card.
  final Widget child;

  /// The header title displayed in the card header.
  final String? title;

  /// The secondary text displayed beneath [title].
  final String? subtitle;

  /// Action widgets rendered to the right of [title] and [subtitle].
  final List<Widget> actions;

  /// Whether the header is rendered [outside] (above) or [inside] the card surface.
  ///
  /// See [ThanksCardHeaderPosition] for detailed placement guidelines.
  final ThanksCardHeaderPosition headerPosition;

  /// The visual treatment of the card container.
  final ThanksCardVariant variant;

  /// Internal padding preset for the card content.
  final ThanksCardSpacing padding;

  /// External margin preset around the entire card widget.
  final ThanksCardSpacing margin;

  /// Explicit internal padding overriding [padding].
  final EdgeInsetsGeometry? customPadding;

  /// Explicit external margin overriding [margin].
  final EdgeInsetsGeometry? customMargin;

  /// Whether to render a divider between the inside header and the [child].
  ///
  /// Only applies when [headerPosition] is [ThanksCardHeaderPosition.inside]
  /// and a header is present.
  final bool showDivider;

  /// Custom border radius for the card surface. Defaults to [ThanksSpacing.radiusLarge] (16px).
  final BorderRadiusGeometry? borderRadius;

  /// Optional callback invoked when the card is tapped.
  final VoidCallback? onTap;

  bool get _hasHeader =>
      title != null || subtitle != null || actions.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final thanksTheme = theme.extension<ThanksTheme>();
    final surfaceColor = thanksTheme?.surfaceElevated ?? ThanksColors.surface;
    final borderColor = thanksTheme?.borderSubtle ?? ThanksColors.border;

    final effectiveMargin = customMargin ?? margin.insets;
    final effectivePadding = customPadding ?? padding.insets;
    final effectiveRadius =
        borderRadius ?? BorderRadius.circular(ThanksSpacing.radiusLarge);

    final isOutsideHeader = _hasHeader &&
        headerPosition == ThanksCardHeaderPosition.outside;
    final isInsideHeader = _hasHeader &&
        headerPosition == ThanksCardHeaderPosition.inside;

    Widget surfaceContent = child;

    if (isInsideHeader) {
      final headerWidget = _buildHeader(context);
      surfaceContent = Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          headerWidget,
          if (showDivider) ...[
            ThanksSpacing.spaceSmall,
            Divider(color: borderColor, height: 1),
            ThanksSpacing.spaceSmall,
          ] else ...[
            ThanksSpacing.spaceSmall,
          ],
          child,
        ],
      );
    }

    // Apply internal padding
    surfaceContent = Padding(
      padding: effectivePadding,
      child: surfaceContent,
    );

    // Build the visual card surface
    final surface = _buildSurface(
      context: context,
      surfaceColor: surfaceColor,
      borderColor: borderColor,
      borderRadius: effectiveRadius,
      content: surfaceContent,
    );

    Widget rootWidget;
    if (isOutsideHeader) {
      final headerWidget = _buildHeader(context);
      rootWidget = Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          headerWidget,
          ThanksSpacing.spaceSmall,
          surface,
        ],
      );
    } else {
      rootWidget = surface;
    }

    if (effectiveMargin != EdgeInsets.zero) {
      rootWidget = Padding(
        padding: effectiveMargin,
        child: rootWidget,
      );
    }

    return rootWidget;
  }

  Widget _buildHeader(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (title != null || subtitle != null)
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title != null)
                  Text(
                    title!,
                    style: textTheme.titleMedium,
                  ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: textTheme.bodySmall?.copyWith(
                          color: ThanksColors.textSecondary,
                        ) ??
                        const TextStyle(
                          fontSize: 12,
                          color: ThanksColors.textSecondary,
                        ),
                  ),
              ],
            ),
          )
        else
          const Spacer(),
        if (actions.isNotEmpty) ...[
          if (title != null || subtitle != null)
            ThanksSpacing.spaceSmall,
          Row(
            mainAxisSize: MainAxisSize.min,
            spacing: ThanksSpacing.small,
            children: actions,
          ),
        ],
      ],
    );
  }

  Widget _buildSurface({
    required BuildContext context,
    required Color surfaceColor,
    required Color borderColor,
    required BorderRadiusGeometry borderRadius,
    required Widget content,
  }) {
    final (backgroundColor, border) = switch (variant) {
      ThanksCardVariant.none => (Colors.transparent, null),
      ThanksCardVariant.filled => (surfaceColor, null),
      ThanksCardVariant.outlined => (
          Colors.transparent,
          Border.all(color: borderColor),
        ),
      ThanksCardVariant.filledOutlined => (
          surfaceColor,
          Border.all(color: borderColor),
        ),
    };

    if (onTap != null) {
      return Material(
        color: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius,
          side: border == null ? BorderSide.none : border.top,
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          borderRadius: borderRadius.resolve(Directionality.of(context)),
          child: content,
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        border: border,
        borderRadius: borderRadius,
      ),
      clipBehavior:
          variant == ThanksCardVariant.none ? Clip.none : Clip.antiAlias,
      child: content,
    );
  }
}
