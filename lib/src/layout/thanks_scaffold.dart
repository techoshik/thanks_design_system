import 'package:flutter/material.dart';

import '../foundations/spacing.dart';

/// A standard Thanks page shell with consistent body spacing.
///
/// Set [bodyPadding] to [EdgeInsets.zero] for full-bleed content, or set
/// [applyBodyPadding] to false when [body] manages its own scrolling padding.
class ThanksScaffold extends StatelessWidget {
  const ThanksScaffold({
    super.key,
    this.appBar,
    this.body,
    this.bodyPadding = ThanksSpacing.insetLargeWithFab,
    this.applyBodyPadding = true,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.drawer,
    this.endDrawer,
    this.backgroundColor,
  });

  final PreferredSizeWidget? appBar;
  final Widget? body;
  final EdgeInsetsGeometry bodyPadding;
  final bool applyBodyPadding;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final Widget? drawer;
  final Widget? endDrawer;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: body == null || !applyBodyPadding
          ? body
          : Padding(padding: bodyPadding, child: body),
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
      drawer: drawer,
      endDrawer: endDrawer,
      backgroundColor: backgroundColor,
    );
  }
}
