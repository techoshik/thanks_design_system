import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

/// Contract for application-specific logging integrations.
///
/// Applications can implement this delegate to forward logs to analytics,
/// crash reporting, or another observability tool.
abstract class ThanksLogDelegate {
  void debug(
    String message, {
    String name,
    Object? error,
    StackTrace? stackTrace,
  });

  void error(
    String message, {
    String name,
    Object? error,
    StackTrace? stackTrace,
  });
}

/// Global logging entry point for Thanks applications.
///
/// When no delegate is configured, logs are written to the developer console
/// in debug mode. Configure a delegate when the host application needs to add
/// analytics or crash-reporting behavior.
abstract final class ThanksLog {
  static ThanksLogDelegate? _delegate;

  /// Registers the host application's logging implementation.
  static void setDelegate(ThanksLogDelegate delegate) {
    _delegate = delegate;
  }

  /// Writes a development diagnostic message.
  static void debug(
    String message, {
    String name = 'ThanksLog',
    Object? error,
    StackTrace? stackTrace,
  }) {
    final delegate = _delegate;
    if (delegate != null) {
      delegate.debug(message, name: name, error: error, stackTrace: stackTrace);
      return;
    }

    _defaultDebug(message, name: name, error: error, stackTrace: stackTrace);
  }

  /// Writes an error message with optional exception and stack-trace details.
  static void error(
    String message, {
    String name = 'ThanksLog',
    Object? error,
    StackTrace? stackTrace,
  }) {
    final delegate = _delegate;
    if (delegate != null) {
      delegate.error(message, name: name, error: error, stackTrace: stackTrace);
      return;
    }

    _defaultError(message, name: name, error: error, stackTrace: stackTrace);
  }

  static void _defaultDebug(
    String message, {
    required String name,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (!kDebugMode) return;

    developer.log(
      message,
      name: name,
      error: error,
      stackTrace: stackTrace,
      level: 0,
    );
  }

  static void _defaultError(
    String message, {
    required String name,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (!kDebugMode) return;

    developer.log(
      message,
      name: name,
      error: error,
      stackTrace: stackTrace,
      level: 1000,
    );
  }
}
