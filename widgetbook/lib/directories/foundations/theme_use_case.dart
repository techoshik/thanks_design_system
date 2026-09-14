import 'package:flutter/material.dart';
import 'package:thanks_design_system/thanks_design_system.dart';

Widget themeUseCase(BuildContext context) {
  final materialTheme = Theme.of(context);
  final thanksTheme = ThanksTheme.of(context);
  final spacing = thanksTheme.spacing;
  final surface = thanksTheme.surface;

  final palettes = <({String name, ThanksColorPalette palette})>[
    (name: 'Primary', palette: thanksTheme.primary),
    (name: 'Success', palette: thanksTheme.success),
    (name: 'Warning', palette: thanksTheme.warning),
    (name: 'Error', palette: thanksTheme.error),
    (name: 'Info', palette: thanksTheme.info),
  ];

  return Scaffold(
    backgroundColor: surface.page,
    body: ListView(
      padding: spacing.insetMedium,
      children: [
        Text(
          'ThanksTheme semantic palettes',
          style: materialTheme.textTheme.headlineSmall,
        ),
        SizedBox(height: spacing.small),
        Text(
          'All custom semantic values come from ThanksTheme.of(context).',
          style: materialTheme.textTheme.bodyMedium,
        ),
        SizedBox(height: spacing.medium),
        for (final entry in palettes) ...[
          Text(entry.name, style: materialTheme.textTheme.titleMedium),
          SizedBox(height: spacing.small),
          _PaletteRow(palette: entry.palette),
          SizedBox(height: spacing.medium),
        ],
        Text(
          'Surface and text roles',
          style: materialTheme.textTheme.titleMedium,
        ),
        SizedBox(height: spacing.small),
        Wrap(
          spacing: spacing.small,
          runSpacing: spacing.small,
          children: [
            _TokenTile(
              label: 'surface.page',
              color: surface.page,
              textColor: thanksTheme.textPrimary,
            ),
            _TokenTile(
              label: 'surface.panel',
              color: surface.panel,
              textColor: thanksTheme.textPrimary,
            ),
            _TokenTile(
              label: 'surface.hover',
              color: surface.hover,
              textColor: thanksTheme.textPrimary,
            ),
            _TokenTile(
              label: 'surface.input',
              color: surface.input,
              textColor: thanksTheme.textPrimary,
            ),
            _TokenTile(
              label: 'surface.selected',
              color: surface.selected,
              textColor: thanksTheme.textPrimary,
            ),
            _TokenTile(
              label: 'borderSubtle',
              color: thanksTheme.borderSubtle,
              textColor: thanksTheme.textPrimary,
            ),
          ],
        ),
      ],
    ),
  );
}

class _PaletteRow extends StatelessWidget {
  const _PaletteRow({required this.palette});

  final ThanksColorPalette palette;

  @override
  Widget build(BuildContext context) {
    final spacing = ThanksTheme.of(context).spacing;
    return Wrap(
      spacing: spacing.small,
      runSpacing: spacing.small,
      children: [
        _TokenTile(
          label: 'main',
          color: palette.main,
          textColor: palette.onMain,
        ),
        _TokenTile(
          label: 'onMain',
          color: palette.onMain,
          textColor: palette.main,
        ),
        _TokenTile(
          label: 'subtle',
          color: palette.subtle,
          textColor: palette.onSubtle,
        ),
        _TokenTile(
          label: 'onSubtle',
          color: palette.onSubtle,
          textColor: palette.main,
        ),
        _TokenTile(
          label: 'border',
          color: palette.border,
          textColor: palette.onSubtle,
        ),
      ],
    );
  }
}

class _TokenTile extends StatelessWidget {
  const _TokenTile({
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
      width: 128,
      height: 64,
      padding: spacing.insetSmall,
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: ThanksTheme.of(context).borderSubtle),
        borderRadius: BorderRadius.circular(spacing.radiusSmall),
      ),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelMedium
              ?.copyWith(color: textColor),
        ),
      ),
    );
  }
}
