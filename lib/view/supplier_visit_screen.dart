import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:emp/core/theme/app_colors.dart';
import 'package:emp/core/theme/app_spacing.dart';
import 'package:emp/core/theme/app_text_styles.dart';
import 'package:emp/viewmodel/supplier_visit/supplier_visit_viewmodel.dart';

// ─────────────────────────────────────────────
// SUPPLIER VISIT SCREEN
// ─────────────────────────────────────────────
class SupplierVisitScreen extends StatelessWidget {
  const SupplierVisitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SupplierVisitViewModel(),
      child: const _SupplierVisitView(),
    );
  }
}

class _SupplierVisitView extends StatelessWidget {
  const _SupplierVisitView();

  @override
  Widget build(BuildContext context) {
    final vm     = context.watch<SupplierVisitViewModel>();
    final screen = MediaQuery.sizeOf(context);
    final hPad   = screen.width * 0.045;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: _buildAppBar(context),
      body: Form(
        key: vm.formKey,
        child: Column(
          children: [
            // ── Scrollable Content ─────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: hPad, vertical: AppSpacing.gapMD),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Business Information ───────────────────────────────
                    _SectionCard(
                      label: 'Supplier Information',
                      subtitle: 'Manufacturer / Distributor details',
                      icon: Icons.business_rounded,
                      iconColor: AppColors.primary,
                      iconTint: AppColors.primaryContainer,
                      child: Column(
                        children: [
                          _TfField(
                            controller: vm.supplierNameCtrl,
                            label: 'Supplier Name',
                            hint: 'e.g. Acme Manufacturing Ltd',
                            prefixIcon: Icons.factory_rounded,
                            validator: _required,
                          ),
                          SizedBox(height: AppSpacing.gapMD),
                          _TfField(
                            controller: vm.contactPersonCtrl,
                            label: 'Contact Person',
                            hint: 'e.g. John Doe',
                            prefixIcon: Icons.person_pin_rounded,
                            validator: _required,
                          ),
                          SizedBox(height: AppSpacing.gapMD),
                          _TfField(
                            controller: vm.phoneCtrl,
                            label: 'Phone Number',
                            hint: '10-digit primary contact',
                            prefixIcon: Icons.phone_rounded,
                            keyboardType: TextInputType.phone,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(10),
                            ],
                            validator: _required,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: AppSpacing.gapMD),

                    // ── Operations ─────────────────────────────────────────
                    _SectionCard(
                      label: 'Operations & Products',
                      subtitle: 'Category and location details',
                      icon: Icons.category_rounded,
                      iconColor: AppColors.secondary,
                      iconTint: AppColors.secondaryContainer,
                      child: Column(
                        children: [
                          _TfField(
                            controller: vm.productCategoryCtrl,
                            label: 'Product Category',
                            hint: 'e.g. Electronics, Raw Materials',
                            prefixIcon: Icons.inventory_2_rounded,
                            validator: _required,
                          ),
                          SizedBox(height: AppSpacing.gapMD),
                          _TfField(
                            controller: vm.locationCtrl,
                            label: 'Factory / Office Location',
                            hint: 'Full physical address',
                            prefixIcon: Icons.location_on_rounded,
                            maxLines: 2,
                            validator: _required,
                          ),
                          SizedBox(height: AppSpacing.gapMD),
                          _TfField(
                            controller: vm.interestDetailsCtrl,
                            label: 'Collaboration Interest',
                            hint: 'Specific details about the partnership',
                            prefixIcon: Icons.handshake_rounded,
                            maxLines: 3,
                            validator: _required,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: AppSpacing.gapMD),

                    // ── Visit Outcome ──────────────────────────────────────
                    _SectionCard(
                      label: 'Visit Outcome',
                      subtitle: 'Result of the interaction',
                      icon: Icons.assignment_turned_in_rounded,
                      iconColor: AppColors.warning,
                      iconTint: AppColors.warningContainer,
                      child: _OutcomeGrid(vm: vm),
                    ),

                    SizedBox(height: AppSpacing.gapXL),
                  ],
                ),
              ),
            ),

            // ── Sticky Sticky Footer ───────────────────────────────────────
            _StickyFooter(vm: vm, hPad: hPad),
          ],
        ),
      ),
    );
  }

  // ── Helpers ──────────────────────────────────────────────────────────────
  static String? _required(String? v) {
    if (v == null || v.trim().isEmpty) return 'Required';
    return null;
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(AppSpacing.appBarHeightLarge),
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.primary,
        ),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Supplier Visiting',
                style: AppTextStyles.headingS.copyWith(color: Colors.white),
              ),
              Text(
                'Onboard manufacturers & distributors',
                style: AppTextStyles.caption.copyWith(
                  color: Colors.white.withAlpha((0.8 * 255).round()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// REUSABLE: SECTION CARD
// ─────────────────────────────────────────────
class _SectionCard extends StatelessWidget {
  final String   label;
  final String   subtitle;
  final IconData icon;
  final Color    iconColor;
  final Color    iconTint;
  final Widget   child;

  const _SectionCard({
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.iconTint,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.06 * 255).round()),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: iconTint,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Icon(icon, color: iconColor, size: AppSpacing.iconMD),
              ),
              SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: AppTextStyles.labelL.copyWith(
                        color: theme.colorScheme.onSurface,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: AppTextStyles.caption.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.gapMD),
          Container(height: 1, color: theme.dividerColor),
          SizedBox(height: AppSpacing.gapMD),
          child,
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// OUTCOME GRID
// ─────────────────────────────────────────────
class _OutcomeGrid extends StatelessWidget {
  final SupplierVisitViewModel vm;
  const _OutcomeGrid({required this.vm});

  static const _options = [
    (SupplierVisitOutcome.interested,      'Interested',      Icons.check_box_rounded,        AppColors.success, AppColors.successContainer),
    (SupplierVisitOutcome.notInterested,   'Not Interested',   Icons.disabled_by_default_rounded,AppColors.error,   AppColors.errorContainer),
    (SupplierVisitOutcome.negotiation,     'Negotiation',     Icons.handshake_rounded,        AppColors.info,    AppColors.infoContainer),
    (SupplierVisitOutcome.followUpRequired,'Follow-up Needed',Icons.event_repeat_rounded,     AppColors.warning, AppColors.warningContainer),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: AppSpacing.gapSM,
      mainAxisSpacing: AppSpacing.gapSM,
      childAspectRatio: 2.5,
      children: _options.map((opt) {
        final isActive = vm.outcome == opt.$1;
        return GestureDetector(
          onTap: () => vm.setOutcome(opt.$1),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
            decoration: BoxDecoration(
              color: isActive ? opt.$5 : theme.colorScheme.surfaceContainerHighest.withAlpha((0.3 * 255).round()),
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(
                color: isActive ? opt.$4 : AppColors.borderLight,
                width: isActive ? 1.5 : 1,
              ),
            ),
            child: Row(
              children: [
                Icon(opt.$3, size: AppSpacing.iconSM, color: isActive ? opt.$4 : theme.colorScheme.onSurfaceVariant),
                SizedBox(width: AppSpacing.gapSM),
                Expanded(
                  child: Text(
                    opt.$2,
                    style: AppTextStyles.labelM.copyWith(
                      color: isActive ? opt.$4 : theme.colorScheme.onSurface,
                      fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ─────────────────────────────────────────────
// STICKY FOOTER
// ─────────────────────────────────────────────
class _StickyFooter extends StatelessWidget {
  final SupplierVisitViewModel vm;
  final double hPad;
  const _StickyFooter({required this.vm, required this.hPad});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: hPad,
        vertical: AppSpacing.gapMD,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.05 * 255).round()),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: AppSpacing.xl5,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: vm.isSubmitting ? AppColors.primaryContainer : AppColors.primary,
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: ElevatedButton(
            onPressed: vm.isSubmitting
                ? null
                : () async {
                    if (vm.outcome == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please select a visit outcome')),
                      );
                      return;
                    }
                    final success = await vm.submit();
                    if (success && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Supplier visit recorded!')),
                      );
                      Navigator.pop(context);
                    }
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
            ),
            child: vm.isSubmitting
                ? const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
                      ),
                      SizedBox(width: 12),
                      Text('Saving Visit…'),
                    ],
                  )
                : Text('Save Supplier Visit', style: AppTextStyles.buttonL),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// REUSABLE: TEXT FIELD  (Internal)
// ─────────────────────────────────────────────
class _TfField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData prefixIcon;
  final int maxLines;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;

  const _TfField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.prefixIcon,
    this.maxLines = 1,
    this.keyboardType,
    this.inputFormatters,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
      style: AppTextStyles.bodyM.copyWith(color: cs.onSurface),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(prefixIcon, size: AppSpacing.iconMD, color: cs.onSurfaceVariant),
        filled: true,
        fillColor: cs.surfaceContainerHighest.withAlpha((0.3 * 255).round()),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: AppColors.borderLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: AppColors.borderLight),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
      ),
    );
  }
}
