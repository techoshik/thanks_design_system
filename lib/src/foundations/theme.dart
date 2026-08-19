import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'colors.dart';
import 'spacing.dart';
import 'typography.dart';

/// Semantic theme tokens and the production Material theme.
@immutable
class ThanksTheme extends ThemeExtension<ThanksTheme> {
  const ThanksTheme({
    required this.surfaceElevated,
    required this.surface2,
    required this.borderSubtle,
    required this.borderStrong,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.success,
    required this.successBackground,
    required this.successBorder,
    required this.warning,
    required this.warningBackground,
    required this.warningBorder,
    required this.danger,
    required this.dangerBackground,
    required this.dangerBorder,
    required this.mono,
  });

  static ThanksTheme of(BuildContext context) =>
      Theme.of(context).extension<ThanksTheme>()!;

  final Color surfaceElevated;
  final Color surface2;
  final Color borderSubtle;
  final Color borderStrong;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color success;
  final Color successBackground;
  final Color successBorder;
  final Color warning;
  final Color warningBackground;
  final Color warningBorder;
  final Color danger;
  final Color dangerBackground;
  final Color dangerBorder;
  final TextStyle mono;

  static final _lightExtension = ThanksTheme(
    surfaceElevated: ThanksColors.surface,
    surface2: ThanksColors.surface2,
    borderSubtle: ThanksColors.border,
    borderStrong: ThanksColors.borderStrong,
    textPrimary: ThanksColors.textPrimary,
    textSecondary: ThanksColors.textSecondary,
    textMuted: ThanksColors.textMuted,
    success: ThanksColors.success,
    successBackground: ThanksColors.successBackground,
    successBorder: ThanksColors.successBorder,
    warning: ThanksColors.warning,
    warningBackground: ThanksColors.warningBackground,
    warningBorder: ThanksColors.warningBorder,
    danger: ThanksColors.danger,
    dangerBackground: ThanksColors.dangerBackground,
    dangerBorder: ThanksColors.dangerBorder,
    mono: ThanksTypography.mono,
  );

  /// Builds the light-only production theme with an optional app brand.
  static ThemeData light({ThanksBrand brand = ThanksBrand.defaultBrand}) {
    final textTheme = ThanksTypography.textTheme;
    final colorScheme = ColorScheme.fromSeed(
      seedColor: brand.primary,
      primary: brand.primary,
      primaryContainer: brand.primaryContainer,
      onPrimary: ThanksColors.surface,
      onPrimaryContainer: brand.onPrimaryContainer,
      secondary: brand.secondary ?? ThanksColors.primary400,
      onSecondary: ThanksColors.surface,
      secondaryContainer: brand.primaryContainer,
      surfaceContainer: ThanksColors.surface,
      error: ThanksColors.danger,
      errorContainer: ThanksColors.dangerBackground,
      onSurface: ThanksColors.textPrimary,
      outlineVariant: ThanksColors.border,
      surface: ThanksColors.pageBackground,
    );
    final selectedBackground = brand.primary.withAlpha(28);
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
      fillColor: ThanksColors.surface,
      focusColor: brand.primary,
      iconColor: brand.primary,
      hoverColor: selectedBackground,
      suffixIconColor: brand.primary,
      constraints: const BoxConstraints(minHeight: ThanksSpacing.inputHeight),
      isDense: true,
      contentPadding: ThanksSpacing.inputContentPadding,
      errorMaxLines: 2,
      labelStyle: textTheme.labelMedium,
      hintStyle: textTheme.bodyMedium?.copyWith(color: ThanksColors.textMuted),
      errorStyle: textTheme.labelSmall?.copyWith(color: ThanksColors.danger),
      prefixIconConstraints: const BoxConstraints(
        minWidth: ThanksSpacing.inputHeight,
        maxHeight: ThanksSpacing.inputHeight,
      ),
      suffixIconConstraints: const BoxConstraints(
        minHeight: ThanksSpacing.inputHeight,
        maxHeight: ThanksSpacing.inputHeight,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      primaryTextTheme: textTheme,
      textTheme: textTheme,
      colorScheme: colorScheme,
      extensions: [_lightExtension],
      visualDensity: VisualDensity.compact,
      iconTheme: const IconThemeData(size: 20),
      scaffoldBackgroundColor: ThanksColors.pageBackground,
      appBarTheme: AppBarTheme(
        centerTitle: false,
        toolbarHeight: ThanksSpacing.appBarHeight,
        actionsPadding: const EdgeInsets.only(right: ThanksSpacing.large),
        titleSpacing: ThanksSpacing.large,
        iconTheme: IconThemeData(color: brand.primary, size: 20),
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: textTheme.titleLarge,
      ),
      dividerColor: colorScheme.outlineVariant,
      dividerTheme: const DividerThemeData(thickness: 0.5, space: 0),
      cardTheme: CardThemeData(
        clipBehavior: Clip.hardEdge,
        color: ThanksColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThanksSpacing.radiusLarge),
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
          iconSize: 20,
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
          iconSize: 24,
          minimumSize: const Size(0, ThanksSpacing.inputHeight),
          fixedSize: const Size(0, ThanksSpacing.inputHeight),
        ),
      ),
      inputDecorationTheme: inputTheme,
      popupMenuTheme: PopupMenuThemeData(
        shape: buttonShape,
        textStyle: buttonTextStyle,
        labelTextStyle: WidgetStatePropertyAll(buttonTextStyle),
        color: ThanksColors.surface,
        menuPadding: EdgeInsets.zero,
        enableFeedback: true,
        surfaceTintColor: ThanksColors.surface,
      ),
      dropdownMenuTheme: DropdownMenuThemeData(
        inputDecorationTheme: inputTheme,
        textStyle: buttonTextStyle,
        menuStyle: MenuStyle(
          shape: WidgetStatePropertyAll(buttonShape),
          backgroundColor: const WidgetStatePropertyAll(ThanksColors.surface),
          minimumSize: const WidgetStatePropertyAll(Size.fromHeight(300)),
          maximumSize: const WidgetStatePropertyAll(Size.fromHeight(600)),
          padding: const WidgetStatePropertyAll(EdgeInsets.zero),
        ),
      ),
    );
  }

  @override
  ThanksTheme copyWith({
    Color? surfaceElevated,
    Color? surface2,
    Color? borderSubtle,
    Color? borderStrong,
    Color? textPrimary,
    Color? textSecondary,
    Color? textMuted,
    Color? success,
    Color? successBackground,
    Color? successBorder,
    Color? warning,
    Color? warningBackground,
    Color? warningBorder,
    Color? danger,
    Color? dangerBackground,
    Color? dangerBorder,
    TextStyle? mono,
  }) =>
      ThanksTheme(
        surfaceElevated: surfaceElevated ?? this.surfaceElevated,
        surface2: surface2 ?? this.surface2,
        borderSubtle: borderSubtle ?? this.borderSubtle,
        borderStrong: borderStrong ?? this.borderStrong,
        textPrimary: textPrimary ?? this.textPrimary,
        textSecondary: textSecondary ?? this.textSecondary,
        textMuted: textMuted ?? this.textMuted,
        success: success ?? this.success,
        successBackground: successBackground ?? this.successBackground,
        successBorder: successBorder ?? this.successBorder,
        warning: warning ?? this.warning,
        warningBackground: warningBackground ?? this.warningBackground,
        warningBorder: warningBorder ?? this.warningBorder,
        danger: danger ?? this.danger,
        dangerBackground: dangerBackground ?? this.dangerBackground,
        dangerBorder: dangerBorder ?? this.dangerBorder,
        mono: mono ?? this.mono,
      );

  @override
  ThanksTheme lerp(covariant ThanksTheme? other, double t) {
    if (other == null) return this;
    return ThanksTheme(
      surfaceElevated: Color.lerp(surfaceElevated, other.surfaceElevated, t)!,
      surface2: Color.lerp(surface2, other.surface2, t)!,
      borderSubtle: Color.lerp(borderSubtle, other.borderSubtle, t)!,
      borderStrong: Color.lerp(borderStrong, other.borderStrong, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      success: Color.lerp(success, other.success, t)!,
      successBackground: Color.lerp(
        successBackground,
        other.successBackground,
        t,
      )!,
      successBorder: Color.lerp(successBorder, other.successBorder, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      warningBackground: Color.lerp(
        warningBackground,
        other.warningBackground,
        t,
      )!,
      warningBorder: Color.lerp(warningBorder, other.warningBorder, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      dangerBackground: Color.lerp(
        dangerBackground,
        other.dangerBackground,
        t,
      )!,
      dangerBorder: Color.lerp(dangerBorder, other.dangerBorder, t)!,
      mono: TextStyle.lerp(mono, other.mono, t)!,
    );
  }
}
