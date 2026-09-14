import 'package:flutter/material.dart';
import 'package:thanks_design_system/thanks_design_system.dart';

Widget scaffoldPlaygroundUseCase(BuildContext context) {
  final theme = Theme.of(context);
  final thanksTheme = ThanksTheme.of(context);
  final spacing = thanksTheme.spacing;
  return ThanksScaffold(
    title: 'Orders',
    subtitle: 'Workspace preview',
    backgroundColor: theme.scaffoldBackgroundColor,
    actions: [
      ThanksButton.icon(
        icon: const Icon(Icons.add),
        tooltip: 'Create order',
        onPressed: () {},
      ),
    ],
    filters: [
      SizedBox(
        width: spacing.inputFieldWidthFilter,
        child: const TextField(
          decoration: InputDecoration(labelText: 'Search orders'),
        ),
      ),
      const Chip(label: Text('Active')),
    ],
    body: ThanksSection(
      title: 'Recent orders',
      subtitle: 'A fluid workspace surface using the active theme.',
      child: _OrderPreview(thanksTheme: thanksTheme),
    ),
    drawer: const Drawer(child: Center(child: Text('Navigation'))),
  );
}

Widget scaffoldEmptyStateUseCase(BuildContext context) {
  final theme = Theme.of(context);
  final thanksTheme = ThanksTheme.of(context);
  return ThanksScaffold(
    title: 'Documents',
    backgroundColor: theme.scaffoldBackgroundColor,
    body: ThanksSection(
      maxWidth: null,
      child: ThanksMessageView(
        icon: Icon(Icons.description_outlined, color: thanksTheme.textMuted),
        title: 'No documents yet',
        message: 'Upload a document to begin working with this case.',
        actionLabel: 'Upload document',
        onAction: () {},
      ),
    ),
  );
}

Widget scaffoldEditorUseCase(BuildContext context) {
  final theme = Theme.of(context);
  final spacing = ThanksTheme.of(context).spacing;
  return ThanksScaffold(
    title: 'Applicant editor',
    backgroundColor: theme.scaffoldBackgroundColor,
    body: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ThanksSection(
            maxWidth: null,
            title: 'Details',
            child: Column(
              children: [
                const TextField(decoration: InputDecoration(labelText: 'Name')),
                SizedBox(height: spacing.medium),
                const TextField(
                  decoration: InputDecoration(labelText: 'Reference'),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: spacing.medium),
        SizedBox(
          width: spacing.formWidthMinimum,
          child: ThanksSection(
            title: 'Summary',
            child: Card(
              child: Padding(
                padding: spacing.insetMedium,
                child: Text(
                  'Focused content remains constrained while the workspace stays fluid.',
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

class _OrderPreview extends StatelessWidget {
  const _OrderPreview({required this.thanksTheme});

  final ThanksTheme thanksTheme;

  @override
  Widget build(BuildContext context) {
    final materialTheme = Theme.of(context);
    return Card(
      child: Padding(
        padding: thanksTheme.spacing.insetMedium,
        child: Column(
          children: [
            for (final order in const [
              '#1042 · Acme Pty Ltd',
              '#1041 · Northwind',
            ])
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  backgroundColor: materialTheme.colorScheme.primaryContainer,
                  child: Icon(
                    Icons.receipt_long,
                    color: materialTheme.colorScheme.primary,
                  ),
                ),
                title: Text(order),
                subtitle: const Text('Updated today'),
                trailing: const ThanksStatusBadge(
                  label: 'Active',
                  tone: ThanksBadgeTone.success,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
