import 'package:flutter/material.dart';
import 'package:thanks_design_system/thanks_design_system.dart';
import 'package:widgetbook/widgetbook.dart';

Widget cardPlaygroundUseCase(BuildContext context) {
  final title = context.knobs.string(
    label: 'Title',
    initialValue: 'Account Summary',
  );
  final subtitle = context.knobs.stringOrNull(
    label: 'Subtitle',
    initialValue: 'View and manage your recent billing activity',
  );
  final headerPosition = context.knobs.object.dropdown<ThanksCardHeaderPosition>(
    label: 'Header Position',
    options: ThanksCardHeaderPosition.values,
    initialOption: ThanksCardHeaderPosition.outside,
    labelBuilder: (p) => p.name,
  );
  final variant = context.knobs.object.dropdown<ThanksCardVariant>(
    label: 'Variant',
    options: ThanksCardVariant.values,
    initialOption: ThanksCardVariant.filledOutlined,
    labelBuilder: (v) => v.name,
  );
  final padding = context.knobs.object.dropdown<ThanksCardSpacing>(
    label: 'Padding',
    options: ThanksCardSpacing.values,
    initialOption: ThanksCardSpacing.medium,
    labelBuilder: (s) => s.name,
  );
  final margin = context.knobs.object.dropdown<ThanksCardSpacing>(
    label: 'Margin',
    options: ThanksCardSpacing.values,
    initialOption: ThanksCardSpacing.medium,
    labelBuilder: (s) => s.name,
  );
  final showDivider = context.knobs.boolean(
    label: 'Show Divider (Inside Header)',
    initialValue: true,
  );
  final showActions = context.knobs.boolean(
    label: 'Show Actions',
    initialValue: true,
  );
  final isTappable = context.knobs.boolean(
    label: 'Is Tappable (onTap)',
    initialValue: false,
  );

  return Scaffold(
    backgroundColor: ThanksColors.pageBackground,
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: ThanksCard(
          title: title.isEmpty ? null : title,
          subtitle: subtitle?.isEmpty ?? true ? null : subtitle,
          headerPosition: headerPosition,
          variant: variant,
          padding: padding,
          margin: margin,
          showDivider: showDivider,
          onTap: isTappable ? () {} : null,
          actions: showActions
              ? [
                  ThanksButton(
                    label: 'Export',
                    variant: ThanksButtonVariant.outlined,
                    onPressed: () {},
                  ),
                  ThanksButton.icon(
                    icon: const Icon(Icons.more_vert),
                    tooltip: 'More options',
                    variant: ThanksButtonVariant.text,
                    onPressed: () {},
                  ),
                ]
              : const [],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Primary card content goes here. This area adapts to any layout or widgets.'),
              ThanksSpacing.spaceMedium,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Outstanding Balance', style: TextStyle(color: ThanksColors.textSecondary)),
                  Text(
                    '\$1,240.00',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(color: ThanksColors.primary500),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget cardSectionOutsideUseCase(BuildContext context) {
  return Scaffold(
    backgroundColor: ThanksColors.pageBackground,
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: ThanksCard(
          title: 'Personal Information',
          subtitle: 'Update your profile photo and contact details.',
          headerPosition: ThanksCardHeaderPosition.outside,
          variant: ThanksCardVariant.filledOutlined,
          padding: ThanksCardSpacing.medium,
          margin: ThanksCardSpacing.medium,
          actions: [
            ThanksButton(
              label: 'Edit Profile',
              variant: ThanksButtonVariant.outlined,
              onPressed: () {},
            ),
          ],
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Name: Alex Morgan', style: TextStyle(fontWeight: FontWeight.w600)),
              SizedBox(height: ThanksSpacing.small),
              Text('Email: alex.morgan@example.com', style: TextStyle(color: ThanksColors.textSecondary)),
              SizedBox(height: ThanksSpacing.small),
              Text('Location: San Francisco, CA', style: TextStyle(color: ThanksColors.textSecondary)),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget cardMetricInsideUseCase(BuildContext context) {
  return Scaffold(
    backgroundColor: ThanksColors.pageBackground,
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 340),
        child: ThanksCard(
          title: 'Monthly Recurring Revenue',
          subtitle: '+14.2% from last month',
          headerPosition: ThanksCardHeaderPosition.inside,
          variant: ThanksCardVariant.filledOutlined,
          padding: ThanksCardSpacing.medium,
          showDivider: true,
          actions: [
            ThanksButton.icon(
              icon: const Icon(Icons.trending_up, color: ThanksColors.success),
              tooltip: 'Growth indicator',
              variant: ThanksButtonVariant.text,
              onPressed: () {},
            ),
          ],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '\$48,250',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: ThanksColors.primary500,
                    ),
              ),
              ThanksSpacing.spaceSmall,
              const Text('Target for Q3: \$50,000', style: TextStyle(fontSize: 12, color: ThanksColors.textMuted)),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget cardNestedUseCase(BuildContext context) {
  return Scaffold(
    backgroundColor: ThanksColors.pageBackground,
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 550),
        child: ThanksCard(
          title: 'Organization Settings',
          subtitle: 'Manage workspace members and billing subscriptions',
          headerPosition: ThanksCardHeaderPosition.outside,
          variant: ThanksCardVariant.filledOutlined,
          padding: ThanksCardSpacing.medium,
          margin: ThanksCardSpacing.medium,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ThanksCard(
                title: 'Enterprise Plan',
                subtitle: 'Active until Dec 2026',
                headerPosition: ThanksCardHeaderPosition.inside,
                variant: ThanksCardVariant.outlined,
                padding: ThanksCardSpacing.medium,
                showDivider: true,
                actions: [
                  ThanksButton(
                    label: 'Change Plan',
                    variant: ThanksButtonVariant.text,
                    onPressed: () {},
                  ),
                ],
                child: const Text('Includes unlimited seats and dedicated 24/7 SLA support.'),
              ),
              ThanksSpacing.spaceMedium,
              ThanksCard(
                title: 'Payment Method',
                subtitle: 'Visa ending in 4242',
                headerPosition: ThanksCardHeaderPosition.inside,
                variant: ThanksCardVariant.outlined,
                padding: ThanksCardSpacing.medium,
                actions: [
                  ThanksButton(
                    label: 'Update',
                    variant: ThanksButtonVariant.outlined,
                    onPressed: () {},
                  ),
                ],
                child: const Text('Default card for automated renewals.'),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
