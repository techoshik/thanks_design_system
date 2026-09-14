import 'package:flutter/material.dart';
import 'package:fit_it/fit_it.dart';

import '../foundations/spacing.dart';

/// The visual treatment used by [ThanksButton].
enum ThanksButtonVariant { text, filled, outlined }

/// The semantic color used by [ThanksButton].
enum ThanksButtonColor { primary, secondary, tertiary }

/// A common action button with Thanks defaults from the active [ThemeData].
///
/// Set [isLoading] while an action is in progress. The button keeps its label
/// width, disables its callback, and shows a progress indicator. Use
/// [leadingIcon] and [trailingIcon] for icons on either side of the label.
/// Set [adaptive] to render the [leadingIcon] as an icon-only button on mobile
/// screens while retaining the labeled button above the mobile breakpoint.
/// Use [ThanksButton.icon] for an icon-only action; it requires a [tooltip]
/// so the control remains accessible.
class ThanksButton extends StatelessWidget {
  const ThanksButton({
    required this.label,
    required this.onPressed,
    this.variant = ThanksButtonVariant.filled,
    this.color = ThanksButtonColor.primary,
    this.isLoading = false,
    this.adaptive = false,
    this.leadingIcon,
    this.trailingIcon,
    this.isExpanded = false,
    this.style,
    super.key,
  }) : assert(
         !adaptive || leadingIcon != null,
         'ThanksButton: leadingIcon is required when adaptive is true.',
       ),
       _icon = null,
       _tooltip = null;

  const ThanksButton.icon({
    required Widget this._icon,
    required String this._tooltip,
    required this.onPressed,
    this.variant = ThanksButtonVariant.filled,
    this.color = ThanksButtonColor.primary,
    this.isLoading = false,
    this.style,
    super.key,
  }) : adaptive = false,
       label = null,
       leadingIcon = null,
       trailingIcon = null,
       isExpanded = false;

  final String? label;
  final VoidCallback? onPressed;
  final ThanksButtonVariant variant;
  final ThanksButtonColor color;
  final bool isLoading;
  final bool adaptive;
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
        colorScheme.onSecondary,
      ),
      ThanksButtonColor.tertiary => (
        colorScheme.tertiary,
        colorScheme.onTertiary,
      ),
    };

    final buttonStyle = _buttonStyle(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
    );
    if (_isIconOnly || _isAdaptiveIconOnly(context)) {
      return _buildIconButton(
        icon: _isIconOnly ? _icon! : leadingIcon!,
        tooltip: _isIconOnly ? _tooltip! : label!,
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
      color:
          variant == ThanksButtonVariant.text ||
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

  bool _isAdaptiveIconOnly(BuildContext context) {
    return adaptive && FitSize.parse(MediaQuery.sizeOf(context).width).isMobile;
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
    required Widget icon,
    required String tooltip,
    required ButtonStyle buttonStyle,
    required Color backgroundColor,
    required Color foregroundColor,
  }) {
    final effectiveIcon = isLoading
        ? SizedBox.square(
            dimension: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: variant == ThanksButtonVariant.filled
                  ? foregroundColor
                  : backgroundColor,
            ),
          )
        : icon;
    final onPressed = isLoading ? null : this.onPressed;

    return switch (variant) {
      ThanksButtonVariant.text => IconButton(
        tooltip: tooltip,
        onPressed: onPressed,
        style: buttonStyle,
        icon: effectiveIcon,
      ),
      ThanksButtonVariant.filled => IconButton.filled(
        tooltip: tooltip,
        onPressed: onPressed,
        style: buttonStyle,
        icon: effectiveIcon,
      ),
      ThanksButtonVariant.outlined => IconButton.outlined(
        tooltip: tooltip,
        onPressed: onPressed,
        style: buttonStyle,
        icon: effectiveIcon,
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
            child: CircularProgressIndicator(strokeWidth: 2, color: color),
          ),
      ],
    );
  }
}
