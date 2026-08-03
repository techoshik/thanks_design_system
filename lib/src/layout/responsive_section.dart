import 'package:flutter/widgets.dart';

import '../foundations/spacing.dart';

/// Centres content and constrains its width on larger displays.
class ResponsiveSection extends StatelessWidget {
  const ResponsiveSection({
    required this.child,
    super.key,
    this.maxWidth = 1200,
    this.padding = const EdgeInsets.all(ThanksSpacing.medium),
  });

  final Widget child;
  final double maxWidth;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) => Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Padding(padding: padding, child: child),
        ),
      );
}
