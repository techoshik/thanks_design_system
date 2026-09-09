import 'package:flutter/material.dart';
import 'package:thanks_design_system/thanks_design_system.dart';

Widget spacingUseCase(BuildContext context) {
  final coreSpaces = <(String, String, double)>[
    ('Small', 'ThanksSpacing.small', ThanksSpacing.small),
    ('Medium', 'ThanksSpacing.medium', ThanksSpacing.medium),
  ];

  final radii = <(String, String, double)>[
    ('Radius Small', 'ThanksSpacing.radiusSmall', ThanksSpacing.radiusSmall),
    ('Radius Medium', 'ThanksSpacing.radiusMedium', ThanksSpacing.radiusMedium),
    ('Radius Full', 'ThanksSpacing.radiusFull', ThanksSpacing.radiusFull),
  ];

  final componentDimensions = <(String, String, double)>[
    ('Button Height', 'ThanksSpacing.buttonHeight', ThanksSpacing.buttonHeight),
    ('Input Height', 'ThanksSpacing.inputHeight', ThanksSpacing.inputHeight),
    (
      'App Bar Height',
      'ThanksSpacing.appBarHeight',
      ThanksSpacing.appBarHeight,
    ),
    ('FAB Clearance', 'ThanksSpacing.fabClearance', ThanksSpacing.fabClearance),
  ];

  final layoutDimensions = <(String, String, double)>[
    (
      'Nav Drawer Width',
      'ThanksSpacing.navigationDrawerWidthLeft',
      ThanksSpacing.navigationDrawerWidthLeft,
    ),
    (
      'Right Drawer Width',
      'ThanksSpacing.navigationDrawerWidthRight',
      ThanksSpacing.navigationDrawerWidthRight,
    ),
    (
      'View Height Min',
      'ThanksSpacing.viewHeightMinimum',
      ThanksSpacing.viewHeightMinimum,
    ),
    (
      'Form Width Min',
      'ThanksSpacing.formWidthMinimum',
      ThanksSpacing.formWidthMinimum,
    ),
    (
      'Form Width Max',
      'ThanksSpacing.formWidthMaximum',
      ThanksSpacing.formWidthMaximum,
    ),
  ];

  final pageGutters = <(String, String, double)>[
    ('Mobile Gutter', 'ThanksSpacing.medium (1x)', ThanksSpacing.medium),
    (
      'Tablet Gutter',
      'ThanksSpacing.medium * 2 (2x)',
      ThanksSpacing.medium * 2,
    ),
    (
      'Desktop Gutter',
      'ThanksSpacing.medium * 4 (4x)',
      ThanksSpacing.medium * 4,
    ),
  ];

  final insets = <(String, String, EdgeInsets)>[
    ('Inset Small', 'all(8)', ThanksSpacing.insetSmall),
    ('Inset Medium', 'all(16)', ThanksSpacing.insetMedium),
    (
      'Small w/ Left Medium',
      'fromLTRB(16, 8, 8, 8)',
      ThanksSpacing.insetSmallWithLeftMedium,
    ),
    (
      'Medium w/ FAB',
      'fromLTRB(16, 16, 16, 100)',
      ThanksSpacing.insetMediumWithFab,
    ),
    (
      'Page Vertical',
      'only(top: 16, bottom: 100)',
      ThanksSpacing.insetPageVertical,
    ),
  ];

  return Scaffold(
    backgroundColor: ThanksColors.pageBackground,
    body: SingleChildScrollView(
      padding: ThanksSpacing.insetMedium,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Core Spacing', style: Theme.of(context).textTheme.titleLarge),
          ThanksSpacing.spaceSmall,
          Text(
            'Primary 8px-based spacing grid used for padding, gaps, and margins.',
            style: TextStyle(color: ThanksColors.textSecondary, fontSize: 13),
          ),
          ThanksSpacing.spaceMedium,
          for (final (name, token, dimension) in coreSpaces)
            _DimensionBar(
              name: name,
              token: token,
              dimension: dimension,
              maxDisplayWidth: 300,
            ),
          const SizedBox(height: ThanksSpacing.medium * 1.5),
          Text('Corner Radii', style: Theme.of(context).textTheme.titleLarge),
          ThanksSpacing.spaceSmall,
          Text(
            'Border radius presets for cards, buttons, dialogs, and pills.',
            style: TextStyle(color: ThanksColors.textSecondary, fontSize: 13),
          ),
          ThanksSpacing.spaceMedium,
          Wrap(
            spacing: ThanksSpacing.medium,
            runSpacing: ThanksSpacing.medium,
            children: [
              for (final (name, token, radius) in radii)
                Container(
                  width: 170,
                  padding: const EdgeInsets.all(ThanksSpacing.medium),
                  decoration: BoxDecoration(
                    color: ThanksColors.surface,
                    borderRadius: BorderRadius.circular(radius),
                    border: Border.all(
                      color: ThanksColors.primary400,
                      width: 2,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x0A000000),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: ThanksSpacing.small),
                      Text(
                        '${radius.toInt()}px',
                        style: const TextStyle(
                          color: ThanksColors.primary600,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        token,
                        style: const TextStyle(
                          color: ThanksColors.textMuted,
                          fontSize: 10,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: ThanksSpacing.medium * 1.5),
          Text(
            'Component Dimensions & Heights',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          ThanksSpacing.spaceSmall,
          Text(
            'Standard heights and vertical clearance used by interactive widgets.',
            style: TextStyle(color: ThanksColors.textSecondary, fontSize: 13),
          ),
          ThanksSpacing.spaceMedium,
          for (final (name, token, dimension) in componentDimensions)
            _DimensionBar(
              name: name,
              token: token,
              dimension: dimension,
              maxDisplayWidth: 400,
            ),
          const SizedBox(height: ThanksSpacing.medium * 1.5),
          Text(
            'Responsive Page Gutters',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          ThanksSpacing.spaceSmall,
          Text(
            'Adaptive horizontal margins applied by ThanksScaffold depending on screen size.',
            style: TextStyle(color: ThanksColors.textSecondary, fontSize: 13),
          ),
          ThanksSpacing.spaceMedium,
          for (final (name, token, dimension) in pageGutters)
            _DimensionBar(
              name: name,
              token: token,
              dimension: dimension,
              color: ThanksColors.success,
              maxDisplayWidth: 400,
            ),
          const SizedBox(height: ThanksSpacing.medium * 1.5),
          Text(
            'Layout & Navigation Dimensions',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          ThanksSpacing.spaceSmall,
          Text(
            'Structural dimensions for side drawers, modals, and responsive form sheets.',
            style: TextStyle(color: ThanksColors.textSecondary, fontSize: 13),
          ),
          ThanksSpacing.spaceMedium,
          for (final (name, token, dimension) in layoutDimensions)
            _DimensionBar(
              name: name,
              token: token,
              dimension: dimension,
              color: ThanksColors.primary600,
              maxDisplayWidth: 450,
            ),
          const SizedBox(height: ThanksSpacing.medium * 1.5),
          Text(
            'Padding & Insets Presets',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          ThanksSpacing.spaceSmall,
          Text(
            'Pre-composed EdgeInsets instances for consistent widget padding.',
            style: TextStyle(color: ThanksColors.textSecondary, fontSize: 13),
          ),
          ThanksSpacing.spaceMedium,
          Wrap(
            spacing: ThanksSpacing.medium,
            runSpacing: ThanksSpacing.medium,
            children: [
              for (final (name, spec, inset) in insets)
                Container(
                  width: 220,
                  padding: const EdgeInsets.all(ThanksSpacing.small),
                  decoration: BoxDecoration(
                    color: ThanksColors.surface,
                    borderRadius: BorderRadius.circular(
                      ThanksSpacing.radiusSmall,
                    ),
                    border: Border.all(color: ThanksColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        spec,
                        style: const TextStyle(
                          color: ThanksColors.primary500,
                          fontSize: 11,
                          fontFamily: 'monospace',
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 36,
                        decoration: BoxDecoration(
                          color: ThanksColors.primary50,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: ThanksColors.primary100),
                        ),
                        child: Center(
                          child: Text(
                            'T:${inset.top.toInt()} B:${inset.bottom.toInt()} L:${inset.left.toInt()} R:${inset.right.toInt()}',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: ThanksColors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: ThanksSpacing.fabClearance),
        ],
      ),
    ),
  );
}

class _DimensionBar extends StatelessWidget {
  const _DimensionBar({
    required this.name,
    required this.token,
    required this.dimension,
    this.color = ThanksColors.primary400,
    this.maxDisplayWidth = 400,
  });

  final String name;
  final String token;
  final double dimension;
  final Color color;
  final double maxDisplayWidth;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: ThanksSpacing.medium),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 170,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                Text(
                  token,
                  style: const TextStyle(
                    color: ThanksColors.textMuted,
                    fontSize: 10,
                    fontFamily: 'monospace',
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 24,
            width: dimension.clamp(8, maxDisplayWidth),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: ThanksSpacing.small),
          Text(
            '${dimension.toInt()}px',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: ThanksColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
