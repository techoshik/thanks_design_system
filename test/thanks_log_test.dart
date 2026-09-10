import 'package:flutter_test/flutter_test.dart';
import 'package:thanks_design_system/thanks_design_system.dart';

void main() {
  test('forwards debug and error messages to the configured delegate', () {
    final delegate = _RecordingLogDelegate();
    final error = StateError('failure');
    final stackTrace = StackTrace.current;

    ThanksLog.error('Default developer-console error');
    ThanksLog.setDelegate(delegate);
    ThanksLog.debug(
      'Diagnostic message',
      name: 'Test',
      error: error,
      stackTrace: stackTrace,
    );
    ThanksLog.error(
      'Error message',
      name: 'Test',
      error: error,
      stackTrace: stackTrace,
    );

    expect(delegate.debugMessage, 'Diagnostic message');
    expect(delegate.debugName, 'Test');
    expect(delegate.debugError, same(error));
    expect(delegate.debugStackTrace, same(stackTrace));
    expect(delegate.errorMessage, 'Error message');
    expect(delegate.errorName, 'Test');
    expect(delegate.errorError, same(error));
    expect(delegate.errorStackTrace, same(stackTrace));
  });
}

final class _RecordingLogDelegate implements ThanksLogDelegate {
  String? debugMessage;
  String? debugName;
  Object? debugError;
  StackTrace? debugStackTrace;
  String? errorMessage;
  String? errorName;
  Object? errorError;
  StackTrace? errorStackTrace;

  @override
  void debug(
    String message, {
    String name = 'ThanksLog',
    Object? error,
    StackTrace? stackTrace,
  }) {
    debugMessage = message;
    debugName = name;
    debugError = error;
    debugStackTrace = stackTrace;
  }

  @override
  void error(
    String message, {
    String name = 'ThanksLog',
    Object? error,
    StackTrace? stackTrace,
  }) {
    errorMessage = message;
    errorName = name;
    errorError = error;
    errorStackTrace = stackTrace;
  }
}
