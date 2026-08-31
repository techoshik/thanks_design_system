import 'package:flutter/material.dart';
import 'package:thanks_design_system/thanks_design_system.dart';
import 'package:widgetbook/widgetbook.dart';

Widget buttonPlaygroundUseCase(BuildContext context) {
  final label = context.knobs.string(
    label: 'Label',
    initialValue: 'Save Changes',
  );
  final variant = context.knobs.object.dropdown<ThanksButtonVariant>(
    label: 'Variant',
    options: ThanksButtonVariant.values,
    initialOption: ThanksButtonVariant.filled,
    labelBuilder: (v) => v.name,
  );
  final color = context.knobs.object.dropdown<ThanksButtonColor>(
    label: 'Color',
    options: ThanksButtonColor.values,
    initialOption: ThanksButtonColor.primary,
    labelBuilder: (c) => c.name,
  );
  final isLoading = context.knobs.boolean(
    label: 'Is Loading',
    initialValue: false,
  );
  final isExpanded = context.knobs.boolean(
    label: 'Is Expanded',
    initialValue: false,
  );
  final showLeadingIcon = context.knobs.boolean(
    label: 'Show Leading Icon',
    initialValue: true,
  );
  final showTrailingIcon = context.knobs.boolean(
    label: 'Show Trailing Icon',
    initialValue: false,
  );

  return Scaffold(
    backgroundColor: ThanksColors.pageBackground,
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(ThanksSpacing.large),
        child: ThanksButton(
          label: label,
          variant: variant,
          color: color,
          isLoading: isLoading,
          isExpanded: isExpanded,
          leadingIcon: showLeadingIcon ? const Icon(Icons.check) : null,
          trailingIcon: showTrailingIcon ? const Icon(Icons.arrow_forward) : null,
          onPressed: () {},
        ),
      ),
    ),
  );
}

Widget buttonAllVariantsUseCase(BuildContext context) {
  return Scaffold(
    backgroundColor: ThanksColors.pageBackground,
    body: Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(ThanksSpacing.large),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Primary Color', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: ThanksSpacing.small),
            Wrap(
              spacing: ThanksSpacing.medium,
              runSpacing: ThanksSpacing.medium,
              children: [
                ThanksButton(label: 'Filled Primary', variant: ThanksButtonVariant.filled, onPressed: () {}),
                ThanksButton(label: 'Outlined Primary', variant: ThanksButtonVariant.outlined, onPressed: () {}),
                ThanksButton(label: 'Text Primary', variant: ThanksButtonVariant.text, onPressed: () {}),
              ],
            ),
            const SizedBox(height: ThanksSpacing.large),
            Text('Secondary Color', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: ThanksSpacing.small),
            Wrap(
              spacing: ThanksSpacing.medium,
              runSpacing: ThanksSpacing.medium,
              children: [
                ThanksButton(label: 'Filled Secondary', color: ThanksButtonColor.secondary, variant: ThanksButtonVariant.filled, onPressed: () {}),
                ThanksButton(label: 'Outlined Secondary', color: ThanksButtonColor.secondary, variant: ThanksButtonVariant.outlined, onPressed: () {}),
                ThanksButton(label: 'Text Secondary', color: ThanksButtonColor.secondary, variant: ThanksButtonVariant.text, onPressed: () {}),
              ],
            ),
            const SizedBox(height: ThanksSpacing.large),
            Text('Tertiary Color', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: ThanksSpacing.small),
            Wrap(
              spacing: ThanksSpacing.medium,
              runSpacing: ThanksSpacing.medium,
              children: [
                ThanksButton(label: 'Filled Tertiary', color: ThanksButtonColor.tertiary, variant: ThanksButtonVariant.filled, onPressed: () {}),
                ThanksButton(label: 'Outlined Tertiary', color: ThanksButtonColor.tertiary, variant: ThanksButtonVariant.outlined, onPressed: () {}),
                ThanksButton(label: 'Text Tertiary', color: ThanksButtonColor.tertiary, variant: ThanksButtonVariant.text, onPressed: () {}),
              ],
            ),
            const SizedBox(height: ThanksSpacing.large),
            Text('Icon Buttons', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: ThanksSpacing.small),
            Wrap(
              spacing: ThanksSpacing.medium,
              runSpacing: ThanksSpacing.medium,
              children: [
                ThanksButton.icon(icon: const Icon(Icons.add), tooltip: 'Add Item', variant: ThanksButtonVariant.filled, onPressed: () {}),
                ThanksButton.icon(icon: const Icon(Icons.edit), tooltip: 'Edit Item', variant: ThanksButtonVariant.outlined, onPressed: () {}),
                ThanksButton.icon(icon: const Icon(Icons.delete), tooltip: 'Delete Item', variant: ThanksButtonVariant.text, onPressed: () {}),
                ThanksButton.icon(icon: const Icon(Icons.download), tooltip: 'Loading', isLoading: true, variant: ThanksButtonVariant.filled, onPressed: () {}),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
