import 'package:flutter/material.dart';

/// Primary action button with Thanks defaults from the active [ThemeData].
class ThanksButton extends StatelessWidget {
  const ThanksButton({
    required this.label,
    required this.onPressed,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => ElevatedButton(
        onPressed: onPressed,
        child: Text(label),
      );
}
