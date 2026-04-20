import 'package:flutter/material.dart';

/// AppColors — Single source of truth for all colors in the app.
///
/// Rules:
///   • Never use Color(...) literals inside UI widgets.
///   • Always reference AppColors.xxx OR use Theme.of(context).colorScheme.xxx
///   • Semantic aliases (e.g. [textPrimary]) are preferred over raw palette values.
abstract final class AppColors {
  // ─────────────────────────────────────────
  // 01 · RAW PALETTE  (internal building blocks)
  // ─────────────────────────────────────────

  // Indigo brand scale
  static const Color _indigo50  = Color(0xFFEEF2FF);
  static const Color _indigo100 = Color(0xFFE0E7FF);
  static const Color _indigo200 = Color(0xFFC7D2FE);
  static const Color _indigo300 = Color(0xFFA5B4FC);
  static const Color _indigo400 = Color(0xFF818CF8);
  static const Color _indigo500 = Color(0xFF6366F1); // primary brand
  static const Color _indigo600 = Color(0xFF4F46E5);
  static const Color _indigo700 = Color(0xFF4338CA);
  static const Color _indigo800 = Color(0xFF3730A3);
  static const Color _indigo900 = Color(0xFF312E81);
  static const Color indigo900  = _indigo900;

  // Violet (secondary)
  static const Color _violet400 = Color(0xFFA78BFA);
  static const Color _violet500 = Color(0xFF8B5CF6);
  static const Color _violet600 = Color(0xFF7C3AED);

  // Cyan (tertiary / accent)
  static const Color _cyan400 = Color(0xFF22D3EE);
  static const Color _cyan500 = Color(0xFF06B6D4);
  static const Color _cyan600 = Color(0xFF0891B2);

  // Neutral scale
  static const Color _neutral0   = Color(0xFFFFFFFF);
  static const Color _neutral50  = Color(0xFFF8FAFC);
  static const Color _neutral100 = Color(0xFFF1F5F9);
  static const Color _neutral150 = Color(0xFFEAEFF5);
  static const Color _neutral200 = Color(0xFFE2E8F0);
  static const Color _neutral300 = Color(0xFFCBD5E1);
  static const Color _neutral400 = Color(0xFF94A3B8);
  static const Color _neutral500 = Color(0xFF64748B);
  static const Color _neutral600 = Color(0xFF475569);
  static const Color _neutral700 = Color(0xFF334155);
  static const Color _neutral800 = Color(0xFF1E293B);
  static const Color _neutral850 = Color(0xFF172033);
  static const Color _neutral900 = Color(0xFF0F172A);
  static const Color _neutral950 = Color(0xFF080D1A);

  static const Color neutral0   = _neutral0;
  static const Color neutral50  = _neutral50;
  static const Color neutral100 = _neutral100;
  static const Color neutral150 = _neutral150;
  static const Color neutral200 = _neutral200;
  static const Color neutral300 = _neutral300;
  static const Color neutral400 = _neutral400;
  static const Color neutral500 = _neutral500;
  static const Color neutral600 = _neutral600;
  static const Color neutral700 = _neutral700;
  static const Color neutral800 = _neutral800;
  static const Color neutral850 = _neutral850;
  static const Color neutral900 = _neutral900;
  static const Color neutral950 = _neutral950;

  // Status palette
  static const Color _green50  = Color(0xFFF0FDF4);
  static const Color _green100 = Color(0xFFDCFCE7);
  static const Color _green500 = Color(0xFF22C55E);
  static const Color _green600 = Color(0xFF16A34A);
  static const Color _green700 = Color(0xFF15803D);

  static const Color _red50   = Color(0xFFFFF1F2);
  static const Color _red100  = Color(0xFFFFE4E6);
  static const Color _red500  = Color(0xFFEF4444);
  static const Color _red600  = Color(0xFFDC2626);
  static const Color _red700  = Color(0xFFB91C1C);

  static const Color _amber50  = Color(0xFFFFFBEB);
  static const Color _amber100 = Color(0xFFFEF3C7);
  static const Color _amber500 = Color(0xFFF59E0B);
  static const Color _amber600 = Color(0xFFD97706);

  static const Color _blue50   = Color(0xFFEFF6FF);
  static const Color _blue100  = Color(0xFFDBEAFE);
  static const Color _blue200  = Color(0xFFBFDBFE);
  static const Color _blue300  = Color(0xFF93C5FD);
  static const Color _blue400  = Color(0xFF60A5FA);
  static const Color _blue500  = Color(0xFF3B82F6);
  static const Color _blue600  = Color(0xFF2563EB);
  static const Color _blue700  = Color(0xFF1D4ED8);
  static const Color _blue800  = Color(0xFF1E40AF);
  static const Color _blue900  = Color(0xFF1E3A8A);

  // ─────────────────────────────────────────
  // 02 · BRAND / PRIMARY
  // ─────────────────────────────────────────

  static const Color primary          = _blue400;
  static const Color primaryLight     = _blue300;
  static const Color primaryDark      = _blue600;
  static const Color primaryContainer = _blue100;
  static const Color onPrimary        = _neutral0;
  static const Color onPrimaryContainer = _blue900;

  static const Color secondary          = _cyan600;
  static const Color secondaryLight     = _cyan500;
  static const Color secondaryDark      = Color(0xFF0891B2);
  static const Color secondaryContainer = Color(0xFFCFFAFE); // cyan-100
  static const Color onSecondary        = _neutral0;
  static const Color onSecondaryContainer = Color(0xFF164E63); // cyan-900

  static const Color tertiary          = _blue500;
  static const Color tertiaryLight     = _blue400;
  static const Color tertiaryDark      = _blue600;
  static const Color tertiaryContainer = Color(0xFFDBEAFE); // blue-100
  static const Color onTertiary        = _neutral0;
  static const Color onTertiaryContainer = Color(0xFF1E3A8A); // blue-900

  // ─────────────────────────────────────────
  // 03 · BACKGROUND & SURFACE (LIGHT)
  // ─────────────────────────────────────────

  static const Color backgroundLight      = _neutral50;
  static const Color scaffoldLight        = _neutral100;
  static const Color surfaceLight         = _neutral0;
  static const Color surfaceVariantLight  = _neutral100;
  static const Color cardLight            = _neutral0;
  static const Color cardTintLight        = _blue50;

  // ─────────────────────────────────────────
  // 04 · BACKGROUND & SURFACE (DARK)
  // ─────────────────────────────────────────

  static const Color backgroundDark     = _neutral950;
  static const Color scaffoldDark       = _neutral900;
  static const Color surfaceDark        = _neutral850;
  static const Color surfaceVariantDark = _neutral800;
  static const Color cardDark           = _neutral800;
  static const Color cardTintDark       = Color(0xFF1E293B); // neutral-800

  // ─────────────────────────────────────────
  // 05 · TEXT (LIGHT)
  // ─────────────────────────────────────────

  static const Color textPrimaryLight   = _neutral900;
  static const Color textSecondaryLight = _neutral600;
  static const Color textMutedLight     = _neutral400;
  static const Color textDisabledLight  = _neutral300;
  static const Color textInverseLight   = _neutral0;
  static const Color textBrandLight     = _blue600;
  static const Color textLinkLight      = _blue600;

  // ─────────────────────────────────────────
  // 06 · TEXT (DARK)
  // ─────────────────────────────────────────

  static const Color textPrimaryDark   = _neutral50;
  static const Color textSecondaryDark = _neutral400;
  static const Color textMutedDark     = _neutral600;
  static const Color textDisabledDark  = _neutral700;
  static const Color textInverseDark   = _neutral900;
  static const Color textBrandDark     = _blue300;
  static const Color textLinkDark      = _blue300;

  // ─────────────────────────────────────────
  // 07 · STATUS COLORS
  // ─────────────────────────────────────────

  // Success
  static const Color success            = _green500;
  static const Color successDark        = _green600;
  static const Color successContainer   = _green100;
  static const Color successBackground  = _green50;
  static const Color onSuccess          = _neutral0;
  static const Color onSuccessContainer = _green700;

  // Error
  static const Color error              = _red500;
  static const Color errorDark          = _red600;
  static const Color errorContainer     = _red100;
  static const Color errorBackground    = _red50;
  static const Color onError            = _neutral0;
  static const Color onErrorContainer   = _red700;

  // Warning
  static const Color warning            = _amber500;
  static const Color warningDark        = _amber600;
  static const Color warningContainer   = _amber100;
  static const Color warningBackground  = _amber50;
  static const Color onWarning          = _neutral0;
  static const Color onWarningContainer = Color(0xFF92400E); // amber-800

  // Info
  static const Color info              = _blue500;
  static const Color infoDark          = _blue600;
  static const Color infoContainer     = _blue100;
  static const Color infoBackground    = _blue50;
  static const Color onInfo            = _neutral0;
  static const Color onInfoContainer   = Color(0xFF1E3A8A); // blue-900

  // ─────────────────────────────────────────
  // 08 · BORDERS & DIVIDERS
  // ─────────────────────────────────────────

  static const Color borderLight        = _neutral200;
  static const Color borderDark         = _neutral700;
  static const Color borderFocusLight   = _blue500;
  static const Color borderFocusDark    = _blue500;
  static const Color borderErrorLight   = _red500;
  static const Color borderErrorDark    = _red500;
  static const Color dividerLight       = _neutral150;
  static const Color dividerDark        = _neutral800;

  // ─────────────────────────────────────────
  // 09 · SHADOWS
  // ─────────────────────────────────────────

  static const Color shadowLight = Color(0x14000000); // ~8% black
  static const Color shadowMedium = Color(0x1F000000); // ~12% black
  static const Color shadowDark  = Color(0x0AFFFFFF); // ~4% white (dark mode)

  // ─────────────────────────────────────────
  // 10 · ICONS
  // ─────────────────────────────────────────

  static const Color iconPrimaryLight   = _neutral700;
  static const Color iconSecondaryLight = _neutral400;
  static const Color iconPrimaryDark    = _neutral300;
  static const Color iconSecondaryDark  = _neutral600;
  static const Color iconBrand          = _blue600;

  // ─────────────────────────────────────────
  // 11 · BUTTONS
  // ─────────────────────────────────────────

  static const Color buttonPrimary         = _blue400;
  static const Color buttonPrimaryHover    = _blue500;
  static const Color buttonPrimaryDisabled = _blue100;
  static const Color onButtonPrimary       = _neutral0;

  static const Color buttonOutlineBorder   = _blue300;
  static const Color buttonOutlineContent  = _blue500;

  static const Color buttonDestructive     = _red500;
  static const Color buttonDestructiveHover = _red600;

  // ─────────────────────────────────────────
  // 12 · FORM / INPUT
  // ─────────────────────────────────────────

  static const Color inputFillLight   = _neutral50;
  static const Color inputFillDark    = _neutral800;
  static const Color inputBorderLight = _neutral200;
  static const Color inputBorderDark  = _neutral700;

  // ─────────────────────────────────────────
  // 13 · HIGHLIGHTS / SELECTION
  // ─────────────────────────────────────────

  static const Color selectionLight    = _blue100;
  static const Color selectionDark     = Color(0xFF1E3A8A);
  static const Color highlightLight    = Color(0xFFFEF9C3); // yellow-100
  static const Color highlightDark     = Color(0xFF422006);

  // ─────────────────────────────────────────
  // 14 · OVERLAY / SCRIM
  // ─────────────────────────────────────────

  static const Color scrimLight = Color(0x4D000000); // 30% black
  static const Color scrimDark  = Color(0x80000000); // 50% black

  // ─────────────────────────────────────────
  // 15 · GRADIENTS
  // ─────────────────────────────────────────

  static const LinearGradient gradientPrimary = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [_blue400, _blue500],
  );

  static const LinearGradient gradientPrimarySubtle = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [_blue50, _blue100],
  );

  static const LinearGradient gradientCool = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [_cyan500, _blue600],
  );

  static const LinearGradient gradientDark = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [_neutral900, _neutral800],
  );

  static const LinearGradient gradientSuccess = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [_green500, _cyan500],
  );

  // ─────────────────────────────────────────
  // 16 · DASHBOARD CARD TINTS
  // ─────────────────────────────────────────

  /// Use these for colourful stat/kpi cards on dashboards.
  static const Color cardTintBlue   = Color(0xFFEFF6FF);
  static const Color cardTintIndigo = Color(0xFFEEF2FF);
  static const Color cardTintViolet = Color(0xFFF5F3FF);
  static const Color cardTintGreen  = Color(0xFFF0FDF4);
  static const Color cardTintAmber  = Color(0xFFFFFBEB);
  static const Color cardTintRed    = Color(0xFFFFF1F2);
  static const Color cardTintCyan   = Color(0xFFECFEFF);

  // Dark-mode variants
  static const Color cardTintBlueDark   = Color(0xFF172554);
  static const Color cardTintIndigoDark = Color(0xFF1E1B4B);
  static const Color cardTintVioletDark = Color(0xFF2E1065);
  static const Color cardTintGreenDark  = Color(0xFF052E16);
  static const Color cardTintAmberDark  = Color(0xFF1C0A00);
  static const Color cardTintRedDark    = Color(0xFF3B0A0A);
  static const Color cardTintCyanDark   = Color(0xFF083344);

  // ─────────────────────────────────────────
  // 17 · TRANSPARENCY HELPERS
  // ─────────────────────────────────────────

  static Color primaryAlpha(double opacity) => primary.withAlpha((opacity.clamp(0.0, 1.0) * 255).round());
  static Color blackAlpha(double opacity)   => Colors.black.withAlpha((opacity.clamp(0.0, 1.0) * 255).round());
  static Color whiteAlpha(double opacity)   => Colors.white.withAlpha((opacity.clamp(0.0, 1.0) * 255).round());
}