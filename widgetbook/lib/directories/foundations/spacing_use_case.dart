import 'package:flutter/material.dart';
import 'package:thanks_design_system/thanks_design_system.dart';

Widget spacingUseCase(BuildContext context) {
  final materialTheme = Theme.of(context);
  final theme = ThanksTheme.of(context);
  final spacing = theme.spacing;
  final dimensions = <({String name, double value})>[
    (name: 'extraSmall', value: spacing.extraSmall),
    (name: 'small', value: spacing.small),
    (name: 'medium', value: spacing.medium),
    (name: 'inputHeight', value: spacing.inputHeight),
    (name: 'buttonHeight', value: spacing.buttonHeight),
    (name: 'appBarHeight', value: spacing.appBarHeight),
    (name: 'fabClearance', value: spacing.fabClearance),
    (name: 'formWidthMinimum', value: spacing.formWidthMinimum),
    (name: 'formWidthMaximum', value: spacing.formWidthMaximum),
    (name: 'filterFieldWidth', value: spacing.inputFieldWidthFilter),
  ];

  return Scaffold(
    backgroundColor: materialTheme.scaffoldBackgroundColor,
    body: ListView(
      padding: spacing.insetMedium,
      children: [
        Text(
          'Theme-owned dimensions',
          style: materialTheme.textTheme.titleLarge,
        ),
        SizedBox(height: spacing.small),
        Text(
          'Spacing and sizing are read from ThanksTheme.of(context).spacing.',
          style: materialTheme.textTheme.bodyMedium,
        ),
        SizedBox(height: spacing.medium),
        for (final dimension in dimensions)
          _DimensionRow(name: dimension.name, value: dimension.value),
        SizedBox(height: spacing.medium),
        Text('Radii', style: materialTheme.textTheme.titleLarge),
        SizedBox(height: spacing.small),
        Wrap(
          spacing: spacing.medium,
          runSpacing: spacing.medium,
          children: [
            _RadiusCard(label: 'small', radius: spacing.radiusSmall),
            _RadiusCard(label: 'medium', radius: spacing.radiusMedium),
            _RadiusCard(label: 'full', radius: spacing.radiusFull),
          ],
        ),
        SizedBox(height: spacing.medium),
        Text('Composed insets', style: materialTheme.textTheme.titleLarge),
        SizedBox(height: spacing.small),
        Wrap(
          spacing: spacing.medium,
          runSpacing: spacing.medium,
          children: [
            _InsetCard(label: 'small', inset: spacing.insetSmall),
            _InsetCard(label: 'medium', inset: spacing.insetMedium),
            _InsetCard(
              label: 'mediumWithFab',
              inset: spacing.insetMediumWithFab,
            ),
          ],
        ),
      ],
    ),
  );
}

class _DimensionRow extends StatelessWidget {
  const _DimensionRow({required this.name, required this.value});

  final String name;
  final double value;

  @override
  Widget build(BuildContext context) {
    final spacing = ThanksTheme.of(context).spacing;
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: spacing.small),
      child: Row(
        children: [
          SizedBox(
            width: 180,
            child: Text(name, style: theme.textTheme.bodyMedium),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: value.clamp(4, 420),
                height: spacing.small,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
          SizedBox(width: spacing.small),
          Text(
            '${value.toStringAsFixed(0)}px',
            style: theme.textTheme.labelMedium,
          ),
        ],
      ),
    );
  }
}

class _RadiusCard extends StatelessWidget {
  const _RadiusCard({required this.label, required this.radius});

  final String label;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final spacing = ThanksTheme.of(context).spacing;
    final theme = Theme.of(context);
    return Container(
      width: 150,
      height: 80,
      padding: spacing.insetSmall,
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        border: Border.all(color: theme.colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(radius),
      ),
      alignment: Alignment.bottomLeft,
      child: Text(label, style: theme.textTheme.labelMedium),
    );
  }
}

class _InsetCard extends StatelessWidget {
  const _InsetCard({required this.label, required this.inset});

  final String label;
  final EdgeInsets inset;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = ThanksTheme.of(context).spacing;
    return Container(
      color: theme.colorScheme.surfaceContainerHighest,
      padding: inset,
      child: Container(
        width: 130,
        height: 54,
        padding: spacing.insetSmall,
        color: theme.colorScheme.surface,
        alignment: Alignment.center,
        child: Text(label, style: theme.textTheme.labelMedium),
      ),
    );
  }
}
