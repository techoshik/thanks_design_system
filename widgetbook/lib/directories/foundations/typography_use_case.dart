import 'package:flutter/material.dart';
import 'package:thanks_design_system/thanks_design_system.dart';

Widget typographyUseCase(BuildContext context) {
  final materialTheme = Theme.of(context);
  final theme = ThanksTheme.of(context);
  final spacing = theme.spacing;
  final textTheme = materialTheme.textTheme;
  final styles = <({String name, TextStyle? style})>[
    (name: 'displayLarge', style: textTheme.displayLarge),
    (name: 'headlineSmall', style: textTheme.headlineSmall),
    (name: 'titleLarge', style: textTheme.titleLarge),
    (name: 'titleMedium', style: textTheme.titleMedium),
    (name: 'bodyLarge', style: textTheme.bodyLarge),
    (name: 'bodyMedium', style: textTheme.bodyMedium),
    (name: 'labelLarge', style: textTheme.labelLarge),
    (name: 'labelMedium', style: textTheme.labelMedium),
    (name: 'mono', style: theme.mono),
  ];

  return Scaffold(
    backgroundColor: materialTheme.scaffoldBackgroundColor,
    body: ListView(
      padding: spacing.insetMedium,
      children: [
        Text('Theme-owned typography', style: textTheme.headlineSmall),
        SizedBox(height: spacing.small),
        Text(
          'Standard text styles come from Theme.of(context).textTheme. '
          'The monospace style is provided by ThanksTheme for technical values.',
          style: textTheme.bodyMedium,
        ),
        SizedBox(height: spacing.medium),
        for (final entry in styles)
          Padding(
            padding: EdgeInsets.only(bottom: spacing.medium),
            child: Container(
              padding: spacing.insetMedium,
              decoration: BoxDecoration(
                color: materialTheme.colorScheme.surface,
                border: Border.all(
                  color: materialTheme.colorScheme.outlineVariant,
                ),
                borderRadius: BorderRadius.circular(spacing.radiusSmall),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(entry.name, style: textTheme.labelMedium),
                  SizedBox(height: spacing.small),
                  Text('Thanks design system', style: entry.style),
                ],
              ),
            ),
          ),
      ],
    ),
  );
}
