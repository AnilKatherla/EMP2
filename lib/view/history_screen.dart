import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:emp/core/theme/app_colors.dart';
import 'package:emp/core/theme/app_spacing.dart';
import 'package:emp/core/theme/app_text_styles.dart';
import 'package:emp/viewmodel/history/history_viewmodel.dart';

// ─────────────────────────────────────────────
// VISIT HISTORY SCREEN (With Visit Proof)
// ─────────────────────────────────────────────
class VisitHistoryScreen extends StatelessWidget {
  const VisitHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => VisitHistoryViewModel(),
      child: const _VisitHistoryView(),
    );
  }
}

class _VisitHistoryView extends StatelessWidget {
  const _VisitHistoryView();

  @override
  Widget build(BuildContext context) {
    final vm     = context.watch<VisitHistoryViewModel>();
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
                    // ── Visit Identification ──────────────────────────────────────
                    _SectionCard(
                      label: 'Visit Identification',
                      icon: Icons.history_rounded,
                      iconColor: AppColors.primary,
                      iconTint: AppColors.primaryContainer,
                      child: Column(
                        children: [
                          _TfField(
                            controller: vm.storeNameCtrl,
                            label: 'Store Name',
                            hint: 'Search or enter store name',
                            prefixIcon: Icons.store_rounded,
                            validator: (v) => v!.isEmpty ? 'Required' : null,
                          ),
                          SizedBox(height: AppSpacing.gapMD),
                          _TfField(
                            controller: vm.visitDateCtrl,
                            label: 'Visit Date',
                            hint: 'DD/MM/YYYY',
                            prefixIcon: Icons.calendar_today_rounded,
                            validator: (v) => v!.isEmpty ? 'Required' : null,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: AppSpacing.gapMD),

                    // ── Visit Proof Section (Moved here) ────────────────────
                    _SectionCard(
                      label: 'Visit Proof',
                      icon: Icons.camera_alt_rounded,
                      iconColor: AppColors.secondary,
                      iconTint: AppColors.secondaryContainer,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Upload genuine proofs for this visit record',
                            style: AppTextStyles.bodyS.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          ),
                          SizedBox(height: AppSpacing.gapMD),
                          GridView.count(
                            crossAxisCount: 2,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisSpacing: AppSpacing.gapMD,
                            mainAxisSpacing: AppSpacing.gapMD,
                            childAspectRatio: 1.15,
                            children: [
                              _PhotoTile(
                                vm: vm,
                                photoKey: 'store',
                                label: 'Store Photo',
                                icon: Icons.storefront_rounded,
                                isRequired: true,
                              ),
                              _PhotoTile(
                                vm: vm,
                                photoKey: 'board',
                                label: 'Store Board',
                                icon: Icons.signpost_rounded,
                                isRequired: true,
                              ),
                              _PhotoTile(
                                vm: vm,
                                photoKey: 'owner',
                                label: 'Owner Photo',
                                icon: Icons.person_pin_circle_rounded,
                                isRequired: false,
                              ),
                              _PhotoTile(
                                vm: vm,
                                photoKey: 'selfie',
                                label: 'Visit Selfie',
                                icon: Icons.portrait_rounded,
                                isRequired: true,
                              ),
                            ],
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
          title: Text(
            'Visit Proof History',
            style: AppTextStyles.headingS.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// REUSABLE COMPONENTS
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

class _PhotoTile extends StatelessWidget {
  final VisitHistoryViewModel vm;
  final String photoKey;
  final String label;
  final IconData icon;
  final bool isRequired;

  const _PhotoTile({required this.vm, required this.photoKey, required this.label, required this.icon, required this.isRequired});

  @override
  Widget build(BuildContext context) {
    final cs         = Theme.of(context).colorScheme;
    final isSelected = vm.isPhotoSelected(photoKey);

    return GestureDetector(
      onTap: () => vm.togglePhoto(photoKey),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.successContainer : cs.surfaceContainerHighest.withAlpha((0.3 * 255).round()),
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: isSelected ? AppColors.success : AppColors.borderLight, width: isSelected ? 1.5 : 1),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Padding(
            padding: EdgeInsets.all(AppSpacing.xs),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(isSelected ? Icons.check_circle_rounded : icon, color: isSelected ? AppColors.success : AppColors.primary, size: AppSpacing.iconMD),
                SizedBox(height: AppSpacing.gapSM),
                Text(label, style: AppTextStyles.labelM.copyWith(fontWeight: FontWeight.w600)),
                Text(isRequired ? 'Required' : 'Optional', style: AppTextStyles.caption.copyWith(color: isRequired ? AppColors.error : cs.onSurfaceVariant)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StickyFooter extends StatelessWidget {
  final VisitHistoryViewModel vm;
  final double hPad;
  const _StickyFooter({required this.vm, required this.hPad});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: AppSpacing.gapMD),
      decoration: BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor, boxShadow: [BoxShadow(color: Colors.black.withAlpha((0.05 * 255).round()), blurRadius: 10, offset: const Offset(0, -4))]),
      child: SizedBox(
        width: double.infinity,
        height: AppSpacing.xl5,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: vm.isSubmitting
                ? null
                : const LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryDark],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
            color: vm.isSubmitting ? AppColors.primaryContainer : null,
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: ElevatedButton(
            onPressed: vm.isSubmitting
                ? null
                : () async {
                    if (await vm.submit() && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Proofs uploaded successfully!')),
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
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text('Uploading…'),
                    ],
                  )
                : const Text('Upload Visit Proofs', style: AppTextStyles.buttonL),
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
  final String? Function(String?)? validator;

  const _TfField({required this.controller, required this.label, required this.hint, required this.prefixIcon, this.validator});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return TextFormField(
      controller: controller,
      validator: validator,
      style: AppTextStyles.bodyM,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(prefixIcon, size: AppSpacing.iconMD, color: cs.onSurfaceVariant),
        filled: true,
        fillColor: cs.surfaceContainerHighest.withAlpha((0.3 * 255).round()),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.md), borderSide: BorderSide(color: AppColors.borderLight)),
      ),
    );
  }
}
