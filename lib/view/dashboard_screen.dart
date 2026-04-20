
import 'package:flutter/material.dart';
import 'package:emp/core/theme/app_colors.dart';
import 'package:emp/core/theme/app_spacing.dart';
import 'package:emp/core/theme/app_text_styles.dart';

// ─────────────────────────────────────────────
// DASHBOARD SCREEN
// ─────────────────────────────────────────────
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  bool _isPunchedIn = false;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _togglePunch() {
    setState(() => _isPunchedIn = !_isPunchedIn);
    final msg = _isPunchedIn ? 'Punched In ✅' : 'Punched Out 🔴';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        backgroundColor: _isPunchedIn ? AppColors.success : AppColors.error,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),
    );
  }

  // Card data: [label, value, icon]
  static const _cards = [
    ("Today's Visits", "12", Icons.route_rounded),
    ("Completed Visits", "8", Icons.check_circle_rounded),
    ("Pending Visits", "4", Icons.hourglass_top_rounded),
    ("Orders Collected", "6", Icons.shopping_bag_rounded),
    ("App Installations", "3", Icons.install_mobile_rounded),
    ("New Leads", "5", Icons.person_add_rounded),
    ("Notifications", "2", Icons.notifications_rounded),
  ];

  // Drawer items: [label, icon]
  static const _drawerItems = [
    ("Dashboard", Icons.grid_view_rounded),
    ("Store Visits", Icons.storefront_rounded),
    ("Supplier Visits", Icons.local_shipping_rounded),
    ("Business Collaboration", Icons.handshake_rounded),
    ("App Installations", Icons.install_mobile_rounded),
    ("Orders", Icons.receipt_long_rounded),
    ("Follow-ups", Icons.follow_the_signs_rounded),
    ("Visit History", Icons.history_rounded),
    ("Notifications", Icons.notifications_rounded),
    ("Profile", Icons.manage_accounts_rounded),
    ("Logout", Icons.logout_rounded),
  ];

  // Card tint colors (status brand colors)
  static const _cardTints = [
    AppColors.primaryContainer, // blue
    AppColors.successContainer, // green
    AppColors.warningContainer, // orange
    AppColors.errorContainer, // rose
    AppColors.secondaryContainer, // violet
    AppColors.successContainer, // emerald
    AppColors.warningContainer, // yellow
  ];

  // Card icon colors
  static const _cardIcons = [
    AppColors.primary, // blue
    AppColors.success, // green
    AppColors.warning, // orange
    AppColors.error, // rose
    AppColors.secondary, // violet
    AppColors.success, // emerald
    AppColors.warning, // yellow
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      drawer: _buildDrawer(context),
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.screenH,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: AppSpacing.gapMD),

              // ── Welcome Header ──────────────────────────────
              _buildWelcomeHeader(context),

              SizedBox(height: AppSpacing.gapLG),

              // ── Profile Card ────────────────────────────────
              _buildProfileCard(context),

              SizedBox(height: AppSpacing.gapLG),

              // ── Task Progress Card ──────────────────────────
              _buildTaskProgressCard(context),

              SizedBox(height: AppSpacing.gapXL),

              // ── Section Label ────────────────────────────────
              _buildSectionHeader(context),

              SizedBox(height: AppSpacing.gapMD),

              // ── KPI Grid ────────────────────────────────────
              _buildDashboardGrid(context),

              // Bottom padding for a cleaner look when scrolled
              SizedBox(height: AppSpacing.gapXL),
            ],
          ),
        ),
      ),
    );
  }

  // ── App Bar ──────────────────────────────────────────────────────────────
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final theme = Theme.of(context);
    return AppBar(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.onPrimary,
      elevation: 0,
      scrolledUnderElevation: 1,
      shadowColor: theme.shadowColor,
      centerTitle: false,
      title: Row(
        children: [
          // Logo mark with gradient
          Container(
            padding: EdgeInsets.all(AppSpacing.xs),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.primaryDark],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Icon(
              Icons.bolt_rounded,
              color: AppColors.onPrimary,
              size: AppSpacing.iconLG,
            ),
          ),
          SizedBox(width: AppSpacing.gapMD),
          Text(
            "TrackForce",
            style: AppTextStyles.headingM.copyWith(
              color: AppColors.onPrimary,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
      iconTheme: const IconThemeData(color: AppColors.onPrimary),
      actions: [
        // ── Punch In / Punch Out Button ──────────────────────────
        GestureDetector(
          onTap: _togglePunch,
          child: AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _isPunchedIn ? _pulseAnimation.value : 1.0,
                child: child,
              );
            },
            child: Container(
              margin: EdgeInsets.symmetric(vertical: AppSpacing.xs),
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xxs,
              ),
              decoration: BoxDecoration(
                color: _isPunchedIn
                    ? AppColors.success.withAlpha((0.25 * 255).round())
                    : Colors.white.withAlpha((0.18 * 255).round()),
                borderRadius: BorderRadius.circular(AppRadius.full),
                border: Border.all(
                  color: _isPunchedIn
                      ? AppColors.success
                      : Colors.white.withAlpha((0.55 * 255).round()),
                  width: 1.4,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Animated status dot
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      color: _isPunchedIn ? AppColors.success : AppColors.error,
                      shape: BoxShape.circle,
                      boxShadow: _isPunchedIn
                          ? [
                              BoxShadow(
                                color: AppColors.success
                                    .withAlpha((0.6 * 255).round()),
                                blurRadius: 6,
                              ),
                            ]
                          : [],
                    ),
                  ),
                  SizedBox(width: AppSpacing.xs),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Text(
                      _isPunchedIn ? 'IN' : 'OUT',
                      key: ValueKey(_isPunchedIn),
                      style: AppTextStyles.labelM.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 11,
                        letterSpacing: 0.6,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(width: AppSpacing.gapSM),
        // ── Notification Bell ────────────────────────────────────
        Stack(
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.notifications_none_rounded,
                color: AppColors.onPrimary,
              ),
            ),
            Positioned(
              top: AppSpacing.xs,
              right: AppSpacing.xs,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.error,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
        SizedBox(width: AppSpacing.xs),
      ],
    );
  }

  // ── Welcome Header ───────────────────────────────────────────────────────
  Widget _buildWelcomeHeader(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Good Morning 🌤️",
          style: AppTextStyles.labelL.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: AppSpacing.xs),
        Text(
          "Welcome back, Anil 👋",
          style: AppTextStyles.headingXL.copyWith(
            color: theme.colorScheme.onSurface,
            fontSize: MediaQuery.sizeOf(context).width < AppBreakpoints.tablet ? 24 : 32,
          ),
        ),
      ],
    );
  }

  // ── Profile Card ────────────────────────────────────────────────────────
  Widget _buildProfileCard(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withAlpha((0.30 * 255).round()),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          // Profile Image
          Container(
            width: AppSpacing.avatarLG,
            height: AppSpacing.avatarLG,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withAlpha((0.6 * 255).round()),
                width: 2,
              ),
              image: const DecorationImage(
                image: AssetImage('assets/images/anil.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: AppSpacing.gapMD),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Anil Kumar",
                  style: AppTextStyles.headingS.copyWith(
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: AppSpacing.xxs),
                Text(
                  "Sales Executive",
                  style: AppTextStyles.labelL.copyWith(
                    color: Colors.white.withAlpha((0.85 * 255).round()),
                  ),
                ),
                SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    Icon(
                      Icons.badge_rounded,
                      color: Colors.white.withAlpha((0.7 * 255).round()),
                      size: AppSpacing.iconSM,
                    ),
                    SizedBox(width: AppSpacing.gapXS),
                    Text(
                      "TF12345",
                      style: AppTextStyles.caption.copyWith(
                        color: Colors.white.withAlpha((0.7 * 255).round()),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Online status indicator
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xxs,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha((0.2 * 255).round()),
              borderRadius: BorderRadius.circular(AppRadius.full),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: AppColors.success,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: AppSpacing.xs),
                Text(
                  "Active",
                  style: AppTextStyles.labelM.copyWith(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Task Progress Card ──────────────────────────────────────────────────
  Widget _buildTaskProgressCard(BuildContext context) {
    final theme = Theme.of(context);
    const completed = 8;
    const total = 12;
    const pending = total - completed;
    const progress = completed / total;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.05 * 255).round()),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Stack(
          children: [
            // ── Background Illustration (Ghosted SVG) ────────────────
            Positioned(
              right: -10,
              bottom: -10,
              child: Opacity(
                opacity: 0.12,
                child: Icon(
                  Icons.auto_graph_rounded, // Replace with SvgPicture.asset('...')
                  size: 100,
                  color: AppColors.primary,
                ),
              ),
            ),

            // ── Card Content ──────────────────────────────────────────
            Padding(
              padding: EdgeInsets.all(AppSpacing.lg),
              child: Row(
                children: [
                  // ── Circular Progress Chart ────────────────
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 72,
                        height: 72,
                        child: CircularProgressIndicator(
                          value: 1.0,
                          strokeWidth: 8,
                          color: AppColors.successContainer.withAlpha((0.4 * 255).round()),
                        ),
                      ),
                      SizedBox(
                        width: 72,
                        height: 72,
                        child: CircularProgressIndicator(
                          value: progress,
                          strokeWidth: 8,
                          strokeCap: StrokeCap.round,
                          color: AppColors.success,
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "${(progress * 100).toInt()}%",
                            style: AppTextStyles.labelL.copyWith(
                              fontWeight: FontWeight.w800,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          Text(
                            "Done",
                            style: AppTextStyles.caption.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(width: AppSpacing.gapLG),

                  // ── Legend and Stats ──────────────────────
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Daily Progress",
                          style: AppTextStyles.headingS.copyWith(
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        SizedBox(height: AppSpacing.gapSM),
                        Row(
                          children: [
                            _buildTaskInfoRow(
                              context,
                              "Completed",
                              completed.toString(),
                              AppColors.success,
                            ),
                            SizedBox(width: AppSpacing.gapMD),
                            _buildTaskInfoRow(
                              context,
                              "Pending",
                              pending.toString(),
                              AppColors.warning,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Arrow indicator
                  Icon(
                    Icons.chevron_right_rounded,
                    color: theme.colorScheme.onSurfaceVariant.withAlpha((0.5 * 255).round()),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskInfoRow(BuildContext context, String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: AppSpacing.xs),
            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.xxs),
        Text(
          value,
          style: AppTextStyles.headingS.copyWith(
            color: color,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  // ── Section Header ──────────────────────────────────────────────────────

  Widget _buildSectionHeader(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        // Left accent bar
        Container(
          width: AppSpacing.xs,
          height: AppSpacing.xl2,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(AppRadius.xs),
          ),
        ),
        SizedBox(width: AppSpacing.gapMD),
        // Title
        Text(
          "Today's Summary",
          style: AppTextStyles.headingM.copyWith(
            color: theme.colorScheme.onSurface,
            fontSize: MediaQuery.sizeOf(context).width < AppBreakpoints.tablet ? 18 : 20,
          ),
        ),
        const Spacer(),
        // Date
        Text(
          "Apr 15",
          style: AppTextStyles.labelL.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  // ── Dashboard Grid ──────────────────────────────────────────────────────
  Widget _buildDashboardGrid(BuildContext context) {
    // FIX: Use LayoutBuilder so the grid knows exactly how wide it can be,
    // then derive childAspectRatio dynamically instead of a fixed 1.4.
    // This prevents vertical overflow on small devices (320 px wide).
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenW    = MediaQuery.sizeOf(context).width;
        final crossCount = screenW < AppBreakpoints.tablet ? 2 : 3;
        final spacing    = AppSpacing.gapMD;
        // Width each tile will actually occupy
        final tileW = (constraints.maxWidth - spacing * (crossCount - 1)) / crossCount;
        // Height: icon chip (20+8+8) + gap(4) + kpi value (~28) + gap(2) + label(~28) + top/bottom padding
        // Force a more compact 110px height on mobile to prevent numbers from looking "oversized".
        final tileH  = screenW < AppBreakpoints.tablet ? 110.0 : 130.0;
        final ratio  = tileW / tileH;

        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: crossCount,
          crossAxisSpacing: spacing,
          mainAxisSpacing: spacing,
          childAspectRatio: ratio,
          children: List.generate(
            _cards.length,
            (i) => _buildDashboardCard(
              context,
              _cards[i].$1,
              _cards[i].$2,
              _cards[i].$3,
              _cardTints[i % _cardTints.length],
              _cardIcons[i % _cardIcons.length],
            ),
          ),
        );
      },
    );
  }

  // ── Dashboard KPI Card ──────────────────────────────────────────────────
  Widget _buildDashboardCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color tint,
    Color iconColor,
  ) {
    final theme = Theme.of(context);

    // FIX: Wrap in LayoutBuilder so we can adapt padding, icon size, and
    // font size to whatever height the grid actually gives this tile.
    // This is the root cause of the "overflowed by 34/55 px" errors.
    return LayoutBuilder(
      builder: (context, constraints) {
        final h = constraints.maxHeight;
        // Adaptive padding: shrink on small tiles
        final pad  = h < 110 ? AppSpacing.sm : AppSpacing.md;
        // Adaptive icon size
        final iconSize = h < 110 ? AppSpacing.iconSM : AppSpacing.iconMD;
        // Adaptive KPI font size: 30.0 was too big for mobile grid tiles.
        final kpiFontSize = h < 110 ? 18.0 : (h < 130 ? 22.0 : 26.0);
        // Adaptive label font size
        final labelFontSize = h < 110 ? 10.0 : 11.0;

        return Container(
          padding: EdgeInsets.all(pad),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha((0.055 * 255).round()),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Icon chip with tint background
              Container(
                padding: EdgeInsets.all(h < 110 ? AppSpacing.xs : AppSpacing.sm),
                decoration: BoxDecoration(
                  color: tint,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: iconSize,
                ),
              ),
              // Value + label
              // FIX: Flexible prevents the inner Column from demanding more
              // space than the parent Column has available.
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      value,
                      style: AppTextStyles.kpiLarge.copyWith(
                        color: theme.colorScheme.onSurface,
                        fontSize: kpiFontSize,
                        height: 1.1,
                      ),
                    ),
                    SizedBox(height: AppSpacing.xxs),
                    Text(
                      title,
                      style: AppTextStyles.labelL.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontSize: labelFontSize,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ── Drawer ──────────────────────────────────────────────────────────────
  Widget _buildDrawer(BuildContext context) {
    final theme = Theme.of(context);
    final media = MediaQuery.of(context);
    final statusBarHeight = media.padding.top;

    return Drawer(
      backgroundColor: theme.colorScheme.surface,
      elevation: 0,
      width: media.size.width * 0.75,
      child: Column(
        children: [
          // ── Drawer Header ────────────────────────────────────
          _buildDrawerHeader(context, statusBarHeight),

          // ── Menu Items ───────────────────────────────────────
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
              children: List.generate(_drawerItems.length, (i) {
                final isActive = i == 0; // Dashboard is active
                final isDanger = i == _drawerItems.length - 1; // Logout

                return _buildDrawerMenuItem(
                  context,
                  _drawerItems[i].$1,
                  _drawerItems[i].$2,
                  isActive: isActive,
                  isDanger: isDanger,
                  onTap: isDanger
                      ? () {
                          Navigator.pop(context);
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/login',
                            (route) => false,
                          );
                        }
                      : i == 1 // Store Visits
                          ? () {
                              Navigator.pop(context); // Close drawer
                              Navigator.pushNamed(context, '/store-visit');
                            }
                          : i == 2 // Supplier Visits
                              ? () {
                                  Navigator.pop(context); // Close drawer
                                  Navigator.pushNamed(context, '/supplier-visit');
                                }
                              : i == 3 // Business Collaboration
                                  ? () {
                                      Navigator.pop(context); // Close drawer
                                      Navigator.pushNamed(context, '/collaboration');
                                    }
                                  : i == 4 // App Installations
                                      ? () {
                                          Navigator.pop(context); // Close drawer
                                          Navigator.pushNamed(context, '/installation');
                                        }
                                      : i == 5 // Orders
                                          ? () {
                                              Navigator.pop(context); // Close drawer
                                              Navigator.pushNamed(context, '/order');
                                            }
                                          : i == 7 // Visit History
                                              ? () {
                                                  Navigator.pop(context); // Close drawer
                                                  Navigator.pushNamed(context, '/history');
                                                }
                                              : i == 8 // Notifications
                                                  ? () {
                                                      Navigator.pop(context); // Close drawer
                                                      Navigator.pushNamed(context, '/notifications');
                                                    }
                                                  : () {},
                );
              }),
            ),
          ),

          // ── Footer ───────────────────────────────────────────
          Padding(
            padding: EdgeInsets.only(bottom: AppSpacing.gapMD),
            child: Text(
              "TrackForce v2.4.1",
              style: AppTextStyles.caption.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Drawer Header ───────────────────────────────────────────────────────
  Widget _buildDrawerHeader(BuildContext context, double statusBarHeight) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        AppSpacing.lg,
        statusBarHeight + AppSpacing.xl2,
        AppSpacing.lg,
        AppSpacing.xl2,
      ),
      decoration: const BoxDecoration(
        color: AppColors.primary,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo row
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha((0.2 * 255).round()),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Icon(
                  Icons.bolt_rounded,
                  color: Colors.white,
                  size: AppSpacing.iconMD,
                ),
              ),
              SizedBox(width: AppSpacing.gapMD),
              Text(
                "TrackForce",
                style: AppTextStyles.headingM.copyWith(
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.gapLG),
          // User info row
          Row(
            children: [
              // User profile image
              Container(
                width: AppSpacing.avatarXL,
                height: AppSpacing.avatarXL,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withAlpha((0.6 * 255).round()),
                    width: 2.5,
                  ),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/anil.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: AppSpacing.gapLG),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // User name
                    Text(
                      "Anil Kumar",
                      style: AppTextStyles.headingS.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: AppSpacing.xxs),
                    // User subtitle
                    Text(
                      "Sales Executive · TF12345",
                      style: AppTextStyles.labelL.copyWith(
                        color: Colors.white.withAlpha((0.75 * 255).round()),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Drawer Menu Item ────────────────────────────────────────────────────
  Widget _buildDrawerMenuItem(
    BuildContext context,
    String label,
    IconData icon, {
    required bool isActive,
    required bool isDanger,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.gapMD,
        vertical: AppSpacing.xxs,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.md),
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            decoration: BoxDecoration(
              color: isActive
                  ? AppColors.primaryContainer
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: AppSpacing.iconLG,
                  color: isDanger
                      ? AppColors.error
                      : isActive
                          ? AppColors.primary
                          : theme.colorScheme.onSurfaceVariant,
                ),
                SizedBox(width: AppSpacing.gapMD),
                // FIX: Wrap label in Expanded so long labels like
                // "Business Collaboration" cannot overflow the Row.
                Expanded(
                  child: Text(
                    label,
                    style: AppTextStyles.bodyM.copyWith(
                      fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                      color: isDanger
                          ? AppColors.error
                          : isActive
                              ? AppColors.primary
                              : theme.colorScheme.onSurface,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                if (isActive) ...[
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// RESPONSIVE BREAKPOINTS (from AppBreakpoints)
// ─────────────────────────────────────────────
class AppBreakpoints {
  static const double mobile = 480;
  static const double tablet = 768;
  static const double desktop = 1024;
  static const double wide = 1280;
}

// ─────────────────────────────────────────────
// BORDER RADIUS CONSTANTS (from AppRadius)
// ─────────────────────────────────────────────
class AppRadius {
  static const double xs = 4;
  static const double sm = 6;
  static const double md = 8;
  static const double lg = 12;
  static const double xl = 16;
  static const double full = 9999;
}
