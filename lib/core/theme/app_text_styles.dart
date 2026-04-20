import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';
import 'app_spacing.dart';

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
  static const String _fontFamily = 'Outfit';

  static TextStyle _outfit({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? letterSpacing,
    double? height,
  }) {
    return GoogleFonts.outfit(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
    );
  }

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
      _outfit(
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
  static TextStyle get headingXL => _outfit(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        height: 1.2,
      );

  static TextStyle get headingL => _outfit(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.3,
    height: 1.3,
  );

  static TextStyle get headingM => _outfit(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.2,
    height: 1.3,
  );

  static TextStyle get headingS => _outfit(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  // --- Body ---
  static TextStyle get bodyL => _outfit(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.6,
  );

  static TextStyle get bodyM => _outfit(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.6,
  );

  static TextStyle get bodyS => _outfit(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  // --- Labels ---
  static TextStyle get labelL => _outfit(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
  );

  static TextStyle get labelM => _outfit(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.3,
  );

  static TextStyle get labelS => _outfit(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
  );

  // --- Overline / Caption ---
  static TextStyle get overline => _outfit(
    fontSize: 10,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.2,
  );

  static TextStyle get caption => _outfit(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.3,
    height: 1.4,
  );

  // --- Buttons ---
  static TextStyle get buttonL => _outfit(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.2,
  );

  static TextStyle get buttonM => _outfit(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.2,
  );

  // --- Code / Monospace ---
  static const TextStyle code = TextStyle(
    fontFamily: 'JetBrainsMono',
    fontSize: 13,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
    height: 1.6,
  );

  // --- Dashboard KPI numbers ---
  static TextStyle get kpiLarge => _outfit(
    fontSize: 36,
    fontWeight: FontWeight.w700,
    letterSpacing: -1,
    height: 1.1,
  );

  static TextStyle get kpiMedium => _outfit(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 1.1,
  );

  // --- Links ---
  static TextStyle link({Color color = AppColors.textLinkLight}) => _outfit(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: color,
      ).copyWith(
        decoration: TextDecoration.underline,
        decorationColor: color.withAlpha((0.4 * 255).round()),
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// RESPONSIVE TEXT STYLES
// ─────────────────────────────────────────────────────────────────────────────

/// ResponsiveTextStyles — Context-aware text styles that scale with screen size.
///
/// All font sizes are computed via [AppSpacing.sp], which scales proportionally
/// to the current screen width relative to the 375 px design baseline and is
/// clamped so text stays readable on small (320 wide) and large (428+) screens.
///
/// Usage:
///   ```dart
///   Text(
///     'Hello',
///     style: ResponsiveTextStyles.headingLarge(context),
///   )
///   ```
///
/// Or to override the TextTheme in a subtree:
///   ```dart
///   Theme(
///     data: Theme.of(context).copyWith(
///       textTheme: ResponsiveTextStyles.responsiveTextThemeOf(context),
///     ),
///     child: ...,
///   )
///   ```
abstract final class ResponsiveTextStyles {
  static const String _fontFamily = 'Outfit';

  static TextStyle _outfit({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? letterSpacing,
    double? height,
    TextDecoration? decoration,
    Color? decorationColor,
  }) {
    return GoogleFonts.outfit(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
      decoration: decoration,
      decorationColor: decorationColor,
    );
  }

  // ─────────────────────────────────────────
  // HEADINGS
  // ─────────────────────────────────────────

  /// Display — large hero text (e.g. splash screens)
  static TextStyle displayLarge(BuildContext context, {Color? color}) =>
      _outfit(
        fontSize: AppSpacing.sp(context, 57),
        fontWeight: FontWeight.w700,
        letterSpacing: -0.25,
        height: 1.12,
        color: color,
      );

  /// Page-level hero heading
  static TextStyle headingLarge(BuildContext context, {Color? color}) =>
      _outfit(
        fontSize: AppSpacing.sp(context, 32),
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        height: 1.2,
        color: color,
      );

  /// Section heading
  static TextStyle headingMedium(BuildContext context, {Color? color}) =>
      _outfit(
        fontSize: AppSpacing.sp(context, 24),
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
        height: 1.3,
        color: color,
      );

  /// Sub-section heading
  static TextStyle headingSmall(BuildContext context, {Color? color}) =>
      _outfit(
        fontSize: AppSpacing.sp(context, 20),
        fontWeight: FontWeight.w600,
        letterSpacing: -0.2,
        height: 1.3,
        color: color,
      );

  /// Card title / list item heading
  static TextStyle titleLarge(BuildContext context, {Color? color}) =>
      _outfit(
        fontSize: AppSpacing.sp(context, 18),
        fontWeight: FontWeight.w600,
        height: 1.4,
        color: color,
      );

  static TextStyle titleMedium(BuildContext context, {Color? color}) =>
      _outfit(
        fontSize: AppSpacing.sp(context, 16),
        fontWeight: FontWeight.w600,
        letterSpacing: 0.15,
        height: 1.4,
        color: color,
      );

  static TextStyle titleSmall(BuildContext context, {Color? color}) =>
      _outfit(
        fontSize: AppSpacing.sp(context, 14),
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        height: 1.4,
        color: color,
      );

  // ─────────────────────────────────────────
  // BODY
  // ─────────────────────────────────────────

  /// Primary reading text
  static TextStyle bodyLarge(BuildContext context, {Color? color}) =>
      _outfit(
        fontSize: AppSpacing.sp(context, 16),
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
        height: 1.6,
        color: color,
      );

  /// Secondary / compact reading text
  static TextStyle bodyMedium(BuildContext context, {Color? color}) =>
      _outfit(
        fontSize: AppSpacing.sp(context, 14),
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        height: 1.6,
        color: color,
      );

  /// Small detail text
  static TextStyle bodySmall(BuildContext context, {Color? color}) =>
      _outfit(
        fontSize: AppSpacing.sp(context, 12),
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
        height: 1.5,
        color: color,
      );

  // ─────────────────────────────────────────
  // LABELS
  // ─────────────────────────────────────────

  static TextStyle labelLarge(BuildContext context, {Color? color}) =>
      _outfit(
        fontSize: AppSpacing.sp(context, 14),
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        color: color,
      );

  static TextStyle labelMedium(BuildContext context, {Color? color}) =>
      _outfit(
        fontSize: AppSpacing.sp(context, 12),
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        color: color,
      );

  static TextStyle labelSmall(BuildContext context, {Color? color}) =>
      _outfit(
        fontSize: AppSpacing.sp(context, 11),
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        color: color,
      );

  // ─────────────────────────────────────────
  // CAPTION
  // ─────────────────────────────────────────

  /// Metadata / timestamp / fine-print text
  static TextStyle caption(BuildContext context, {Color? color}) =>
      _outfit(
        fontSize: AppSpacing.sp(context, 11),
        fontWeight: FontWeight.w400,
        letterSpacing: 0.3,
        height: 1.4,
        color: color,
      );

  /// ALL-CAPS overline (categories, tags)
  static TextStyle overline(BuildContext context, {Color? color}) =>
      _outfit(
        fontSize: AppSpacing.sp(context, 10),
        fontWeight: FontWeight.w600,
        letterSpacing: 1.2,
        color: color,
      );

  // ─────────────────────────────────────────
  // BUTTONS
  // ─────────────────────────────────────────

  static TextStyle buttonLarge(BuildContext context, {Color? color}) =>
      _outfit(
        fontSize: AppSpacing.sp(context, 15),
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
        color: color,
      );

  static TextStyle buttonMedium(BuildContext context, {Color? color}) =>
      _outfit(
        fontSize: AppSpacing.sp(context, 13),
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
        color: color,
      );

  // ─────────────────────────────────────────
  // KPI / DASHBOARD NUMBERS
  // ─────────────────────────────────────────

  static TextStyle kpiLarge(BuildContext context, {Color? color}) =>
      _outfit(
        fontSize: AppSpacing.sp(context, 36),
        fontWeight: FontWeight.w700,
        letterSpacing: -1.0,
        height: 1.1,
        color: color,
      );

  static TextStyle kpiMedium(BuildContext context, {Color? color}) =>
      _outfit(
        fontSize: AppSpacing.sp(context, 24),
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        height: 1.1,
        color: color,
      );

  // ─────────────────────────────────────────
  // LINKS
  // ─────────────────────────────────────────

  static TextStyle link(
    BuildContext context, {
    Color color = AppColors.textLinkLight,
  }) =>
      _outfit(
        fontSize: AppSpacing.sp(context, 14),
        fontWeight: FontWeight.w500,
        color: color,
        decoration: TextDecoration.underline,
        decorationColor: color.withAlpha((0.4 * 255).round()),
      );

  // ─────────────────────────────────────────
  // RESPONSIVE TEXT THEME FACTORY
  // ─────────────────────────────────────────

  /// Returns a fully responsive [TextTheme] whose every style is scaled to
  /// the current screen width via [AppSpacing.sp].
  ///
  /// Intended for use in a [Theme] widget when you need live-scaled typography
  /// (e.g. inside a screen that wants sizes different from the app-wide theme).
  ///
  /// In most cases the app-wide [AppTextStyles.lightTextTheme] /
  /// [AppTextStyles.darkTextTheme] are sufficient; use this only where you
  /// need true per-screen responsiveness.
  static TextTheme responsiveTextThemeOf(
    BuildContext context, {
    Color baseColor = AppColors.textPrimaryLight,
  }) {
    return TextTheme(
      // Display
      displayLarge:  displayLarge(context, color: baseColor),
      displayMedium: _outfit(
        fontSize: AppSpacing.sp(context, 45),
        fontWeight: FontWeight.w700,
        height: 1.16,
        color: baseColor,
      ),
      displaySmall: _outfit(
        fontSize: AppSpacing.sp(context, 36),
        fontWeight: FontWeight.w600,
        height: 1.22,
        color: baseColor,
      ),
      // Headline
      headlineLarge:  headingLarge(context, color: baseColor),
      headlineMedium: headingMedium(context, color: baseColor),
      headlineSmall:  headingSmall(context, color: baseColor),
      // Title
      titleLarge:  titleLarge(context, color: baseColor),
      titleMedium: titleMedium(context, color: baseColor),
      titleSmall:  titleSmall(context, color: baseColor),
      // Body
      bodyLarge:   bodyLarge(context, color: baseColor),
      bodyMedium:  bodyMedium(context, color: baseColor),
      bodySmall:   bodySmall(context, color: baseColor),
      // Label
      labelLarge:  labelLarge(context, color: baseColor),
      labelMedium: labelMedium(context, color: baseColor),
      labelSmall:  labelSmall(context, color: baseColor),
    );
  }
}
