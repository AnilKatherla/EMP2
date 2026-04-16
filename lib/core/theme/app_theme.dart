import 'package:emp/core/theme/app_spacing.dart';
import 'package:emp/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';


/// AppTheme — Central ThemeData factory for Light and Dark modes.
///
/// Usage in MaterialApp:
///   ```dart
///   MaterialApp(
///     theme:      AppTheme.light,
///     darkTheme:  AppTheme.dark,
///     themeMode:  themeMode, // controlled by ThemeController
///   )
///   ```
///
/// ## Responsive Typography
///
/// [AppTheme.light] / [AppTheme.dark] use **fixed-size** text styles (correct
/// for a global ThemeData — it is built once at startup, without a context).
///
/// For **per-screen responsive font sizes** wrap any subtree with the live
/// scale helper:
///   ```dart
///   Theme(
///     data: AppTheme.withResponsiveText(context),
///     child: YourScreen(),
///   )
///   ```
///
/// Or use [ResponsiveTextStyles] directly on any Text widget:
///   ```dart
///   Text('Hello', style: ResponsiveTextStyles.headingLarge(context))
///   ```
abstract final class AppTheme {
  // ─────────────────────────────────────────
  // LIGHT THEME
  // ─────────────────────────────────────────

  static ThemeData get light => _build(Brightness.light);

  // ─────────────────────────────────────────
  // DARK THEME
  // ─────────────────────────────────────────

  static ThemeData get dark => _build(Brightness.dark);

  // ─────────────────────────────────────────
  // RESPONSIVE THEME HELPER
  // ─────────────────────────────────────────

  /// Returns the current theme with its TextTheme **overridden** by a
  /// fully responsive [ResponsiveTextStyles.responsiveTextThemeOf] instance.
  ///
  /// Call this inside a build method and wrap the result in a [Theme] widget.
  /// It reads both the current brightness and [MediaQuery] from [context].
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///   return Theme(
  ///     data: AppTheme.withResponsiveText(context),
  ///     child: Scaffold(...),
  ///   );
  /// }
  /// ```
  static ThemeData withResponsiveText(BuildContext context) {
    final currentTheme = Theme.of(context);
    final isLight = currentTheme.brightness == Brightness.light;
    return currentTheme.copyWith(
      textTheme: ResponsiveTextStyles.responsiveTextThemeOf(
        context,
        baseColor: isLight
            ? AppColors.textPrimaryLight
            : AppColors.textPrimaryDark,
      ),
    );
  }

  // ─────────────────────────────────────────
  // BUILDER
  // ─────────────────────────────────────────

  static ThemeData _build(Brightness brightness) {
    final bool isLight = brightness == Brightness.light;

    final ColorScheme colorScheme = isLight
        ? _lightColorScheme
        : _darkColorScheme;

    final TextTheme textTheme = isLight
        ? AppTextStyles.lightTextTheme
        : AppTextStyles.darkTextTheme;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      textTheme: textTheme,
      fontFamily: 'Inter',

      // ── Scaffold ───────────────────────────
      scaffoldBackgroundColor: isLight
          ? AppColors.scaffoldLight
          : AppColors.scaffoldDark,

      // ── AppBar ─────────────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor: isLight
            ? AppColors.surfaceLight
            : AppColors.surfaceDark,
        foregroundColor: isLight
            ? AppColors.textPrimaryLight
            : AppColors.textPrimaryDark,
        elevation: AppElevation.appBar,
        scrolledUnderElevation: AppElevation.level1,
        surfaceTintColor: Colors.transparent,
        shadowColor: isLight
            ? AppColors.shadowLight
            : AppColors.shadowDark,
        centerTitle: false,
        titleTextStyle: AppTextStyles.headingM.copyWith(
          color: isLight
              ? AppColors.textPrimaryLight
              : AppColors.textPrimaryDark,
        ),
        iconTheme: IconThemeData(
          color: isLight
              ? AppColors.iconPrimaryLight
              : AppColors.iconPrimaryDark,
          size: AppSpacing.iconLG,
        ),
        actionsIconTheme: IconThemeData(
          color: isLight
              ? AppColors.iconPrimaryLight
              : AppColors.iconPrimaryDark,
          size: AppSpacing.iconLG,
        ),
        systemOverlayStyle: isLight
            ? SystemUiOverlayStyle.dark
            : SystemUiOverlayStyle.light,
      ),

      // ── ElevatedButton ─────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.buttonPrimary,
          foregroundColor: AppColors.onButtonPrimary,
          disabledBackgroundColor: AppColors.buttonPrimaryDisabled,
          disabledForegroundColor: AppColors.onButtonPrimary.withAlpha((0.6 * 255).round()),
          elevation: 0,
          shadowColor: Colors.transparent,
          padding: AppSpacing.paddingButtonL,
          shape: const RoundedRectangleBorder(
            borderRadius: AppRadius.brButton,
          ),
          textStyle: AppTextStyles.buttonL,
          minimumSize: const Size(64, 44),
        ).copyWith(
          overlayColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.hovered)) {
              return AppColors.buttonPrimaryHover;
            }
            if (states.contains(WidgetState.pressed)) {
              return AppColors.primaryDark;
            }
            return null;
          }),
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return AppColors.buttonPrimaryDisabled;
            }
            if (states.contains(WidgetState.pressed)) {
              return AppColors.buttonPrimaryHover;
            }
            return AppColors.buttonPrimary;
          }),
        ),
      ),

      // ── OutlinedButton ─────────────────────
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.buttonOutlineContent,
          side: const BorderSide(
            color: AppColors.buttonOutlineBorder,
            width: 1.5,
          ),
          padding: AppSpacing.paddingButtonL,
          shape: const RoundedRectangleBorder(
            borderRadius: AppRadius.brButton,
          ),
          textStyle: AppTextStyles.buttonL,
          minimumSize: const Size(64, 44),
        ),
      ),

      // ── TextButton ─────────────────────────
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          padding: AppSpacing.paddingButtonM,
          shape: const RoundedRectangleBorder(
            borderRadius: AppRadius.brButton,
          ),
          textStyle: AppTextStyles.buttonM,
          minimumSize: const Size(48, 36),
        ),
      ),

      // ── FilledButton ───────────────────────
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onButtonPrimary,
          padding: AppSpacing.paddingButtonL,
          shape: const RoundedRectangleBorder(
            borderRadius: AppRadius.brButton,
          ),
          textStyle: AppTextStyles.buttonL,
          minimumSize: const Size(64, 44),
        ),
      ),

      // ── Input / Form ───────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isLight
            ? AppColors.inputFillLight
            : AppColors.inputFillDark,
        contentPadding: AppSpacing.paddingInput,
        hintStyle: AppTextStyles.bodyM.copyWith(
          color: isLight
              ? AppColors.textMutedLight
              : AppColors.textMutedDark,
        ),
        labelStyle: AppTextStyles.labelL.copyWith(
          color: isLight
              ? AppColors.textSecondaryLight
              : AppColors.textSecondaryDark,
        ),
        floatingLabelStyle: AppTextStyles.labelM.copyWith(
          color: AppColors.primary,
        ),
        border: OutlineInputBorder(
          borderRadius: AppRadius.brMD,
          borderSide: BorderSide(
            color: isLight
                ? AppColors.inputBorderLight
                : AppColors.inputBorderDark,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.brMD,
          borderSide: BorderSide(
            color: isLight
                ? AppColors.inputBorderLight
                : AppColors.inputBorderDark,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.brMD,
          borderSide: const BorderSide(
            color: AppColors.borderFocusLight,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.brMD,
          borderSide: const BorderSide(
            color: AppColors.error,
            width: 1,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppRadius.brMD,
          borderSide: const BorderSide(
            color: AppColors.errorDark,
            width: 2,
          ),
        ),
        errorStyle: AppTextStyles.caption.copyWith(
          color: AppColors.error,
        ),
        prefixIconColor: WidgetStateColor.resolveWith((states) {
          if (states.contains(WidgetState.focused)) {
            return AppColors.primary;
          }
          return isLight
              ? AppColors.iconSecondaryLight
              : AppColors.iconSecondaryDark;
        }),
        suffixIconColor: WidgetStateColor.resolveWith((states) {
          if (states.contains(WidgetState.focused)) {
            return AppColors.primary;
          }
          return isLight
              ? AppColors.iconSecondaryLight
              : AppColors.iconSecondaryDark;
        }),
      ),

      // ── Card ───────────────────────────────
      // cardTheme: CardTheme(
      //   color: isLight
      //       ? AppColors.cardLight
      //       : AppColors.cardDark,
      //   elevation: AppElevation.card,
      //   shadowColor: isLight
      //       ? AppColors.shadowLight
      //       : Colors.transparent,
      //   surfaceTintColor: Colors.transparent,
      //   shape: const RoundedRectangleBorder(
      //     borderRadius: AppRadius.brCard,
      //   ),
      //   margin: EdgeInsets.zero,
      //   clipBehavior: Clip.antiAlias,
      // ),

      // ── Divider ────────────────────────────
      dividerTheme: DividerThemeData(
        color: isLight
            ? AppColors.dividerLight
            : AppColors.dividerDark,
        thickness: 1,
        space: 1,
      ),

      // ── Icon ───────────────────────────────
      iconTheme: IconThemeData(
        color: isLight
            ? AppColors.iconPrimaryLight
            : AppColors.iconPrimaryDark,
        size: AppSpacing.iconLG,
      ),

      // ── ListTile ───────────────────────────
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.xs,
        ),
        tileColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: AppRadius.brMD,
        ),
        titleTextStyle: AppTextStyles.bodyM.copyWith(
          color: isLight
              ? AppColors.textPrimaryLight
              : AppColors.textPrimaryDark,
          fontWeight: FontWeight.w500,
        ),
        subtitleTextStyle: AppTextStyles.bodyS.copyWith(
          color: isLight
              ? AppColors.textSecondaryLight
              : AppColors.textSecondaryDark,
        ),
        iconColor: isLight
            ? AppColors.iconPrimaryLight
            : AppColors.iconPrimaryDark,
        selectedColor: AppColors.primary,
        selectedTileColor: isLight
            ? AppColors.selectionLight
            : AppColors.selectionDark,
      ),

      // ── Chip ───────────────────────────────
      chipTheme: ChipThemeData(
        backgroundColor: isLight
            ? AppColors.surfaceVariantLight
            : AppColors.surfaceVariantDark,
        selectedColor: AppColors.primaryContainer,
        disabledColor: isLight
            ? AppColors.borderLight
            : AppColors.borderDark,
        labelStyle: AppTextStyles.labelM.copyWith(
          color: isLight
              ? AppColors.textSecondaryLight
              : AppColors.textSecondaryDark,
        ),
        secondaryLabelStyle: AppTextStyles.labelM.copyWith(
          color: AppColors.onPrimaryContainer,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: AppRadius.brSM,
          side: BorderSide.none,
        ),
      ),

      // ── BottomNavigationBar ────────────────
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: isLight
            ? AppColors.surfaceLight
            : AppColors.surfaceDark,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: isLight
            ? AppColors.iconSecondaryLight
            : AppColors.iconSecondaryDark,
        elevation: AppElevation.level2,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: AppTextStyles.labelS.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: AppTextStyles.labelS,
      ),

      // ── NavigationBar (M3) ─────────────────
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: isLight
            ? AppColors.surfaceLight
            : AppColors.surfaceDark,
        indicatorColor: isLight
            ? AppColors.primaryContainer
            : AppColors.selectionDark,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.primary);
          }
          return IconThemeData(
            color: isLight
                ? AppColors.iconSecondaryLight
                : AppColors.iconSecondaryDark,
          );
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppTextStyles.labelS.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            );
          }
          return AppTextStyles.labelS.copyWith(
            color: isLight
                ? AppColors.textSecondaryLight
                : AppColors.textSecondaryDark,
          );
        }),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),

      // ── Drawer ─────────────────────────────
      drawerTheme: DrawerThemeData(
        backgroundColor: isLight
            ? AppColors.surfaceLight
            : AppColors.surfaceDark,
        elevation: AppElevation.drawer,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(AppRadius.xl2),
            bottomRight: Radius.circular(AppRadius.xl2),
          ),
        ),
      ),

      // ── Dialog ─────────────────────────────
      // dialogTheme: DialogTheme(
      //   backgroundColor: isLight
      //       ? AppColors.surfaceLight
      //       : AppColors.surfaceDark,
      //   elevation: AppElevation.dialog,
      //   shape: const RoundedRectangleBorder(
      //     borderRadius: AppRadius.brXL,
      //   ),
      //   titleTextStyle: AppTextStyles.headingM.copyWith(
      //     color: isLight
      //         ? AppColors.textPrimaryLight
      //         : AppColors.textPrimaryDark,
      //   ),
      //   contentTextStyle: AppTextStyles.bodyM.copyWith(
      //     color: isLight
      //         ? AppColors.textSecondaryLight
      //         : AppColors.textSecondaryDark,
      //   ),
      // ),

      // ── SnackBar ───────────────────────────
      snackBarTheme: SnackBarThemeData(
        backgroundColor: isLight
            ? AppColors.neutral700
            : AppColors.neutral100,
        contentTextStyle: AppTextStyles.bodyM.copyWith(
          color: isLight ? AppColors.neutral50 : AppColors.neutral900,
        ),
        actionTextColor: AppColors.primaryLight,
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(
          borderRadius: AppRadius.brMD,
        ),
        elevation: AppElevation.level3,
      ),

      // ── Switch ─────────────────────────────
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.onPrimary;
          }
          return isLight ? AppColors.neutral400 : AppColors.neutral600;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }
          return isLight ? AppColors.borderLight : AppColors.borderDark;
        }),
        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
      ),

      // ── Checkbox ───────────────────────────
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(AppColors.onPrimary),
        side: BorderSide(
          color: isLight ? AppColors.borderLight : AppColors.borderDark,
          width: 1.5,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: AppRadius.brXS,
        ),
      ),

      // ── Radio ──────────────────────────────
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }
          return isLight ? AppColors.borderLight : AppColors.borderDark;
        }),
      ),

      // ── Slider ─────────────────────────────
      sliderTheme: SliderThemeData(
        activeTrackColor: AppColors.primary,
        inactiveTrackColor: isLight
            ? AppColors.primaryContainer
            : AppColors.selectionDark,
        thumbColor: AppColors.primary,
        overlayColor: AppColors.primaryAlpha(0.12),
        valueIndicatorColor: AppColors.primaryDark,
        valueIndicatorTextStyle: AppTextStyles.labelM.copyWith(
          color: AppColors.onPrimary,
        ),
      ),

      // ── TabBar ─────────────────────────────
      // tabBarTheme: TabBarTheme(
      //   labelColor: AppColors.primary,
      //   unselectedLabelColor: isLight
      //       ? AppColors.textSecondaryLight
      //       : AppColors.textSecondaryDark,
      //   indicatorColor: AppColors.primary,
      //   indicatorSize: TabBarIndicatorSize.label,
      //   dividerColor: Colors.transparent,
      //   labelStyle: AppTextStyles.labelL.copyWith(fontWeight: FontWeight.w600),
      //   unselectedLabelStyle: AppTextStyles.labelL,
      // ),

      // ── FloatingActionButton ───────────────
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        elevation: AppElevation.fab,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.brLG,
        ),
      ),

      // ── ProgressIndicator ──────────────────
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
        linearTrackColor: AppColors.primaryContainer,
        circularTrackColor: AppColors.primaryContainer,
        refreshBackgroundColor: AppColors.surfaceLight,
      ),

      // ── Tooltip ────────────────────────────
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: isLight ? AppColors.neutral800 : AppColors.neutral200,
          borderRadius: AppRadius.brSM,
        ),
        textStyle: AppTextStyles.caption.copyWith(
          color: isLight ? AppColors.neutral50 : AppColors.neutral900,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        waitDuration: const Duration(milliseconds: 600),
      ),

      // ── PopupMenu ──────────────────────────
      popupMenuTheme: PopupMenuThemeData(
        color: isLight ? AppColors.surfaceLight : AppColors.surfaceDark,
        elevation: AppElevation.level3,
        shape: const RoundedRectangleBorder(
          borderRadius: AppRadius.brMD,
        ),
        textStyle: AppTextStyles.bodyM.copyWith(
          color: isLight
              ? AppColors.textPrimaryLight
              : AppColors.textPrimaryDark,
        ),
        surfaceTintColor: Colors.transparent,
      ),

      // ── BottomSheet ────────────────────────
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: isLight
            ? AppColors.surfaceLight
            : AppColors.surfaceDark,
        elevation: AppElevation.level4,
        shape: const RoundedRectangleBorder(
          borderRadius: AppRadius.brSheet,
        ),
        showDragHandle: true,
        dragHandleColor: isLight
            ? AppColors.neutral300
            : AppColors.neutral600,
        surfaceTintColor: Colors.transparent,
      ),

      // ── Badge ──────────────────────────────
      badgeTheme: const BadgeThemeData(
        backgroundColor: AppColors.error,
        textColor: AppColors.onError,
        textStyle: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),

      // ── SearchBar ──────────────────────────
      searchBarTheme: SearchBarThemeData(
        backgroundColor: WidgetStatePropertyAll(
          isLight ? AppColors.inputFillLight : AppColors.inputFillDark,
        ),
        elevation: const WidgetStatePropertyAll(0),
        shape: const WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: AppRadius.brMD),
        ),
        side: WidgetStatePropertyAll(BorderSide(
          color: isLight ? AppColors.inputBorderLight : AppColors.inputBorderDark,
          width: 1,
        )),
        hintStyle: WidgetStatePropertyAll(AppTextStyles.bodyM.copyWith(
          color: isLight ? AppColors.textMutedLight : AppColors.textMutedDark,
        )),
        textStyle: WidgetStatePropertyAll(AppTextStyles.bodyM.copyWith(
          color: isLight
              ? AppColors.textPrimaryLight
              : AppColors.textPrimaryDark,
        )),
      ),

      // ── Extensions ────────────────────────
      extensions: const [
        AppStatusColors(),
        AppGradients(),
      ],
    );
  }

  // ─────────────────────────────────────────
  // COLOR SCHEMES
  // ─────────────────────────────────────────

  static const ColorScheme _lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    // Primary
    primary: AppColors.primary,
    onPrimary: AppColors.onPrimary,
    primaryContainer: AppColors.primaryContainer,
    onPrimaryContainer: AppColors.onPrimaryContainer,
    // Secondary
    secondary: AppColors.secondary,
    onSecondary: AppColors.onSecondary,
    secondaryContainer: AppColors.secondaryContainer,
    onSecondaryContainer: AppColors.onSecondaryContainer,
    // Tertiary
    tertiary: AppColors.tertiary,
    onTertiary: AppColors.onTertiary,
    tertiaryContainer: AppColors.tertiaryContainer,
    onTertiaryContainer: AppColors.onTertiaryContainer,
    // Error
    error: AppColors.error,
    onError: AppColors.onError,
    errorContainer: AppColors.errorContainer,
    onErrorContainer: AppColors.onErrorContainer,
    // Surface
    surface: AppColors.surfaceLight,
    onSurface: AppColors.textPrimaryLight,
    surfaceContainerHighest: AppColors.surfaceVariantLight,
    onSurfaceVariant: AppColors.textSecondaryLight,
    // Outline
    outline: AppColors.borderLight,
    outlineVariant: AppColors.dividerLight,
    // Misc
    shadow: AppColors.shadowLight,
    scrim: AppColors.scrimLight,
    inverseSurface: AppColors.neutral800,
    onInverseSurface: AppColors.neutral50,
    inversePrimary: AppColors.primaryLight,
    surfaceTint: AppColors.primary,
  );

  static const ColorScheme _darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    // Primary
    primary: AppColors.primaryLight,
    onPrimary: AppColors.onPrimary,
    primaryContainer: Color(0xFF1E1B4B),
    onPrimaryContainer: AppColors.primaryLight,
    // Secondary
    secondary: AppColors.secondaryLight,
    onSecondary: AppColors.onSecondary,
    secondaryContainer: Color(0xFF2E1065),
    onSecondaryContainer: AppColors.secondaryLight,
    // Tertiary
    tertiary: AppColors.tertiaryLight,
    onTertiary: AppColors.onTertiary,
    tertiaryContainer: Color(0xFF083344),
    onTertiaryContainer: AppColors.tertiaryLight,
    // Error
    error: Color(0xFFFCA5A5),
    onError: Color(0xFF7F1D1D),
    errorContainer: Color(0xFF991B1B),
    onErrorContainer: Color(0xFFFECACA),
    // Surface
    surface: AppColors.surfaceDark,
    onSurface: AppColors.textPrimaryDark,
    surfaceContainerHighest: AppColors.surfaceVariantDark,
    onSurfaceVariant: AppColors.textSecondaryDark,
    // Outline
    outline: AppColors.borderDark,
    outlineVariant: AppColors.dividerDark,
    // Misc
    shadow: Colors.black,
    scrim: AppColors.scrimDark,
    inverseSurface: AppColors.neutral100,
    onInverseSurface: AppColors.neutral900,
    inversePrimary: AppColors.primaryDark,
    surfaceTint: AppColors.primaryLight,
  );

  // Convenience color lookup shorthand
  static const Color neutral100 = Color(0xFFF1F5F9);
  static const Color neutral200 = Color(0xFFE2E8F0);
  static const Color neutral50  = Color(0xFFF8FAFC);
  static const Color neutral700 = Color(0xFF334155);
  static const Color neutral900 = Color(0xFF0F172A);
}

// ─────────────────────────────────────────
// THEME EXTENSIONS
// ─────────────────────────────────────────

/// AppStatusColors — ThemeExtension to access status colors via Theme.of(context).
@immutable
class AppStatusColors extends ThemeExtension<AppStatusColors> {
  const AppStatusColors({
    this.success      = AppColors.success,
    this.successBg    = AppColors.successBackground,
    this.onSuccess    = AppColors.onSuccessContainer,
    this.warning      = AppColors.warning,
    this.warningBg    = AppColors.warningBackground,
    this.onWarning    = AppColors.onWarningContainer,
    this.info         = AppColors.info,
    this.infoBg       = AppColors.infoBackground,
    this.onInfo       = AppColors.onInfoContainer,
  });

  final Color success;
  final Color successBg;
  final Color onSuccess;
  final Color warning;
  final Color warningBg;
  final Color onWarning;
  final Color info;
  final Color infoBg;
  final Color onInfo;

  @override
  AppStatusColors copyWith({
    Color? success, Color? successBg, Color? onSuccess,
    Color? warning, Color? warningBg, Color? onWarning,
    Color? info,    Color? infoBg,    Color? onInfo,
  }) => AppStatusColors(
    success:   success   ?? this.success,
    successBg: successBg ?? this.successBg,
    onSuccess: onSuccess ?? this.onSuccess,
    warning:   warning   ?? this.warning,
    warningBg: warningBg ?? this.warningBg,
    onWarning: onWarning ?? this.onWarning,
    info:      info      ?? this.info,
    infoBg:    infoBg    ?? this.infoBg,
    onInfo:    onInfo    ?? this.onInfo,
  );

  @override
  AppStatusColors lerp(AppStatusColors? other, double t) {
    if (other is! AppStatusColors) return this;
    return AppStatusColors(
      success:   Color.lerp(success,   other.success,   t)!,
      successBg: Color.lerp(successBg, other.successBg, t)!,
      onSuccess: Color.lerp(onSuccess, other.onSuccess, t)!,
      warning:   Color.lerp(warning,   other.warning,   t)!,
      warningBg: Color.lerp(warningBg, other.warningBg, t)!,
      onWarning: Color.lerp(onWarning, other.onWarning, t)!,
      info:      Color.lerp(info,      other.info,      t)!,
      infoBg:    Color.lerp(infoBg,    other.infoBg,    t)!,
      onInfo:    Color.lerp(onInfo,    other.onInfo,    t)!,
    );
  }
}

/// AppGradients — ThemeExtension to access gradients via Theme.of(context).
@immutable
class AppGradients extends ThemeExtension<AppGradients> {
  const AppGradients({
    this.primary        = AppColors.gradientPrimary,
    this.primarySubtle  = AppColors.gradientPrimarySubtle,
    this.cool           = AppColors.gradientCool,
    this.success        = AppColors.gradientSuccess,
    this.dark           = AppColors.gradientDark,
  });

  final LinearGradient primary;
  final LinearGradient primarySubtle;
  final LinearGradient cool;
  final LinearGradient success;
  final LinearGradient dark;

  @override
  AppGradients copyWith({
    LinearGradient? primary, LinearGradient? primarySubtle,
    LinearGradient? cool, LinearGradient? success, LinearGradient? dark,
  }) => AppGradients(
    primary:       primary       ?? this.primary,
    primarySubtle: primarySubtle ?? this.primarySubtle,
    cool:          cool          ?? this.cool,
    success:       success       ?? this.success,
    dark:          dark          ?? this.dark,
  );

  @override
  AppGradients lerp(AppGradients? other, double t) => t < 0.5 ? this : (other ?? this);
}

// ─────────────────────────────────────────
// EXTENSION on BuildContext (DX helper)
// ─────────────────────────────────────────

extension ThemeContext on BuildContext {
  ThemeData        get theme        => Theme.of(this);
  ColorScheme      get colorScheme  => Theme.of(this).colorScheme;
  TextTheme        get textTheme    => Theme.of(this).textTheme;
  bool             get isDarkMode   => Theme.of(this).brightness == Brightness.dark;

  AppStatusColors? get statusColors =>
      Theme.of(this).extension<AppStatusColors>();
  AppGradients?    get appGradients =>
      Theme.of(this).extension<AppGradients>();
}