// ─────────────────────────────────────────────────────────────────────────────
// EXAMPLE: Responsive Theme Usage
//
// This file demonstrates how to consume the new responsive spacing &
// typography APIs in a real widget. Copy the patterns you need into your
// screens.
//
// KEY APIS:
//   AppSpacing.w(context, value)   → width-scaled spacing
//   AppSpacing.h(context, value)   → height-scaled spacing
//   AppSpacing.sp(context, value)  → font-size scaling
//   AppSpacing.vGap(context, n)    → responsive SizedBox (vertical)
//   AppSpacing.hGap(context, n)    → responsive SizedBox (horizontal)
//   AppSpacing.screenPaddingOf(context) → responsive EdgeInsets
//   AppSpacing.cardPaddingOf(context)   → responsive card EdgeInsets
//
//   ResponsiveTextStyles.headingLarge(context)
//   ResponsiveTextStyles.headingMedium(context)
//   ResponsiveTextStyles.bodyLarge(context)
//   ResponsiveTextStyles.bodyMedium(context)
//   ResponsiveTextStyles.caption(context)
//   ... (all styles accept optional color:)
//
//   AppTheme.withResponsiveText(context) → wraps current theme with live
//                                          responsive TextTheme for subtrees
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_spacing.dart';
import 'app_text_styles.dart';
import 'app_theme.dart';

/// Example card widget that uses 100% responsive spacing & typography.
///
/// Drop inside any Scaffold to see live scaling at runtime.
class ResponsiveUsageExample extends StatelessWidget {
  const ResponsiveUsageExample({super.key});

  @override
  Widget build(BuildContext context) {
    // ── Wrap with live-scaled TextTheme so Theme.of(context).textTheme
    // also uses responsive sizes in this subtree.
    return Theme(
      data: AppTheme.withResponsiveText(context),
      child: Scaffold(
        backgroundColor: AppColors.scaffoldLight,
        appBar: AppBar(
          title: Text(
            'Responsive Theme Demo',
            style: ResponsiveTextStyles.titleMedium(context),
          ),
        ),
        body: SingleChildScrollView(
          padding: AppSpacing.screenPaddingOf(context),  // ← responsive
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ── Section: Typography showcase ─────────────────────────────
              Text(
                'Typography Scale',
                style: ResponsiveTextStyles.overline(
                  context,
                  color: AppColors.textMutedLight,
                ),
              ),

              AppSpacing.vGap(context, AppSpacing.sm),

              Text(
                'Heading Large · 32sp',
                style: ResponsiveTextStyles.headingLarge(
                  context,
                  color: AppColors.textPrimaryLight,
                ),
              ),

              AppSpacing.vGap(context, AppSpacing.xs),

              Text(
                'Heading Medium · 24sp',
                style: ResponsiveTextStyles.headingMedium(
                  context,
                  color: AppColors.textPrimaryLight,
                ),
              ),

              AppSpacing.vGap(context, AppSpacing.xs),

              Text(
                'Heading Small · 20sp',
                style: ResponsiveTextStyles.headingSmall(
                  context,
                  color: AppColors.textPrimaryLight,
                ),
              ),

              AppSpacing.vGap(context, AppSpacing.xs),

              Text(
                'Body Large · 16sp — The quick brown fox jumps over the lazy dog.',
                style: ResponsiveTextStyles.bodyLarge(
                  context,
                  color: AppColors.textSecondaryLight,
                ),
              ),

              AppSpacing.vGap(context, AppSpacing.xs),

              Text(
                'Body Medium · 14sp — The quick brown fox jumps over the lazy dog.',
                style: ResponsiveTextStyles.bodyMedium(
                  context,
                  color: AppColors.textSecondaryLight,
                ),
              ),

              AppSpacing.vGap(context, AppSpacing.xs),

              Text(
                'Caption · 11sp — Posted 2 hours ago',
                style: ResponsiveTextStyles.caption(
                  context,
                  color: AppColors.textMutedLight,
                ),
              ),

              AppSpacing.vGap(context, AppSpacing.xl2),

              // ── Section: Spacing showcase ─────────────────────────────────
              Text(
                'Spacing & Layout',
                style: ResponsiveTextStyles.overline(
                  context,
                  color: AppColors.textMutedLight,
                ),
              ),

              AppSpacing.vGap(context, AppSpacing.sm),

              // Responsive card
              _DemoCard(context: context),

              AppSpacing.vGap(context, AppSpacing.lg),

              // Responsive row with hGap
              Row(
                children: [
                  _ColorBox(color: AppColors.primary),
                  AppSpacing.hGap(context, AppSpacing.sm),  // ← responsive
                  _ColorBox(color: AppColors.secondary),
                  AppSpacing.hGap(context, AppSpacing.sm),
                  _ColorBox(color: AppColors.tertiary),
                ],
              ),

              AppSpacing.vGap(context, AppSpacing.xl2),

              // ── Section: Direct sp() usage ───────────────────────────────
              Text(
                'Direct AppSpacing.sp()',
                style: ResponsiveTextStyles.overline(
                  context,
                  color: AppColors.textMutedLight,
                ),
              ),

              AppSpacing.vGap(context, AppSpacing.sm),

              Text(
                'KPI: 1,284',
                style: TextStyle(
                  fontSize: AppSpacing.sp(context, 36), // ← sp() directly
                  fontWeight: FontWeight.w700,
                  letterSpacing: -1,
                  height: 1.1,
                  color: AppColors.primary,
                ),
              ),

              Text(
                'Active employees this month',
                style: TextStyle(
                  fontSize: AppSpacing.sp(context, 13),
                  color: AppColors.textMutedLight,
                ),
              ),

              AppSpacing.vGap(context, AppSpacing.xl3),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Helper widgets ───────────────────────────────────────────────────────────

class _DemoCard extends StatelessWidget {
  final BuildContext context;
  const _DemoCard({required this.context});

  @override
  Widget build(BuildContext ctx) {
    return Container(
      width: double.infinity,
      padding: AppSpacing.cardPaddingOf(ctx),    // ← responsive card padding
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: AppRadius.brCard,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: AppSpacing.w(ctx, 16),   // ← width-scaled blur
            offset: Offset(0, AppSpacing.h(ctx, 4)),  // ← height-scaled offset
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Responsive Card',
            style: ResponsiveTextStyles.titleMedium(ctx),
          ),
          SizedBox(height: AppSpacing.h(ctx, AppSpacing.xs)),
          Text(
            'All padding, font sizes, and gaps in this card scale '
            'proportionally with the screen size.',
            style: ResponsiveTextStyles.bodyMedium(
              ctx,
              color: AppColors.textSecondaryLight,
            ),
          ),
          SizedBox(height: AppSpacing.h(ctx, AppSpacing.md)),
          Row(
            children: [
              _Badge(label: 'Active', ctx: ctx),
              SizedBox(width: AppSpacing.w(ctx, AppSpacing.sm)),
              _Badge(label: 'Synced', ctx: ctx),
            ],
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final BuildContext ctx;
  const _Badge({required this.label, required this.ctx});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.w(ctx, AppSpacing.sm),
        vertical: AppSpacing.h(ctx, AppSpacing.xxs + 1),
      ),
      decoration: BoxDecoration(
        color: AppColors.primaryContainer,
        borderRadius: AppRadius.brSM,
      ),
      child: Text(
        label,
        style: ResponsiveTextStyles.labelSmall(ctx, color: AppColors.onPrimaryContainer),
      ),
    );
  }
}

class _ColorBox extends StatelessWidget {
  final Color color;
  const _ColorBox({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width:  AppSpacing.w(context, 40),  // ← width-scaled dimension
      height: AppSpacing.w(context, 40),
      decoration: BoxDecoration(
        color: color,
        borderRadius: AppRadius.brMD,
      ),
    );
  }
}
