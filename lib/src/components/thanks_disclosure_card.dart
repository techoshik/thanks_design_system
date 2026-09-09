import 'package:flutter/material.dart';

import '../foundations/spacing.dart';
import 'thanks_button.dart';
import 'thanks_card.dart';

/// A controlled, accessible card that reveals supporting details inline.
///
/// The host owns [expanded] state and receives changes through
/// [onExpandedChanged]. The entire card surface and the visible chevron toggle the
/// disclosure, while [actions] stay independent so their interactions do not
/// collapse or expand the card.
class ThanksDisclosureCard extends StatelessWidget {
  const ThanksDisclosureCard({
    required this.summary,
    required this.details,
    required this.semanticLabel,
    required this.expanded,
    required this.onExpandedChanged,
    super.key,
    this.actions = const [],
    this.collapsedContent,
    this.variant = ThanksCardVariant.filledOutlined,
    this.padding = ThanksCardSpacing.medium,
    this.radius = ThanksCardSpacing.medium,
  });

  /// Compact, always-visible information for the item.
  final Widget summary;

  /// Full-width content visible only while [expanded] is false.
  ///
  /// Use this for a compact preview that [details] replaces after expansion.
  final Widget? collapsedContent;

  /// Supporting information visible only while [expanded] is true.
  final Widget details;

  /// The item name used to label the expand/collapse controls.
  final String semanticLabel;

  /// Whether [details] are currently visible.
  final bool expanded;

  /// Reports the requested expanded state to the host.
  final ValueChanged<bool> onExpandedChanged;

  /// Independent trailing actions, such as an overflow menu.
  final List<Widget> actions;

  /// The shared card surface treatment.
  final ThanksCardVariant variant;

  /// The shared card content padding.
  final ThanksCardSpacing padding;

  /// The shared card corner-radius preset.
  final ThanksCardSpacing radius;

  String get _toggleLabel =>
      '${expanded ? 'Collapse' : 'Expand'} $semanticLabel';

  void _toggle() => onExpandedChanged(!expanded);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      explicitChildNodes: true,
      button: true,
      expanded: expanded,
      label: _toggleLabel,
      child: ThanksCard(
        variant: variant,
        padding: padding,
        radius: radius,
        onTap: _toggle,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: summary),
                if (actions.isNotEmpty) ...[
                  ThanksSpacing.spaceSmall,
                  Row(mainAxisSize: MainAxisSize.min, children: actions),
                ],
                ThanksButton.icon(
                  icon: Icon(
                    expanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                  ),
                  tooltip: _toggleLabel,
                  variant: ThanksButtonVariant.text,
                  onPressed: _toggle,
                ),
              ],
            ),
            if (!expanded && collapsedContent != null) ...[
              ThanksSpacing.spaceSmall,
              collapsedContent!,
            ],
            if (expanded) ...[
              ThanksSpacing.spaceMedium,
              const Divider(),
              ThanksSpacing.spaceMedium,
              details,
            ],
          ],
        ),
      ),
    );
  }
}
