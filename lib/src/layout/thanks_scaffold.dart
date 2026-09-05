import 'package:fit_it/fit_it.dart';
import 'package:flutter/material.dart';

export 'package:fit_it/fit_it.dart' show FitContainer, FitIt, FitSize;

import '../components/thanks_button.dart';
import '../components/thanks_sliver_loading.dart';
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
    this.backDestinationLabel,
    this.onBackPressed,
    this.isLoading = false,
    this.body,
    this.sliver,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.drawer,
    this.endDrawer,
    this.backgroundColor,
    this.maxWidthPage,
    this.maxWidthBody,
  }) : assert(
         body == null || sliver == null,
         'Cannot provide both body and sliver.',
       );

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

  /// Human-readable name of the page reached by the back action.
  ///
  /// When set to `Invoices`, the button tooltip becomes `Back to Invoices`.
  final String? backDestinationLabel;
  final VoidCallback? onBackPressed;

  /// Whether the page is currently in a loading state.
  ///
  /// When true, [ThanksSliverLoading] is automatically displayed in place of
  /// [body] or [sliver].
  final bool isLoading;

  /// The standard box widget to display as the primary page content.
  ///
  /// Cannot be provided if [sliver] is also provided.
  final Widget? body;

  /// A custom sliver widget to display as the primary page content.
  ///
  /// Useful for custom scrolling layouts, [SliverList], or states such as
  /// [ThanksSliverEmptyState]. Cannot be provided if [body] is also provided.
  final Widget? sliver;

  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final Widget? drawer;
  final Widget? endDrawer;
  final Color? backgroundColor;

  /// The maximum size constraint for the entire page, using [FitContainer].
  final FitSize? maxWidthPage;

  /// The maximum size constraint for the body content, using [FitContainer].
  final FitSize? maxWidthBody;

  @override
  Widget build(BuildContext context) {
    final showFiltersInBottomSheet = _showFiltersInBottomSheet(context);
    final hasBackButton =
        title != null &&
        showBackButton &&
        (onBackPressed != null || Navigator.of(context).canPop());
    final effectiveAppBar = _buildAppBar(
      context,
      showFiltersInBottomSheet: showFiltersInBottomSheet,
      hasBackButton: hasBackButton,
    );

    final effectiveMaxWidthBody =
        (maxWidthBody != null &&
            maxWidthPage != null &&
            maxWidthBody!.maxWidth > maxWidthPage!.maxWidth)
        ? maxWidthPage
        : maxWidthBody;

    final effectiveBody = body != null && effectiveMaxWidthBody != null
        ? FitContainer(maxFitSize: effectiveMaxWidthBody, child: body)
        : body;
    final Widget? contentSliver;
    if (isLoading) {
      contentSliver = const ThanksSliverLoading();
    } else if (sliver != null) {
      contentSliver = sliver;
    } else if (effectiveBody != null) {
      contentSliver = SliverToBoxAdapter(child: effectiveBody);
    } else {
      contentSliver = null;
    }
    final inlineFilters = filters.isNotEmpty && !showFiltersInBottomSheet
        ? Wrap(
            spacing: ThanksSpacing.medium,
            runSpacing: ThanksSpacing.medium,
            children: filters,
          )
        : null;

    final pageContent = CustomScrollView(
      slivers: [
        if (inlineFilters != null)
          SliverPadding(
            padding: _sectionPadding(context),
            sliver: SliverToBoxAdapter(child: inlineFilters),
          ),
        if (contentSliver != null)
          SliverPadding(
            padding: _sectionPadding(
              context,
              bottom: ThanksSpacing.fabClearance,
            ),
            sliver: contentSliver,
          ),
      ],
    );

    final constrainedPage = maxWidthPage != null
        ? FitContainer(maxFitSize: maxWidthPage, child: pageContent)
        : pageContent;

    return Scaffold(
      key: controller?._scaffoldKey,
      appBar: effectiveAppBar,
      body: SafeArea(bottom: false, child: constrainedPage),
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
      drawer: drawer,
      endDrawer: endDrawer,
      backgroundColor: backgroundColor,
    );
  }

  EdgeInsets _sectionPadding(
    BuildContext context, {
    double top = ThanksSpacing.medium,
    double bottom = ThanksSpacing.medium,
  }) {
    final gutter = _horizontalGutter(context);
    return EdgeInsets.fromLTRB(gutter, top, gutter, bottom);
  }

  double _horizontalGutter(BuildContext context) {
    final size = FitSize.parse(MediaQuery.sizeOf(context).width);
    return size.isTabletOrBelow
        ? ThanksSpacing.medium
        : ThanksSpacing.medium * 2;
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

  PreferredSizeWidget? _buildAppBar(
    BuildContext context, {
    required bool showFiltersInBottomSheet,
    required bool hasBackButton,
  }) {
    final rawAppBar = _createDefaultAppBar(
      context,
      showFiltersInBottomSheet: showFiltersInBottomSheet,
      hasBackButton: hasBackButton,
    );

    if (rawAppBar == null) return null;

    return _ThanksAppBarWrapper(
      appBar: rawAppBar,
      maxWidthPage: maxWidthPage,
      horizontalGutter: _horizontalGutter(context),
    );
  }

  PreferredSizeWidget? _createDefaultAppBar(
    BuildContext context, {
    required bool showFiltersInBottomSheet,
    required bool hasBackButton,
  }) {
    if (title == null) return null;

    final hasDrawer = drawer != null;
    final backTooltip = backDestinationLabel == null
        ? 'Back'
        : 'Back to $backDestinationLabel';

    Widget? leading;
    if (hasBackButton) {
      leading = Builder(
        builder: (context) {
          return IconButton.filledTonal(
            tooltip: backTooltip,
            icon: const Icon(Icons.arrow_back),
            style: IconButton.styleFrom(shape: StadiumBorder()),
            onPressed: onBackPressed ?? () => Navigator.of(context).maybePop(),
          );
        },
      );
    } else if (hasDrawer) {
      leading = Builder(
        builder: (buttonContext) => IconButton.filledTonal(
          tooltip: 'Open menu',
          icon: const Icon(Icons.menu_rounded),
          style: IconButton.styleFrom(shape: StadiumBorder()),
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

    Widget titleWidget = Text(title!);
    if (subtitle != null) {
      titleWidget = Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          titleWidget,
          Text(subtitle!, style: Theme.of(context).textTheme.bodySmall),
        ],
      );
    }

    return AppBar(
      automaticallyImplyLeading: false,
      leading: leading,
      title: titleWidget,
      backgroundColor: backgroundColor,
      actionsPadding: EdgeInsets.zero,
      actions: [Row(spacing: ThanksSpacing.small, children: effectiveActions)],
    );
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

class _ThanksAppBarWrapper extends StatelessWidget
    implements PreferredSizeWidget {
  const _ThanksAppBarWrapper({
    required this.appBar,
    this.maxWidthPage,
    required this.horizontalGutter,
  });

  final PreferredSizeWidget appBar;
  final FitSize? maxWidthPage;
  final double horizontalGutter;

  @override
  Size get preferredSize =>
      Size.fromHeight(appBar.preferredSize.height + ThanksSpacing.medium * 2);

  @override
  Widget build(BuildContext context) {
    Widget content = Padding(
      padding: EdgeInsets.symmetric(
        vertical: ThanksSpacing.medium,
        horizontal: horizontalGutter,
      ),
      child: appBar,
    );

    if (maxWidthPage != null) {
      content = FitContainer(maxFitSize: maxWidthPage, child: content);
    }

    return SafeArea(bottom: false, child: content);
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
