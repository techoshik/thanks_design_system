import 'package:flutter/material.dart';

import '../foundations/spacing.dart';

/// A compact, accessible choice control for two or more mutually exclusive options.
class PillSelector<T> extends StatelessWidget {
  const PillSelector({
    super.key,
    required this.options,
    required this.labelBuilder,
    this.iconBuilder,
    required this.selected,
    required this.onChanged,
    this.height,
    this.borderColor,
    this.isDense = false,
    this.isExpanded = false,
  }) : assert(options.length >= 2);

  final List<T> options;
  final String Function(T item) labelBuilder;
  final Widget Function(T item)? iconBuilder;
  final T? selected;
  final ValueChanged<T?> onChanged;
  final double? height;
  final Color? borderColor;
  final bool isDense;
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final pillHeight = isDense
        ? ThanksSpacing.buttonHeight
        : height ?? ThanksSpacing.inputHeight - 4;

    return SizedBox(
      width: isExpanded ? double.infinity : null,
      height: pillHeight,
      child: Card(
        shape: StadiumBorder(
          side: BorderSide(
            color: borderColor ?? colorScheme.outlineVariant,
          ),
        ),
        child: Padding(
          padding: isDense ? EdgeInsets.zero : const EdgeInsets.all(3),
          child: Row(
            mainAxisSize: isExpanded ? MainAxisSize.max : MainAxisSize.min,
            children: options.map((option) {
              final isSelected = selected == option;
              return isExpanded
                  ? Expanded(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(pillHeight),
                          onTap: () => onChanged(isSelected ? null : option),
                          child: Container(
                            width: double.infinity,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? colorScheme.primary
                                  : colorScheme.surfaceContainer,
                              borderRadius: BorderRadius.circular(pillHeight),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (isSelected)
                                  Icon(
                                    Icons.check,
                                    size: 18,
                                    color: colorScheme.onPrimary,
                                  )
                                else if (iconBuilder != null)
                                  iconBuilder!(option),
                                if (isSelected || iconBuilder != null)
                                  const SizedBox(width: 6),
                                Text(
                                  labelBuilder(option),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(
                                        color: isSelected
                                            ? colorScheme.onPrimary
                                            : colorScheme.onSurface,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  : ChoiceChip(
                      label: Text(labelBuilder(option)),
                      avatar: isSelected ? null : iconBuilder?.call(option),
                      selected: isSelected,
                      onSelected: (_) => onChanged(isSelected ? null : option),
                      shape: const StadiumBorder(),
                      selectedColor: colorScheme.primary,
                      backgroundColor: colorScheme.surfaceContainer,
                      checkmarkColor: colorScheme.onPrimary,
                      labelStyle:
                          Theme.of(context).textTheme.titleSmall?.copyWith(
                                color: isSelected
                                    ? colorScheme.onPrimary
                                    : colorScheme.onSurface,
                              ),
                      side: BorderSide.none,
                    );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
