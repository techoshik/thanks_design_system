import 'package:flutter/widgets.dart';

/// A responsive grid whose children determine their own content.
class ThanksGrid extends StatelessWidget {
  const ThanksGrid({
    required this.children,
    super.key,
    this.minItemWidth = 280,
    this.spacing = 16,
  });

  final List<Widget> children;
  final double minItemWidth;
  final double spacing;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) {
          final count = (constraints.maxWidth / (minItemWidth + spacing))
              .floor()
              .clamp(1, children.length);
          return Wrap(
            spacing: spacing,
            runSpacing: spacing,
            children: children
                .map((child) => SizedBox(
                      width: (constraints.maxWidth - spacing * (count - 1)) /
                          count,
                      child: child,
                    ))
                .toList(),
          );
        },
      );
}

/// A semantic wrapper for a [ThanksGrid] child.
class ThanksGridItem extends StatelessWidget {
  const ThanksGridItem({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) => child;
}
