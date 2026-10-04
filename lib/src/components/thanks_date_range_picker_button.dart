import 'package:fit_it/fit_it.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

import '../../thanks_design_system.dart';

class ThanksDateRangePickerButton extends StatelessWidget {
  final Function(DateTimeRange?)? onDateChanged;
  final String? noDateSelectedText;
  final String? dateFormat;

  final DateTimeRange? selectedDateRange;
  final DateTime? lastDate;
  final DateTime? firstDate;
  final bool isFullWidth;

  const ThanksDateRangePickerButton({
    super.key,
    this.noDateSelectedText,
    this.onDateChanged,
    this.firstDate,
    this.lastDate,
    this.selectedDateRange,
    this.isFullWidth = true,
    this.dateFormat,
  });

  String _formatDateRange(DateTimeRange range) {
    final format = DateFormat(dateFormat ?? 'dd MMM, yyyy');
    final startStr = format.format(range.start);
    final endStr = format.format(range.end);
    if (range.start.year == range.end.year &&
        range.start.month == range.end.month &&
        range.start.day == range.end.day) {
      return startStr;
    }
    return '$startStr - $endStr';
  }

  @override
  Widget build(BuildContext context) {
    return ThanksCard(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      variant: ThanksCardVariant.outlined,
      radius: ThanksCardSpacing.small,
      padding: ThanksCardSpacing.none,
      child: Row(
        mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            color: Theme.of(context).colorScheme.primary,
            style: IconButton.styleFrom(
              shape: const RoundedRectangleBorder(),
              fixedSize: Size.fromHeight(ThanksSpacing.inputHeight),
            ),
            onPressed:
                selectedDateRange == null ||
                    onDateChanged == null ||
                    selectedDateRange?.start.startOfDay == firstDate?.startOfDay
                ? null
                : () {
                    final previousDate = selectedDateRange!.start.subtract(
                      const Duration(days: 1),
                    );
                    onDateChanged?.call(
                      DateTimeRange(
                        start: previousDate,
                        end: selectedDateRange!.end,
                      ),
                    );
                  },
          ),
          Container(
            width: 1,
            height: ThanksSpacing.inputHeight,
            color: Theme.of(context).colorScheme.primaryContainer,
          ),

          if (isFullWidth)
            Expanded(child: _buildButton(context))
          else
            _buildButton(context),

          Container(
            width: 1,
            height: ThanksSpacing.inputHeight,
            color: Theme.of(context).colorScheme.primaryContainer,
          ),

          IconButton(
            icon: const Icon(Icons.arrow_forward_ios),
            color: Theme.of(context).colorScheme.primary,
            style: IconButton.styleFrom(
              shape: const RoundedRectangleBorder(),
              fixedSize: Size.fromHeight(ThanksSpacing.inputHeight),
            ),
            onPressed:
                selectedDateRange == null ||
                    onDateChanged == null ||
                    selectedDateRange?.end.startOfDay == lastDate?.startOfDay
                ? null
                : () {
                    final nextDate = selectedDateRange!.end.add(
                      const Duration(days: 1),
                    );
                    onDateChanged?.call(
                      DateTimeRange(
                        start: selectedDateRange!.start,
                        end: nextDate,
                      ),
                    );
                  },
          ),
        ],
      ),
    );
  }

  Widget _buildButton(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        fixedSize: const Size.fromHeight(ThanksSpacing.inputHeight),
        shape: const RoundedRectangleBorder(),
      ),
      onPressed: onDateChanged == null
          ? null
          : () async {
              final date = await showThanksDateRangePicker(
                context: context,
                initialDateRange: selectedDateRange,
                firstDate: firstDate,
                lastDate: lastDate,
              );
              if (date != null) {
                onDateChanged?.call(date);
              }
            },
      child: Text(
        selectedDateRange != null
            ? _formatDateRange(selectedDateRange!)
            : (noDateSelectedText ?? 'Select Date'),
      ),
    );
  }
}
