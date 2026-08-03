import 'package:flutter/material.dart';

import '../foundations/spacing.dart';

/// Standard surface for grouped Thanks content.
class ThanksCard extends StatelessWidget {
  const ThanksCard({required this.child, super.key, this.margin, this.padding});

  final Widget child;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) => Card(
        margin: margin,
        child: Padding(
          padding: padding ?? const EdgeInsets.all(ThanksSpacing.medium),
          child: child,
        ),
      );
}
