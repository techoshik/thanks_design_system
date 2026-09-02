import 'package:flutter/material.dart';
import 'package:thanks_design_system/thanks_design_system.dart';

Widget typographyUseCase(BuildContext context) {
  final textTheme = ThanksTypography.textTheme;

  final styles = <(String, String, TextStyle?)>[
    ('Display Large', '57px / Regular', textTheme.displayLarge),
    ('Display Medium', '45px / Regular', textTheme.displayMedium),
    ('Display Small', '36px / Regular', textTheme.displaySmall),
    ('Headline Large', '32px / Regular', textTheme.headlineLarge),
    ('Headline Medium', '28px / Regular', textTheme.headlineMedium),
    ('Headline Small', '24px / Regular', textTheme.headlineSmall),
    ('Title Large', '22px / SemiBold', textTheme.titleLarge),
    ('Title Medium', '16px / SemiBold', textTheme.titleMedium),
    ('Title Small', '14px / SemiBold', textTheme.titleSmall),
    ('Body Large', '14px / Line-height 1.6', textTheme.bodyLarge),
    ('Body Medium', '14px / Line-height 1.6', textTheme.bodyMedium),
    ('Body Small', '12px / Line-height 1.5', textTheme.bodySmall),
    ('Label Large', '12px / Medium', textTheme.labelLarge),
    ('Label Medium', '11px / Medium', textTheme.labelMedium),
    ('Label Small', '11px / Regular', textTheme.labelSmall),
    ('Monospace', '13px / Mono', ThanksTypography.mono),
  ];

  return Scaffold(
    backgroundColor: ThanksColors.pageBackground,
    body: SingleChildScrollView(
      padding: ThanksSpacing.insetMedium,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('DM Sans Type Scale', style: textTheme.headlineSmall),
          ThanksSpacing.spaceSmall,
          Text(
            'The production type scale provided by thanks_design_system.',
            style: textTheme.bodyMedium?.copyWith(color: ThanksColors.textSecondary),
          ),
          ThanksSpacing.spaceMedium,
          for (final (name, spec, style) in styles) ...[
            Container(
              margin: const EdgeInsets.only(bottom: ThanksSpacing.medium),
              padding: const EdgeInsets.all(ThanksSpacing.medium),
              decoration: BoxDecoration(
                color: ThanksColors.surface,
                borderRadius: BorderRadius.circular(ThanksSpacing.radiusSmall),
                border: Border.all(color: ThanksColors.border),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  SizedBox(
                    width: 180,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                        Text(spec, style: const TextStyle(color: ThanksColors.textMuted, fontSize: 11)),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'The quick brown fox jumps over the lazy dog',
                      style: style,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    ),
  );
}
