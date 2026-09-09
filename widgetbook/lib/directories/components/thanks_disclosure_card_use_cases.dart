import 'package:flutter/material.dart';
import 'package:thanks_design_system/thanks_design_system.dart';

Widget disclosureCardServicePrototypeUseCase(BuildContext context) {
  return const _ServiceDisclosureCardPrototype();
}

class _ServiceDisclosureCardPrototype extends StatefulWidget {
  const _ServiceDisclosureCardPrototype();

  @override
  State<_ServiceDisclosureCardPrototype> createState() =>
      _ServiceDisclosureCardPrototypeState();
}

class _ServiceDisclosureCardPrototypeState
    extends State<_ServiceDisclosureCardPrototype> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.all(ThanksSpacing.medium),
        child: ThanksDisclosureCard(
          semanticLabel: 'Skilled Migration Service',
          expanded: _expanded,
          onExpandedChanged: (value) => setState(() => _expanded = value),
          actions: [
            ThanksPopupMenuButton<String>(
              tooltip: 'More service actions',
              icon: const Icon(Icons.more_vert),
              onSelected: (_) {},
              itemBuilder: (_) => const [
                PopupMenuItem(value: 'edit', child: Text('Edit')),
                PopupMenuItem(value: 'deactivate', child: Text('Deactivate')),
                PopupMenuItem(value: 'delete', child: Text('Delete')),
              ],
            ),
          ],
          summary: const _ServiceSummary(),
          collapsedContent: const _ServiceDescriptionPreview(),
          details: const _ServiceDetails(),
        ),
      ),
    );
  }
}

class _ServiceSummary extends StatelessWidget {
  const _ServiceSummary();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: ThanksSpacing.small,
          runSpacing: ThanksSpacing.small,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              'Skilled Migration Service',
              style: theme.textTheme.titleMedium,
            ),
            const ThanksStatusBadge(
              label: 'Active',
              size: .small,
              tone: ThanksBadgeTone.success,
            ),
          ],
        ),
        ThanksSpacing.spaceMedium,
        Wrap(
          spacing: ThanksSpacing.medium,
          runSpacing: ThanksSpacing.small,
          children: const [
            _Metadata(
              icon: Icons.dynamic_form_outlined,
              label: 'Skilled Migration Intake',
            ),
            _Metadata(icon: Icons.update, label: 'Updated today'),
          ],
        ),
      ],
    );
  }
}

class _ServiceDescriptionPreview extends StatelessWidget {
  const _ServiceDescriptionPreview();

  @override
  Widget build(BuildContext context) {
    return Text(
      'A complete intake service for skilled-migration clients, including eligibility review, document collection, and preparation for the next case stage. This preview ends here…',
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }
}

class _ServiceDetails extends StatelessWidget {
  const _ServiceDetails();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'A complete intake service for skilled-migration clients, including eligibility review, document collection, and preparation for the next case stage. The full description remains available here without making every list row tall.',
          style: theme.textTheme.bodyMedium,
        ),
        ThanksSpacing.spaceMedium,
        Text('Requirements Form', style: theme.textTheme.titleSmall),
        ThanksSpacing.spaceExtraSmall,
        Text(
          'Skilled Migration Intake · 12 active fields · 3 document uploads',
          style: theme.textTheme.bodySmall,
        ),
        ThanksSpacing.spaceMedium,
        Text(
          'Created 2 Sep 2026 · Last updated 9 Sep 2026',
          style: theme.textTheme.bodySmall,
        ),
        ThanksSpacing.spaceMedium,
        Wrap(
          spacing: ThanksSpacing.small,
          runSpacing: ThanksSpacing.small,
          children: [
            ThanksButton(
              label: 'Preview Form',
              leadingIcon: const Icon(Icons.preview_outlined),
              variant: ThanksButtonVariant.outlined,
              onPressed: () {},
            ),
            ThanksButton(
              label: 'Open in Forms',
              leadingIcon: const Icon(Icons.dynamic_form_outlined),
              variant: ThanksButtonVariant.outlined,
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }
}

class _Metadata extends StatelessWidget {
  const _Metadata({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: theme.colorScheme.onSurfaceVariant),
        ThanksSpacing.spaceSmall,
        Text(label, style: theme.textTheme.bodySmall),
      ],
    );
  }
}
