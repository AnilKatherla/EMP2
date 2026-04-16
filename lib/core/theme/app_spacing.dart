import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
// RESPONSIVE SCALE CONSTANTS
// ─────────────────────────────────────────────────────────────────────────────
/// The design was built at this logical width (iPhone 12 standard).
const double _kDesignWidth  = 375.0;
/// The design was built at this logical height (iPhone 12 standard).
const double _kDesignHeight = 812.0;

/// Minimum scale factor — prevents text / spacing from becoming too tiny
/// on very small devices (320 wide).
const double _kMinScale = 0.85;

/// Maximum scale factor — prevents over-scaling on large phones (428+).
const double _kMaxScale = 1.15;

/// [_fontScaleExtra] adds a small extra factor so that font sizes never drop
/// below a comfortable reading size even when spacing is very compressed.
const double _kMinFontScale = 0.88;
const double _kMaxFontScale = 1.12;

/// AppSpacing — Consistent spacing values across the app.
///
/// Based on an 4pt base grid. Use multiples of 4 for all spacing.
abstract final class AppSpacing {
  // ─────────────────────────────────────────
  // BASE UNIT
  // ─────────────────────────────────────────
  static const double base = 4.0;

  // ─────────────────────────────────────────
  // RESPONSIVE SCALING FUNCTIONS
  // ─────────────────────────────────────────

  /// Scales [value] proportionally to the current screen **width**.
  ///
  /// ```dart
  /// SizedBox(width: AppSpacing.w(context, 24))
  /// ```
  static double w(BuildContext context, double value) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final scale = (screenWidth / _kDesignWidth).clamp(_kMinScale, _kMaxScale);
    return value * scale;
  }

  /// Scales [value] proportionally to the current screen **height**.
  ///
  /// ```dart
  /// SizedBox(height: AppSpacing.h(context, 48))
  /// ```
  static double h(BuildContext context, double value) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final scale = (screenHeight / _kDesignHeight).clamp(_kMinScale, _kMaxScale);
    return value * scale;
  }

  /// Scales a **font size** [value] based on screen width.
  ///
  /// Uses slightly tighter min/max clamps so text is always readable.
  ///
  /// ```dart
  /// Text('Hello', style: TextStyle(fontSize: AppSpacing.sp(context, 16)))
  /// ```
  static double sp(BuildContext context, double value) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final scale =
        (screenWidth / _kDesignWidth).clamp(_kMinFontScale, _kMaxFontScale);
    return value * scale;
  }

  /// Returns a responsive horizontal screen padding (EdgeInsets.symmetric)
  /// that scales with screen width.
  ///
  /// ```dart
  /// Padding(padding: AppSpacing.screenPaddingOf(context))
  /// ```
  static EdgeInsets screenPaddingOf(BuildContext context) => EdgeInsets.symmetric(
        horizontal: w(context, screenH),
        vertical: h(context, screenV),
      );

  /// Returns a responsive card padding that scales with screen width.
  static EdgeInsets cardPaddingOf(BuildContext context) =>
      EdgeInsets.all(w(context, cardPadding));

  /// Returns a responsive [SizedBox] for **vertical** gaps.
  ///
  /// ```dart
  /// AppSpacing.vGap(context, AppSpacing.lg)
  /// ```
  static Widget vGap(BuildContext context, double value) =>
      SizedBox(height: h(context, value));

  /// Returns a responsive [SizedBox] for **horizontal** gaps.
  static Widget hGap(BuildContext context, double value) =>
      SizedBox(width: w(context, value));


  // ─────────────────────────────────────────
  // SPACING SCALE
  // ─────────────────────────────────────────
  static const double xxs  = base * 0.5;  // 2
  static const double xs   = base * 1;    // 4
  static const double sm   = base * 2;    // 8
  static const double md   = base * 3;    // 12
  static const double lg   = base * 4;    // 16
  static const double xl   = base * 5;    // 20
  static const double xl2  = base * 6;    // 24
  static const double xl3  = base * 8;    // 32
  static const double xl4  = base * 10;   // 40
  static const double xl5  = base * 12;   // 48
  static const double xl6  = base * 16;   // 64
  static const double xl7  = base * 20;   // 80
  static const double xl8  = base * 24;   // 96

  // ─────────────────────────────────────────
  // SEMANTIC SPACING ALIASES
  // ─────────────────────────────────────────

  // Screen edge padding
  static const double screenH   = lg;      // horizontal screen padding: 16
  static const double screenV   = xl2;     // vertical screen padding: 24

  // Component inner padding
  static const double cardPadding    = lg;   // 16
  static const double sectionPadding = xl2;  // 24
  static const double itemPadding    = md;   // 12

  // Between items
  static const double gapXS  = xs;          // 4
  static const double gapSM  = sm;          // 8
  static const double gapMD  = lg;          // 16
  static const double gapLG  = xl2;         // 24
  static const double gapXL  = xl3;         // 32

  // AppBar height
  static const double appBarHeight     = 56.0;
  static const double appBarHeightLarge = 64.0;

  // Bottom nav
  static const double bottomNavHeight = 64.0;

  // FAB clearance
  static const double fabClearance = 80.0;

  // ─────────────────────────────────────────
  // EDGE INSETS HELPERS
  // ─────────────────────────────────────────

  static const EdgeInsets paddingScreen = EdgeInsets.symmetric(
    horizontal: screenH,
    vertical: screenV,
  );

  static const EdgeInsets paddingCard = EdgeInsets.all(cardPadding);

  static const EdgeInsets paddingSection = EdgeInsets.symmetric(
    horizontal: screenH,
    vertical: sectionPadding,
  );

  static const EdgeInsets paddingButtonL = EdgeInsets.symmetric(
    horizontal: xl2,
    vertical: md,
  );

  static const EdgeInsets paddingButtonM = EdgeInsets.symmetric(
    horizontal: xl,
    vertical: sm + 2,
  );

  static const EdgeInsets paddingButtonS = EdgeInsets.symmetric(
    horizontal: lg,
    vertical: sm,
  );

  static const EdgeInsets paddingInput = EdgeInsets.symmetric(
    horizontal: lg,
    vertical: md,
  );

  // ─────────────────────────────────────────
  // ICON SIZES
  // ─────────────────────────────────────────

  static const double iconXS = 14.0;
  static const double iconSM = 16.0;
  static const double iconMD = 20.0;
  static const double iconLG = 24.0;
  static const double iconXL = 32.0;
  static const double iconXXL = 48.0;

  // Avatar sizes
  static const double avatarSM = 28.0;
  static const double avatarMD = 36.0;
  static const double avatarLG = 44.0;
  static const double avatarXL = 56.0;
}

/// AppRadius — Border radius constants.
abstract final class AppRadius {
  static const double none   = 0;
  static const double xs     = 4;
  static const double sm     = 6;
  static const double md     = 8;
  static const double lg     = 12;
  static const double xl     = 16;
  static const double xl2    = 20;
  static const double xl3    = 24;
  static const double full   = 9999; // pill / circle

  // Semantic aliases
  static const double button  = md;
  static const double card    = lg;
  static const double input   = md;
  static const double dialog  = xl;
  static const double chip    = sm;
  static const double badge   = full;
  static const double avatar  = full;
  static const double tooltip = sm;
  static const double sheet   = xl2;

  // BorderRadius shortcuts
  static const BorderRadius brNone   = BorderRadius.all(Radius.circular(none));
  static const BorderRadius brXS     = BorderRadius.all(Radius.circular(xs));
  static const BorderRadius brSM     = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius brMD     = BorderRadius.all(Radius.circular(md));
  static const BorderRadius brLG     = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius brXL     = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius brFull   = BorderRadius.all(Radius.circular(full));
  static const BorderRadius brButton = BorderRadius.all(Radius.circular(button));
  static const BorderRadius brCard   = BorderRadius.all(Radius.circular(card));
  static const BorderRadius brSheet  = BorderRadius.only(
    topLeft: Radius.circular(sheet),
    topRight: Radius.circular(sheet),
  );
}

/// AppElevation — Material 3 tonal elevation levels.
abstract final class AppElevation {
  static const double level0 = 0;
  static const double level1 = 1;
  static const double level2 = 3;
  static const double level3 = 6;
  static const double level4 = 8;
  static const double level5 = 12;

  // Semantic aliases
  static const double card    = level1;
  static const double cardHover = level2;
  static const double appBar  = level0;
  static const double dialog  = level3;
  static const double fab     = level3;
  static const double drawer  = level4;
  static const double tooltip = level2;
}

/// AppBreakpoints — Responsive design breakpoints.
abstract final class AppBreakpoints {
  static const double mobile  = 480;
  static const double tablet  = 768;
  static const double desktop = 1024;
  static const double wide    = 1280;

  /// Returns true when the screen width is considered tablet+.
  static bool isTablet(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= tablet;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= desktop;

  static bool isMobile(BuildContext context) =>
      MediaQuery.sizeOf(context).width < tablet;
}