import 'package:flutter/material.dart';
import 'package:thanks_design_system/thanks_design_system.dart';
import 'package:widgetbook/widgetbook.dart';

Widget pillSelectorPlaygroundUseCase(BuildContext context) {
  final isDense = context.knobs.boolean(label: 'Is Dense', initialValue: false);
  final isExpanded = context.knobs.boolean(
    label: 'Is Expanded',
    initialValue: false,
  );

  return Scaffold(
    backgroundColor: ThanksColors.pageBackground,
    body: Center(
      child: Padding(
        padding: ThanksSpacing.insetMedium,
        child: _InteractivePillSelector(
          isDense: isDense,
          isExpanded: isExpanded,
        ),
      ),
    ),
  );
}

class _InteractivePillSelector extends StatefulWidget {
  const _InteractivePillSelector({
    required this.isDense,
    required this.isExpanded,
  });

  final bool isDense;
  final bool isExpanded;

  @override
  State<_InteractivePillSelector> createState() =>
      _InteractivePillSelectorState();
}

class _InteractivePillSelectorState extends State<_InteractivePillSelector> {
  String selected = 'All';

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: widget.isExpanded ? 400 : null,
          child: ThanksPillSelector<String>(
            options: const ['All', 'Unpaid', 'Overdue', 'Archived'],
            selected: selected,
            onChanged: (val) {
              if (val != null) {
                setState(() => selected = val);
              }
            },
            labelBuilder: (item) => item,
            iconBuilder: (item) => switch (item) {
              'All' => const Icon(Icons.list, size: 16),
              'Unpaid' => const Icon(Icons.schedule, size: 16),
              'Overdue' => const Icon(Icons.error_outline, size: 16),
              'Archived' => const Icon(Icons.archive_outlined, size: 16),
              _ => const SizedBox.shrink(),
            },
            isDense: widget.isDense,
            isExpanded: widget.isExpanded,
          ),
        ),
        ThanksSpacing.spaceMedium,
        Text(
          'Selected filter: $selected',
          style: const TextStyle(color: ThanksColors.textSecondary),
        ),
      ],
    );
  }
}
