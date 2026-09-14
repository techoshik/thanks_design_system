import 'package:flutter/material.dart';
import 'package:thanks_design_system/thanks_design_system.dart';

Widget colorsUseCase(BuildContext context) {
  final materialTheme = Theme.of(context);
  final thanksTheme = ThanksTheme.of(context);
  final spacing = thanksTheme.spacing;
  final swatches = <({String name, Color color, Color textColor})>[
    (
      name: 'primary',
      color: materialTheme.colorScheme.primary,
      textColor: materialTheme.colorScheme.onPrimary,
    ),
    (
      name: 'primaryContainer',
      color: materialTheme.colorScheme.primaryContainer,
      textColor: materialTheme.colorScheme.onPrimaryContainer,
    ),
    (
      name: 'surface',
      color: materialTheme.colorScheme.surface,
      textColor: materialTheme.colorScheme.onSurface,
    ),
    (
      name: 'surfaceContainerHighest',
      color: materialTheme.colorScheme.surfaceContainerHighest,
      textColor: materialTheme.colorScheme.onSurface,
    ),
    (
      name: 'outlineVariant',
      color: materialTheme.colorScheme.outlineVariant,
      textColor: materialTheme.colorScheme.onSurface,
    ),
  ];

  return Scaffold(
    backgroundColor: materialTheme.scaffoldBackgroundColor,
    body: ListView(
      padding: spacing.insetMedium,
      children: [
        Text('Material color roles', style: materialTheme.textTheme.titleLarge),
        SizedBox(height: spacing.small),
        Wrap(
          spacing: spacing.medium,
          runSpacing: spacing.medium,
          children: [
            for (final swatch in swatches)
              _ColorCard(
                name: swatch.name,
                color: swatch.color,
                textColor: swatch.textColor,
              ),
          ],
        ),
        SizedBox(height: spacing.medium),
        Text(
          'Semantic status roles',
          style: materialTheme.textTheme.titleLarge,
        ),
        SizedBox(height: spacing.small),
        Wrap(
          spacing: spacing.medium,
          runSpacing: spacing.medium,
          children: [
            _PaletteCard(name: 'Primary', palette: thanksTheme.primary),
            _PaletteCard(name: 'Success', palette: thanksTheme.success),
            _PaletteCard(name: 'Warning', palette: thanksTheme.warning),
            _PaletteCard(name: 'Error', palette: thanksTheme.error),
            _PaletteCard(name: 'Info', palette: thanksTheme.info),
          ],
        ),
      ],
    ),
  );
}

class _ColorCard extends StatelessWidget {
  const _ColorCard({
    required this.name,
    required this.color,
    required this.textColor,
  });

  final String name;
  final Color color;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    final spacing = ThanksTheme.of(context).spacing;
    return Container(
      width: 150,
      height: 72,
      padding: spacing.insetSmall,
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(spacing.radiusSmall),
      ),
      alignment: Alignment.bottomLeft,
      child: Text(
        name,
        style: Theme.of(context).textTheme.labelMedium
            ?.copyWith(color: textColor),
      ),
    );
  }
}

class _PaletteCard extends StatelessWidget {
  const _PaletteCard({required this.name, required this.palette});

  final String name;
  final ThanksColorPalette palette;

  @override
  Widget build(BuildContext context) {
    final spacing = ThanksTheme.of(context).spacing;
    final materialTheme = Theme.of(context);
    return Container(
      width: 240,
      padding: spacing.insetSmall,
      decoration: BoxDecoration(
        color: materialTheme.colorScheme.surface,
        border: Border.all(color: materialTheme.colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(spacing.radiusSmall),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name, style: materialTheme.textTheme.titleSmall),
          SizedBox(height: spacing.small),
          _RoleRow(
            label: 'main',
            color: palette.main,
            textColor: palette.onMain,
          ),
          _RoleRow(
            label: 'onMain',
            color: palette.onMain,
            textColor: palette.main,
          ),
          _RoleRow(
            label: 'subtle',
            color: palette.subtle,
            textColor: palette.onSubtle,
          ),
          _RoleRow(
            label: 'onSubtle',
            color: palette.onSubtle,
            textColor: palette.main,
          ),
          _RoleRow(
            label: 'border',
            color: palette.border,
            textColor: palette.onSubtle,
          ),
        ],
      ),
    );
  }
}

class _RoleRow extends StatelessWidget {
  const _RoleRow({
    required this.label,
    required this.color,
    required this.textColor,
  });

  final String label;
  final Color color;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    final spacing = ThanksTheme.of(context).spacing;
    return Container(
      height: 32,
      margin: EdgeInsets.only(bottom: spacing.extraSmall),
      padding: spacing.insetSmallHorizontal,
      color: color,
      alignment: Alignment.centerLeft,
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall
            ?.copyWith(color: textColor),
      ),
    );
  }
}
