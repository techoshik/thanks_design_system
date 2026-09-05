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
  final showBackButton = context.knobs.boolean(
    label: 'Show Back Button',
    initialValue: false,
  );
  final showFilters = context.knobs.boolean(
    label: 'Show Filters',
    initialValue: true,
  );
  final isLoading = context.knobs.boolean(
    label: 'Is Loading',
    initialValue: false,
  );
  final maxWidthPage = context.knobs.objectOrNull.dropdown<FitSize>(
    label: 'Max Width Page',
    options: FitSize.values,
    initialOption: null,
    labelBuilder: (s) => s.name,
  );
  final maxWidthBody = context.knobs.objectOrNull.dropdown<FitSize>(
    label: 'Max Width Body',
    options: FitSize.values,
    initialOption: null,
    labelBuilder: (s) => s.name,
  );

  return ThanksScaffold(
    title: title.isEmpty ? null : title,
    subtitle: subtitle?.isEmpty ?? true ? null : subtitle,
    showBackButton: showBackButton,
    onBackPressed: showBackButton ? () {} : null,
    isLoading: isLoading,
    maxWidthPage: maxWidthPage,
    maxWidthBody: maxWidthBody,
    drawer: const Drawer(
      child: SafeArea(
        child: Column(
          children: [
            ListTile(leading: Icon(Icons.dashboard), title: Text('Dashboard')),
            ListTile(
              leading: Icon(Icons.receipt_long),
              title: Text('Invoices'),
            ),
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
            itemCount: 40,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (_, index) => Material(
              color: Colors.transparent,
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const CircleAvatar(
                  backgroundColor: ThanksColors.primary50,
                  child: Icon(
                    Icons.receipt,
                    color: ThanksColors.primary500,
                    size: 20,
                  ),
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
        ),
      ],
    ),
  );
}

Widget scaffoldEmptyStateUseCase(BuildContext context) {
  return ThanksScaffold(
    title: 'Orders & Receipts',
    subtitle: 'Track your incoming deliveries',
    showBackButton: true,
    onBackPressed: () {},
    sliver: ThanksSliverEmptyState(
      icon: const Icon(
        Icons.inbox_outlined,
        size: 56,
        color: ThanksColors.textMuted,
      ),
      title: 'No Orders Yet',
      subtitle:
          'When you place orders, they will appear here with live tracking updates.',
      action: ThanksButton(
        label: 'Explore Catalog',
        leadingIcon: const Icon(Icons.shopping_bag_outlined),
        onPressed: () {},
      ),
    ),
  );
}

