import 'package:flutter/material.dart';
import 'package:thanks_design_system/thanks_design_system.dart';

Widget colorsUseCase(BuildContext context) {
  return Scaffold(
    backgroundColor: ThanksColors.pageBackground,
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(ThanksSpacing.large),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Primary Scale', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: ThanksSpacing.medium),
          Wrap(
            spacing: ThanksSpacing.medium,
            runSpacing: ThanksSpacing.medium,
            children: const [
              _ColorCard(name: 'primary50', color: ThanksColors.primary50, textColor: Colors.black87),
              _ColorCard(name: 'primary100', color: ThanksColors.primary100, textColor: Colors.black87),
              _ColorCard(name: 'primary200', color: ThanksColors.primary200, textColor: Colors.black87),
              _ColorCard(name: 'primary400', color: ThanksColors.primary400, textColor: Colors.white),
              _ColorCard(name: 'primary500 (Base)', color: ThanksColors.primary500, textColor: Colors.white),
              _ColorCard(name: 'primary600', color: ThanksColors.primary600, textColor: Colors.white),
              _ColorCard(name: 'primary800', color: ThanksColors.primary800, textColor: Colors.white),
              _ColorCard(name: 'primary950', color: ThanksColors.primary950, textColor: Colors.white),
            ],
          ),
          const SizedBox(height: ThanksSpacing.large * 1.5),
          Text('Surfaces & Backgrounds', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: ThanksSpacing.medium),
          Wrap(
            spacing: ThanksSpacing.medium,
            runSpacing: ThanksSpacing.medium,
            children: const [
              _ColorCard(name: 'pageBackground', color: ThanksColors.pageBackground, textColor: Colors.black87, hasBorder: true),
              _ColorCard(name: 'surface', color: ThanksColors.surface, textColor: Colors.black87, hasBorder: true),
              _ColorCard(name: 'surface2', color: ThanksColors.surface2, textColor: Colors.black87, hasBorder: true),
            ],
          ),
          const SizedBox(height: ThanksSpacing.large * 1.5),
          Text('Borders & Text', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: ThanksSpacing.medium),
          Wrap(
            spacing: ThanksSpacing.medium,
            runSpacing: ThanksSpacing.medium,
            children: const [
              _ColorCard(name: 'border', color: ThanksColors.border, textColor: Colors.black87),
              _ColorCard(name: 'borderStrong', color: ThanksColors.borderStrong, textColor: Colors.black87),
              _ColorCard(name: 'textPrimary', color: ThanksColors.textPrimary, textColor: Colors.white),
              _ColorCard(name: 'textSecondary', color: ThanksColors.textSecondary, textColor: Colors.white),
              _ColorCard(name: 'textMuted', color: ThanksColors.textMuted, textColor: Colors.white),
            ],
          ),
          const SizedBox(height: ThanksSpacing.large * 1.5),
          Text('Semantic Feedback', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: ThanksSpacing.medium),
          Wrap(
            spacing: ThanksSpacing.medium,
            runSpacing: ThanksSpacing.medium,
            children: const [
              _ColorCard(name: 'success', color: ThanksColors.success, textColor: Colors.white),
              _ColorCard(name: 'successBackground', color: ThanksColors.successBackground, textColor: ThanksColors.success, hasBorder: true),
              _ColorCard(name: 'warning', color: ThanksColors.warning, textColor: Colors.white),
              _ColorCard(name: 'warningBackground', color: ThanksColors.warningBackground, textColor: ThanksColors.warning, hasBorder: true),
              _ColorCard(name: 'danger', color: ThanksColors.danger, textColor: Colors.white),
              _ColorCard(name: 'dangerBackground', color: ThanksColors.dangerBackground, textColor: ThanksColors.danger, hasBorder: true),
            ],
          ),
        ],
      ),
    ),
  );
}

class _ColorCard extends StatelessWidget {
  const _ColorCard({
    required this.name,
    required this.color,
    required this.textColor,
    this.hasBorder = false,
  });

  final String name;
  final Color color;
  final Color textColor;
  final bool hasBorder;

  @override
  Widget build(BuildContext context) {
    final hexString = '#${color.toARGB32().toRadixString(16).substring(2).toUpperCase()}';

    return Container(
      width: 170,
      height: 90,
      padding: const EdgeInsets.all(ThanksSpacing.small),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(ThanksSpacing.radiusSmall),
        border: hasBorder ? Border.all(color: ThanksColors.border) : null,
        boxShadow: const [
          BoxShadow(color: Color(0x0A000000), blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
          Text(
            hexString,
            style: TextStyle(
              color: textColor.withAlpha(200),
              fontSize: 11,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }
}
