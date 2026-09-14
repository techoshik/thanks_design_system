import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'colors.dart';
import 'spacing.dart';
import 'typography.dart';

/// Semantic surface roles used to group application content without relying
/// on elevation or page-local color values.
@immutable
class ThanksSurfaceTokens {
  const ThanksSurfaceTokens({
    required this.page,
    required this.panel,
    required this.hover,
    required this.input,
    required this.selected,
  });

  final Color page;
  final Color panel;
  final Color hover;
  final Color input;
  final Color selected;

  ThanksSurfaceTokens copyWith({
    Color? page,
    Color? panel,
    Color? hover,
    Color? input,
    Color? selected,
  }) => ThanksSurfaceTokens(
    page: page ?? this.page,
    panel: panel ?? this.panel,
    hover: hover ?? this.hover,
    input: input ?? this.input,
    selected: selected ?? this.selected,
  );

  static ThanksSurfaceTokens lerp(
    ThanksSurfaceTokens a,
    ThanksSurfaceTokens b,
    double t,
  ) => ThanksSurfaceTokens(
    page: Color.lerp(a.page, b.page, t)!,
    panel: Color.lerp(a.panel, b.panel, t)!,
    hover: Color.lerp(a.hover, b.hover, t)!,
    input: Color.lerp(a.input, b.input, t)!,
    selected: Color.lerp(a.selected, b.selected, t)!,
  );
}

/// A semantic color palette with foreground and surface roles.
@immutable
class ThanksColorPalette {
  const ThanksColorPalette({
    required this.main,
    required this.onMain,
    required this.subtle,
    required this.onSubtle,
    required this.border,
  });

  final Color main;
  final Color onMain;
  final Color subtle;
  final Color onSubtle;
  final Color border;

  ThanksColorPalette copyWith({
    Color? main,
    Color? onMain,
    Color? subtle,
    Color? onSubtle,
    Color? border,
  }) => ThanksColorPalette(
    main: main ?? this.main,
    onMain: onMain ?? this.onMain,
    subtle: subtle ?? this.subtle,
    onSubtle: onSubtle ?? this.onSubtle,
    border: border ?? this.border,
  );

  static ThanksColorPalette lerp(
    ThanksColorPalette a,
    ThanksColorPalette b,
    double t,
  ) => ThanksColorPalette(
    main: Color.lerp(a.main, b.main, t)!,
    onMain: Color.lerp(a.onMain, b.onMain, t)!,
    subtle: Color.lerp(a.subtle, b.subtle, t)!,
    onSubtle: Color.lerp(a.onSubtle, b.onSubtle, t)!,
    border: Color.lerp(a.border, b.border, t)!,
  );
}

/// Semantic theme tokens and the production Material theme.
@immutable
class ThanksTheme extends ThemeExtension<ThanksTheme> {
  const ThanksTheme({
    required this.primary,
    required this.success,
    required this.warning,
    required this.error,
    required this.info,
    required this.spacing,
    required this.surface,
    required this.borderSubtle,
    required this.borderStrong,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.mono,
  });

  static ThanksTheme of(BuildContext context) =>
      Theme.of(context).extension<ThanksTheme>() ?? _fallbackExtension;

  static final ThanksTheme _fallbackExtension = _lightExtension(
    brand: ThanksBrand.defaultBrand,
  );

  final ThanksColorPalette primary;
  final ThanksColorPalette success;
  final ThanksColorPalette warning;
  final ThanksColorPalette error;
  final ThanksColorPalette info;
  final ThanksSpacingTokens spacing;
  final ThanksSurfaceTokens surface;
  final Color borderSubtle;
  final Color borderStrong;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final TextStyle mono;

  /// Compatibility alias for the previous panel token.
  Color get surfaceElevated => surface.panel;

  /// Compatibility alias for the previous neutral secondary surface token.
  Color get surface2 => surface.hover;

  // Transitional getters for internal consumers while they migrate to the
  // semantic palette roles.
  Color get successBackground => success.subtle;
  Color get successBorder => success.border;
  Color get warningBackground => warning.subtle;
  Color get warningBorder => warning.border;
  ThanksColorPalette get danger => error;
  Color get dangerBackground => error.subtle;
  Color get dangerBorder => error.border;

  static ThanksTheme _lightExtension({required ThanksBrand brand}) =>
      ThanksTheme(
        primary: ThanksColorPalette(
          main: brand.primary,
          onMain: ThanksColors.surface,
          subtle: brand.primaryContainer,
          onSubtle: brand.onPrimaryContainer,
          border: brand.primary.withValues(alpha: 0.35),
        ),
        success: const ThanksColorPalette(
          main: ThanksColors.success,
          onMain: ThanksColors.surface,
          subtle: ThanksColors.successBackground,
          onSubtle: ThanksColors.success,
          border: ThanksColors.successBorder,
        ),
        warning: const ThanksColorPalette(
          main: ThanksColors.warning,
          onMain: ThanksColors.surface,
          subtle: ThanksColors.warningBackground,
          onSubtle: ThanksColors.warning,
          border: ThanksColors.warningBorder,
        ),
        error: const ThanksColorPalette(
          main: ThanksColors.danger,
          onMain: ThanksColors.surface,
          subtle: ThanksColors.dangerBackground,
          onSubtle: ThanksColors.danger,
          border: ThanksColors.dangerBorder,
        ),
        info: const ThanksColorPalette(
          main: ThanksColors.info,
          onMain: ThanksColors.surface,
          subtle: ThanksColors.infoBackground,
          onSubtle: ThanksColors.textPrimary,
          border: ThanksColors.infoBorder,
        ),
        spacing: ThanksSpacingTokens.defaults,
        surface: ThanksSurfaceTokens(
          page: ThanksColors.pageBackground,
          panel: ThanksColors.surface,
          hover: ThanksColors.surface2,
          input: ThanksColors.surface,
          selected: brand.primary.withAlpha(28),
        ),
        borderSubtle: ThanksColors.border,
        borderStrong: ThanksColors.borderStrong,
        textPrimary: ThanksColors.textPrimary,
        textSecondary: ThanksColors.textSecondary,
        textMuted: ThanksColors.textMuted,
        mono: ThanksTypography.mono,
      );

  /// Builds the light-only production theme with an optional app brand.
  static ThemeData light({ThanksBrand brand = ThanksBrand.defaultBrand}) {
    final textTheme = ThanksTypography.textTheme;
    final thanksTheme = _lightExtension(brand: brand);
    final colorScheme = ColorScheme.fromSeed(
      seedColor: brand.primary,
      primary: brand.primary,
      primaryContainer: brand.primaryContainer,
      onPrimary: ThanksColors.surface,
      onPrimaryContainer: brand.onPrimaryContainer,
      secondary: brand.secondary ?? ThanksColors.primary400,
      onSecondary: ThanksColors.surface,
      secondaryContainer: brand.primaryContainer,
      error: ThanksColors.danger,
      errorContainer: ThanksColors.dangerBackground,
      outline: ThanksColors.border,
      outlineVariant: ThanksColors.border,
      surface: thanksTheme.surface.page,
      onSurface: ThanksColors.textPrimary,
      surfaceContainer: thanksTheme.surface.panel,
      surfaceContainerHighest: thanksTheme.surface.hover,
    );
    final selectedBackground = thanksTheme.surface.selected;
    final interactiveHoverColor = brand.primary.withValues(alpha: 0.08);
    final buttonTextStyle = textTheme.bodyMedium;
    const buttonMinimumSize = Size(
      ThanksSpacing.buttonHeight,
      ThanksSpacing.buttonHeight,
    );
    final buttonShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(ThanksSpacing.radiusSmall),
    );
    final iconShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(ThanksSpacing.radiusSmall),
    );
    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(ThanksSpacing.radiusSmall),
      borderSide: const BorderSide(color: ThanksColors.border),
      gapPadding: 0,
    );
    final inputTheme = InputDecorationTheme(
      border: inputBorder,
      enabledBorder: inputBorder,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(ThanksSpacing.radiusSmall),
        borderSide: BorderSide(color: brand.primary),
        gapPadding: 0,
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(ThanksSpacing.radiusSmall),
        borderSide: const BorderSide(color: ThanksColors.danger),
        gapPadding: 0,
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(ThanksSpacing.radiusSmall),
        borderSide: const BorderSide(color: ThanksColors.danger),
        gapPadding: 0,
      ),
      disabledBorder: InputBorder.none,
      alignLabelWithHint: true,
      filled: true,
      fillColor: thanksTheme.surface.input,
      focusColor: Colors.transparent,
      iconColor: brand.primary,
      hoverColor: interactiveHoverColor,
      suffixIconColor: brand.primary,
      constraints: const BoxConstraints(minHeight: ThanksSpacing.inputHeight),
      isDense: true,
      contentPadding: ThanksSpacing.inputContentPadding,
      errorMaxLines: 2,
      labelStyle: textTheme.labelMedium,
      hintStyle: textTheme.bodyMedium?.copyWith(color: ThanksColors.textMuted),
      errorStyle: textTheme.labelSmall?.copyWith(color: ThanksColors.danger),
      prefixIconConstraints: const BoxConstraints(
        minWidth: kMinInteractiveDimension,
        minHeight: ThanksSpacing.inputHeight,
        maxHeight: ThanksSpacing.inputHeight,
      ),
      suffixIconConstraints: const BoxConstraints(
        minWidth: kMinInteractiveDimension,
        minHeight: ThanksSpacing.inputHeight,
        maxHeight: ThanksSpacing.inputHeight,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      hoverColor: interactiveHoverColor,
      primaryTextTheme: textTheme,
      textTheme: textTheme,
      colorScheme: colorScheme,
      extensions: [thanksTheme],
      visualDensity: VisualDensity.compact,
      iconTheme: const IconThemeData(size: ThanksSpacing.iconSmall),
      scaffoldBackgroundColor: thanksTheme.surface.page,
      appBarTheme: AppBarTheme(
        centerTitle: false,
        toolbarHeight: ThanksSpacing.appBarHeight,
        actionsPadding: const EdgeInsets.only(right: ThanksSpacing.medium),
        titleSpacing: ThanksSpacing.medium,
        iconTheme: IconThemeData(
          color: brand.primary,
          size: ThanksSpacing.iconSmall,
        ),
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: textTheme.titleLarge,
      ),
      dividerColor: colorScheme.outlineVariant,
      menuTheme: MenuThemeData(
        style: MenuStyle(
          backgroundColor: WidgetStatePropertyAll(thanksTheme.surface.panel),
          surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
          elevation: const WidgetStatePropertyAll(4),
          shadowColor: WidgetStatePropertyAll(colorScheme.shadow),
        ),
      ),
      dividerTheme: const DividerThemeData(thickness: 0.5, space: 0),
      cardTheme: CardThemeData(
        clipBehavior: Clip.hardEdge,
        color: thanksTheme.surface.panel,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThanksSpacing.radiusMedium),
          side: const BorderSide(color: ThanksColors.border),
        ),
        margin: EdgeInsets.zero,
      ),
      listTileTheme: ListTileThemeData(
        titleTextStyle: textTheme.titleSmall,
        textColor: ThanksColors.textPrimary,
        contentPadding: const EdgeInsets.only(
          left: ThanksSpacing.medium,
          right: ThanksSpacing.small,
        ),
        selectedTileColor: selectedBackground,
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          textStyle: buttonTextStyle,
          shape: buttonShape,
          minimumSize: buttonMinimumSize,
          fixedSize: const Size.fromHeight(ThanksSpacing.buttonHeight),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          textStyle: buttonTextStyle,
          shape: buttonShape,
          minimumSize: buttonMinimumSize,
          fixedSize: const Size.fromHeight(ThanksSpacing.buttonHeight),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          textStyle: buttonTextStyle,
          side: BorderSide(color: brand.primary),
          shape: buttonShape,
          minimumSize: buttonMinimumSize,
          fixedSize: const Size.fromHeight(ThanksSpacing.buttonHeight),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          shape: iconShape,
          iconSize: ThanksSpacing.iconSmall,
          minimumSize: buttonMinimumSize,
          fixedSize: const Size.square(ThanksSpacing.buttonHeight),
          padding: EdgeInsets.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: SegmentedButton.styleFrom(
          selectedForegroundColor: brand.primary,
          selectedBackgroundColor: selectedBackground,
          tapTargetSize: MaterialTapTargetSize.padded,
          textStyle: buttonTextStyle,
          iconSize: ThanksSpacing.iconSmall,
          minimumSize: const Size(0, ThanksSpacing.inputHeight),
          fixedSize: const Size(0, ThanksSpacing.inputHeight),
        ),
      ),
      inputDecorationTheme: inputTheme,
      popupMenuTheme: PopupMenuThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThanksSpacing.radiusMedium),
          side: BorderSide(color: colorScheme.outlineVariant, width: 1),
        ),
        textStyle: buttonTextStyle,
        labelTextStyle: WidgetStatePropertyAll(buttonTextStyle),
        color: thanksTheme.surface.panel,
        surfaceTintColor: Colors.transparent,
        elevation: 3,
        shadowColor: colorScheme.shadow,
        menuPadding: EdgeInsets.zero,
        enableFeedback: true,
      ),
      dropdownMenuTheme: DropdownMenuThemeData(
        inputDecorationTheme: inputTheme,
        textStyle: buttonTextStyle,
        menuStyle: MenuStyle(
          shape: WidgetStatePropertyAll(buttonShape),
          backgroundColor: WidgetStatePropertyAll(thanksTheme.surface.panel),
          surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
          minimumSize: const WidgetStatePropertyAll(Size.fromHeight(300)),
          maximumSize: const WidgetStatePropertyAll(Size.fromHeight(600)),
          padding: const WidgetStatePropertyAll(EdgeInsets.zero),
        ),
      ),
    );
  }

  @override
  ThanksTheme copyWith({
    ThanksColorPalette? primary,
    ThanksColorPalette? success,
    ThanksColorPalette? warning,
    ThanksColorPalette? error,
    ThanksColorPalette? info,
    ThanksSpacingTokens? spacing,
    ThanksSurfaceTokens? surface,
    Color? borderSubtle,
    Color? borderStrong,
    Color? textPrimary,
    Color? textSecondary,
    Color? textMuted,
    TextStyle? mono,
  }) => ThanksTheme(
    primary: primary ?? this.primary,
    success: success ?? this.success,
    warning: warning ?? this.warning,
    error: error ?? this.error,
    info: info ?? this.info,
    spacing: spacing ?? this.spacing,
    surface: surface ?? this.surface,
    borderSubtle: borderSubtle ?? this.borderSubtle,
    borderStrong: borderStrong ?? this.borderStrong,
    textPrimary: textPrimary ?? this.textPrimary,
    textSecondary: textSecondary ?? this.textSecondary,
    textMuted: textMuted ?? this.textMuted,
    mono: mono ?? this.mono,
  );

  @override
  ThanksTheme lerp(covariant ThanksTheme? other, double t) {
    if (other == null) return this;
    return ThanksTheme(
      primary: ThanksColorPalette.lerp(primary, other.primary, t),
      success: ThanksColorPalette.lerp(success, other.success, t),
      warning: ThanksColorPalette.lerp(warning, other.warning, t),
      error: ThanksColorPalette.lerp(error, other.error, t),
      info: ThanksColorPalette.lerp(info, other.info, t),
      spacing: spacing,
      surface: ThanksSurfaceTokens.lerp(surface, other.surface, t),
      borderSubtle: Color.lerp(borderSubtle, other.borderSubtle, t)!,
      borderStrong: Color.lerp(borderStrong, other.borderStrong, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      mono: TextStyle.lerp(mono, other.mono, t)!,
    );
  }
}
