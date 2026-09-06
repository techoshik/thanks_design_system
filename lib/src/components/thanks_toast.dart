import 'dart:async';

import 'package:flutter/material.dart';

import '../foundations/spacing.dart';
import '../foundations/theme.dart';

/// The semantic treatment used by [ThanksToast].
enum ThanksToastType { success, error, info }

/// Top-centered transient feedback for Thanks applications.
///
/// A toast uses the root [Overlay], allowing it to appear above the current
/// route instead of in the low-priority bottom snackbar area.
abstract final class ThanksToast {
  static OverlayEntry? _entry;
  static Timer? _dismissTimer;

  /// Shows a success toast.
  static void success(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
    EdgeInsets margin = const EdgeInsets.fromLTRB(16, 24, 16, 0),
  }) => show(
    context,
    message,
    type: ThanksToastType.success,
    duration: duration,
    margin: margin,
  );

  /// Shows an error toast.
  static void error(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
    EdgeInsets margin = const EdgeInsets.fromLTRB(16, 24, 16, 0),
  }) => show(
    context,
    message,
    type: ThanksToastType.error,
    duration: duration,
    margin: margin,
  );

  /// Shows an informational toast.
  static void info(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
    EdgeInsets margin = const EdgeInsets.fromLTRB(16, 24, 16, 0),
  }) => show(
    context,
    message,
    type: ThanksToastType.info,
    duration: duration,
    margin: margin,
  );

  /// Shows a toast using the requested semantic [type].
  static void show(
    BuildContext context,
    String message, {
    ThanksToastType type = ThanksToastType.info,
    Duration duration = const Duration(seconds: 3),
    EdgeInsets margin = const EdgeInsets.fromLTRB(16, 24, 16, 0),
  }) {
    final overlay = Overlay.of(context, rootOverlay: true);
    dismiss();
    _entry = OverlayEntry(
      builder: (context) => _ToastView(
        message: message,
        type: type,
        margin: margin,
        onDismissed: dismiss,
      ),
    );
    overlay.insert(_entry!);
    _dismissTimer = Timer(duration, dismiss);
  }

  /// Immediately removes the visible toast, if there is one.
  static void dismiss() {
    _dismissTimer?.cancel();
    _dismissTimer = null;
    _entry?.remove();
    _entry = null;
  }
}

class _ToastView extends StatelessWidget {
  const _ToastView({
    required this.message,
    required this.type,
    required this.margin,
    required this.onDismissed,
  });

  final String message;
  final ThanksToastType type;
  final EdgeInsets margin;
  final VoidCallback onDismissed;

  @override
  Widget build(BuildContext context) {
    final thanksTheme = ThanksTheme.of(context);
    final (color, background, icon) = switch (type) {
      ThanksToastType.success => (
        thanksTheme.success,
        thanksTheme.successBackground,
        Icons.check_circle_outline,
      ),
      ThanksToastType.error => (
        thanksTheme.danger,
        thanksTheme.dangerBackground,
        Icons.error_outline,
      ),
      ThanksToastType.info => (
        thanksTheme.textPrimary,
        thanksTheme.surfaceElevated,
        Icons.info_outline,
      ),
    };

    return SafeArea(
      child: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: margin,
          child: Semantics(
            liveRegion: true,
            label: message,
            child: Material(
              color: Colors.transparent,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: background,
                    borderRadius: BorderRadius.circular(
                      ThanksSpacing.radiusMedium,
                    ),
                    border: Border.all(color: color),
                    boxShadow: const [
                      BoxShadow(color: Color(0x1F000000), blurRadius: 12),
                    ],
                  ),
                  child: Padding(
                    padding: ThanksSpacing.insetSmallWithLeftMedium,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(icon, color: color),
                        ThanksSpacing.spaceSmall,
                        Flexible(
                          child: Text(
                            message,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        IconButton(
                          tooltip: 'Dismiss',
                          onPressed: onDismissed,
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
