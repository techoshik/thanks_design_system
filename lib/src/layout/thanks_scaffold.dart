import 'dart:math' as math;

import 'package:fit_it/fit_it.dart';
import 'package:flutter/material.dart';

import '../components/buttons.dart';
import '../foundations/spacing.dart';

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

/// A standard Thanks page shell with consistent body spacing.
///
/// Set [bodyPadding] to [EdgeInsets.zero] for full-bleed content, or set
/// [applyBodyPadding] to false when [body] manages its own padding. Use
/// [sliver] for scrollable page content such as lists and grids.
///
/// When [appBar] is omitted, provide [title] to get a standard top bar. A menu
/// button is shown on the left when [drawer] is available. When the current
/// route can pop, a back button appears above the title; both controls are
/// shown when both capabilities are available. Supply [controller] when a
/// custom widget needs to open or close either drawer programmatically.
class ThanksScaffold extends StatelessWidget {
  const ThanksScaffold({
    super.key,
    this.controller,
    this.appBar,
    this.title,
    this.subtitle,
    this.actions = const [],
    this.filters = const [],
    this.filterSpacing = ThanksSpacing.medium,
    this.filterDisplayMode = ThanksFilterDisplayMode.adaptive,
    this.compactFilterBreakpoint = 600,
    this.showBackButton = true,
    this.backDestinationLabel,
    this.onBackPressed,
    this.body,
    this.sliver,
    this.bodyPadding = ThanksSpacing.insetLargeWithFab,
    this.applyBodyPadding = true,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.drawer,
    this.endDrawer,
    this.backgroundColor,
  }) : assert(
          body == null || sliver == null,
          'Provide either body or sliver, not both.',
        );

  final ThanksScaffoldController? controller;
  final PreferredSizeWidget? appBar;
  final String? title;
  final String? subtitle;

  /// Widgets rendered at the right of the generated top bar.
  final List<Widget> actions;

  /// Widgets displayed below the top bar or in a modal bottom sheet.
  final List<Widget> filters;

  /// Horizontal and vertical gap inserted between inline filter widgets.
  final double filterSpacing;

  /// Selects whether filters appear inline or in a modal bottom sheet.
  final ThanksFilterDisplayMode filterDisplayMode;

  /// Viewport width below which adaptive filters use a bottom sheet.
  final double compactFilterBreakpoint;

  final bool showBackButton;

  /// Human-readable name of the page reached by the back action.
  ///
  /// When set to `Invoices`, the button label becomes `Back to Invoices`.
  final String? backDestinationLabel;
  final VoidCallback? onBackPressed;
  final Widget? body;

  /// Content sliver for lists, grids, and other native sliver layouts.
  final Widget? sliver;
  final EdgeInsetsGeometry bodyPadding;
  final bool applyBodyPadding;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final Widget? drawer;
  final Widget? endDrawer;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final showFiltersInBottomSheet = _showFiltersInBottomSheet(context);
    final topBar = _buildTopBar(
      context,
      showFiltersInBottomSheet: showFiltersInBottomSheet,
    );
    final contentSliver =
        sliver ?? (body == null ? null : SliverToBoxAdapter(child: body));

    return Scaffold(
      key: controller?._scaffoldKey,
      body: CustomScrollView(
        slivers: [
          if (topBar != null)
            SliverPadding(
              padding: _sectionPadding(context),
              sliver: topBar,
            ),
          if (filters.isNotEmpty && !showFiltersInBottomSheet)
            SliverPadding(
              padding: _sectionPadding(context),
              sliver: SliverToBoxAdapter(
                child: Wrap(
                  spacing: filterSpacing,
                  runSpacing: filterSpacing,
                  children: filters,
                ),
              ),
            ),
          if (contentSliver != null)
            SliverPadding(
              padding:
                  applyBodyPadding ? _contentPadding(context) : EdgeInsets.zero,
              sliver: contentSliver,
            ),
        ],
      ),
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
      drawer: drawer,
      endDrawer: endDrawer,
      backgroundColor: backgroundColor,
    );
  }

  EdgeInsets _sectionPadding(BuildContext context) {
    final gutter = _horizontalGutter(context);
    return EdgeInsets.fromLTRB(gutter, ThanksSpacing.large, gutter, 0);
  }

  EdgeInsets _contentPadding(BuildContext context) {
    final padding = bodyPadding.resolve(Directionality.of(context));
    final gutter = _horizontalGutter(context);
    return padding.copyWith(
      left: math.max(padding.left, gutter),
      right: math.max(padding.right, gutter),
    );
  }

  double _horizontalGutter(BuildContext context) {
    final size = FitSize.parse(MediaQuery.sizeOf(context).width);
    return size.isTabletOrBelow ? ThanksSpacing.large : ThanksSpacing.large * 2;
  }

  bool _showFiltersInBottomSheet(BuildContext context) =>
      switch (filterDisplayMode) {
        ThanksFilterDisplayMode.inline => false,
        ThanksFilterDisplayMode.bottomSheet => true,
        ThanksFilterDisplayMode.adaptive =>
          MediaQuery.sizeOf(context).width < compactFilterBreakpoint,
      };

  Widget? _buildTopBar(
    BuildContext context, {
    required bool showFiltersInBottomSheet,
  }) {
    if (appBar != null) return SliverToBoxAdapter(child: appBar!);
    if (title == null) return null;

    final canGoBack = showBackButton && Navigator.of(context).canPop();
    final hasDrawer = drawer != null;

    return SliverToBoxAdapter(
      child: Builder(
        builder: (buttonContext) => _ThanksTopBar(
          title: title!,
          subtitle: subtitle,
          actions: actions,
          showBackButton: canGoBack,
          backDestinationLabel: backDestinationLabel,
          showMenuButton: hasDrawer,
          onBackPressed:
              onBackPressed ?? () => Navigator.of(context).maybePop(),
          onMenuPressed: () {
            if (controller != null) {
              controller!.openDrawer();
            } else {
              Scaffold.of(buttonContext).openDrawer();
            }
          },
          onFiltersPressed: showFiltersInBottomSheet
              ? () => _showFiltersBottomSheet(buttonContext)
              : null,
        ),
      ),
    );
  }

  void _showFiltersBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) => _ThanksFiltersBottomSheet(
        filters: filters,
        spacing: filterSpacing,
      ),
    );
  }
}

class _ThanksTopBar extends StatelessWidget {
  const _ThanksTopBar({
    required this.title,
    required this.subtitle,
    required this.actions,
    required this.showBackButton,
    required this.backDestinationLabel,
    required this.showMenuButton,
    required this.onBackPressed,
    required this.onMenuPressed,
    required this.onFiltersPressed,
  });

  final String title;
  final String? subtitle;
  final List<Widget> actions;
  final bool showBackButton;
  final String? backDestinationLabel;
  final bool showMenuButton;
  final VoidCallback onBackPressed;
  final VoidCallback onMenuPressed;
  final VoidCallback? onFiltersPressed;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      spacing: ThanksSpacing.small,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showMenuButton)
          ThanksButton.icon(
            tooltip: 'Open menu',
            variant: ThanksButtonVariant.text,
            icon: const Icon(Icons.menu_rounded),
            onPressed: onMenuPressed,
          ),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (showBackButton)
                ThanksButton(
                  label: backDestinationLabel == null
                      ? 'Back'
                      : 'Back to $backDestinationLabel',
                  onPressed: onBackPressed,
                  variant: ThanksButtonVariant.outlined,
                  leadingIcon: const Icon(Icons.arrow_back, size: 14),
                  style: ButtonStyle(
                    padding: const WidgetStatePropertyAll(
                      EdgeInsets.symmetric(horizontal: ThanksSpacing.small),
                    ),
                    side: WidgetStatePropertyAll(
                      BorderSide(
                        color: Theme.of(context).colorScheme.outlineVariant,
                      ),
                    ),
                    textStyle: WidgetStatePropertyAll(textTheme.labelSmall),
                  ),
                ),
              Text(title, style: textTheme.titleLarge),
              if (subtitle != null) Text(subtitle!, style: textTheme.bodySmall),
            ],
          ),
        ),
        ...actions,
        if (onFiltersPressed != null)
          ThanksButton.icon(
            tooltip: 'Show filters',
            variant: ThanksButtonVariant.text,
            icon: const Icon(Icons.filter_list_rounded, size: 20),
            onPressed: onFiltersPressed,
          ),
      ],
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
          ThanksSpacing.large,
          ThanksSpacing.large,
          ThanksSpacing.large,
          ThanksSpacing.large + bottomInset,
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
