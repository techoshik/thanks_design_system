import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:thanks_design_system/thanks_design_system.dart';

void main() {
  testWidgets(
    'ThanksDisclosureCard exposes a compact summary and toggles its details',
    (tester) async {
      final semantics = tester.ensureSemantics();
      await tester.pumpWidget(
        MaterialApp(
          theme: ThanksTheme.light(),
          home: const Scaffold(body: _DisclosureHarness()),
        ),
      );

      expect(find.text('First service'), findsOneWidget);
      expect(find.text('Short service preview'), findsOneWidget);
      expect(find.text('Complete service description'), findsNothing);
      expect(find.byTooltip('Expand First service'), findsOneWidget);
      expect(find.bySemanticsLabel('Expand First service'), findsOneWidget);

      await tester.tap(find.text('First service'));
      await tester.pumpAndSettle();

      expect(find.text('Complete service description'), findsOneWidget);
      expect(find.text('Short service preview'), findsNothing);
      expect(find.byTooltip('Collapse First service'), findsOneWidget);

      await tester.tap(find.byTooltip('Collapse First service'));
      await tester.pumpAndSettle();

      expect(find.text('Complete service description'), findsNothing);
      expect(find.text('Short service preview'), findsOneWidget);
      semantics.dispose();
    },
  );

  testWidgets(
    'ThanksDisclosureCard toggles when tapping collapsedContent',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThanksTheme.light(),
          home: const Scaffold(body: _DisclosureHarness()),
        ),
      );

      expect(find.text('Complete service description'), findsNothing);

      await tester.tap(find.text('Short service preview'));
      await tester.pumpAndSettle();

      expect(find.text('Complete service description'), findsOneWidget);
    },
  );

  testWidgets(
    'ThanksDisclosureCard keeps trailing actions separate from disclosure',
    (tester) async {
      var actionPressed = false;
      await tester.pumpWidget(
        MaterialApp(
          theme: ThanksTheme.light(),
          home: Scaffold(
            body: _DisclosureHarness(
              actions: [
                ThanksButton.icon(
                  icon: const Icon(Icons.more_vert),
                  tooltip: 'More service actions',
                  variant: ThanksButtonVariant.text,
                  onPressed: () => actionPressed = true,
                ),
              ],
            ),
          ),
        ),
      );

      await tester.tap(find.byTooltip('More service actions'));
      await tester.pump();

      expect(actionPressed, isTrue);
      expect(find.text('Complete service description'), findsNothing);
    },
  );
}

class _DisclosureHarness extends StatefulWidget {
  const _DisclosureHarness({this.actions = const []});

  final List<Widget> actions;

  @override
  State<_DisclosureHarness> createState() => _DisclosureHarnessState();
}

class _DisclosureHarnessState extends State<_DisclosureHarness> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return ThanksDisclosureCard(
      summary: const Text('First service'),
      collapsedContent: const Text('Short service preview'),
      details: const Text('Complete service description'),
      semanticLabel: 'First service',
      expanded: _expanded,
      actions: widget.actions,
      onExpandedChanged: (expanded) => setState(() => _expanded = expanded),
    );
  }
}
