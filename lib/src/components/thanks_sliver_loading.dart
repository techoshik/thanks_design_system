import 'package:flutter/material.dart';

import '../foundations/colors.dart';
import '../foundations/spacing.dart';

/// A centered loading indicator sliver that fills the remaining viewport.
///
/// Designed for use in [CustomScrollView] or [ThanksScaffold] to display a
/// loading state that stays vertically and horizontally centered in the
/// available page area below app bars and filters.
class ThanksSliverLoading extends StatelessWidget {
  const ThanksSliverLoading({
    super.key,
    this.message,
    this.color = ThanksColors.primary500,
    this.strokeWidth = 3.0,
    this.semanticsLabel,
  });

  /// An optional status message displayed below the loading indicator.
  final String? message;

  /// The color of the progress indicator.
  final Color color;

  /// The width of the circular progress indicator line.
  final double strokeWidth;

  /// Semantic label for accessibility.
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: Padding(
          padding: ThanksSpacing.insetMedium,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                strokeWidth: strokeWidth,
                color: color,
                semanticsLabel: semanticsLabel,
              ),
              if (message != null) ...[
                ThanksSpacing.spaceMedium,
                Text(
                  message!,
                  style: const TextStyle(
                    color: ThanksColors.textSecondary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
