import 'package:flutter/material.dart';

import '../foundations/spacing.dart';

/// The visual treatment used by [ThanksButton].
enum ThanksButtonVariant {
  text,
  filled,
  outlined,
}

/// The semantic color used by [ThanksButton].
enum ThanksButtonColor {
  primary,
  secondary,
  tertiary,
}

/// A common action button with Thanks defaults from the active [ThemeData].
///
/// Set [isLoading] while an action is in progress. The button keeps its label
/// width, disables its callback, and shows a progress indicator. Use
/// [leadingIcon] and [trailingIcon] for icons on either side of the label.
/// Use [ThanksButton.icon] for an icon-only action; it requires a [tooltip]
/// so the control remains accessible.
class ThanksButton extends StatelessWidget {
  const ThanksButton({
    required this.label,
    required this.onPressed,
    this.variant = ThanksButtonVariant.filled,
    this.color = ThanksButtonColor.primary,
    this.isLoading = false,
    this.leadingIcon,
    this.trailingIcon,
    this.isExpanded = false,
    this.style,
    super.key,
  })  : _icon = null,
        _tooltip = null;

  const ThanksButton.icon({
    required Widget icon,
    required String tooltip,
    required this.onPressed,
    this.variant = ThanksButtonVariant.filled,
    this.color = ThanksButtonColor.primary,
    this.isLoading = false,
    this.style,
    super.key,
  })  : label = null,
        leadingIcon = null,
        trailingIcon = null,
        isExpanded = false,
        _icon = icon,
        _tooltip = tooltip;

  final String? label;
  final VoidCallback? onPressed;
  final ThanksButtonVariant variant;
  final ThanksButtonColor color;
  final bool isLoading;
  final Widget? leadingIcon;
  final Widget? trailingIcon;
  final bool isExpanded;
  final ButtonStyle? style;
  final Widget? _icon;
  final String? _tooltip;

  bool get _isIconOnly => _icon != null;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final (backgroundColor, foregroundColor) = switch (color) {
      ThanksButtonColor.primary => (colorScheme.primary, colorScheme.onPrimary),
      ThanksButtonColor.secondary => (
          colorScheme.secondary,
          colorScheme.onSecondary
        ),
      ThanksButtonColor.tertiary => (
          colorScheme.tertiary,
          colorScheme.onTertiary
        ),
    };

    final buttonStyle = _buttonStyle(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
    );
    if (_isIconOnly) {
      return _buildIconButton(
        buttonStyle: buttonStyle,
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
      );
    }

    final child = _ButtonChild(
      label: label!,
      isLoading: isLoading,
      leadingIcon: leadingIcon,
      trailingIcon: trailingIcon,
      color: variant == ThanksButtonVariant.text ||
              variant == ThanksButtonVariant.outlined
          ? backgroundColor
          : foregroundColor,
    );

    final button = switch (variant) {
      ThanksButtonVariant.text => TextButton(
          onPressed: isLoading ? null : onPressed,
          style: buttonStyle,
          child: child,
        ),
      ThanksButtonVariant.filled => FilledButton(
          onPressed: isLoading ? null : onPressed,
          style: buttonStyle,
          child: child,
        ),
      ThanksButtonVariant.outlined => OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: buttonStyle,
          child: child,
        ),
    };

    return isExpanded
        ? SizedBox(width: double.infinity, child: button)
        : button;
  }

  ButtonStyle _buttonStyle({
    required Color backgroundColor,
    required Color foregroundColor,
  }) {
    final base = switch (variant) {
      ThanksButtonVariant.text => ButtonStyle(
          foregroundColor: WidgetStatePropertyAll(backgroundColor),
        ),
      ThanksButtonVariant.filled => ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(backgroundColor),
          foregroundColor: WidgetStatePropertyAll(foregroundColor),
        ),
      ThanksButtonVariant.outlined => ButtonStyle(
          foregroundColor: WidgetStatePropertyAll(backgroundColor),
          side: WidgetStatePropertyAll(BorderSide(color: backgroundColor)),
        ),
    };
    return style == null ? base : base.merge(style!);
  }

  Widget _buildIconButton({
    required ButtonStyle buttonStyle,
    required Color backgroundColor,
    required Color foregroundColor,
  }) {
    final icon = isLoading
        ? SizedBox.square(
            dimension: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: variant == ThanksButtonVariant.filled
                  ? foregroundColor
                  : backgroundColor,
            ),
          )
        : _icon!;
    final onPressed = isLoading ? null : this.onPressed;

    return switch (variant) {
      ThanksButtonVariant.text => IconButton(
          tooltip: _tooltip,
          onPressed: onPressed,
          style: buttonStyle,
          icon: icon,
        ),
      ThanksButtonVariant.filled => IconButton.filled(
          tooltip: _tooltip,
          onPressed: onPressed,
          style: buttonStyle,
          icon: icon,
        ),
      ThanksButtonVariant.outlined => IconButton.outlined(
          tooltip: _tooltip,
          onPressed: onPressed,
          style: buttonStyle,
          icon: icon,
        ),
    };
  }
}

class _ButtonChild extends StatelessWidget {
  const _ButtonChild({
    required this.label,
    required this.isLoading,
    required this.leadingIcon,
    required this.trailingIcon,
    required this.color,
  });

  final String label;
  final bool isLoading;
  final Widget? leadingIcon;
  final Widget? trailingIcon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final content = <Widget>[
      if (leadingIcon != null) leadingIcon!,
      if (leadingIcon != null) ThanksSpacing.spaceSmall,
      Text(label),
      if (trailingIcon != null) ThanksSpacing.spaceSmall,
      if (trailingIcon != null) trailingIcon!,
    ];

    return Stack(
      alignment: Alignment.center,
      children: [
        Opacity(
          opacity: isLoading ? 0 : 1,
          child: Row(mainAxisSize: MainAxisSize.min, children: content),
        ),
        if (isLoading)
          SizedBox.square(
            dimension: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: color,
            ),
          ),
      ],
    );
  }
}
