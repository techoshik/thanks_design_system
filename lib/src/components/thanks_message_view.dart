import 'package:flutter/material.dart';

import '../foundations/colors.dart';
import '../foundations/spacing.dart';
import 'thanks_button.dart';

/// A centered, non-sliver message widget for empty, error, and loading states.
///
/// Use [ThanksMessageView] in non-scroll bodies (plain [Scaffold.body],
/// [Dialog] content, tab panes) to communicate a page-level or section-level
/// state to the user. For [CustomScrollView] contexts use
/// [ThanksSliverEmptyState] or [ThanksSliverLoading] instead.
///
/// **Named constructors**
/// - [ThanksMessageView.loading] — spinner with an optional detail message.
/// - [ThanksMessageView.error] — error icon with an optional action button.
///
/// ```dart
/// // Generic usage
/// ThanksMessageView(
///   icon: const Icon(Icons.inbox_outlined),
///   title: 'No services yet',
///   message: 'Add your first service to get started.',
///   actionLabel: 'Add service',
///   onAction: _onAddService,
/// )
///
/// // Loading preset
/// ThanksMessageView.loading(title: 'Fetching services…')
///
/// // Error preset
/// ThanksMessageView.error(
///   title: 'Could not load services',
///   message: 'Check your connection and try again.',
///   onAction: _reload,
/// )
/// ```
class ThanksMessageView extends StatelessWidget {
  /// Creates a generic [ThanksMessageView].
  ///
  /// [icon] and [title] are required. Supply [actionLabel] and [onAction]
  /// together to show an action button; the button is hidden when [onAction]
  /// is `null`.
  const ThanksMessageView({
    required this.icon,
    required this.title,
    this.message,
    this.actionLabel,
    this.actionIcon,
    this.onAction,
    super.key,
  });

  /// A centered loading state with a [CircularProgressIndicator] preset.
  ///
  /// The spinner is 60 × 60. [title] defaults to `'Loading'`. Supply
  /// [message] for an optional supporting line below the title.
  factory ThanksMessageView.loading({
    String title = 'Loading',
    String? message,
    Key? key,
  }) => ThanksMessageView(
    key: key,
    icon: const SizedBox.square(
      dimension: ThanksSpacing.iconLarge,
      child: CircularProgressIndicator(strokeWidth: 3),
    ),
    title: title,
    message: message,
  );

  /// A centered error state with an optional action button preset.
  ///
  /// Renders [Icons.error_outline] at 60 px tinted with [ColorScheme.error].
  /// Supply [onAction] to show the action button; it is hidden when `null`.
  /// [actionLabel] defaults to `'Retry'`.
  factory ThanksMessageView.error({
    required String title,
    String? message,
    String actionLabel = 'Retry',
    VoidCallback? onAction,
    Key? key,
  }) => _ThanksMessageViewError(
    key: key,
    title: title,
    message: message,
    actionLabel: actionLabel,
    onAction: onAction,
  );

  /// The icon or visual asset displayed above [title].
  ///
  /// For the [loading] and [error] presets this is set automatically.
  /// For the main constructor, pass any widget — typically an [Icon] or
  /// image widget sized to your preference (the presets use 60 px).
  final Widget icon;

  /// The primary message displayed below [icon].
  final String title;

  /// An optional supporting line displayed below [title].
  final String? message;

  /// The label on the action button.
  ///
  /// The button is only rendered when both [actionLabel] and [onAction] are
  /// non-null.
  final String? actionLabel;

  /// An optional leading icon widget on the action button.
  final Widget? actionIcon;

  /// The callback invoked when the action button is tapped.
  ///
  /// Set to `null` to hide the action button entirely.
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: ThanksSpacing.insetMedium,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            icon,
            ThanksSpacing.spaceMedium,
            Text(
              title,
              style: textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            if (message != null) ...[
              ThanksSpacing.spaceSmall,
              Text(
                message!,
                style: textTheme.bodyMedium?.copyWith(
                  color: ThanksColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (actionLabel != null && onAction != null) ...[
              ThanksSpacing.spaceMedium,
              ThanksButton(
                label: actionLabel!,
                leadingIcon: actionIcon,
                onPressed: onAction,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Private subclass for [ThanksMessageView.error] so the error icon color
/// can be resolved from [Theme.of] in [build] without requiring the caller to
/// supply a [BuildContext].
class _ThanksMessageViewError extends ThanksMessageView {
  const _ThanksMessageViewError({
    required super.title,
    super.message,
    super.actionLabel,
    super.onAction,
    super.key,
  }) : super(icon: const _ErrorIcon());

  @override
  Widget build(BuildContext context) {
    final errorColor = Theme.of(context).colorScheme.error;
    return ThanksMessageView(
      key: key,
      icon: Icon(
        Icons.error_outline,
        size: ThanksSpacing.iconLarge,
        color: errorColor,
      ),
      title: title,
      message: message,
      actionLabel: actionLabel,
      actionIcon: const Icon(Icons.refresh),
      onAction: onAction,
    );
  }
}

/// Placeholder icon used as [ThanksMessageView.icon] before the error color
/// is available. Replaced at build time by [_ThanksMessageViewError.build].
class _ErrorIcon extends StatelessWidget {
  const _ErrorIcon();

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.error_outline,
      size: ThanksSpacing.iconLarge,
      color: Theme.of(context).colorScheme.error,
    );
  }
}
