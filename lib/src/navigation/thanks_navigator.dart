import 'package:flutter/material.dart';

/// Abstract contract for router-agnostic navigation.
///
/// Decouples feature screens and UI modules from specific routing implementations
/// (such as GoRouter, AutoRoute, or standard Navigator 2.0).
abstract class ThanksNavigationDelegate {
  void go(String location, {Object? extra});
  Future<T?> push<T>(String location, {Object? extra});
  void pop<T>([T? result]);
  bool canPop();
}

/// Global entry point for app navigation and root context resolution.
abstract final class ThanksNavigator {
  /// The global root navigator key attached to the application's root router.
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  /// The root [BuildContext] for transient overlays, dialogs, and toasts.
  static BuildContext? get currentContext => navigatorKey.currentContext;

  static ThanksNavigationDelegate? _delegate;

  /// Registers the authoritative navigation delegate (e.g. GoRouterNavigationDelegate).
  static void setDelegate(ThanksNavigationDelegate delegate) {
    _delegate = delegate;
  }

  /// Navigates to a location, replacing the current route stack according to router rules.
  static void go(String location, {Object? extra}) {
    if (_delegate != null) {
      _delegate!.go(location, extra: extra);
    } else {
      assert(false, 'ThanksNavigator delegate is not configured.');
    }
  }

  /// Pushes a new route onto the stack and returns a [Future] with the route's result.
  static Future<T?> push<T>(String location, {Object? extra}) {
    if (_delegate != null) {
      return _delegate!.push<T>(location, extra: extra);
    }
    assert(false, 'ThanksNavigator delegate is not configured.');
    return Future<T?>.value(null);
  }

  /// Pops the topmost route.
  static void pop<T>([T? result]) {
    if (_delegate != null) {
      _delegate!.pop<T>(result);
    } else {
      final context = currentContext;
      if (context != null) {
        Navigator.of(context).pop(result);
      }
    }
  }

  /// Safely closes the top-most dialog/overlay without affecting underlying page routes.
  static void closeDialog<T>([T? result]) {
    final context = currentContext;
    if (context != null && Navigator.of(context, rootNavigator: true).canPop()) {
      Navigator.of(context, rootNavigator: true).pop(result);
    } else {
      pop<T>(result);
    }
  }

  /// Returns whether a route can be popped.
  static bool canPop() => _delegate?.canPop() ?? false;
}
