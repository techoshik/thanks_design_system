import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:thanks_design_system/thanks_design_system.dart';

void main() {
  setUp(ThanksToast.dismiss);
  tearDown(ThanksToast.dismiss);

  Widget buildApp(Widget child) => MaterialApp(
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
    late BuildContext context;
    await tester.pumpWidget(
      buildApp(
        Builder(
          builder: (buildContext) {
            context = buildContext;
            return const SizedBox();
          },
        ),
      ),
    );

    final future = ThanksDialog.show<void>(
      context: context,
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
    late BuildContext context;
    await tester.pumpWidget(
      buildApp(
        Builder(
          builder: (buildContext) {
            context = buildContext;
            return const SizedBox();
          },
        ),
      ),
    );

    ThanksDialog.show<void>(context: context, message: 'Short message');
    await tester.pumpAndSettle();

    final dialog = tester.widget<AlertDialog>(find.byType(AlertDialog));
    expect(dialog.constraints?.maxWidth, FitSize.mobile.maxWidth);
    expect(find.text('Short message'), findsOneWidget);

    Navigator.of(context).pop();
    await tester.pumpAndSettle();
  });

  testWidgets('dialog without actions has no action section padding', (
    tester,
  ) async {
    late BuildContext context;
    await tester.pumpWidget(
      buildApp(
        Builder(
          builder: (buildContext) {
            context = buildContext;
            return const SizedBox();
          },
        ),
      ),
    );

    ThanksDialog.show<void>(context: context, message: 'Read-only message');
    await tester.pumpAndSettle();

    final dialog = tester.widget<AlertDialog>(find.byType(AlertDialog));
    expect(dialog.actions, isNull);
    expect(dialog.actionsPadding, isNull);

    Navigator.of(context).pop();
    await tester.pumpAndSettle();
  });

  testWidgets('confirmation returns the selected result', (tester) async {
    late BuildContext context;
    await tester.pumpWidget(
      buildApp(
        Builder(
          builder: (buildContext) {
            context = buildContext;
            return const SizedBox();
          },
        ),
      ),
    );

    final future = ThanksDialog.confirm(
      context: context,
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
    late BuildContext context;
    await tester.pumpWidget(
      buildApp(
        Builder(
          builder: (buildContext) {
            context = buildContext;
            return const SizedBox();
          },
        ),
      ),
    );

    final future = ThanksDialog.notice(
      context: context,
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
    late BuildContext context;
    await tester.pumpWidget(
      buildApp(
        Builder(
          builder: (buildContext) {
            context = buildContext;
            return const SizedBox();
          },
        ),
      ),
    );

    ThanksDialog.show<void>(context: context, message: 'Dismissible');
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsNothing);

    ThanksDialog.show<void>(
      context: context,
      message: 'Must stay open',
      barrierDismissible: false,
    );
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(find.text('Must stay open'), findsOneWidget);

    Navigator.of(context).pop();
    await tester.pumpAndSettle();
  });

  testWidgets('Enter activates an autofocus primary action', (tester) async {
    late BuildContext context;
    var activated = false;
    await tester.pumpWidget(
      buildApp(
        Builder(
          builder: (buildContext) {
            context = buildContext;
            return const SizedBox();
          },
        ),
      ),
    );

    ThanksDialog.show<void>(
      context: context,
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
    Navigator.of(context).pop();
    await tester.pumpAndSettle();
  });

  testWidgets('toast appears top-centered with its configured margin', (
    tester,
  ) async {
    late BuildContext context;
    await tester.pumpWidget(
      buildApp(
        Builder(
          builder: (buildContext) {
            context = buildContext;
            return const SizedBox();
          },
        ),
      ),
    );

    ThanksToast.success(
      context,
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
    late BuildContext context;
    await tester.pumpWidget(
      buildApp(
        Builder(
          builder: (buildContext) {
            context = buildContext;
            return const SizedBox();
          },
        ),
      ),
    );

    ThanksToast.info(context, 'First message');
    await tester.pump();
    ThanksToast.error(context, 'Second message');
    await tester.pump();

    expect(find.text('First message'), findsNothing);
    expect(find.text('Second message'), findsOneWidget);

    ThanksToast.dismiss();
    await tester.pump();
  });

  testWidgets('toast dismisses after its configured duration', (tester) async {
    late BuildContext context;
    await tester.pumpWidget(
      buildApp(
        Builder(
          builder: (buildContext) {
            context = buildContext;
            return const SizedBox();
          },
        ),
      ),
    );

    ThanksToast.info(
      context,
      'Temporary message',
      duration: const Duration(seconds: 1),
    );
    await tester.pump();
    expect(find.text('Temporary message'), findsOneWidget);

    await tester.pump(const Duration(seconds: 1));
    expect(find.text('Temporary message'), findsNothing);
  });
}
