import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:thanks_design_system/thanks_design_system.dart';
import 'package:widgetbook_workspace/directories/components/button_use_cases.dart';
import 'package:widgetbook_workspace/directories/components/card_use_cases.dart';
import 'package:widgetbook_workspace/directories/foundations/colors_use_case.dart';
import 'package:widgetbook_workspace/directories/foundations/spacing_use_case.dart';
import 'package:widgetbook_workspace/directories/foundations/typography_use_case.dart';
import 'package:widgetbook_workspace/directories/layout/scaffold_use_cases.dart';
import 'package:widgetbook_workspace/main.dart';

void main() {
  Widget wrapWithTheme(Widget Function(BuildContext) builder) {
    return MaterialApp(
      theme: ThanksTheme.light(),
      home: Builder(builder: builder),
    );
  }

  testWidgets('colorsUseCase renders without error', (tester) async {
    await tester.pumpWidget(wrapWithTheme(colorsUseCase));
    expect(tester.takeException(), isNull);
  });

  testWidgets('typographyUseCase renders without error', (tester) async {
    await tester.pumpWidget(wrapWithTheme(typographyUseCase));
    expect(tester.takeException(), isNull);
  });

  testWidgets('spacingUseCase renders without error', (tester) async {
    await tester.pumpWidget(wrapWithTheme(spacingUseCase));
    expect(tester.takeException(), isNull);
  });

  testWidgets('cardSectionOutsideUseCase renders without error', (tester) async {
    await tester.pumpWidget(wrapWithTheme(cardSectionOutsideUseCase));
    expect(tester.takeException(), isNull);
  });

  testWidgets('cardMetricInsideUseCase renders without error', (tester) async {
    await tester.pumpWidget(wrapWithTheme(cardMetricInsideUseCase));
    expect(tester.takeException(), isNull);
  });

  testWidgets('cardNestedUseCase renders without error', (tester) async {
    await tester.pumpWidget(wrapWithTheme(cardNestedUseCase));
    expect(tester.takeException(), isNull);
  });

  testWidgets('buttonAllVariantsUseCase renders without error', (tester) async {
    await tester.pumpWidget(wrapWithTheme(buttonAllVariantsUseCase));
    expect(tester.takeException(), isNull);
  });

  testWidgets('scaffoldEmptyStateUseCase renders without error', (tester) async {
    await tester.pumpWidget(wrapWithTheme(scaffoldEmptyStateUseCase));
    expect(tester.takeException(), isNull);
  });

  testWidgets('ThanksWidgetbookApp renders and can tap items without errors', (tester) async {
    await tester.pumpWidget(const ThanksWidgetbookApp());
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}

