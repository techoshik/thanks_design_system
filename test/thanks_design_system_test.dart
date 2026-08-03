import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:thanks_design_system/thanks_design_system.dart';

void main() {
  test('default theme uses production foundations', () {
    final theme = ThanksTheme.light();

    expect(theme.colorScheme.primary, ThanksBrand.defaultBrand.primary);
    expect(theme.scaffoldBackgroundColor, ThanksColors.pageBackground);
    expect(theme.visualDensity, VisualDensity.compact);
    expect(ThanksSpacing.inputHeight, 40);
    expect(ThanksSpacing.radiusSmall, 8);
    expect(
      theme.textTheme.bodyMedium?.fontFamily,
      contains(ThanksTypography.fontFamily),
    );
  });

  testWidgets('plain and icon text fields share the 40px minimum height', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThanksTheme.light(),
        home: const Scaffold(
          body: Column(
            children: [
              TextField(key: Key('plain')),
              TextField(
                  key: Key('icon'),
                  decoration: InputDecoration(
                    suffixIcon: Icon(Icons.visibility),
                  )),
            ],
          ),
        ),
      ),
    );

    final plainHeight = tester.getSize(find.byKey(const Key('plain'))).height;
    final iconHeight = tester.getSize(find.byKey(const Key('icon'))).height;

    expect(plainHeight, greaterThanOrEqualTo(ThanksSpacing.inputHeight));
    expect(iconHeight, plainHeight);
  });

  testWidgets('expanded pill selector fills the available width',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThanksTheme.light(),
        home: Scaffold(
          body: SizedBox(
            width: 320,
            child: PillSelector<int>(
              options: const [1, 2, 3],
              labelBuilder: _label,
              selected: 1,
              onChanged: _noop,
              isExpanded: true,
            ),
          ),
        ),
      ),
    );

    expect(tester.getSize(find.byType(PillSelector<int>)).width, 320);
  });

  testWidgets('ThanksScaffold applies its default page padding',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ThanksScaffold(
          body: SizedBox(key: Key('body'), width: 10, height: 10),
        ),
      ),
    );

    expect(
      tester.getTopLeft(find.byKey(const Key('body'))),
      const Offset(ThanksSpacing.large, ThanksSpacing.large),
    );
  });

  testWidgets('ThanksScaffold can leave body padding to a scroll view', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ThanksScaffold(
          applyBodyPadding: false,
          body: SizedBox(key: Key('body'), width: 10, height: 10),
        ),
      ),
    );

    expect(tester.getTopLeft(find.byKey(const Key('body'))), Offset.zero);
  });
}

String _label(int value) => '$value';
void _noop(int? value) {}
