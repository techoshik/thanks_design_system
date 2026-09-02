import 'package:flutter/material.dart';
import 'package:thanks_design_system/thanks_design_system.dart';

Widget spacingUseCase(BuildContext context) {
  final spaces = <(String, double)>[
    ('Small', ThanksSpacing.small),
    ('Medium', ThanksSpacing.medium),
    ('Button Height', ThanksSpacing.buttonHeight),
    ('Input Height', ThanksSpacing.inputHeight),
    ('App Bar Height', ThanksSpacing.appBarHeight),
    ('FAB Clearance', ThanksSpacing.fabClearance),
  ];

  return Scaffold(
    backgroundColor: ThanksColors.pageBackground,
    body: SingleChildScrollView(
      padding: ThanksSpacing.insetMedium,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Spacing Dimensions', style: Theme.of(context).textTheme.headlineSmall),
          ThanksSpacing.spaceMedium,
          for (final (name, dimension) in spaces) ...[
            Padding(
              padding: const EdgeInsets.only(bottom: ThanksSpacing.medium),
              child: Row(
                children: [
                  SizedBox(
                    width: 150,
                    child: Text(
                      '$name (${dimension.toInt()}px)',
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                    ),
                  ),
                  Container(
                    height: 24,
                    width: dimension,
                    decoration: BoxDecoration(
                      color: ThanksColors.primary400,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    ),
  );
}
