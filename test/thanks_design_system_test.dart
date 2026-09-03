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
                decoration: InputDecoration(suffixIcon: Icon(Icons.visibility)),
              ),
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

  testWidgets('expanded pill selector fills the available width', (
    tester,
  ) async {
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

  testWidgets('ThanksScaffold applies its default page padding', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ThanksScaffold(
          body: SizedBox(key: Key('body'), width: 10, height: 10),
        ),
      ),
    );

    expect(
      tester.getTopLeft(find.byKey(const Key('body'))),
      const Offset(ThanksSpacing.medium, ThanksSpacing.medium),
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

  testWidgets('ThanksScaffold can pin the app bar while content scrolls', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ThanksScaffold(
          title: 'Invoices',
          pinAppBar: true,
          body: SizedBox(height: 2000, child: Text('Invoice list')),
        ),
      ),
    );

    expect(find.byType(CustomScrollView), findsOneWidget);
    final titleOffsetBefore = tester.getTopLeft(find.text('Invoices'));

    await tester.drag(find.byType(CustomScrollView), const Offset(0, -400));
    await tester.pump();

    expect(tester.getTopLeft(find.text('Invoices')), titleOffsetBefore);
  });

  testWidgets('ThanksScaffold gives top bar and filters one medium gap', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ThanksScaffold(title: 'Invoices', filters: [Text('Open')]),
      ),
    );

    final paddings = tester.widgetList<SliverPadding>(
      find.byType(SliverPadding),
    );
    const headerMargin = EdgeInsets.fromLTRB(
      ThanksSpacing.medium,
      ThanksSpacing.small,
      ThanksSpacing.medium,
      0,
    );
    const filterMargin = EdgeInsets.fromLTRB(
      ThanksSpacing.medium,
      ThanksSpacing.medium,
      ThanksSpacing.medium,
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

    expect(paddings.first.padding.resolve(TextDirection.ltr).left, 32);
    expect(paddings.elementAt(1).padding.resolve(TextDirection.ltr).right, 32);
    expect(tester.getTopLeft(find.byKey(const Key('body'))).dx, 32);
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
    'ThanksScaffold shows adaptive filters in a bottom sheet on mobile',
    (tester) async {
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
        IconTheme.of(tester.element(find.byIcon(Icons.filter_list_rounded)))
            .size,
        20,
      );
      await tester.tap(find.byIcon(Icons.filter_list_rounded));
      await tester.pumpAndSettle();

      expect(find.text('Filters'), findsOneWidget);
      expect(find.text('Open'), findsOneWidget);
      expect(find.text('Overdue'), findsOneWidget);
    },
  );

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
          actions: [Icon(Icons.search), Icon(Icons.more_vert)],
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
    expect(morePosition.dx - searchPosition.dx, 24 + ThanksSpacing.small);
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
          onGenerateRoute: (_) =>
              MaterialPageRoute<void>(builder: (_) => const SizedBox()),
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
    expect(tester.getTopLeft(find.byType(TextButton)).dy, ThanksSpacing.small);
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
            onGenerateRoute: (_) =>
                MaterialPageRoute<void>(builder: (_) => const SizedBox()),
          ),
        ),
      ),
    );

    expect(
      tester.getTopLeft(find.byType(TextButton)).dy,
      24 + ThanksSpacing.small,
    );
  });

  testWidgets('ThanksScaffoldController opens the right drawer', (
    tester,
  ) async {
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

  testWidgets(
    'ThanksScaffold sets maximum width of page using FitContainer when maxWidthPage is provided',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(1200, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        const MaterialApp(
          home: ThanksScaffold(
            title: 'Wide Page',
            maxWidthPage: FitSize.tablet,
            body: SizedBox(
              key: Key('page-body'),
              width: double.infinity,
              height: 100,
            ),
          ),
        ),
      );

      expect(find.byType(FitContainer), findsOneWidget);
      final fitContainer = tester.widget<FitContainer>(
        find.byType(FitContainer),
      );
      expect(fitContainer.maxFitSize, FitSize.tablet);

      // Verify the page content is constrained to FitSize.tablet.maxWidth (800) width and centered within 1200px
      final bodyWidth = tester
          .getSize(find.byKey(const Key('page-body')))
          .width;
      expect(bodyWidth, lessThanOrEqualTo(FitSize.tablet.maxWidth));
      final bodyRect = tester.getRect(find.byKey(const Key('page-body')));
      expect(bodyRect.center.dx, closeTo(600, 1.0));
    },
  );

  testWidgets(
    'ThanksScaffold sets maximum width of body using FitContainer when maxWidthBody is provided',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(1200, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        const MaterialApp(
          home: ThanksScaffold(
            title: 'Wide Title',
            maxWidthBody: FitSize.tablet,
            body: SizedBox(
              key: Key('constrained-body'),
              width: double.infinity,
              height: 100,
            ),
          ),
        ),
      );

      expect(find.byType(FitContainer), findsOneWidget);
      final fitContainer = tester.widget<FitContainer>(
        find.byType(FitContainer),
      );
      expect(fitContainer.maxFitSize, FitSize.tablet);

      // Body is constrained to FitSize.tablet.maxWidth (800)
      final bodyWidth = tester
          .getSize(find.byKey(const Key('constrained-body')))
          .width;
      expect(bodyWidth, FitSize.tablet.maxWidth);
      final bodyRect = tester.getRect(
        find.byKey(const Key('constrained-body')),
      );
      expect(bodyRect.center.dx, closeTo(600, 1.0));
    },
  );

  testWidgets(
    'ThanksScaffold sets maximum width of both differently based on which value is provided',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(1400, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        const MaterialApp(
          home: ThanksScaffold(
            title: 'Multi Width Scaffold',
            maxWidthPage: FitSize.laptop,
            maxWidthBody: FitSize.mobile,
            body: SizedBox(
              key: Key('dual-body'),
              width: double.infinity,
              height: 100,
            ),
          ),
        ),
      );

      final fitContainers = tester
          .widgetList<FitContainer>(find.byType(FitContainer))
          .toList();
      expect(fitContainers, hasLength(2));
      // One FitContainer has maxFitSize laptop (page), one has mobile (body)
      final sizes = fitContainers.map((c) => c.maxFitSize).toSet();
      expect(sizes, containsAll([FitSize.laptop, FitSize.mobile]));

      final bodyWidth = tester
          .getSize(find.byKey(const Key('dual-body')))
          .width;
      expect(bodyWidth, FitSize.mobile.maxWidth);
      final bodyRect = tester.getRect(find.byKey(const Key('dual-body')));
      expect(bodyRect.center.dx, closeTo(700, 1.0));
    },
  );

  testWidgets(
    'ThanksScaffold applies maxWidthPage and maxWidthBody with pinAppBar enabled',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(1400, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        const MaterialApp(
          home: ThanksScaffold(
            title: 'Pinned Top Bar',
            pinAppBar: true,
            maxWidthPage: FitSize.laptop,
            maxWidthBody: FitSize.tablet,
            body: SizedBox(
              key: Key('pinned-body'),
              width: double.infinity,
              height: 100,
            ),
          ),
        ),
      );

      final fitContainers = tester
          .widgetList<FitContainer>(find.byType(FitContainer))
          .toList();
      expect(fitContainers, hasLength(2));
      final sizes = fitContainers.map((c) => c.maxFitSize).toSet();
      expect(sizes, containsAll([FitSize.laptop, FitSize.tablet]));

      final bodyWidth = tester
          .getSize(find.byKey(const Key('pinned-body')))
          .width;
      expect(bodyWidth, FitSize.tablet.maxWidth);
    },
  );

  testWidgets(
    'ThanksCard renders child with default none variant and zero padding/margin',
    (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: ThanksCard(child: Text('Card Content'))),
        ),
      );

      expect(find.text('Card Content'), findsOneWidget);
      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration as BoxDecoration?;
      expect(decoration?.color, Colors.transparent);
      expect(decoration?.border, isNull);
    },
  );

  testWidgets(
    'ThanksCard renders outside header with title, subtitle, and actions',
    (tester) async {
      var actionClicked = false;
      await tester.pumpWidget(
        MaterialApp(
          theme: ThanksTheme.light(),
          home: Scaffold(
            body: ThanksCard(
              title: 'Card Title',
              subtitle: 'Card Subtitle',
              actions: [
                IconButton(
                  key: const Key('header-action'),
                  icon: const Icon(Icons.more_horiz),
                  onPressed: () => actionClicked = true,
                ),
              ],
              headerPosition: ThanksCardHeaderPosition.outside,
              variant: ThanksCardVariant.filledOutlined,
              child: const Text('Body Content'),
            ),
          ),
        ),
      );

      expect(find.text('Card Title'), findsOneWidget);
      expect(find.text('Card Subtitle'), findsOneWidget);
      expect(find.byKey(const Key('header-action')), findsOneWidget);
      expect(find.text('Body Content'), findsOneWidget);

      final titleOffset = tester.getTopLeft(find.text('Card Title'));
      final bodyOffset = tester.getTopLeft(find.text('Body Content'));
      expect(titleOffset.dy, lessThan(bodyOffset.dy));

      await tester.tap(find.byKey(const Key('header-action')));
      expect(actionClicked, isTrue);
    },
  );

  testWidgets(
    'ThanksCard renders inside header with title, subtitle, and divider',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThanksTheme.light(),
          home: const Scaffold(
            body: ThanksCard(
              title: 'Inside Title',
              subtitle: 'Inside Subtitle',
              headerPosition: ThanksCardHeaderPosition.inside,
              variant: ThanksCardVariant.outlined,
              showDivider: true,
              child: Text('Inside Body'),
            ),
          ),
        ),
      );

      expect(find.text('Inside Title'), findsOneWidget);
      expect(find.text('Inside Subtitle'), findsOneWidget);
      expect(find.text('Inside Body'), findsOneWidget);
      expect(find.byType(Divider), findsOneWidget);
    },
  );

  testWidgets(
    'ThanksCard supports filled, outlined, and filledOutlined variants',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThanksTheme.light(),
          home: const Scaffold(
            body: Column(
              children: [
                ThanksCard(
                  key: Key('card-filled'),
                  variant: ThanksCardVariant.filled,
                  child: Text('Filled'),
                ),
                ThanksCard(
                  key: Key('card-outlined'),
                  variant: ThanksCardVariant.outlined,
                  child: Text('Outlined'),
                ),
                ThanksCard(
                  key: Key('card-filled-outlined'),
                  variant: ThanksCardVariant.filledOutlined,
                  child: Text('Filled Outlined'),
                ),
              ],
            ),
          ),
        ),
      );

      final filledContainer = tester.widget<Container>(
        find
            .descendant(
              of: find.byKey(const Key('card-filled')),
              matching: find.byType(Container),
            )
            .first,
      );
      final filledDeco = filledContainer.decoration as BoxDecoration;
      expect(filledDeco.color, ThanksColors.surface);
      expect(filledDeco.border, isNull);

      final outlinedContainer = tester.widget<Container>(
        find
            .descendant(
              of: find.byKey(const Key('card-outlined')),
              matching: find.byType(Container),
            )
            .first,
      );
      final outlinedDeco = outlinedContainer.decoration as BoxDecoration;
      expect(outlinedDeco.color, Colors.transparent);
      expect(outlinedDeco.border?.top.color, ThanksColors.border);

      final filledOutlinedContainer = tester.widget<Container>(
        find
            .descendant(
              of: find.byKey(const Key('card-filled-outlined')),
              matching: find.byType(Container),
            )
            .first,
      );
      final filledOutlinedDeco =
          filledOutlinedContainer.decoration as BoxDecoration;
      expect(filledOutlinedDeco.color, ThanksColors.surface);
      expect(filledOutlinedDeco.border?.top.color, ThanksColors.border);
    },
  );

  testWidgets('ThanksCard applies spacing presets and custom margin/padding', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ThanksCard(
            margin: ThanksCardSpacing.medium,
            padding: ThanksCardSpacing.small,
            child: SizedBox(key: Key('child-box'), width: 100, height: 50),
          ),
        ),
      ),
    );

    final outerPadding = tester.widget<Padding>(find.byType(Padding).first);
    expect(outerPadding.padding, const EdgeInsets.all(ThanksSpacing.medium));

    final childOffset = tester.getTopLeft(find.byKey(const Key('child-box')));
    expect(childOffset.dx, ThanksSpacing.medium + ThanksSpacing.small);
    expect(childOffset.dy, ThanksSpacing.medium + ThanksSpacing.small);
  });

  testWidgets('ThanksCard applies radius preset and custom border radius', (
    tester,
  ) async {
    // Verify enum getters
    expect(ThanksCardSpacing.none.radius, 0);
    expect(ThanksCardSpacing.none.borderRadius, BorderRadius.zero);
    expect(ThanksCardSpacing.small.radius, ThanksSpacing.radiusSmall);
    expect(
      ThanksCardSpacing.small.borderRadius,
      BorderRadius.circular(ThanksSpacing.radiusSmall),
    );
    expect(ThanksCardSpacing.medium.radius, ThanksSpacing.radiusMedium);
    expect(
      ThanksCardSpacing.medium.borderRadius,
      BorderRadius.circular(ThanksSpacing.radiusMedium),
    );

    // Verify default radius (medium -> 16px)
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ThanksCard(
            key: Key('default-radius-card'),
            variant: ThanksCardVariant.filled,
            child: Text('Default Radius'),
          ),
        ),
      ),
    );

    final defaultContainer = tester.widget<Container>(
      find
          .descendant(
            of: find.byKey(const Key('default-radius-card')),
            matching: find.byType(Container),
          )
          .first,
    );
    final defaultDeco = defaultContainer.decoration as BoxDecoration;
    expect(
      defaultDeco.borderRadius,
      BorderRadius.circular(ThanksSpacing.radiusMedium),
    );

    // Verify small radius (8px)
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ThanksCard(
            key: Key('small-radius-card'),
            variant: ThanksCardVariant.filled,
            radius: ThanksCardSpacing.small,
            child: Text('Small Radius'),
          ),
        ),
      ),
    );

    final smallContainer = tester.widget<Container>(
      find
          .descendant(
            of: find.byKey(const Key('small-radius-card')),
            matching: find.byType(Container),
          )
          .first,
    );
    final smallDeco = smallContainer.decoration as BoxDecoration;
    expect(
      smallDeco.borderRadius,
      BorderRadius.circular(ThanksSpacing.radiusSmall),
    );

    // Verify customBorderRadius override
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ThanksCard(
            key: Key('custom-radius-card'),
            variant: ThanksCardVariant.filled,
            radius: ThanksCardSpacing.small,
            customBorderRadius: BorderRadius.all(Radius.circular(24)),
            child: Text('Custom Radius'),
          ),
        ),
      ),
    );

    final customContainer = tester.widget<Container>(
      find
          .descendant(
            of: find.byKey(const Key('custom-radius-card')),
            matching: find.byType(Container),
          )
          .first,
    );
    final customDeco = customContainer.decoration as BoxDecoration;
    expect(
      customDeco.borderRadius,
      const BorderRadius.all(Radius.circular(24)),
    );
  });

  testWidgets('ThanksCard handles tap events when onTap is provided', (
    tester,
  ) async {
    var tapped = false;
    await tester.pumpWidget(
      MaterialApp(
        theme: ThanksTheme.light(),
        home: Scaffold(
          body: ThanksCard(
            variant: ThanksCardVariant.filledOutlined,
            onTap: () => tapped = true,
            child: const Text('Tap Me'),
          ),
        ),
      ),
    );

    expect(find.byType(InkWell), findsOneWidget);
    await tester.tap(find.text('Tap Me'));
    expect(tapped, isTrue);
  });

  testWidgets('ThanksCard supports nesting an inner card inside a main card', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThanksTheme.light(),
        home: const Scaffold(
          body: ThanksCard(
            key: Key('main-card'),
            title: 'Main Page Card',
            variant: ThanksCardVariant.filledOutlined,
            padding: ThanksCardSpacing.medium,
            child: ThanksCard(
              key: Key('inner-card'),
              title: 'Nested Card',
              headerPosition: ThanksCardHeaderPosition.inside,
              variant: ThanksCardVariant.outlined,
              padding: ThanksCardSpacing.medium,
              child: Text('Nested content'),
            ),
          ),
        ),
      ),
    );

    expect(find.text('Main Page Card'), findsOneWidget);
    expect(find.text('Nested Card'), findsOneWidget);
    expect(find.text('Nested content'), findsOneWidget);
  });
}

String _label(int value) => '$value';
void _noop(int? value) {}
