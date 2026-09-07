import 'package:fit_it/fit_it.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../foundations/spacing.dart';
import 'thanks_card.dart';

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
  ///
  /// **Header actions**: supply [headerLeading] and/or [headerActions] to show
  /// a structured header with a geometrically centered [title], a leading
  /// widget (e.g. a [CloseButton]) pinned to the left, and trailing action
  /// widgets pinned to the right. The standard [title] text position and
  /// default [titlePadding] are unchanged when neither header property is
  /// supplied.
  ///
  /// ```dart
  /// ThanksDialog.show<void>(
  ///   context: context,
  ///   title: 'Service Details',
  ///   headerLeading: CloseButton(onPressed: () => Navigator.pop(context)),
  ///   headerActions: [
  ///     IconButton(icon: const Icon(Icons.edit), onPressed: _onEdit),
  ///   ],
  ///   content: ServiceDetailContent(service: service),
  /// );
  /// ```
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
    // Header action props — backlog: ThanksDialog header actions (2026-09-07)
    Widget? headerLeading,
    List<Widget> headerActions = const [],
  }) {
    assert(
      message == null || content == null,
      'Use message or content, not both.',
    );

    final hasHeaderExtras = headerLeading != null || headerActions.isNotEmpty;

    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (dialogContext) {
        final body = content == null
            ? (message == null ? null : Text(message))
            : ThanksCard(
                variant: ThanksCardVariant.filledOutlined,
                padding: ThanksCardSpacing.medium,
                margin: ThanksCardSpacing.none,
                child: content,
              );
        final actionWidgets = actions.isEmpty
            ? null
            : [
                for (final action in actions)
                  _DialogActionButton(action: action, context: dialogContext),
              ];

        // Build the title widget. When headerLeading or headerActions are
        // supplied we render a Stack-based header so the title text is
        // geometrically centered regardless of side widget widths.
        final Widget? titleWidget;
        final EdgeInsetsGeometry? titlePadding;

        if (hasHeaderExtras) {
          titleWidget = _DialogHeaderTitle(
            title: title,
            leading: headerLeading,
            actions: headerActions,
            titleTextAlign: titleTextAlign,
          );
          // We manage all internal padding in _DialogHeaderTitle.
          titlePadding = EdgeInsets.zero;
        } else if (title != null) {
          titleWidget = Text(
            title,
            textAlign: titleTextAlign,
            style: Theme.of(dialogContext).textTheme.titleLarge,
          );
          titlePadding = null; // AlertDialog default
        } else {
          titleWidget = null;
          titlePadding = null;
        }

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
              title: titleWidget,
              titlePadding: titlePadding,
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

/// A structured dialog header that geometrically centers [title] while
/// pinning [leading] to the left and [actions] to the right.
///
/// Uses a [Stack] with [Align] children (not [Positioned]) so the widget is
/// compatible with [AlertDialog]'s internal [Column] layout which does not
/// accept [Positioned] as a direct descendant.
class _DialogHeaderTitle extends StatelessWidget {
  const _DialogHeaderTitle({
    this.title,
    this.leading,
    this.actions = const [],
    this.titleTextAlign = TextAlign.center,
  });

  final String? title;
  final Widget? leading;
  final List<Widget> actions;
  final TextAlign titleTextAlign;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: ThanksSpacing.insetSmall,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Title centered over the full row. A horizontal padding reserve
          // prevents the text from sliding under the side widgets.
          if (title != null)
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48),
                child: Text(
                  title!,
                  textAlign: TextAlign.center,
                  style: textTheme.titleLarge,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          // Leading widget aligned to the start of the row.
          if (leading != null)
            Align(alignment: Alignment.centerLeft, child: leading!),
          // Trailing action widgets aligned to the end of the row.
          if (actions.isNotEmpty)
            Align(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: actions,
              ),
            ),
        ],
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
