import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:thanks_design_system/thanks_design_system.dart';

void main() {
  group('ThanksSection Widget Tests', () {
    testWidgets('renders title with titleMedium style and subtitle', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light(),
          home: const Scaffold(
            body: ThanksSection(
              title: 'Section Header',
              subtitle: 'Section description or metadata',
              child: Text('Section Body Content'),
            ),
          ),
        ),
      );

      expect(find.text('Section Header'), findsOneWidget);
      expect(find.text('Section description or metadata'), findsOneWidget);
      expect(find.text('Section Body Content'), findsOneWidget);

      final titleElement = tester.element(find.text('Section Header'));
      final titleWidget = tester.widget<Text>(find.text('Section Header'));
      final theme = Theme.of(titleElement);
      expect(titleWidget.style, theme.textTheme.titleMedium);
    });

    testWidgets('renders trailing widget and custom vertical padding', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const Scaffold(
            body: ThanksSection(
              title: 'Section with Action',
              trailing: Icon(Icons.settings),
              verticalPadding: ThanksSpacing.small,
              child: Text('Child content'),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.settings), findsOneWidget);
      expect(find.text('Child content'), findsOneWidget);

      final paddingWidget = tester.widget<Padding>(
        find
            .descendant(
              of: find.byType(ThanksSection),
              matching: find.byType(Padding),
            )
            .first,
      );
      expect(
        paddingWidget.padding,
        const EdgeInsets.symmetric(vertical: ThanksSpacing.small),
      );
    });
  });
}
