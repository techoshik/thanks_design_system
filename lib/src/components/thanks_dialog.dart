import 'package:fit_it/fit_it.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../foundations/spacing.dart';

/// The visual treatment used by a [ThanksDialogAction].
enum ThanksDialogActionStyle { text, outlined, filled }

/// An action shown at the bottom of a [ThanksDialog].
class ThanksDialogAction {
  const ThanksDialogAction({
    required this.label,
    this.onPressed,
    this.autofocus = false,
    this.style = ThanksDialogActionStyle.filled,
    this.isDestructive = false,
  });

  /// Creates an autofocus filled action for the main dialog outcome.
  const ThanksDialogAction.primary({
    required String label,
    required VoidCallback onPressed,
  }) : this(label: label, onPressed: onPressed, autofocus: true);

  /// Creates a filled destructive action without autofocus.
  const ThanksDialogAction.primaryDestructive({
    required String label,
    required VoidCallback onPressed,
  }) : this(label: label, onPressed: onPressed, isDestructive: true);

  /// Creates an outlined secondary action without autofocus.
  const ThanksDialogAction.secondary({
    required String label,
    required VoidCallback onPressed,
  }) : this(
         label: label,
         onPressed: onPressed,
         style: ThanksDialogActionStyle.outlined,
       );

  final String label;
  final VoidCallback? onPressed;
  final bool autofocus;
  final ThanksDialogActionStyle style;
  final bool isDestructive;
}

/// Context-driven dialogs and confirmation prompts for Thanks applications.
abstract final class ThanksDialog {
  /// Shows a themed dialog with an optional message or custom [content].
  static Future<T?> show<T>({
    required BuildContext context,
    String? title,
    String? message,
    Widget? content,
    List<ThanksDialogAction> actions = const [],
    bool barrierDismissible = true,
    bool scrollable = true,
    EdgeInsetsGeometry? contentPadding,
    FitSize maxFitSize = FitSize.mobile,
    TextAlign titleTextAlign = TextAlign.center,
  }) {
    assert(
      message == null || content == null,
      'Use message or content, not both.',
    );

    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (dialogContext) {
        final body = content ?? (message == null ? null : Text(message));
        final actionWidgets = actions.isEmpty
            ? null
            : [
                for (final action in actions)
                  _DialogActionButton(action: action, context: dialogContext),
              ];

        return Shortcuts(
          shortcuts: {
            const SingleActivator(LogicalKeyboardKey.escape): barrierDismissible
                ? const _DismissDialogIntent()
                : const _IgnoreDialogDismissIntent(),
          },
          child: Actions(
            actions: {
              _DismissDialogIntent: CallbackAction<_DismissDialogIntent>(
                onInvoke: (_) => Navigator.of(dialogContext).maybePop(),
              ),
              _IgnoreDialogDismissIntent:
                  CallbackAction<_IgnoreDialogDismissIntent>(
                    onInvoke: (_) => null,
                  ),
            },
            child: AlertDialog(
              scrollable: scrollable,
              constraints: BoxConstraints(maxWidth: maxFitSize.maxWidth),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(ThanksSpacing.radiusMedium),
              ),
              title: title == null
                  ? null
                  : Text(
                      title,
                      textAlign: titleTextAlign,
                      style: Theme.of(dialogContext).textTheme.titleLarge,
                    ),
              contentPadding: contentPadding ?? ThanksSpacing.insetMedium,
              content: body,
              actionsPadding: actionWidgets == null
                  ? null
                  : ThanksSpacing.insetMedium,
              actions: actionWidgets,
            ),
          ),
        );
      },
    );
  }

  /// Shows a standard two-action confirmation dialog.
  static Future<bool> confirm({
    required BuildContext context,
    String? title,
    required String message,
    String confirmLabel = 'Confirm',
    String cancelLabel = 'Cancel',
    bool isDestructive = false,
    bool barrierDismissible = true,
  }) async {
    final result = await show<bool>(
      context: context,
      title: title,
      message: message,
      barrierDismissible: barrierDismissible,
      actions: [
        ThanksDialogAction.secondary(
          label: cancelLabel,
          onPressed: () => Navigator.of(context).pop(false),
        ),
        if (isDestructive)
          ThanksDialogAction.primaryDestructive(
            label: confirmLabel,
            onPressed: () => Navigator.of(context).pop(true),
          )
        else
          ThanksDialogAction.primary(
            label: confirmLabel,
            onPressed: () => Navigator.of(context).pop(true),
          ),
      ],
    );
    return result ?? false;
  }

  /// Shows a single-action dialog for an acknowledgement message.
  static Future<void> notice({
    required BuildContext context,
    String? title,
    required String message,
    String acknowledgeLabel = 'OK',
    bool barrierDismissible = true,
  }) {
    return show<void>(
      context: context,
      title: title,
      message: message,
      barrierDismissible: barrierDismissible,
      actions: [
        ThanksDialogAction.primary(
          label: acknowledgeLabel,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }

  /// Shows a draggable modal bottom sheet containing [child].
  static Future<T?> showBottomSheet<T>({
    required BuildContext context,
    required Widget child,
    double initialSize = 0.7,
    double minSize = 0.4,
    double maxSize = 0.95,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: initialSize,
        minChildSize: minSize,
        maxChildSize: maxSize,
        builder: (_, _) => child,
      ),
    );
  }
}

class _DismissDialogIntent extends Intent {
  const _DismissDialogIntent();
}

class _IgnoreDialogDismissIntent extends Intent {
  const _IgnoreDialogDismissIntent();
}

class _DialogActionButton extends StatelessWidget {
  const _DialogActionButton({required this.action, required this.context});

  final ThanksDialogAction action;
  final BuildContext context;

  @override
  Widget build(BuildContext buildContext) {
    final colorScheme = Theme.of(buildContext).colorScheme;
    final foreground = action.isDestructive ? colorScheme.onError : null;
    final background = action.isDestructive ? colorScheme.error : null;
    final child = Text(action.label);
    final onPressed = action.onPressed ?? () => Navigator.of(context).pop();

    return switch (action.style) {
      ThanksDialogActionStyle.text => TextButton(
        autofocus: action.autofocus,
        onPressed: onPressed,
        child: child,
      ),
      ThanksDialogActionStyle.outlined => OutlinedButton(
        autofocus: action.autofocus,
        onPressed: onPressed,
        child: child,
      ),
      ThanksDialogActionStyle.filled => FilledButton(
        autofocus: action.autofocus,
        style: action.isDestructive
            ? FilledButton.styleFrom(
                foregroundColor: foreground,
                backgroundColor: background,
              )
            : null,
        onPressed: onPressed,
        child: child,
      ),
    };
  }
}
