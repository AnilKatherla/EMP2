import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:emp/core/theme/app_colors.dart';
import 'package:emp/core/theme/app_spacing.dart';
import 'package:emp/core/theme/app_text_styles.dart';
import 'package:emp/viewmodel/installation/installation_viewmodel.dart';

// ─────────────────────────────────────────────
// APP INSTALLATION SCREEN
// ─────────────────────────────────────────────
class AppInstallationScreen extends StatelessWidget {
  const AppInstallationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppInstallationViewModel(),
      child: const _AppInstallationView(),
    );
  }
}

class _AppInstallationView extends StatelessWidget {
  const _AppInstallationView();

  @override
  Widget build(BuildContext context) {
    final vm     = context.watch<AppInstallationViewModel>();
    final screen = MediaQuery.sizeOf(context);
    final hPad   = screen.width * 0.045;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: _buildAppBar(context),
      body: Form(
        key: vm.formKey,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: hPad, vertical: AppSpacing.gapMD),
                child: Column(
                  children: [
                    // ── Retailer Details ───────────────────────────────────
                    _SectionCard(
                      label: 'Retailer Details',
                      icon: Icons.storefront_rounded,
                      iconColor: AppColors.primary,
                      iconTint: AppColors.primaryContainer,
                      child: Column(
                        children: [
                          _TfField(
                            controller: vm.storeNameCtrl,
                            label: 'Store Name',
                            hint: 'e.g. Balaji Provision Store',
                            prefixIcon: Icons.store_rounded,
                            validator: _required,
                          ),
                          SizedBox(height: AppSpacing.gapMD),
                          _TfField(
                            controller: vm.ownerNameCtrl,
                            label: 'Owner Name',
                            hint: 'e.g. Amit Patil',
                            prefixIcon: Icons.person_rounded,
                            validator: _required,
                          ),
                          SizedBox(height: AppSpacing.gapMD),
                          _TfField(
                            controller: vm.phoneCtrl,
                            label: 'Mobile Number',
                            hint: '10-digit number',
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

                    // ── Deployment Details ─────────────────────────────────
                    _SectionCard(
                      label: 'Installation & Training',
                      icon: Icons.install_mobile_rounded,
                      iconColor: AppColors.secondary,
                      iconTint: AppColors.secondaryContainer,
                      child: Column(
                        children: [
                          _AppSelector(vm: vm),
                          SizedBox(height: AppSpacing.gapMD),
                          _ToggleTile(
                            label: 'App Training Completed',
                            subtitle: 'Retailer is trained on app usage',
                            icon: Icons.school_rounded,
                            value: vm.isTrainingCompleted,
                            onChanged: vm.toggleTraining,
                          ),
                          _ToggleTile(
                            label: 'First Order Placed',
                            subtitle: 'First order successfully recorded',
                            icon: Icons.shopping_basket_rounded,
                            value: vm.isFirstOrderPlaced,
                            onChanged: vm.toggleFirstOrder,
                          ),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: AppSpacing.gapXL),
                  ],
                ),
              ),
            ),
            
            // ── Sticky Footer ──────────────────────────────────────────────
            _StickyFooter(vm: vm, hPad: hPad),
          ],
        ),
      ),
    );
  }

  static String? _required(String? v) {
    if (v == null || v.trim().isEmpty) return 'Required';
    return null;
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(AppSpacing.appBarHeightLarge),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primary, AppColors.primaryDark],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
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
                'App Installation',
                style: AppTextStyles.headingS.copyWith(color: Colors.white),
              ),
              Text(
                'Deploy and track retailer app usage',
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
// COMPONENTS
// ─────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color iconColor;
  final Color iconTint;
  final Widget child;

  const _SectionCard({required this.label, required this.icon, required this.iconColor, required this.iconTint, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha((0.05 * 255).round()), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(padding: EdgeInsets.all(AppSpacing.sm), decoration: BoxDecoration(color: iconTint, borderRadius: BorderRadius.circular(AppRadius.md)), child: Icon(icon, color: iconColor, size: AppSpacing.iconMD)),
              SizedBox(width: AppSpacing.md),
              Text(label, style: AppTextStyles.labelL.copyWith(fontWeight: FontWeight.w700)),
            ],
          ),
          SizedBox(height: AppSpacing.gapMD),
          child,
        ],
      ),
    );
  }
}

class _AppSelector extends StatelessWidget {
  final AppInstallationViewModel vm;
  const _AppSelector({required this.vm});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return DropdownButtonFormField<String>(
      value: vm.selectedApp,
      onChanged: vm.setApp,
      validator: (v) => v == null ? 'Please select an app' : null,
      style: AppTextStyles.bodyM.copyWith(color: cs.onSurface),
      decoration: InputDecoration(
        labelText: 'Select App Installed',
        prefixIcon: Icon(Icons.install_mobile_rounded, size: AppSpacing.iconMD, color: cs.onSurfaceVariant),
        filled: true,
        fillColor: cs.surfaceContainerHighest.withAlpha((0.3 * 255).round()),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.md), borderSide: BorderSide(color: AppColors.borderLight)),
      ),
      items: AppInstallationViewModel.apps.map((a) => DropdownMenuItem(value: a, child: Text(a))).toList(),
    );
  }
}

class _ToggleTile extends StatelessWidget {
  final String label;
  final String subtitle;
  final IconData icon;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleTile({required this.label, required this.subtitle, required this.icon, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      title: Text(label, style: AppTextStyles.labelL),
      subtitle: Text(subtitle, style: AppTextStyles.caption),
      secondary: Icon(icon, color: value ? AppColors.primary : cs.onSurfaceVariant),
      contentPadding: EdgeInsets.zero,
      activeColor: AppColors.primary,
    );
  }
}

class _StickyFooter extends StatelessWidget {
  final AppInstallationViewModel vm;
  final double hPad;
  const _StickyFooter({required this.vm, required this.hPad});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: AppSpacing.gapMD),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [BoxShadow(color: Colors.black.withAlpha((0.05 * 255).round()), blurRadius: 10, offset: const Offset(0, -4))],
      ),
      child: SizedBox(
        width: double.infinity,
        height: AppSpacing.xl5,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: vm.isSubmitting ? null : const LinearGradient(colors: [AppColors.primary, AppColors.primaryDark], begin: Alignment.topLeft, end: Alignment.bottomRight),
            color: vm.isSubmitting ? AppColors.primaryContainer : null,
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: ElevatedButton(
            onPressed: vm.isSubmitting ? null : () async {
              if (await vm.submit() && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Installation recorded!')));
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md))),
            child: vm.isSubmitting
                ? const Row(mainAxisAlignment: MainAxisAlignment.center, children: [SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary)), SizedBox(width: 12), Text('Saving…')])
                : const Text('Record Installation', style: AppTextStyles.buttonL),
          ),
        ),
      ),
    );
  }
}

class _TfField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData prefixIcon;
  final int maxLines;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;

  const _TfField({required this.controller, required this.label, required this.hint, required this.prefixIcon, this.maxLines = 1, this.keyboardType, this.inputFormatters, this.validator});

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
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.md), borderSide: BorderSide(color: AppColors.borderLight)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.md), borderSide: BorderSide(color: AppColors.borderLight)),
        contentPadding: EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
      ),
    );
  }
}
