import 'package:flutter/widgets.dart';

import '../foundations/spacing.dart';

/// A vertical content grouping with consistent outer spacing.
class Section extends StatelessWidget {
  const Section({
    required this.child,
    super.key,
    this.padding = const EdgeInsets.symmetric(vertical: ThanksSpacing.large),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) => Padding(padding: padding, child: child);
}
