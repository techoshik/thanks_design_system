import 'package:flutter/material.dart';

import '../foundations/spacing.dart';

/// Popup menu button with Thanks design-system defaults.
///
/// The popup menu shape, colors, and elevation come from [ThanksTheme]. The
/// menu is clipped to its shape so hover and focus overlays cannot paint
/// outside the rounded corners.
class ThanksPopupMenuButton<T> extends PopupMenuButton<T> {
  const ThanksPopupMenuButton({
    super.key,
    required super.itemBuilder,
    super.initialValue,
    super.onOpened,
    super.onSelected,
    super.onCanceled,
    super.tooltip,
    super.elevation,
    super.shadowColor,
    super.surfaceTintColor,
    super.padding = ThanksSpacing.insetSmall,
    super.menuPadding,
    super.child,
    super.borderRadius,
    super.splashRadius,
    super.icon,
    super.iconSize,
    super.offset = Offset.zero,
    super.enabled = true,
    super.shape,
    super.color,
    super.iconColor,
    super.enableFeedback,
    super.constraints,
    super.position,
    super.useRootNavigator = false,
    super.popUpAnimationStyle,
    super.routeSettings,
    super.style,
    super.requestFocus,
  }) : super(clipBehavior: Clip.antiAlias);
}
