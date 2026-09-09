import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:thanks_design_system/src/foundations/colors.dart';
import 'package:thanks_design_system/src/foundations/spacing.dart';

/// Standard shape variants for [ThanksImageView].
enum ThanksImageShape {
  /// Renders as a full circle (e.g. user / applicant avatars).
  circle,

  /// Renders with rounded corners using [ThanksSpacing] radii.
  rounded,

  /// Renders as a sharp rectangle without border radius.
  square,
}

/// A design-system component for rendering network images, asset images,
/// or graceful initials/icon fallbacks.
///
/// Handles:
/// - Network images via [Image.network] with built-in loading and error fallback.
/// - Asset images (paths starting with `assets/`).
/// - User initials fallback with high-contrast theme styling.
/// - Circular, rounded, and square shapes.
/// - Interactive tap callbacks with appropriate ripple clipping.
class ThanksImageView extends StatelessWidget {
  const ThanksImageView({
    super.key,
    this.url,
    this.name,
    this.size = 40,
    this.width,
    this.height,
    this.shape = ThanksImageShape.circle,
    this.borderRadius,
    this.fit = BoxFit.cover,
    this.backgroundColor,
    this.onTap,
    this.semanticLabel,
  });

  /// The image source: network URL (http/https) or local asset path.
  final String? url;

  /// User or entity name used to generate fallback initials when [url] is null,
  /// empty, or fails to load.
  final String? name;

  /// Default square dimension for the image if [width] and [height] are omitted.
  final double size;

  /// Explicit width. Defaults to [size].
  final double? width;

  /// Explicit height. Defaults to [size].
  final double? height;

  /// The shape clipping applied to the image.
  final ThanksImageShape shape;

  /// Custom border radius when [shape] is [ThanksImageShape.rounded].
  /// Defaults to [ThanksSpacing.radiusMedium] (8.0).
  final double? borderRadius;

  /// How the image should be inscribed into the box.
  final BoxFit fit;

  /// Background color for the fallback initials container.
  final Color? backgroundColor;

  /// Optional tap callback.
  final VoidCallback? onTap;

  /// Accessibility label.
  final String? semanticLabel;

  double get _effectiveWidth => width ?? size;
  double get _effectiveHeight => height ?? size;

  String get _initials {
    final trimmed = name?.trim() ?? '';
    if (trimmed.isEmpty) return '';
    final parts = trimmed.split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts[0][0].toUpperCase();
  }

  BorderRadius _getBorderRadius() {
    return switch (shape) {
      ThanksImageShape.circle => BorderRadius.circular(
          max(_effectiveWidth, _effectiveHeight),
        ),
      ThanksImageShape.rounded =>
        BorderRadius.circular(borderRadius ?? ThanksSpacing.radiusMedium),
      ThanksImageShape.square => BorderRadius.zero,
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final clipRadius = _getBorderRadius();
    final effectiveBg =
        backgroundColor ?? theme.colorScheme.primaryContainer;
    final onBgColor = theme.colorScheme.onPrimaryContainer;

    Widget buildFallback() {
      final initials = _initials;
      return Container(
        width: _effectiveWidth,
        height: _effectiveHeight,
        color: effectiveBg,
        alignment: Alignment.center,
        child: initials.isNotEmpty
            ? Text(
                initials,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: onBgColor,
                  fontWeight: FontWeight.bold,
                  fontSize: min(_effectiveWidth, _effectiveHeight) * 0.4,
                ),
              )
            : Icon(
                Icons.person_outline,
                color: onBgColor,
                size: min(_effectiveWidth, _effectiveHeight) * 0.5,
              ),
      );
    }

    Widget content;
    final rawUrl = url?.trim();

    if (rawUrl == null || rawUrl.isEmpty) {
      content = buildFallback();
    } else if (rawUrl.startsWith('assets/')) {
      content = Image.asset(
        rawUrl,
        width: _effectiveWidth,
        height: _effectiveHeight,
        fit: fit,
        errorBuilder: (_, __, ___) => buildFallback(),
      );
    } else {
      content = Image.network(
        rawUrl,
        width: _effectiveWidth,
        height: _effectiveHeight,
        fit: fit,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return Container(
            width: _effectiveWidth,
            height: _effectiveHeight,
            color: theme.colorScheme.surfaceContainerHighest,
            child: const Center(
              child: SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
        },
        errorBuilder: (_, __, ___) => buildFallback(),
      );
    }

    Widget result = ClipRRect(
      borderRadius: clipRadius,
      child: content,
    );

    if (onTap != null) {
      result = ClipRRect(
        borderRadius: clipRadius,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: result,
          ),
        ),
      );
    }

    if (semanticLabel != null) {
      result = Semantics(
        label: semanticLabel,
        child: result,
      );
    }

    return result;
  }
}
