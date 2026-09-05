import 'package:flutter/material.dart';

export 'package:fit_it/fit_it.dart' show FitContainer, FitIt, FitSize;

import '../components/thanks_button.dart';
import '../foundations/colors.dart';
import '../foundations/spacing.dart';
import 'thanks_section.dart';

/// Controls how [ThanksScaffold.filters] are presented.
enum ThanksFilterDisplayMode {
  /// Shows filters inline on wide screens and in a bottom sheet on compact
  /// screens.
  adaptive,

  /// Always shows filters inline, wrapping them onto additional rows.
  inline,

  /// Always opens filters in a modal bottom sheet.
  bottomSheet,
}

/// Imperative controls for the drawers owned by a [ThanksScaffold].
class ThanksScaffoldController {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  /// Opens the left drawer, if one is configured.
  void openDrawer() => _scaffoldKey.currentState?.openDrawer();

  /// Closes the left drawer, if it is open.
  void closeDrawer() => _scaffoldKey.currentState?.closeDrawer();

  /// Opens or closes the left drawer.
  void toggleDrawer() {
    final state = _scaffoldKey.currentState;
    if (state == null) return;
    if (state.isDrawerOpen) {
      state.closeDrawer();
    } else {
      state.openDrawer();
    }
  }

  /// Opens the right drawer, if one is configured.
  void openEndDrawer() => _scaffoldKey.currentState?.openEndDrawer();

  /// Closes the right drawer, if it is open.
  void closeEndDrawer() => _scaffoldKey.currentState?.closeEndDrawer();

  /// Opens or closes the right drawer.
  void toggleEndDrawer() {
    final state = _scaffoldKey.currentState;
    if (state == null) return;
    if (state.isEndDrawerOpen) {
      state.closeEndDrawer();
    } else {
      state.openEndDrawer();
    }
  }
}

/// A standard Thanks page shell with consistent section and gutter spacing.
///
/// Use [body] for the primary page content. Provide [title] to configure the
/// standard top bar. When the current route can pop or [onBackPressed] is
/// supplied and [showBackButton] is true, a back button is shown as the leading
/// navigation control. Otherwise, if [drawer] is available, a menu button is
/// shown. Supply [controller] when a custom widget needs to open or close either
/// drawer programmatically.
class ThanksScaffold extends StatelessWidget {
  const ThanksScaffold({
    super.key,
    this.controller,
    this.title,
    this.subtitle,
    this.actions = const [],
    this.filters = const [],
    this.filterDisplayMode = ThanksFilterDisplayMode.adaptive,
    this.showBackButton = true,
    this.onBackPressed,
    this.body,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.drawer,
    this.endDrawer,
    this.backgroundColor,
    this.maxWidthHeader = FitSize.desktop,
  });

  final ThanksScaffoldController? controller;
  final String? title;
  final String? subtitle;

  /// Widgets rendered at the right of the generated top bar.
  final List<Widget> actions;

  /// Widgets displayed below the top bar or in a modal bottom sheet.
  final List<Widget> filters;

  /// Selects whether filters appear inline or in a modal bottom sheet.
  final ThanksFilterDisplayMode filterDisplayMode;

  final bool showBackButton;

  final VoidCallback? onBackPressed;

  /// The primary page content widget.
  final Widget? body;

  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final Widget? drawer;
  final Widget? endDrawer;
  final Color? backgroundColor;

  /// The maximum size constraint for the entire page, using [FitContainer].
  final FitSize maxWidthHeader;

  @override
  Widget build(BuildContext context) {
    final showFiltersInBottomSheet = _showFiltersInBottomSheet(context);

    final hasBackButton =
        title != null &&
        showBackButton &&
        (onBackPressed != null || Navigator.of(context).canPop());

    Widget? header;
    if (title != null) {
      final hasDrawer = drawer != null;
      const double leadingSize = ThanksSpacing.inputHeight;

      final leadingButtonStyle = IconButton.styleFrom(
        shape: const StadiumBorder(),
        backgroundColor: ThanksColors.surface,
        foregroundColor: Theme.of(context).colorScheme.primary,
        fixedSize: const Size.square(leadingSize),
        minimumSize: const Size.square(leadingSize),
        padding: EdgeInsets.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      );

      Widget? leading;
      if (hasBackButton) {
        leading = IconButton.filledTonal(
          tooltip: 'Back',
          icon: const Icon(Icons.arrow_back),
          style: leadingButtonStyle,
          onPressed: onBackPressed ?? () => Navigator.of(context).maybePop(),
        );
      } else if (hasDrawer) {
        leading = Builder(
          builder: (buttonContext) => IconButton.filledTonal(
            tooltip: 'Open menu',
            icon: const Icon(Icons.menu_rounded),
            style: leadingButtonStyle,
            onPressed: () {
              if (controller != null) {
                controller!.openDrawer();
              } else {
                Scaffold.of(buttonContext).openDrawer();
              }
            },
          ),
        );
      }

      final effectiveActions = [
        ...actions,
        if (showFiltersInBottomSheet)
          Builder(
            builder: (buttonContext) => IconButton(
              tooltip: 'Show filters',
              icon: const Icon(Icons.filter_list_rounded),
              onPressed: () => _showFiltersBottomSheet(buttonContext),
            ),
          ),
      ];

      header = ThanksSection(
        maxWidth: maxWidthHeader,
        backgroundColor: backgroundColor,
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: leading,
          minLeadingWidth: leadingSize + ThanksSpacing.medium,
          title: Text(title!, style: Theme.of(context).textTheme.titleLarge),
          subtitle: subtitle != null
              ? Text(
                  subtitle!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                )
              : null,
          trailing: effectiveActions.isNotEmpty
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: ThanksSpacing.small,
                  children: effectiveActions,
                )
              : null,
        ),
      );
    }

    final inlineFilters = filters.isNotEmpty && !showFiltersInBottomSheet
        ? ThanksSection(
            maxWidth: maxWidthHeader,
            child: Wrap(
              spacing: ThanksSpacing.medium,
              runSpacing: ThanksSpacing.medium,
              children: filters,
            ),
          )
        : null;

    return Scaffold(
      key: controller?._scaffoldKey,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
      drawer: drawer,
      endDrawer: endDrawer,
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ?header,
            ?inlineFilters,
            Expanded(child: body ?? const SizedBox.shrink()),
          ],
        ),
      ),
    );
  }

  bool _showFiltersInBottomSheet(BuildContext context) {
    if (filters.isEmpty) return false;
    return switch (filterDisplayMode) {
      ThanksFilterDisplayMode.inline => false,
      ThanksFilterDisplayMode.bottomSheet => true,
      ThanksFilterDisplayMode.adaptive => FitSize.parse(
        MediaQuery.sizeOf(context).width,
      ).isMobile,
    };
  }

  void _showFiltersBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) => _ThanksFiltersBottomSheet(
        filters: filters,
        spacing: ThanksSpacing.medium,
      ),
    );
  }
}

class _ThanksFiltersBottomSheet extends StatelessWidget {
  const _ThanksFiltersBottomSheet({
    required this.filters,
    required this.spacing,
  });

  final List<Widget> filters;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          ThanksSpacing.medium,
          ThanksSpacing.medium,
          ThanksSpacing.medium,
          ThanksSpacing.medium + bottomInset,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: spacing,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              spacing: ThanksSpacing.small,
              children: [
                Text('Filters', style: Theme.of(context).textTheme.titleMedium),
                const Spacer(),
                ThanksButton.icon(
                  tooltip: 'Close filters',
                  variant: ThanksButtonVariant.text,
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            Wrap(spacing: spacing, runSpacing: spacing, children: filters),
          ],
        ),
      ),
    );
  }
}
