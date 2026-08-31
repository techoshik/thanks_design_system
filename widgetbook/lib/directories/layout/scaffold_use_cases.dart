import 'package:flutter/material.dart';
import 'package:thanks_design_system/thanks_design_system.dart';
import 'package:widgetbook/widgetbook.dart';

Widget scaffoldPlaygroundUseCase(BuildContext context) {
  final title = context.knobs.string(
    label: 'Title',
    initialValue: 'Invoices & Billing',
  );
  final subtitle = context.knobs.stringOrNull(
    label: 'Subtitle',
    initialValue: 'Manage open balances and tax receipts',
  );
  final pinAppBar = context.knobs.boolean(
    label: 'Pin App Bar',
    initialValue: false,
  );
  final showBackButton = context.knobs.boolean(
    label: 'Show Back Button',
    initialValue: false,
  );
  final showFilters = context.knobs.boolean(
    label: 'Show Filters',
    initialValue: true,
  );

  return ThanksScaffold(
    title: title.isEmpty ? null : title,
    subtitle: subtitle?.isEmpty ?? true ? null : subtitle,
    pinAppBar: pinAppBar,
    showBackButton: showBackButton,
    drawer: const Drawer(
      child: SafeArea(
        child: Column(
          children: [
            ListTile(leading: Icon(Icons.dashboard), title: Text('Dashboard')),
            ListTile(leading: Icon(Icons.receipt_long), title: Text('Invoices')),
            ListTile(leading: Icon(Icons.settings), title: Text('Settings')),
          ],
        ),
      ),
    ),
    actions: [
      ThanksButton.icon(
        icon: const Icon(Icons.search),
        tooltip: 'Search',
        variant: ThanksButtonVariant.text,
        onPressed: () {},
      ),
      ThanksButton(
        label: 'New Invoice',
        leadingIcon: const Icon(Icons.add),
        onPressed: () {},
      ),
    ],
    filters: showFilters
        ? [
            ThanksButton(
              label: 'Status: All',
              variant: ThanksButtonVariant.outlined,
              trailingIcon: const Icon(Icons.arrow_drop_down),
              onPressed: () {},
            ),
            ThanksButton(
              label: 'Due Date',
              variant: ThanksButtonVariant.outlined,
              trailingIcon: const Icon(Icons.calendar_today, size: 14),
              onPressed: () {},
            ),
          ]
        : const [],
    body: Column(
      children: [
        ThanksCard(
          title: 'Recent Invoices',
          subtitle: 'Past 30 days',
          variant: ThanksCardVariant.filledOutlined,
          padding: ThanksCardSpacing.medium,
          margin: ThanksCardSpacing.none,
          headerPosition: ThanksCardHeaderPosition.outside,
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 4,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (_, index) => ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const CircleAvatar(
                backgroundColor: ThanksColors.primary50,
                child: Icon(Icons.receipt, color: ThanksColors.primary500, size: 20),
              ),
              title: Text('Invoice #104${index + 1}'),
              subtitle: Text('Due in ${index + 2} days · Acme Corp'),
              trailing: Text(
                '\$${(index + 1) * 350}.00',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
