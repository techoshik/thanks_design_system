import 'package:flutter/material.dart';

import '../foundations/spacing.dart';

/// An input field label widget supporting required indicators, descriptions,
/// and trailing actions.
class ThanksInputLabel extends StatelessWidget {
  const ThanksInputLabel({
    super.key,
    this.label,
    this.labelWidget,
    this.child,
    this.noPadding = false,
    this.actions = const [],
    this.description,
    this.isRequired = false,
  }) : assert(
         label != null || labelWidget != null,
         'Either label or labelWidget must be provided',
       );

  final String? label;
  final Widget? labelWidget;
  final String? description;
  final Widget? child;
  final bool noPadding;
  final List<Widget> actions;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final hasDescription =
        description != null && description!.trim().isNotEmpty;

    final style = textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.only(
            top: noPadding ? 0 : ThanksSpacing.medium,
            left: 2,
            bottom: hasDescription ? 4 : 2,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    labelWidget ?? _buildLabel(context, style),
                    if (hasDescription)
                      Text(description!, style: textTheme.labelMedium),
                  ],
                ),
              ),
              ...actions,
            ],
          ),
        ),
        ?child,
      ],
    );
  }

  Widget _buildLabel(BuildContext context, TextStyle? style) {
    final colorScheme = Theme.of(context).colorScheme;
    if (!isRequired) {
      return Text(label!, style: style);
    }

    return RichText(
      text: TextSpan(
        style: style,
        children: [
          TextSpan(text: label),
          TextSpan(
            text: ' *',
            style: style?.copyWith(color: colorScheme.error),
          ),
        ],
      ),
    );
  }
}
