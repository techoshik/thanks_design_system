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
    expect(ThanksSpacing.buttonHeight, 32);
    expect(theme.iconTheme.size, 20);
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

  testWidgets('ThanksButton supports variants, colors, icons, and loading', (
    tester,
  ) async {
    var pressed = false;
    await tester.pumpWidget(
      MaterialApp(
        theme: ThanksTheme.light(),
        home: Scaffold(
          body: ThanksButton(
            label: 'Save',
            onPressed: () => pressed = true,
            variant: ThanksButtonVariant.outlined,
            color: ThanksButtonColor.secondary,
            leadingIcon: const Icon(Icons.save),
            trailingIcon: const Icon(Icons.arrow_forward),
            isLoading: true,
          ),
        ),
      ),
    );

    expect(find.byType(OutlinedButton), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.byIcon(Icons.save), findsOneWidget);
    expect(find.byIcon(Icons.arrow_forward), findsOneWidget);

    await tester.tap(find.byType(OutlinedButton));
    expect(pressed, isFalse);
  });

  testWidgets('ThanksButton can fill its available width', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThanksTheme.light(),
        home: Scaffold(
          body: ThanksButton(
            label: 'Continue',
            onPressed: () {},
            variant: ThanksButtonVariant.filled,
            isExpanded: true,
          ),
        ),
      ),
    );

    expect(tester.getSize(find.byType(ThanksButton)).width, 800);
  });

  testWidgets('ThanksButton supports the tertiary color', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThanksTheme.light(),
        home: Scaffold(
          body: ThanksButton(
            label: 'More options',
            onPressed: () {},
            variant: ThanksButtonVariant.filled,
            color: ThanksButtonColor.tertiary,
          ),
        ),
      ),
    );

    final button = tester.widget<FilledButton>(find.byType(FilledButton));
    final background = button.style?.backgroundColor?.resolve({});

    expect(background, ThanksTheme.light().colorScheme.tertiary);
  });

  testWidgets('ThanksButton defaults to the filled variant', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThanksTheme.light(),
        home: Scaffold(
          body: ThanksButton(label: 'Continue', onPressed: () {}),
        ),
      ),
    );

    expect(find.byType(FilledButton), findsOneWidget);
    expect(find.byType(ElevatedButton), findsNothing);
  });

  testWidgets('ThanksButton variants use the shared 32px button height', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThanksTheme.light(),
        home: Scaffold(
          body: Column(
            children: [
              ThanksButton(
                key: const Key('filled-button'),
                label: 'Filled',
                onPressed: () {},
              ),
              ThanksButton(
                key: const Key('outlined-button'),
                label: 'Outlined',
                variant: ThanksButtonVariant.outlined,
                onPressed: () {},
              ),
              ThanksButton(
                key: const Key('text-button'),
                label: 'Text',
                variant: ThanksButtonVariant.text,
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );

    for (final key in ['filled-button', 'outlined-button', 'text-button']) {
      expect(
        tester.getSize(find.byKey(Key(key))).height,
        ThanksSpacing.buttonHeight,
      );
    }
  });

  testWidgets('ThanksButton.icon supports variants, colors, and loading', (
    tester,
  ) async {
    var pressed = false;
    await tester.pumpWidget(
      MaterialApp(
        theme: ThanksTheme.light(),
        home: Scaffold(
          body: ThanksButton.icon(
            icon: const Icon(Icons.add),
            tooltip: 'Add invoice',
            onPressed: () => pressed = true,
            variant: ThanksButtonVariant.outlined,
            color: ThanksButtonColor.tertiary,
            isLoading: true,
          ),
        ),
      ),
    );

    final button = tester.widget<IconButton>(find.byType(IconButton));
    final foreground = button.style?.foregroundColor?.resolve({});

    expect(button.tooltip, 'Add invoice');
    expect(foreground, ThanksTheme.light().colorScheme.tertiary);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.byIcon(Icons.add), findsNothing);

    await tester.tap(find.byType(IconButton));
    expect(pressed, isFalse);
  });

  testWidgets('ThanksButton.icon matches the shared button height', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThanksTheme.light(),
        home: Scaffold(
          body: Row(
            children: [
              ThanksButton(
                key: const Key('text-button'),
                label: 'Add',
                onPressed: () {},
              ),
              ThanksButton.icon(
                key: const Key('icon-button'),
                icon: const Icon(Icons.add),
                tooltip: 'Add',
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );

    expect(
      tester.getSize(find.byKey(const Key('icon-button'))).height,
      ThanksSpacing.buttonHeight,
    );
    expect(
      tester.getSize(find.byKey(const Key('icon-button'))).height,
      tester.getSize(find.byKey(const Key('text-button'))).height,
    );
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

  testWidgets('ThanksScaffold keeps its shell and sliver content together', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ThanksScaffold(
          title: 'Invoices',
          subtitle: 'Manage payments',
          filters: [Text('Open'), Text('Overdue')],
          sliver: SliverToBoxAdapter(child: Text('Invoice list')),
        ),
      ),
    );

    expect(find.byType(CustomScrollView), findsOneWidget);
    expect(find.byType(SliverAppBar), findsNothing);
    expect(find.text('Open'), findsOneWidget);
    expect(find.text('Overdue'), findsOneWidget);
    expect(find.text('Invoice list'), findsOneWidget);
  });

  testWidgets('ThanksScaffold gives top bar and filters one large gap', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ThanksScaffold(
          title: 'Invoices',
          filters: [Text('Open')],
        ),
      ),
    );

    final paddings = tester.widgetList<SliverPadding>(
      find.byType(SliverPadding),
    );
    const headerMargin = EdgeInsets.fromLTRB(
      ThanksSpacing.large,
      ThanksSpacing.small,
      ThanksSpacing.large,
      0,
    );
    const filterMargin = EdgeInsets.fromLTRB(
      ThanksSpacing.large,
      ThanksSpacing.large,
      ThanksSpacing.large,
      0,
    );

    expect(paddings, hasLength(2));
    expect(paddings.first.padding, headerMargin);
    expect(paddings.last.padding, filterMargin);
  });

  testWidgets('ThanksScaffold doubles horizontal gutters above tablet', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(size: Size(1100, 800)),
          child: ThanksScaffold(
            title: 'Invoices',
            filters: [Text('Open')],
            body: SizedBox(key: Key('body')),
          ),
        ),
      ),
    );

    final paddings = tester.widgetList<SliverPadding>(
      find.byType(SliverPadding),
    );

    expect(paddings.first.padding.resolve(TextDirection.ltr).left, 48);
    expect(paddings.elementAt(1).padding.resolve(TextDirection.ltr).right, 48);
    expect(tester.getTopLeft(find.byKey(const Key('body'))).dx, 48);
  });

  testWidgets('ThanksScaffold wraps inline filters onto additional rows', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(800, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      const MaterialApp(
        home: ThanksScaffold(
          title: 'Invoices',
          filterDisplayMode: ThanksFilterDisplayMode.inline,
          filters: [
            SizedBox(key: Key('filter-one'), width: 400, height: 20),
            SizedBox(key: Key('filter-two'), width: 400, height: 20),
          ],
        ),
      ),
    );

    expect(
      tester.getTopLeft(find.byKey(const Key('filter-two'))).dy,
      greaterThan(tester.getTopLeft(find.byKey(const Key('filter-one'))).dy),
    );
  });

  testWidgets(
      'ThanksScaffold shows adaptive filters in a bottom sheet on mobile', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThanksTheme.light(),
        home: MediaQuery(
          data: const MediaQueryData(size: Size(375, 800)),
          child: const ThanksScaffold(
            title: 'Invoices',
            filters: [Text('Open'), Text('Overdue')],
          ),
        ),
      ),
    );

    expect(find.text('Open'), findsNothing);
    expect(
      IconTheme.of(
        tester.element(find.byIcon(Icons.filter_list_rounded)),
      ).size,
      20,
    );
    await tester.tap(find.byIcon(Icons.filter_list_rounded));
    await tester.pumpAndSettle();

    expect(find.text('Filters'), findsOneWidget);
    expect(find.text('Open'), findsOneWidget);
    expect(find.text('Overdue'), findsOneWidget);
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

  testWidgets('ThanksScaffold shows a menu for an available left drawer', (
    tester,
  ) async {
    final controller = ThanksScaffoldController();
    await tester.pumpWidget(
      MaterialApp(
        home: ThanksScaffold(
          controller: controller,
          title: 'Home',
          drawer: const Drawer(child: Text('Navigation')),
          body: const SizedBox(),
        ),
      ),
    );

    expect(find.byIcon(Icons.menu_rounded), findsOneWidget);
    await tester.tap(find.byIcon(Icons.menu_rounded));
    await tester.pumpAndSettle();
    expect(find.text('Navigation'), findsOneWidget);
  });

  testWidgets('ThanksScaffold spaces generated top-bar actions', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ThanksScaffold(
          title: 'Home',
          actions: [
            Icon(Icons.search),
            Icon(Icons.more_vert),
          ],
          body: SizedBox(),
        ),
      ),
    );

    final searchPosition = tester.getTopLeft(find.byIcon(Icons.search));
    final morePosition = tester.getTopLeft(find.byIcon(Icons.more_vert));

    expect(
      tester.getTopLeft(find.text('Home')).dy,
      ThanksSpacing.small + ThanksSpacing.buttonHeight,
    );
    expect(
      morePosition.dx - searchPosition.dx,
      24 + ThanksSpacing.small,
    );
  });

  testWidgets('ThanksScaffold shows menu and back navigation together', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThanksTheme.light(),
        home: Navigator(
          onGenerateInitialRoutes: (_, __) => [
            MaterialPageRoute<void>(builder: (_) => const SizedBox()),
            MaterialPageRoute<void>(
              builder: (_) => ThanksScaffold(
                title: 'Details',
                backDestinationLabel: 'Invoices',
                drawer: const Drawer(),
                body: const SizedBox(),
              ),
            ),
          ],
          onGenerateRoute: (_) => MaterialPageRoute<void>(
            builder: (_) => const SizedBox(),
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    expect(find.byType(TextButton), findsOneWidget);
    expect(find.text('Back to Invoices'), findsOneWidget);
    expect(
      tester.getSize(find.byType(TextButton)).height,
      ThanksSpacing.buttonHeight,
    );
    expect(
      tester.getTopLeft(find.byType(TextButton)).dy,
      ThanksSpacing.small,
    );
    expect(
      tester.getTopLeft(find.text('Details')).dy,
      ThanksSpacing.small + ThanksSpacing.buttonHeight,
    );
    expect(find.byIcon(Icons.menu_rounded), findsOneWidget);

    await tester.tap(find.byIcon(Icons.menu_rounded));
    await tester.pumpAndSettle();
    expect(find.byType(Drawer), findsOneWidget);
  });

  testWidgets('ThanksScaffold keeps its back button below the top safe area', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThanksTheme.light(),
        home: MediaQuery(
          data: const MediaQueryData(padding: EdgeInsets.only(top: 24)),
          child: Navigator(
            onGenerateInitialRoutes: (_, __) => [
              MaterialPageRoute<void>(builder: (_) => const SizedBox()),
              MaterialPageRoute<void>(
                builder: (_) => const ThanksScaffold(title: 'Details'),
              ),
            ],
            onGenerateRoute: (_) => MaterialPageRoute<void>(
              builder: (_) => const SizedBox(),
            ),
          ),
        ),
      ),
    );

    expect(
      tester.getTopLeft(find.byType(TextButton)).dy,
      24 + ThanksSpacing.small,
    );
  });

  testWidgets('ThanksScaffoldController opens the right drawer',
      (tester) async {
    final controller = ThanksScaffoldController();
    await tester.pumpWidget(
      MaterialApp(
        home: ThanksScaffold(
          controller: controller,
          title: 'Home',
          endDrawer: const Drawer(child: Text('Actions')),
          body: const SizedBox(),
        ),
      ),
    );

    controller.openEndDrawer();
    await tester.pumpAndSettle();
    expect(find.text('Actions'), findsOneWidget);
  });
}

String _label(int value) => '$value';
void _noop(int? value) {}
