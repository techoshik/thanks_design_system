import 'package:fit_it/fit_it.dart';
import 'package:material_ui/material_ui.dart';

import '../../thanks_design_system.dart';

Future<DateTimeRange?> showThanksDateRangePicker({
  required BuildContext context,
  DateTimeRange? initialDateRange,
  DateTime? firstDate,
  DateTime? lastDate,
}) async {
  final now = DateTime.now();

  final options = [
    _DateRangeOption(
      label: 'Today',
      range: DateTimeRange(start: now.startOfDay, end: now.endOfDay),
    ),
    _DateRangeOption(
      label: 'Yesterday',
      range: DateTimeRange(
        start: now.subtract(const Duration(days: 1)).startOfDay,
        end: now.subtract(const Duration(days: 1)).endOfDay,
      ),
    ),
    _DateRangeOption(
      label: 'This Week',
      range: DateTimeRange(
        start: now.subtract(Duration(days: now.weekday - 1)).startOfDay,
        end: now.endOfDay,
      ),
    ),
    _DateRangeOption(
      label: 'Last Week',
      range: DateTimeRange(
        start: now.subtract(Duration(days: now.weekday - 1 + 7)).startOfDay,
        end: now.subtract(Duration(days: now.weekday)).endOfDay,
      ),
    ),
    _DateRangeOption(
      label: 'This Month',
      range: DateTimeRange(
        start: DateTime(now.year, now.month, 1),
        end: now.endOfDay,
      ),
    ),
    _DateRangeOption(
      label: 'Last Month',
      range: DateTimeRange(
        start: DateTime(now.year, now.month - 1, 1),
        end: DateTime(now.year, now.month, 0).endOfDay,
      ),
    ),
  ];

  return showDateRangePicker(
    context: context,
    initialDateRange: initialDateRange,
    firstDate: firstDate ?? DateTime(now.year - 10),
    lastDate: lastDate ?? DateTime(now.year + 10),
    builder: (BuildContext context, Widget? child) {
      final size = FitSize.parse(MediaQuery.sizeOf(context).width);
      final isDesktop = size.isTabletOrAbove;
      final constraints = const BoxConstraints(maxHeight: 550.0);

      if (!isDesktop) {
        // Fallback to normal dialog-like behavior for mobile
        return Center(
          child: FitContainer(
            maxFitSize: FitSize.mobile,
            child: ConstrainedBox(constraints: constraints, child: child!),
          ),
        );
      }

      return _PickerView(
        initialDateRange: initialDateRange,
        constraints: constraints,
        options: options,
        child: child!,
      );
    },
  );
}

class _PickerView extends StatelessWidget {
  const _PickerView({
    required this.initialDateRange,
    required this.constraints,
    required this.options,
    required this.child,
  });

  final BoxConstraints constraints;
  final DateTimeRange? initialDateRange;
  final List<_DateRangeOption> options;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FitContainer(
        maxFitSize: FitSize.tablet,
        alignment: .center,
        child: ConstrainedBox(
          constraints: constraints,
          child: Material(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(ThanksSpacing.radiusMedium),
            clipBehavior: Clip.antiAlias,
            elevation: 4,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Left side: Predefined options
                SizedBox(
                  width: 220,
                  child: ColoredBox(
                    color: Theme.of(context).colorScheme.surfaceContainerLow,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: ThanksSpacing.insetMedium,
                          child: Text(
                            'Quick Ranges',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          child: ListView(
                            padding: ThanksSpacing.insetSmallHorizontal,
                            children: options.map((option) {
                              final isSelected =
                                  initialDateRange != null &&
                                  initialDateRange!.start.startOfDay ==
                                      option.range.start.startOfDay &&
                                  initialDateRange!.end.startOfDay ==
                                      option.range.end.startOfDay;

                              return Padding(
                                padding: const EdgeInsets.only(
                                  bottom: ThanksSpacing.extraSmall,
                                ),
                                child: ListTile(
                                  dense: true,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      ThanksSpacing.radiusSmall,
                                    ),
                                  ),
                                  selected: isSelected,
                                  selectedTileColor: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer,
                                  title: Text(
                                    option.label,
                                    style: TextStyle(
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      color: isSelected
                                          ? Theme.of(context)
                                                .colorScheme
                                                .onPrimaryContainer
                                          : null,
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.of(context).pop(option.range);
                                  },
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Right side: Native picker
                Expanded(
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      textButtonTheme: TextButtonThemeData(
                        style: ButtonStyle(
                          textStyle: WidgetStateProperty.all(
                            const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                    child: child,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DateRangeOption {
  final String label;
  final DateTimeRange range;

  _DateRangeOption({required this.label, required this.range});
}
