import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:thanks_design_system/thanks_design_system.dart';

void main() {
  group('ThanksImageView Tests', () {
    testWidgets('renders initials fallback when url is null', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThanksTheme.light(),
          home: const Scaffold(
            body: ThanksImageView(
              name: 'Sofia García',
              size: 40,
            ),
          ),
        ),
      );

      expect(find.text('SG'), findsOneWidget);
    });

    testWidgets('renders single initial for single name', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThanksTheme.light(),
          home: const Scaffold(
            body: ThanksImageView(
              name: 'Cher',
              size: 40,
            ),
          ),
        ),
      );

      expect(find.text('C'), findsOneWidget);
    });

    testWidgets('renders person icon when name is empty and url is null',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThanksTheme.light(),
          home: const Scaffold(
            body: ThanksImageView(
              size: 40,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.person_outline), findsOneWidget);
    });

    testWidgets('invokes onTap callback when tapped', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          theme: ThanksTheme.light(),
          home: Scaffold(
            body: ThanksImageView(
              name: 'Alex Doe',
              size: 40,
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ThanksImageView));
      await tester.pumpAndSettle();

      expect(tapped, isTrue);
    });
  });
}
