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
    expect(ThanksSpacing.extraSmall, 4);
    expect(ThanksSpacing.radiusSmall, 8);
    expect(
      theme.textTheme.bodyMedium?.fontFamily,
      contains(ThanksTypography.fontFamily),
    );
    expect(theme.popupMenuTheme.color, ThanksColors.surface);
    expect(theme.popupMenuTheme.surfaceTintColor, Colors.transparent);
    expect(theme.popupMenuTheme.elevation, 3);
    expect(theme.popupMenuTheme.shadowColor, theme.colorScheme.shadow);
    final popupBorder = theme.popupMenuTheme.shape as RoundedRectangleBorder;
    expect(
      popupBorder.borderRadius,
      BorderRadius.circular(ThanksSpacing.radiusMedium),
    );
    expect(popupBorder.side.color, theme.colorScheme.outlineVariant);
    expect(theme.inputDecorationTheme.suffixIconConstraints?.minWidth, kMinInteractiveDimension);
    expect(theme.inputDecorationTheme.suffixIconConstraints?.minHeight, ThanksSpacing.inputHeight);
    expect(theme.inputDecorationTheme.suffixIconConstraints?.maxHeight, ThanksSpacing.inputHeight);
    expect(theme.inputDecorationTheme.prefixIconConstraints?.minWidth, kMinInteractiveDimension);
    expect(theme.inputDecorationTheme.prefixIconConstraints?.minHeight, ThanksSpacing.inputHeight);
    expect(theme.inputDecorationTheme.prefixIconConstraints?.maxHeight, ThanksSpacing.inputHeight);
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

  testWidgets(
    'suffixIcon aligns symmetrically with DropdownButtonFormField icon',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 600));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      const dropdownKey = Key('test_dropdown');
      const inputKey = Key('test_input');

      await tester.pumpWidget(
        MaterialApp(
          theme: ThanksTheme.light(),
          home: Scaffold(
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: ThanksSpacing.medium),
              child: Column(
                children: [
                  DropdownButtonFormField<String>(
                    key: dropdownKey,
                    initialValue: 'item1',
                    items: const [
                      DropdownMenuItem(value: 'item1', child: Text('Item 1')),
                    ],
                    onChanged: null,
                  ),
                  const SizedBox(height: ThanksSpacing.medium),
                  const TextField(
                    key: inputKey,
                    decoration: InputDecoration(
                      suffixIcon: Icon(Icons.calendar_month_outlined),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final dropdownIcon = find.byIcon(Icons.arrow_drop_down);
      final calendarIcon = find.byIcon(Icons.calendar_month_outlined);

      final dropdownIconRect = tester.getRect(dropdownIcon);
      final calendarIconRect = tester.getRect(calendarIcon);

      // The suffix icon container must be centered in line with the dropdown icon.
      expect(calendarIconRect.center.dx, closeTo(dropdownIconRect.center.dx, 1.0));

      // The painted glyph (RichText inside Icon) must be inset from the right border.
      final calendarGlyph = find.descendant(of: calendarIcon, matching: find.byType(RichText));
      final calendarGlyphRect = tester.getRect(calendarGlyph);
      final inputRect = tester.getRect(find.byKey(inputKey));
      expect(calendarGlyphRect.right, lessThan(inputRect.right - ThanksSpacing.small));
    },
  );

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

  testWidgets(
    'ThanksScaffold provides full-width body while ThanksSection applies gutter on mobile',
    (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(size: Size(375, 800)),
            child: ThanksScaffold(
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(key: Key('raw-body'), width: 10, height: 10),
                  ThanksSection(
                    child: SizedBox(
                      key: Key('section-body'),
                      width: 10,
                      height: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Body is full-width (starts at 0) so scrollbars can pin to the right edge
      expect(tester.getTopLeft(find.byKey(const Key('raw-body'))).dx, 0.0);
      // ThanksSection inside body applies the responsive gutter (16px on mobile)
      expect(
        tester.getTopLeft(find.byKey(const Key('section-body'))).dx,
        ThanksSpacing.medium,
      );
    },
  );

  testWidgets('ThanksScaffold keeps its shell and content together', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ThanksScaffold(
          title: 'Invoices',
          subtitle: 'Manage payments',
          filters: [Text('Open'), Text('Overdue')],
          body: Text('Invoice list'),
        ),
      ),
    );

    expect(find.byType(ListTile), findsOneWidget);
    expect(find.text('Open'), findsOneWidget);
    expect(find.text('Overdue'), findsOneWidget);
    expect(find.text('Invoice list'), findsOneWidget);
  });

  testWidgets('ThanksScaffold app bar stays fixed while body scrolls', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ThanksScaffold(
          title: 'Invoices',
          body: SingleChildScrollView(
            child: SizedBox(height: 2000, child: Text('Invoice list')),
          ),
        ),
      ),
    );

    final titleOffsetBefore = tester.getTopLeft(find.text('Invoices'));

    await tester.drag(
      find.byType(SingleChildScrollView),
      const Offset(0, -400),
    );
    await tester.pump();

    expect(tester.getTopLeft(find.text('Invoices')), titleOffsetBefore);
  });

  testWidgets('ThanksScaffold renders default app bar and inline filters', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(size: Size(375, 800)),
          child: ThanksScaffold(
            title: 'Invoices',
            filterDisplayMode: ThanksFilterDisplayMode.inline,
            filters: [Text('Open')],
          ),
        ),
      ),
    );

    expect(find.byType(ListTile), findsOneWidget);
    expect(find.text('Open'), findsOneWidget);

    final filterSection = find.ancestor(
      of: find.text('Open'),
      matching: find.byType(ThanksSection),
    );
    expect(filterSection, findsOneWidget);

    final sectionWidget = tester.widget<ThanksSection>(filterSection);
    expect(sectionWidget.verticalPadding, ThanksSpacing.medium);
    expect(sectionWidget.enableGutter, isTrue);
    expect(sectionWidget.maxWidth, FitSize.desktop);
  });

  testWidgets('ThanksSection doubles horizontal gutters above tablet', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(size: Size(1100, 800)),
          child: ThanksScaffold(
            title: 'Invoices',
            filters: [Text('Open')],
            body: ThanksSection(child: SizedBox(key: Key('body'))),
          ),
        ),
      ),
    );

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

  testWidgets('ThanksScaffold shows a menu for an available left drawer', (
    tester,
  ) async {
    final controller = ThanksScaffoldController();
    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(size: Size(375, 800)),
          child: ThanksScaffold(
            controller: controller,
            title: 'Home',
            drawer: const Drawer(child: Text('Navigation')),
            body: const SizedBox(),
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.menu_rounded), findsOneWidget);
    final menuButtonFinder = find.byType(IconButton);
    expect(
      tester.getSize(menuButtonFinder),
      const Size.square(ThanksSpacing.inputHeight),
    );
    expect(tester.getTopLeft(menuButtonFinder).dx, ThanksSpacing.medium);
    await tester.tap(find.byIcon(Icons.menu_rounded));
    await tester.pumpAndSettle();
    expect(find.text('Navigation'), findsOneWidget);
  });

  testWidgets('ThanksScaffold renders default app bar with actions', (
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

    expect(find.byType(ListTile), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.byIcon(Icons.search), findsOneWidget);
    expect(find.byIcon(Icons.more_vert), findsOneWidget);

    final searchPosition = tester.getTopLeft(find.byIcon(Icons.search));
    final morePosition = tester.getTopLeft(find.byIcon(Icons.more_vert));

    expect(morePosition.dx, greaterThan(searchPosition.dx));
  });

  testWidgets(
    'ThanksScaffold renders default app bar using ListTile with titleLarge style',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThanksTheme.light(),
          home: const ThanksScaffold(
            title: 'Dashboard',
            subtitle: 'Overview of metrics',
            body: SizedBox(),
          ),
        ),
      );

      final listTileFinder = find.byType(ListTile);
      expect(listTileFinder, findsOneWidget);

      final titleFinder = find.text('Dashboard');
      final subtitleFinder = find.text('Overview of metrics');

      expect(titleFinder, findsOneWidget);
      expect(subtitleFinder, findsOneWidget);

      final titleText = tester.widget<Text>(titleFinder);
      final subtitleText = tester.widget<Text>(subtitleFinder);
      final theme = Theme.of(tester.element(titleFinder));

      expect(titleText.style, theme.textTheme.titleLarge);
      expect(subtitleText.style?.color, theme.colorScheme.onSurfaceVariant);
    },
  );

  testWidgets(
    'ThanksScaffold shows back button instead of menu button when route can pop',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThanksTheme.light(),
          home: MediaQuery(
            data: const MediaQueryData(size: Size(375, 800)),
            child: Navigator(
              onGenerateInitialRoutes: (_, __) => [
                MaterialPageRoute<void>(builder: (_) => const SizedBox()),
                MaterialPageRoute<void>(
                  builder: (_) => ThanksScaffold(
                    title: 'Details',
                    drawer: const Drawer(),
                    body: const SizedBox(),
                  ),
                ),
              ],
              onGenerateRoute: (_) =>
                  MaterialPageRoute<void>(builder: (_) => const SizedBox()),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
      expect(find.byIcon(Icons.menu_rounded), findsNothing);
      final backButtonFinder = find.byType(IconButton).first;
      expect(
        tester.getSize(backButtonFinder),
        const Size.square(ThanksSpacing.inputHeight),
      );
      expect(tester.getTopLeft(backButtonFinder).dx, ThanksSpacing.medium);
      expect(
        tester.widget<IconButton>(backButtonFinder).tooltip,
        'Back to Invoices',
      );

      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();
      expect(find.text('Details'), findsNothing);
    },
  );

  testWidgets(
    'ThanksScaffold shows back button when onBackPressed is provided even if route cannot pop',
    (tester) async {
      var backPressed = false;
      await tester.pumpWidget(
        MaterialApp(
          home: ThanksScaffold(
            title: 'Details',
            drawer: const Drawer(),
            onBackPressed: () => backPressed = true,
          ),
        ),
      );

      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
      expect(find.byIcon(Icons.menu_rounded), findsNothing);

      await tester.tap(find.byIcon(Icons.arrow_back));
      expect(backPressed, isTrue);
    },
  );

  testWidgets(
    'ThanksScaffold hides back button when showBackButton is false even if route can pop',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Navigator(
            onGenerateInitialRoutes: (_, __) => [
              MaterialPageRoute<void>(builder: (_) => const SizedBox()),
              MaterialPageRoute<void>(
                builder: (_) => const ThanksScaffold(
                  title: 'Details',
                  showBackButton: false,
                  drawer: Drawer(),
                ),
              ),
            ],
            onGenerateRoute: (_) =>
                MaterialPageRoute<void>(builder: (_) => const SizedBox()),
          ),
        ),
      );

      expect(find.byIcon(Icons.arrow_back), findsNothing);
      expect(find.byIcon(Icons.menu_rounded), findsOneWidget);
    },
  );

  testWidgets(
    'ThanksScaffold aligns title with content when there are no leading icons',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThanksTheme.light(),
          home: const MediaQuery(
            data: MediaQueryData(size: Size(375, 800)),
            child: ThanksScaffold(
              title: 'Aligned Title',
              showBackButton: false,
              body: ThanksSection(child: Text('Aligned Body Content')),
            ),
          ),
        ),
      );

      final titleOffset = tester.getTopLeft(find.text('Aligned Title'));
      final bodyOffset = tester.getTopLeft(find.text('Aligned Body Content'));

      expect(titleOffset.dx, bodyOffset.dx);
      expect(titleOffset.dx, ThanksSpacing.medium);
    },
  );

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
      tester.getTopLeft(find.byIcon(Icons.arrow_back)).dy,
      greaterThanOrEqualTo(24 + ThanksSpacing.small),
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
            maxWidthHeader: FitSize.tablet,
            body: SizedBox(
              key: Key('page-body'),
              width: double.infinity,
              height: 100,
            ),
          ),
        ),
      );

      expect(find.byType(FitContainer), findsNWidgets(2));
      for (final container in tester.widgetList<FitContainer>(
        find.byType(FitContainer),
      )) {
        expect(container.maxFitSize, FitSize.tablet);
      }

      // Verify the app bar is constrained to FitSize.tablet.maxWidth (800) width and centered within 1200px
      final topBarFinder = find.byType(ListTile).first;
      final appBarWidth = tester.getSize(topBarFinder).width;
      expect(appBarWidth, lessThanOrEqualTo(FitSize.tablet.maxWidth));
      final appBarRect = tester.getRect(topBarFinder);
      expect(appBarRect.center.dx, closeTo(600, 1.0));

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
            body: SizedBox(
              key: Key('constrained-body'),
              width: double.infinity,
              height: 100,
            ),
          ),
        ),
      );

      final bodyFitContainerFinder = find.ancestor(
        of: find.byKey(const Key('constrained-body')),
        matching: find.byType(FitContainer),
      );
      expect(bodyFitContainerFinder, findsOneWidget);
      final fitContainer = tester.widget<FitContainer>(bodyFitContainerFinder);
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
            maxWidthHeader: FitSize.laptop,
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
      expect(fitContainers, hasLength(3));
      // App bar and page have maxFitSize laptop, body has mobile
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

  testWidgets('ThanksScaffold applies maxWidthPage and maxWidthBody', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1400, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      const MaterialApp(
        home: ThanksScaffold(
          title: 'Pinned Top Bar',
          maxWidthHeader: FitSize.laptop,
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
    expect(fitContainers, hasLength(3));
    final sizes = fitContainers.map((c) => c.maxFitSize).toSet();
    expect(sizes, containsAll([FitSize.laptop, FitSize.tablet]));

    final bodyWidth = tester
        .getSize(find.byKey(const Key('pinned-body')))
        .width;
    expect(bodyWidth, FitSize.tablet.maxWidth);
  });

  testWidgets(
    'ThanksScaffold clamps maxWidthBody so it does not exceed maxWidthPage',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(1400, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        const MaterialApp(
          home: ThanksScaffold(
            title: 'Clamped Body',
            maxWidthHeader: FitSize.mobile,
            body: SizedBox(
              key: Key('clamped-body'),
              width: double.infinity,
              height: 100,
            ),
          ),
        ),
      );

      final bodyWidth = tester
          .getSize(find.byKey(const Key('clamped-body')))
          .width;
      expect(bodyWidth, lessThanOrEqualTo(FitSize.mobile.maxWidth));
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

  testWidgets('ThanksCard applies backgroundColor', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              const ThanksCard(
                key: Key('card-bg-container'),
                variant: ThanksCardVariant.outlined,
                backgroundColor: Color(0xFF123456),
                child: Text('Container BG'),
              ),
              ThanksCard(
                key: const Key('card-bg-material'),
                variant: ThanksCardVariant.filled,
                backgroundColor: const Color(0xFF654321),
                onTap: () {},
                child: const Text('Material BG'),
              ),
            ],
          ),
        ),
      ),
    );

    final container = tester.widget<Container>(
      find
          .descendant(
            of: find.byKey(const Key('card-bg-container')),
            matching: find.byType(Container),
          )
          .first,
    );
    expect(
      (container.decoration as BoxDecoration).color,
      const Color(0xFF123456),
    );

    final material = tester.widget<Material>(
      find
          .descendant(
            of: find.byKey(const Key('card-bg-material')),
            matching: find.byType(Material),
          )
          .first,
    );
    expect(material.color, const Color(0xFF654321));
  });

  testWidgets('ThanksCard applies borderColor', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              const ThanksCard(
                key: Key('card-border-outlined'),
                variant: ThanksCardVariant.outlined,
                borderColor: Color(0xFF112233),
                child: Text('Outlined Border'),
              ),
              const ThanksCard(
                key: Key('card-border-filled'),
                variant: ThanksCardVariant.filled,
                borderColor: Color(0xFF445566),
                child: Text('Filled Border'),
              ),
              ThanksCard(
                key: const Key('card-border-material'),
                variant: ThanksCardVariant.outlined,
                borderColor: const Color(0xFF778899),
                onTap: () {},
                child: const Text('Material Border'),
              ),
            ],
          ),
        ),
      ),
    );

    final container1 = tester.widget<Container>(
      find
          .descendant(
            of: find.byKey(const Key('card-border-outlined')),
            matching: find.byType(Container),
          )
          .first,
    );
    expect(
      (container1.decoration as BoxDecoration).border?.top.color,
      const Color(0xFF112233),
    );

    final container2 = tester.widget<Container>(
      find
          .descendant(
            of: find.byKey(const Key('card-border-filled')),
            matching: find.byType(Container),
          )
          .first,
    );
    expect(
      (container2.decoration as BoxDecoration).border?.top.color,
      const Color(0xFF445566),
    );

    final material = tester.widget<Material>(
      find
          .descendant(
            of: find.byKey(const Key('card-border-material')),
            matching: find.byType(Material),
          )
          .first,
    );
    expect(
      (material.shape as RoundedRectangleBorder).side.color,
      const Color(0xFF778899),
    );
  });

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

  testWidgets('ThanksSliverLoading renders centered indicator and message', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: CustomScrollView(
            slivers: [ThanksSliverLoading(message: 'Loading records...')],
          ),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Loading records...'), findsOneWidget);
  });

  testWidgets('ThanksSliverEmptyState asserts when all parameters are null', (
    tester,
  ) async {
    expect(() => ThanksSliverEmptyState(), throwsAssertionError);
  });

  testWidgets(
    'ThanksSliverEmptyState renders icon, title, subtitle, and action',
    (tester) async {
      var actionPressed = false;
      await tester.pumpWidget(
        MaterialApp(
          theme: ThanksTheme.light(),
          home: Scaffold(
            body: CustomScrollView(
              slivers: [
                ThanksSliverEmptyState(
                  icon: const Icon(Icons.inbox),
                  title: 'No Orders Yet',
                  subtitle: 'Items you buy will appear here.',
                  action: ThanksButton(
                    label: 'Start Shopping',
                    onPressed: () => actionPressed = true,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.inbox), findsOneWidget);
      expect(find.text('No Orders Yet'), findsOneWidget);
      expect(find.text('Items you buy will appear here.'), findsOneWidget);
      expect(find.text('Start Shopping'), findsOneWidget);

      await tester.tap(find.text('Start Shopping'));
      expect(actionPressed, isTrue);
    },
  );

  testWidgets('ThanksSliverEmptyState renders partial configurations', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: CustomScrollView(
            slivers: [ThanksSliverEmptyState(title: 'Only Title')],
          ),
        ),
      ),
    );

    expect(find.text('Only Title'), findsOneWidget);
    expect(find.byType(Icon), findsNothing);
  });

  testWidgets('ThanksScaffold supports multi-column expanded layouts in body', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1200, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        theme: ThanksTheme.light(),
        home: MediaQuery(
          data: const MediaQueryData(size: Size(1200, 800)),
          child: ThanksScaffold(
            title: 'Dynamic Form Editor',
            body: Row(
              children: [
                Expanded(
                  child: ListView.builder(
                    key: const Key('left-column'),
                    itemCount: 20,
                    itemBuilder: (_, i) => Text('Palette Item $i'),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: ListView.builder(
                    key: const Key('center-column'),
                    itemCount: 20,
                    itemBuilder: (_, i) => Text('Canvas Component $i'),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    key: const Key('right-column'),
                    itemCount: 20,
                    itemBuilder: (_, i) => Text('Inspector Field $i'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    // The outer page does not contain a CustomScrollView
    expect(find.byType(CustomScrollView), findsNothing);

    // All three columns render without unbounded height errors
    expect(find.byKey(const Key('left-column')), findsOneWidget);
    expect(find.byKey(const Key('center-column')), findsOneWidget);
    expect(find.byKey(const Key('right-column')), findsOneWidget);
    expect(find.text('Palette Item 0'), findsOneWidget);
    expect(find.text('Canvas Component 0'), findsOneWidget);
    expect(find.text('Inspector Field 0'), findsOneWidget);

    // Default body has zero padding, so multi-column layouts and scrollbars reach screen edges
    final bodyPadding = tester.widget<Padding>(
      find.ancestor(of: find.byType(Row), matching: find.byType(Padding)).first,
    );
    expect(bodyPadding.padding, EdgeInsets.zero);
  });

  testWidgets('ThanksScaffold respects custom bottomPadding', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ThanksScaffold(body: SizedBox(key: Key('box-body'), height: 50)),
      ),
    );

    final padding = tester.widget<Padding>(
      find
          .ancestor(
            of: find.byKey(const Key('box-body')),
            matching: find.byType(Padding),
          )
          .first,
    );
    expect((padding.padding as EdgeInsets).bottom, 20.0);
  });

  testWidgets(
    'ThanksSection renders title, subtitle, and child with titleMedium',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThanksTheme.light(),
          home: const Scaffold(
            body: ThanksSection(
              title: 'Test Section',
              subtitle: 'Section Subtitle',
              child: Text('Child Widget'),
            ),
          ),
        ),
      );

      expect(find.text('Test Section'), findsOneWidget);
      expect(find.text('Section Subtitle'), findsOneWidget);
      expect(find.text('Child Widget'), findsOneWidget);
    },
  );

  testWidgets('ThanksInputLabel renders label text and wraps child', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThanksTheme.light(),
        home: const Scaffold(
          body: Column(
            children: [
              ThanksInputLabel(
                label: 'Full Name',
                isRequired: true,
                child: TextField(),
              ),
              ThanksInputLabel(label: 'Email Address', child: TextField()),
            ],
          ),
        ),
      ),
    );

    expect(find.textContaining('Full Name'), findsOneWidget);
    expect(find.text('Email Address'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(2));
  });

  testWidgets('ThanksGrid renders column children', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThanksTheme.light(),
        home: const Scaffold(
          body: ThanksGrid(
            children: [
              ThanksGridItem(mobile: 12, desktop: 6, child: Text('Col 1')),
              ThanksGridItem(mobile: 12, desktop: 6, child: Text('Col 2')),
            ],
          ),
        ),
      ),
    );

    expect(find.text('Col 1'), findsOneWidget);
    expect(find.text('Col 2'), findsOneWidget);
  });

  testWidgets(
    'ThanksScaffold wraps app bar and inline filters in ThanksSection',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThanksTheme.light(),
          home: const ThanksScaffold(
            title: 'Test Title',
            filterDisplayMode: ThanksFilterDisplayMode.inline,
            filters: [Text('Filter 1')],
            body: Text('Page Body'),
          ),
        ),
      );

      // Verify that ThanksSection is present for both app bar and filters
      final sections = find.byType(ThanksSection);
      expect(sections, findsAtLeast(2));

      // Verify top bar ListTile is descendant of a ThanksSection
      expect(
        find.descendant(
          of: find.byType(ThanksSection),
          matching: find.byType(ListTile),
        ),
        findsAtLeast(1),
      );

      // Verify filters Wrap is descendant of a ThanksSection
      expect(
        find.descendant(
          of: find.byType(ThanksSection),
          matching: find.byType(Wrap),
        ),
        findsOneWidget,
      );
    },
  );
}

String _label(int value) => '$value';
void _noop(int? value) {}
