import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:thanks_design_system/thanks_design_system.dart';

/// Wraps [child] in a minimal [MaterialApp] with the Thanks light theme so
/// that [Theme.of] and [IconTheme] resolve correctly in every test.
Widget buildApp(Widget child) => MaterialApp(
  theme: ThanksTheme.light(),
  home: Scaffold(body: Center(child: child)),
);

void main() {
  // ---------------------------------------------------------------------------
  // Label rendering
  // ---------------------------------------------------------------------------

  testWidgets('renders label text for every tone', (tester) async {
    for (final tone in ThanksBadgeTone.values) {
      await tester.pumpWidget(
        buildApp(ThanksStatusBadge(label: 'Status', tone: tone)),
      );
      expect(find.text('Status'), findsOneWidget, reason: 'tone: $tone');
    }
  });

  // ---------------------------------------------------------------------------
  // Tone colours — background colour on the Container decoration
  // ---------------------------------------------------------------------------

  testWidgets('success tone applies successBackground colour', (tester) async {
    await tester.pumpWidget(
      buildApp(
        const ThanksStatusBadge(label: 'Active', tone: ThanksBadgeTone.success),
      ),
    );

    final container = tester.widget<Container>(find.byType(Container).first);
    final decoration = container.decoration as BoxDecoration;
    expect(decoration.color, ThanksColors.successBackground);
  });

  testWidgets('warning tone applies warningBackground colour', (tester) async {
    await tester.pumpWidget(
      buildApp(
        const ThanksStatusBadge(label: 'Draft', tone: ThanksBadgeTone.warning),
      ),
    );

    final container = tester.widget<Container>(find.byType(Container).first);
    final decoration = container.decoration as BoxDecoration;
    expect(decoration.color, ThanksColors.warningBackground);
  });

  testWidgets('danger tone applies dangerBackground colour', (tester) async {
    await tester.pumpWidget(
      buildApp(
        const ThanksStatusBadge(
          label: 'Archived',
          tone: ThanksBadgeTone.danger,
        ),
      ),
    );

    final container = tester.widget<Container>(find.byType(Container).first);
    final decoration = container.decoration as BoxDecoration;
    expect(decoration.color, ThanksColors.dangerBackground);
  });

  testWidgets('neutral tone applies surface2 colour', (tester) async {
    await tester.pumpWidget(
      buildApp(
        const ThanksStatusBadge(
          label: 'Inactive',
          tone: ThanksBadgeTone.neutral,
        ),
      ),
    );

    final container = tester.widget<Container>(find.byType(Container).first);
    final decoration = container.decoration as BoxDecoration;
    expect(decoration.color, ThanksColors.surface2);
  });

  testWidgets('primary tone applies primary50 colour', (tester) async {
    await tester.pumpWidget(
      buildApp(
        const ThanksStatusBadge(
          label: 'Submitted',
          tone: ThanksBadgeTone.primary,
        ),
      ),
    );

    final container = tester.widget<Container>(find.byType(Container).first);
    final decoration = container.decoration as BoxDecoration;
    expect(decoration.color, ThanksColors.primary50);
  });

  // ---------------------------------------------------------------------------
  // Default size — small
  // ---------------------------------------------------------------------------

  testWidgets('default size is small — uses extraSmall vertical padding',
      (tester) async {
    await tester.pumpWidget(
      buildApp(
        const ThanksStatusBadge(
          label: 'Active',
          tone: ThanksBadgeTone.success,
        ),
      ),
    );

    final container = tester.widget<Container>(find.byType(Container).first);
    final decoration = container.decoration as BoxDecoration;
    // All sizes use a pill (radiusFull) shape
    expect(
      decoration.borderRadius,
      BorderRadius.circular(ThanksSpacing.radiusFull),
    );

    // Small: extraSmall vertical, small horizontal
    final padding = container.padding as EdgeInsets;
    expect(padding.top, ThanksSpacing.extraSmall);
    expect(padding.bottom, ThanksSpacing.extraSmall);
    expect(padding.left, ThanksSpacing.small);
    expect(padding.right, ThanksSpacing.small);
  });

  // ---------------------------------------------------------------------------
  // Medium size
  // ---------------------------------------------------------------------------

  testWidgets('medium size uses small vertical and medium horizontal padding',
      (tester) async {
    await tester.pumpWidget(
      buildApp(
        const ThanksStatusBadge(
          label: 'Active',
          tone: ThanksBadgeTone.success,
          size: ThanksBadgeSize.medium,
        ),
      ),
    );

    final container = tester.widget<Container>(find.byType(Container).first);
    final padding = container.padding as EdgeInsets;
    expect(padding.top, ThanksSpacing.small);
    expect(padding.bottom, ThanksSpacing.small);
    expect(padding.left, ThanksSpacing.medium);
    expect(padding.right, ThanksSpacing.medium);
  });

  // ---------------------------------------------------------------------------
  // Icon rendering
  // ---------------------------------------------------------------------------

  testWidgets('badge without icon renders no Icon widget', (tester) async {
    await tester.pumpWidget(
      buildApp(
        const ThanksStatusBadge(label: 'Active', tone: ThanksBadgeTone.success),
      ),
    );

    expect(find.byType(Icon), findsNothing);
  });

  testWidgets('badge with icon renders the icon and the label', (tester) async {
    await tester.pumpWidget(
      buildApp(
        const ThanksStatusBadge(
          label: 'Active',
          tone: ThanksBadgeTone.success,
          icon: Icon(Icons.check_circle_outline),
        ),
      ),
    );

    expect(find.byIcon(Icons.check_circle_outline), findsOneWidget);
    expect(find.text('Active'), findsOneWidget);
  });

  testWidgets('icon is tinted with tone foreground colour via IconTheme',
      (tester) async {
    await tester.pumpWidget(
      buildApp(
        const ThanksStatusBadge(
          label: 'Active',
          tone: ThanksBadgeTone.success,
          icon: Icon(Icons.check_circle_outline),
        ),
      ),
    );

    // The icon widget itself must NOT hard-code a color — it inherits from
    // the surrounding IconTheme, which the badge sets to the tone foreground.
    final iconWidget = tester.widget<Icon>(
      find.byIcon(Icons.check_circle_outline),
    );
    expect(iconWidget.color, isNull);

    final iconThemeData = IconTheme.of(
      tester.element(find.byIcon(Icons.check_circle_outline)),
    );
    expect(iconThemeData.color, ThanksColors.success);
  });

  // ---------------------------------------------------------------------------
  // Foreground text colour
  // ---------------------------------------------------------------------------

  testWidgets('label text colour matches the tone foreground token',
      (tester) async {
    await tester.pumpWidget(
      buildApp(
        const ThanksStatusBadge(
          label: 'Draft',
          tone: ThanksBadgeTone.warning,
        ),
      ),
    );

    final textWidget = tester.widget<Text>(find.text('Draft'));
    expect(textWidget.style?.color, ThanksColors.warning);
  });
}
