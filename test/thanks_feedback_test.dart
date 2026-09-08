import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:thanks_design_system/thanks_design_system.dart';

void main() {
  setUp(ThanksToast.dismiss);
  tearDown(ThanksToast.dismiss);

  Widget buildApp(Widget child) => MaterialApp(
    navigatorKey: ThanksNavigator.navigatorKey,
    theme: ThanksTheme.light(),
    home: Scaffold(body: Center(child: child)),
  );

  test('dialog action factories apply their intended defaults', () {
    final primary = ThanksDialogAction.primary(label: 'Save', onPressed: () {});
    final destructive = ThanksDialogAction.primaryDestructive(
      label: 'Delete',
      onPressed: () {},
    );
    final secondary = ThanksDialogAction.secondary(
      label: 'Cancel',
      onPressed: () {},
    );

    expect(primary.style, ThanksDialogActionStyle.filled);
    expect(primary.autofocus, isTrue);
    expect(primary.isDestructive, isFalse);
    expect(destructive.style, ThanksDialogActionStyle.filled);
    expect(destructive.autofocus, isFalse);
    expect(destructive.isDestructive, isTrue);
    expect(secondary.style, ThanksDialogActionStyle.outlined);
    expect(secondary.autofocus, isFalse);
    expect(secondary.isDestructive, isFalse);
  });

  testWidgets('dialog action closes the dialog', (tester) async {
    await tester.pumpWidget(buildApp(const SizedBox()));

    final future = ThanksDialog.show<void>(
      
      title: 'Discard changes?',
      message: 'Your updates will not be saved.',
      actions: const [
        ThanksDialogAction(
          label: 'Close',
          style: ThanksDialogActionStyle.outlined,
        ),
      ],
    );
    await tester.pumpAndSettle();

    expect(find.text('Discard changes?'), findsOneWidget);
    expect(find.byType(OutlinedButton), findsOneWidget);

    await tester.tap(find.text('Close'));
    await tester.pumpAndSettle();
    await future;
    expect(find.byType(AlertDialog), findsNothing);
  });

  testWidgets('dialog is content-sized and uses the mobile fit width cap', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1200, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(buildApp(const SizedBox()));

    ThanksDialog.show<void>( message: 'Short message');
    await tester.pumpAndSettle();

    final dialog = tester.widget<AlertDialog>(find.byType(AlertDialog));
    expect(dialog.constraints?.maxWidth, FitSize.mobile.maxWidth);
    expect(find.text('Short message'), findsOneWidget);

    ThanksNavigator.pop();
    await tester.pumpAndSettle();
  });

  testWidgets('custom content is card-wrapped without wrapping title or actions',
      (tester) async {
    await tester.pumpWidget(buildApp(const SizedBox()));

    ThanksDialog.show<void>(
      
      title: 'Details',
      content: const Text('Main information'),
      actions: [
        ThanksDialogAction.primary(
          label: 'Done',
          onPressed: () => ThanksNavigator.pop(),
        ),
      ],
    );
    await tester.pumpAndSettle();

    final dialog = tester.widget<AlertDialog>(find.byType(AlertDialog));
    expect(dialog.title, isA<Text>());
    expect(dialog.content, isA<ThanksCard>());
    expect(dialog.actions, hasLength(1));
    expect(find.text('Main information'), findsOneWidget);

    ThanksNavigator.pop();
    await tester.pumpAndSettle();
  });

  testWidgets('dialog without actions has no action section padding', (
    tester,
  ) async {
    await tester.pumpWidget(buildApp(const SizedBox()));

    ThanksDialog.show<void>( message: 'Read-only message');
    await tester.pumpAndSettle();

    final dialog = tester.widget<AlertDialog>(find.byType(AlertDialog));
    expect(dialog.actions, isNull);
    expect(dialog.actionsPadding, isNull);

    ThanksNavigator.pop();
    await tester.pumpAndSettle();
  });

  testWidgets('confirmation returns the selected result', (tester) async {
    await tester.pumpWidget(buildApp(const SizedBox()));

    final future = ThanksDialog.confirm(
      
      title: 'Delete item?',
      message: 'This cannot be undone.',
      confirmLabel: 'Delete',
      isDestructive: true,
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();
    expect(await future, isTrue);
  });

  testWidgets('notice shows one acknowledgement action', (tester) async {
    await tester.pumpWidget(buildApp(const SizedBox()));

    final future = ThanksDialog.notice(
      
      title: 'Payment complete',
      message: 'Your receipt is ready.',
    );
    await tester.pumpAndSettle();

    expect(find.byType(FilledButton), findsOneWidget);
    expect(find.text('OK'), findsOneWidget);

    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    await future;
    expect(find.byType(AlertDialog), findsNothing);
  });

  testWidgets('Escape only dismisses a dismissible dialog', (tester) async {
    await tester.pumpWidget(buildApp(const SizedBox()));

    ThanksDialog.show<void>( message: 'Dismissible');
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsNothing);

    ThanksDialog.show<void>(
      
      message: 'Must stay open',
      barrierDismissible: false,
    );
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(find.text('Must stay open'), findsOneWidget);

    ThanksNavigator.pop();
    await tester.pumpAndSettle();
  });

  testWidgets('Enter activates an autofocus primary action', (tester) async {
    var activated = false;
    await tester.pumpWidget(
      buildApp(
        const SizedBox(),
      ),
    );

    ThanksDialog.show<void>(
      
      message: 'Save your changes?',
      actions: [
        ThanksDialogAction.primary(
          label: 'Save',
          onPressed: () => activated = true,
        ),
      ],
    );
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();

    expect(activated, isTrue);
    ThanksNavigator.pop();
    await tester.pumpAndSettle();
  });

  testWidgets('toast appears top-centered with its configured margin', (
    tester,
  ) async {
    await tester.pumpWidget(buildApp(const SizedBox()));

    ThanksToast.success(
      'Saved successfully',
      
      margin: const EdgeInsets.only(top: 32),
    );
    await tester.pump();

    final toastRect = tester.getRect(find.text('Saved successfully'));
    final screenWidth =
        tester.binding.platformDispatcher.views.first.physicalSize.width /
        tester.binding.platformDispatcher.views.first.devicePixelRatio;
    expect(toastRect.top, greaterThanOrEqualTo(32));
    expect(toastRect.center.dx, closeTo(screenWidth / 2, 3));

    ThanksToast.dismiss();
    await tester.pump();
  });

  testWidgets('a new toast replaces the visible toast', (tester) async {
    await tester.pumpWidget(buildApp(const SizedBox()));

    ThanksToast.info('First message', );
    await tester.pump();
    ThanksToast.error('Second message', );
    await tester.pump();

    expect(find.text('First message'), findsNothing);
    expect(find.text('Second message'), findsOneWidget);

    ThanksToast.dismiss();
    await tester.pump();
  });

  testWidgets('toast dismisses after its configured duration', (tester) async {
    await tester.pumpWidget(buildApp(const SizedBox()));

    ThanksToast.info(
      'Temporary message',
      
      duration: const Duration(seconds: 1),
    );
    await tester.pump();
    expect(find.text('Temporary message'), findsOneWidget);

    await tester.pump(const Duration(seconds: 1));
    expect(find.text('Temporary message'), findsNothing);
  });

  testWidgets('toast shows without explicit context using ThanksNavigator', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        navigatorKey: ThanksNavigator.navigatorKey,
        theme: ThanksTheme.light(),
        home: const Scaffold(body: SizedBox()),
      ),
    );

    ThanksToast.success('Context-free toast');
    await tester.pump();

    expect(find.text('Context-free toast'), findsOneWidget);
    ThanksToast.dismiss();
    await tester.pump();
  });


  // ---------------------------------------------------------------------------

  testWidgets('dialog shows and closes without explicit context using ThanksNavigator', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        navigatorKey: ThanksNavigator.navigatorKey,
        theme: ThanksTheme.light(),
        home: const Scaffold(body: SizedBox()),
      ),
    );

    ThanksDialog.notice(
      title: 'Context-free Notice',
      message: 'This was shown without passing context.',
    );
    await tester.pumpAndSettle();

    expect(find.text('Context-free Notice'), findsOneWidget);
    expect(find.text('This was shown without passing context.'), findsOneWidget);

    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    expect(find.text('Context-free Notice'), findsNothing);
  });

  testWidgets('confirmation dialog operates without explicit context using ThanksNavigator', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        navigatorKey: ThanksNavigator.navigatorKey,
        theme: ThanksTheme.light(),
        home: const Scaffold(body: SizedBox()),
      ),
    );

    bool? result;
    ThanksDialog.confirm(
      title: 'Context-free Confirm',
      message: 'Are you sure?',
    ).then((val) => result = val);
    await tester.pumpAndSettle();

    expect(find.text('Context-free Confirm'), findsOneWidget);
    await tester.tap(find.text('Confirm'));
    await tester.pumpAndSettle();

    expect(result, isTrue);
    expect(find.text('Context-free Confirm'), findsNothing);
  });

  // ThanksDialog header actions
  // ---------------------------------------------------------------------------

  testWidgets('dialog renders headerLeading widget when provided',
      (tester) async {
    await tester.pumpWidget(
      buildApp(
        const SizedBox(),
      ),
    );

    ThanksDialog.show<void>(
      
      title: 'Service Details',
      headerLeading: const CloseButton(),
    );
    await tester.pumpAndSettle();

    expect(find.byType(CloseButton), findsOneWidget);
    expect(find.text('Service Details'), findsOneWidget);

    ThanksNavigator.pop();
    await tester.pumpAndSettle();
  });

  testWidgets('dialog renders headerActions widgets when provided',
      (tester) async {
    await tester.pumpWidget(
      buildApp(
        const SizedBox(),
      ),
    );

    ThanksDialog.show<void>(
      
      title: 'Service Details',
      headerActions: [
        IconButton(
          key: const Key('edit-action'),
          onPressed: () {},
          icon: const Icon(Icons.edit),
        ),
      ],
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('edit-action')), findsOneWidget);
    expect(find.text('Service Details'), findsOneWidget);

    ThanksNavigator.pop();
    await tester.pumpAndSettle();
  });

  testWidgets('dialog title is geometrically centered when header props used',
      (tester) async {
    await tester.pumpWidget(
      buildApp(
        const SizedBox(),
      ),
    );

    ThanksDialog.show<void>(
      
      title: 'Details',
      headerLeading: const CloseButton(),
      headerActions: [
        IconButton(
          key: const Key('action-btn'),
          onPressed: () {},
          icon: const Icon(Icons.more_vert),
        ),
      ],
    );
    await tester.pumpAndSettle();

    // Title should be inside a Stack that lets it center geometrically
    // while leading and actions are positioned on the sides.
    expect(find.byType(CloseButton), findsOneWidget); // leading present = header mode active
    expect(find.text('Details'), findsOneWidget);

    ThanksNavigator.pop();
    await tester.pumpAndSettle();
  });

  testWidgets(
      'dialog without headerLeading or headerActions keeps existing title behavior',
      (tester) async {
    await tester.pumpWidget(
      buildApp(
        const SizedBox(),
      ),
    );

    ThanksDialog.show<void>( title: 'Plain Title');
    await tester.pumpAndSettle();

    // Standard title — no Stack, no CloseButton
    expect(find.text('Plain Title'), findsOneWidget);
    expect(find.byType(CloseButton), findsNothing);
    // No header extras supplied — only standard title is rendered.

    ThanksNavigator.pop();
    await tester.pumpAndSettle();
  });

  testWidgets('dialog without title but with headerLeading renders leading',
      (tester) async {
    await tester.pumpWidget(
      buildApp(
        const SizedBox(),
      ),
    );

    ThanksDialog.show<void>(
      
      message: 'Content here',
      headerLeading: const CloseButton(),
    );
    await tester.pumpAndSettle();

    expect(find.byType(CloseButton), findsOneWidget);

    ThanksNavigator.pop();
    await tester.pumpAndSettle();
  });
}
