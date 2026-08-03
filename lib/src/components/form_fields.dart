import 'package:flutter/material.dart';

/// Text field styled through the active Thanks theme.
class ThanksTextField extends StatelessWidget {
  const ThanksTextField({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.onChanged,
  });

  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) => TextField(
        controller: controller,
        decoration: InputDecoration(labelText: labelText, hintText: hintText),
        onChanged: onChanged,
      );
}

/// Checkbox row styled through the active Thanks theme.
class ThanksCheckboxTile extends StatelessWidget {
  const ThanksCheckboxTile({
    required this.value,
    required this.onChanged,
    required this.title,
    super.key,
  });

  final bool value;
  final ValueChanged<bool?>? onChanged;
  final Widget title;

  @override
  Widget build(BuildContext context) => CheckboxListTile(
        value: value,
        onChanged: onChanged,
        title: title,
        controlAffinity: ListTileControlAffinity.leading,
        contentPadding: EdgeInsets.zero,
      );
}
