import 'package:flutter/material.dart';
import 'app_colors.dart';

/// AppTextStyles — All typography definitions for the app.
///
/// Based on Material 3's typescale but extended with SaaS-specific
/// aliases (label, caption, code, etc.).
///
/// Usage:
///   Text('Hello', style: AppTextStyles.headingL)
///   Text('Hello', style: Theme.of(context).textTheme.headlineMedium)
abstract final class AppTextStyles {
  // ─────────────────────────────────────────
  // FONT FAMILY
  // ─────────────────────────────────────────

  /// Add to pubspec.yaml:
  ///   fonts:
  ///     - family: Inter
  ///       fonts:
  ///         - asset: assets/fonts/Inter-Regular.ttf
  ///         - asset: assets/fonts/Inter-Medium.ttf   weight: 500
  ///         - asset: assets/fonts/Inter-SemiBold.ttf weight: 600
  ///         - asset: assets/fonts/Inter-Bold.ttf     weight: 700
  static const String _fontFamily = 'Inter';

  // ─────────────────────────────────────────
  // BASE TEXT THEME  (used inside AppTheme)
  // ─────────────────────────────────────────

  static TextTheme get lightTextTheme => _buildTextTheme(AppColors.textPrimaryLight);
  static TextTheme get darkTextTheme  => _buildTextTheme(AppColors.textPrimaryDark);

  static TextTheme _buildTextTheme(Color baseColor) {
    return TextTheme(
      // Display
      displayLarge:  _style(57, FontWeight.w700, baseColor, -0.25),
      displayMedium: _style(45, FontWeight.w700, baseColor, 0),
      displaySmall:  _style(36, FontWeight.w600, baseColor, 0),

      // Headline
      headlineLarge:  _style(32, FontWeight.w700, baseColor, 0),
      headlineMedium: _style(28, FontWeight.w600, baseColor, 0),
      headlineSmall:  _style(24, FontWeight.w600, baseColor, 0),

      // Title
      titleLarge:  _style(22, FontWeight.w600, baseColor, 0),
      titleMedium: _style(16, FontWeight.w600, baseColor, 0.15),
      titleSmall:  _style(14, FontWeight.w500, baseColor, 0.1),

      // Body
      bodyLarge:   _style(16, FontWeight.w400, baseColor, 0.5),
      bodyMedium:  _style(14, FontWeight.w400, baseColor, 0.25),
      bodySmall:   _style(12, FontWeight.w400, baseColor, 0.4),

      // Label
      labelLarge:  _style(14, FontWeight.w500, baseColor, 0.1),
      labelMedium: _style(12, FontWeight.w500, baseColor, 0.5),
      labelSmall:  _style(11, FontWeight.w500, baseColor, 0.5),
    );
  }

  static TextStyle _style(
    double size,
    FontWeight weight,
    Color color, [
    double letterSpacing = 0,
    double height = 1.5,
  ]) =>
      TextStyle(
        fontFamily: _fontFamily,
        fontSize: size,
        fontWeight: weight,
        color: color,
        letterSpacing: letterSpacing,
        height: height,
      );

  // ─────────────────────────────────────────
  // SEMANTIC ALIASES  (use in widgets directly)
  // ─────────────────────────────────────────

  // --- Headings ---
  static const TextStyle headingXL = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 1.2,
  );

  static const TextStyle headingL = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.3,
    height: 1.3,
  );

  static const TextStyle headingM = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.2,
    height: 1.3,
  );

  static const TextStyle headingS = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  // --- Body ---
  static const TextStyle bodyL = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.6,
  );

  static const TextStyle bodyM = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.6,
  );

  static const TextStyle bodyS = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  // --- Labels ---
  static const TextStyle labelL = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
  );

  static const TextStyle labelM = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.3,
  );

  static const TextStyle labelS = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
  );

  // --- Overline / Caption ---
  static const TextStyle overline = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 10,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.2,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.3,
    height: 1.4,
  );

  // --- Buttons ---
  static const TextStyle buttonL = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.2,
  );

  static const TextStyle buttonM = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.2,
  );

  // --- Code / Monospace ---
  static const TextStyle code = TextStyle(
    fontFamily: 'JetBrainsMono', // fallback: monospace
    fontSize: 13,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
    height: 1.6,
  );

  // --- Dashboard KPI numbers ---
  static const TextStyle kpiLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 36,
    fontWeight: FontWeight.w700,
    letterSpacing: -1,
    height: 1.1,
  );

  static const TextStyle kpiMedium = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 1.1,
  );

  // --- Links ---
  static TextStyle link({Color color = AppColors.textLinkLight}) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: color,
        decoration: TextDecoration.underline,
        decorationColor: color.withAlpha((0.4 * 255).round()),
      );
}