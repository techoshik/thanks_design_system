import 'dart:math' as math;

import 'package:fit_it/fit_it.dart';
import 'package:flutter/material.dart';

import '../foundations/spacing.dart';

/// A responsive Bootstrap-style grid with twelve logical columns.
class ThanksGrid extends StatelessWidget {
  const ThanksGrid({
    super.key,
    required this.children,
    this.gap = ThanksSpacing.medium,
    this.runGap,
    this.alignment = WrapAlignment.start,
    this.crossAxisAlignment = WrapCrossAlignment.start,
  });

  static const columnCount = 12;

  final List<ThanksGridItem> children;
  final double gap;
  final double? runGap;
  final WrapAlignment alignment;
  final WrapCrossAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    final fitSize = FitSize.parse(MediaQuery.sizeOf(context).width);

    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;
        final totalGutterWidth = gap * (columnCount - 1);
        final columnWidth = math
            .max(0, (availableWidth - totalGutterWidth) / columnCount)
            .toDouble();

        return Wrap(
          spacing: gap,
          runSpacing: runGap ?? gap,
          alignment: alignment,
          crossAxisAlignment: crossAxisAlignment,
          children: [
            for (final item in children)
              SizedBox(
                width: _itemWidth(
                  columnWidth: columnWidth,
                  span: item.spanFor(fitSize),
                  gap: gap,
                  availableWidth: availableWidth,
                ),
                child: item,
              ),
          ],
        );
      },
    );
  }

  static double _itemWidth({
    required double columnWidth,
    required int span,
    required double gap,
    required double availableWidth,
  }) {
    if (span == columnCount) return availableWidth;
    return (columnWidth * span) + (gap * (span - 1));
  }
}

/// A child of [ThanksGrid] with a column span for each responsive breakpoint.
///
/// Unspecified spans inherit from the previous smaller breakpoint.
class ThanksGridItem extends StatelessWidget {
  const ThanksGridItem({
    super.key,
    required this.child,
    this.mobile = ThanksGrid.columnCount,
    this.tablet,
    this.laptop,
    this.desktop,
    this.desktopLarge,
  }) : assert(mobile > 0 && mobile <= ThanksGrid.columnCount),
       assert(
         tablet == null || (tablet > 0 && tablet <= ThanksGrid.columnCount),
       ),
       assert(
         laptop == null || (laptop > 0 && laptop <= ThanksGrid.columnCount),
       ),
       assert(
         desktop == null || (desktop > 0 && desktop <= ThanksGrid.columnCount),
       ),
       assert(
         desktopLarge == null ||
             (desktopLarge > 0 && desktopLarge <= ThanksGrid.columnCount),
       );

  final Widget child;
  final int mobile;
  final int? tablet;
  final int? laptop;
  final int? desktop;
  final int? desktopLarge;

  int spanFor(FitSize size) {
    return switch (size) {
      FitSize.mobile => mobile,
      FitSize.tablet => tablet ?? mobile,
      FitSize.laptop => laptop ?? tablet ?? mobile,
      FitSize.desktop => desktop ?? laptop ?? tablet ?? mobile,
      FitSize.desktopLarge =>
        desktopLarge ?? desktop ?? laptop ?? tablet ?? mobile,
    };
  }

  @override
  Widget build(BuildContext context) => child;
}
