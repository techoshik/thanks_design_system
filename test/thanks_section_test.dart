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

    testWidgets('defaults to FitSize.desktop maxWidth and enableGutter true', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(1600, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ThanksSection(
              child: SizedBox(key: Key('section-child'), height: 50),
            ),
          ),
        ),
      );

      final section = tester.widget<ThanksSection>(find.byType(ThanksSection));
      expect(section.maxWidth, FitSize.desktop);
      expect(section.enableGutter, isTrue);

      final fitContainer = tester.widget<FitContainer>(
        find.descendant(
          of: find.byType(ThanksSection),
          matching: find.byType(FitContainer),
        ),
      );
      expect(fitContainer.maxFitSize, FitSize.desktop);

      // Child is centered and inset by desktop gutter (32px)
      final childRect = tester.getRect(find.byKey(const Key('section-child')));
      expect(childRect.left, greaterThan(32));
    });

    testWidgets('respects enableGutter false', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ThanksSection(
              maxWidth: null,
              enableGutter: false,
              child: SizedBox(key: Key('no-gutter-child'), height: 50),
            ),
          ),
        ),
      );

      expect(
        tester.getTopLeft(find.byKey(const Key('no-gutter-child'))).dx,
        0.0,
      );
    });

    testWidgets('respects maxWidth null', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ThanksSection(
              maxWidth: null,
              child: Text('Unconstrained'),
            ),
          ),
        ),
      );

      expect(
        find.descendant(
          of: find.byType(ThanksSection),
          matching: find.byType(FitContainer),
        ),
        findsNothing,
      );
    });

    testWidgets(
      'fills total page width with backgroundColor including gutters',
      (tester) async {
        await tester.binding.setSurfaceSize(const Size(1100, 800));
        addTearDown(() => tester.binding.setSurfaceSize(null));

        const testColor = Color(0xFF123456);

        await tester.pumpWidget(
          MaterialApp(
            home: MediaQuery(
              data: const MediaQueryData(size: Size(1100, 800)),
              child: Scaffold(
                body: ThanksSection(
                  backgroundColor: testColor,
                  child: SizedBox(key: Key('child'), height: 100),
                ),
              ),
            ),
          ),
        );

        // Container with background color exists and spans the full 1100px width
        final containerFinder = find.descendant(
          of: find.byType(ThanksSection),
          matching: find.byWidgetPredicate(
            (widget) =>
                widget is Container &&
                widget.color == testColor,
          ),
        );
        expect(containerFinder, findsOneWidget);
        expect(tester.getSize(containerFinder).width, 1100.0);

        // Child content inside the section is inset by gutter (32px for 1000px screen)
        final childLeft = tester.getTopLeft(find.byKey(const Key('child'))).dx;
        expect(childLeft, 32.0);
      },
    );
  });
}
