import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:thanks_design_system/thanks_design_system.dart';

/// Minimal host app with the Thanks light theme.
Widget buildApp(Widget child) => MaterialApp(
  theme: ThanksTheme.light(),
  home: Scaffold(body: child),
);

void main() {
  // ---------------------------------------------------------------------------
  // Main constructor
  // ---------------------------------------------------------------------------

  testWidgets('renders icon, title, and message', (tester) async {
    await tester.pumpWidget(
      buildApp(
        const ThanksMessageView(
          icon: Icon(Icons.inbox),
          title: 'No data',
          message: 'Nothing here yet.',
        ),
      ),
    );

    expect(find.byIcon(Icons.inbox), findsOneWidget);
    expect(find.text('No data'), findsOneWidget);
    expect(find.text('Nothing here yet.'), findsOneWidget);
  });

  testWidgets('hides message when not provided', (tester) async {
    await tester.pumpWidget(
      buildApp(
        const ThanksMessageView(icon: Icon(Icons.inbox), title: 'No data'),
      ),
    );

    expect(find.text('No data'), findsOneWidget);
    // Only one Text widget — the title; no message body.
    expect(find.byType(Text), findsOneWidget);
  });

  testWidgets('shows action button when actionLabel and onAction are provided',
      (tester) async {
    var tapped = false;
    await tester.pumpWidget(
      buildApp(
        ThanksMessageView(
          icon: const Icon(Icons.inbox),
          title: 'No data',
          actionLabel: 'Refresh',
          onAction: () => tapped = true,
        ),
      ),
    );

    expect(find.text('Refresh'), findsOneWidget);
    await tester.tap(find.text('Refresh'));
    expect(tapped, isTrue);
  });

  testWidgets('hides action button when onAction is null', (tester) async {
    await tester.pumpWidget(
      buildApp(
        const ThanksMessageView(
          icon: Icon(Icons.inbox),
          title: 'No data',
          actionLabel: 'Refresh',
          // onRetry intentionally omitted
        ),
      ),
    );

    expect(find.byType(ThanksButton), findsNothing);
  });

  testWidgets('action button shows optional leading actionIcon', (tester) async {
    await tester.pumpWidget(
      buildApp(
        ThanksMessageView(
          icon: const Icon(Icons.inbox),
          title: 'No data',
          actionLabel: 'Retry',
          actionIcon: const Icon(Icons.refresh),
          onAction: () {},
        ),
      ),
    );

    expect(find.byIcon(Icons.refresh), findsOneWidget);
  });

  testWidgets('content is centered on screen', (tester) async {
    await tester.pumpWidget(
      buildApp(
        const ThanksMessageView(icon: Icon(Icons.inbox), title: 'No data'),
      ),
    );

    expect(find.byType(Center), findsAtLeastNWidgets(1));
  });

  // ---------------------------------------------------------------------------
  // .loading() factory
  // ---------------------------------------------------------------------------

  testWidgets('loading factory renders a CircularProgressIndicator',
      (tester) async {
    await tester.pumpWidget(
      buildApp(ThanksMessageView.loading()),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('loading factory renders default title', (tester) async {
    await tester.pumpWidget(
      buildApp(ThanksMessageView.loading()),
    );

    expect(find.text('Loading'), findsOneWidget);
  });

  testWidgets('loading factory renders a custom title', (tester) async {
    await tester.pumpWidget(
      buildApp(ThanksMessageView.loading(title: 'Fetching services…')),
    );

    expect(find.text('Fetching services…'), findsOneWidget);
  });

  testWidgets('loading factory renders optional message', (tester) async {
    await tester.pumpWidget(
      buildApp(
        ThanksMessageView.loading(message: 'This may take a moment.'),
      ),
    );

    expect(find.text('This may take a moment.'), findsOneWidget);
  });

  testWidgets('loading factory spinner is 60 × 60', (tester) async {
    await tester.pumpWidget(
      buildApp(ThanksMessageView.loading()),
    );

    // The spinner is wrapped in a SizedBox(60)
    final spinnerBox = tester.widget<SizedBox>(
      find
          .ancestor(
            of: find.byType(CircularProgressIndicator),
            matching: find.byType(SizedBox),
          )
          .first,
    );
    expect(spinnerBox.width, 60);
    expect(spinnerBox.height, 60);
  });

  // ---------------------------------------------------------------------------
  // .error() factory
  // ---------------------------------------------------------------------------

  testWidgets('error factory renders Icons.error_outline and title',
      (tester) async {
    await tester.pumpWidget(
      buildApp(
        ThanksMessageView.error(title: 'Something went wrong'),
      ),
    );

    expect(find.byIcon(Icons.error_outline), findsOneWidget);
    expect(find.text('Something went wrong'), findsOneWidget);
  });

  testWidgets('error factory renders optional message', (tester) async {
    await tester.pumpWidget(
      buildApp(
        ThanksMessageView.error(
          title: 'Load failed',
          message: 'Check your connection.',
        ),
      ),
    );

    expect(find.text('Check your connection.'), findsOneWidget);
  });

  testWidgets('error factory renders action button when onAction is provided',
      (tester) async {
    var retried = false;
    await tester.pumpWidget(
      buildApp(
        ThanksMessageView.error(
          title: 'Load failed',
          onAction: () => retried = true,
        ),
      ),
    );

    expect(find.text('Retry'), findsOneWidget);
    await tester.tap(find.text('Retry'));
    expect(retried, isTrue);
  });

  testWidgets('error factory hides action button when onAction is null',
      (tester) async {
    await tester.pumpWidget(
      buildApp(
        ThanksMessageView.error(title: 'Load failed'),
      ),
    );

    expect(find.byType(ThanksButton), findsNothing);
  });

  testWidgets('error factory uses a custom actionLabel', (tester) async {
    await tester.pumpWidget(
      buildApp(
        ThanksMessageView.error(
          title: 'Load failed',
          actionLabel: 'Try again',
          onAction: () {},
        ),
      ),
    );

    expect(find.text('Try again'), findsOneWidget);
  });

  testWidgets('error icon is 60 × 60', (tester) async {
    await tester.pumpWidget(
      buildApp(ThanksMessageView.error(title: 'Oops')),
    );

    final icon = tester.widget<Icon>(find.byIcon(Icons.error_outline));
    expect(icon.size, 60);
  });
}
