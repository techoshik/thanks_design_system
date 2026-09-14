import 'package:flutter/material.dart';
import 'package:thanks_design_system/thanks_design_system.dart';
import 'package:widgetbook/widgetbook.dart';

Widget sliverLoadingPlaygroundUseCase(BuildContext context) {
  final theme = Theme.of(context);
  final message = context.knobs.stringOrNull(
    label: 'Message',
    initialValue: 'Loading invoices...',
  );
  final strokeWidth = context.knobs.double.slider(
    label: 'Stroke Width',
    initialValue: 3.0,
    min: 1.0,
    max: 8.0,
  );

  return Scaffold(
    backgroundColor: theme.scaffoldBackgroundColor,
    body: CustomScrollView(
      slivers: [
        ThanksSliverLoading(
          message: message?.isEmpty ?? true ? null : message,
          strokeWidth: strokeWidth,
        ),
      ],
    ),
  );
}

Widget sliverEmptyStatePlaygroundUseCase(BuildContext context) {
  final theme = Theme.of(context);
  final thanksTheme = ThanksTheme.of(context);
  final title = context.knobs.stringOrNull(
    label: 'Title',
    initialValue: 'No Invoices Found',
  );
  final subtitle = context.knobs.stringOrNull(
    label: 'Subtitle',
    initialValue: 'Try adjusting your search or date filters to find what you are looking for.',
  );
  final showIcon = context.knobs.boolean(
    label: 'Show Icon',
    initialValue: true,
  );
  final showAction = context.knobs.boolean(
    label: 'Show Action Button',
    initialValue: true,
  );

  return Scaffold(
    backgroundColor: theme.scaffoldBackgroundColor,
    body: CustomScrollView(
      slivers: [
        ThanksSliverEmptyState(
          icon: showIcon
              ? Icon(
                  Icons.receipt_long_outlined,
                  size: 48,
                  color: thanksTheme.textMuted,
                )
              : null,
          title: title?.isEmpty ?? true ? null : title,
          subtitle: subtitle?.isEmpty ?? true ? null : subtitle,
          action: showAction
              ? ThanksButton(
                  label: 'Clear Filters',
                  variant: ThanksButtonVariant.outlined,
                  onPressed: () {},
                )
              : null,
        ),
      ],
    ),
  );
}
