import 'package:flutter/material.dart';
import 'package:thanks_design_system/thanks_design_system.dart';
import 'package:widgetbook/widgetbook.dart';

import 'directories/components/button_use_cases.dart';
import 'directories/components/card_use_cases.dart';
import 'directories/components/thanks_pill_selector_use_cases.dart';
import 'directories/components/thanks_disclosure_card_use_cases.dart';
import 'directories/components/sliver_state_use_cases.dart';
import 'directories/foundations/colors_use_case.dart';
import 'directories/foundations/spacing_use_case.dart';
import 'directories/foundations/typography_use_case.dart';
import 'directories/layout/scaffold_use_cases.dart';

void main() {
  runApp(const ThanksWidgetbookApp());
}

class ThanksWidgetbookApp extends StatelessWidget {
  const ThanksWidgetbookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Widgetbook.material(
      directories: [
        WidgetbookCategory(
          name: 'Foundations',
          children: [
            WidgetbookComponent(
              name: 'Colors',
              useCases: [
                WidgetbookUseCase(
                  name: 'Palette & Semantic Tokens',
                  builder: colorsUseCase,
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'Typography',
              useCases: [
                WidgetbookUseCase(
                  name: 'DM Sans Type Scale',
                  builder: typographyUseCase,
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'Spacing',
              useCases: [
                WidgetbookUseCase(
                  name: 'Dimensions & Radii',
                  builder: spacingUseCase,
                ),
              ],
            ),
          ],
        ),
        WidgetbookCategory(
          name: 'Components',
          children: [
            WidgetbookComponent(
              name: 'ThanksCard',
              useCases: [
                WidgetbookUseCase(
                  name: 'Playground (Live Knobs)',
                  builder: cardPlaygroundUseCase,
                ),
                WidgetbookUseCase(
                  name: 'Section Card (Outside Header)',
                  builder: cardSectionOutsideUseCase,
                ),
                WidgetbookUseCase(
                  name: 'Tile / Metric Card (Inside Header)',
                  builder: cardMetricInsideUseCase,
                ),
                WidgetbookUseCase(
                  name: 'Nested Cards',
                  builder: cardNestedUseCase,
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'ThanksButton',
              useCases: [
                WidgetbookUseCase(
                  name: 'Playground (Live Knobs)',
                  builder: buttonPlaygroundUseCase,
                ),
                WidgetbookUseCase(
                  name: 'All Variants & Colors',
                  builder: buttonAllVariantsUseCase,
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'ThanksPillSelector',
              useCases: [
                WidgetbookUseCase(
                  name: 'Interactive Playground',
                  builder: pillSelectorPlaygroundUseCase,
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'ThanksDisclosureCard',
              useCases: [
                WidgetbookUseCase(
                  name: 'Service Card Prototype',
                  builder: disclosureCardServicePrototypeUseCase,
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'ThanksSliverLoading',
              useCases: [
                WidgetbookUseCase(
                  name: 'Playground (Centered Spinner)',
                  builder: sliverLoadingPlaygroundUseCase,
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'ThanksSliverEmptyState',
              useCases: [
                WidgetbookUseCase(
                  name: 'Playground (Icon, Title, Subtitle, Action)',
                  builder: sliverEmptyStatePlaygroundUseCase,
                ),
              ],
            ),
          ],
        ),
        WidgetbookCategory(
          name: 'Layout',
          children: [
            WidgetbookComponent(
              name: 'ThanksScaffold',
              useCases: [
                WidgetbookUseCase(
                  name: 'Playground (Drawer & Filters)',
                  builder: scaffoldPlaygroundUseCase,
                ),
                WidgetbookUseCase(
                  name: 'Empty State (Sliver)',
                  builder: scaffoldEmptyStateUseCase,
                ),
                WidgetbookUseCase(
                  name: 'Multi-Column Editor (Non-Scrollable)',
                  builder: scaffoldEditorUseCase,
                ),
              ],
            ),
          ],
        ),
      ],
      addons: [
        ThemeAddon<ThemeData>(
          themes: [
            WidgetbookTheme(
              name: 'Thanks Light Theme',
              data: ThanksTheme.light(),
            ),
          ],
          themeBuilder: (context, theme, child) =>
              Theme(data: theme, child: child),
        ),
        TextScaleAddon(min: 1.0, max: 2.0),
      ],
    );
  }
}
