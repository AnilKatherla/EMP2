import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:emp/core/theme/app_colors.dart';
import 'package:emp/core/theme/app_spacing.dart';
import 'package:emp/core/theme/app_text_styles.dart';
import 'package:emp/viewmodel/collaboration/collaboration_viewmodel.dart';

// ─────────────────────────────────────────────
// BUSINESS COLLABORATION SCREEN
// ─────────────────────────────────────────────
class BusinessCollaborationScreen extends StatelessWidget {
  const BusinessCollaborationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BusinessCollaborationViewModel(),
      child: const _CollaborationView(),
    );
  }
}

class _CollaborationView extends StatelessWidget {
  const _CollaborationView();

  @override
  Widget build(BuildContext context) {
    final vm     = context.watch<BusinessCollaborationViewModel>();
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
                    // ── Basic Details ──────────────────────────────────────
                    _SectionCard(
                      label: 'Collaboration Details',
                      icon: Icons.handshake_rounded,
                      iconColor: AppColors.info,
                      iconTint: AppColors.infoContainer,
                      child: Column(
                        children: [
                          _TfField(
                            controller: vm.orgNameCtrl,
                            label: 'Organization Name',
                            hint: 'e.g. Reliance Logistics',
                            prefixIcon: Icons.domain_rounded,
                            validator: _required,
                          ),
                          SizedBox(height: AppSpacing.gapMD),
                          _TfField(
                            controller: vm.contactPersonCtrl,
                            label: 'Contact Person',
                            hint: 'e.g. Robert Wilson',
                            prefixIcon: Icons.person_rounded,
                            validator: _required,
                          ),
                          SizedBox(height: AppSpacing.gapMD),
                          _TypeDropdown(vm: vm),
                        ],
                      ),
                    ),

                    SizedBox(height: AppSpacing.gapMD),

                    // ── Commercials ────────────────────────────────────────
                    _SectionCard(
                      label: 'Opportunity & Notes',
                      icon: Icons.monetization_on_rounded,
                      iconColor: AppColors.success,
                      iconTint: AppColors.successContainer,
                      child: Column(
                        children: [
                          _TfField(
                            controller: vm.oppValueCtrl,
                            label: 'Opportunity Value',
                            hint: 'Estimated value (₹)',
                            prefixIcon: Icons.payments_rounded,
                            keyboardType: TextInputType.number,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            validator: _required,
                          ),
                          SizedBox(height: AppSpacing.gapMD),
                          _TfField(
                            controller: vm.notesCtrl,
                            label: 'Internal Notes',
                            hint: 'Specify cooperation terms…',
                            prefixIcon: Icons.note_alt_rounded,
                            maxLines: 4,
                            validator: _required,
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
            colors: [AppColors.info, AppColors.infoDark],
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
                'Business Collaboration',
                style: AppTextStyles.headingS.copyWith(color: Colors.white),
              ),
              Text(
                'Partnerships & Warehouse Associations',
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
// REUSABLE COMPONENTS
// ─────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color iconColor;
  final Color iconTint;
  final Widget child;

  const _SectionCard({
    required this.label,
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
            color: Colors.black.withAlpha((0.05 * 255).round()),
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
                decoration: BoxDecoration(color: iconTint, borderRadius: BorderRadius.circular(AppRadius.md)),
                child: Icon(icon, color: iconColor, size: AppSpacing.iconMD),
              ),
              SizedBox(width: AppSpacing.md),
              Text(label, style: AppTextStyles.labelL.copyWith(fontWeight: FontWeight.w700)),
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

class _TypeDropdown extends StatelessWidget {
  final BusinessCollaborationViewModel vm;
  const _TypeDropdown({required this.vm});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return DropdownButtonFormField<String>(
      value: vm.selectedType,
      onChanged: vm.setType,
      validator: (v) => v == null ? 'Selection required' : null,
      style: AppTextStyles.bodyM.copyWith(color: cs.onSurface),
      decoration: InputDecoration(
        labelText: 'Collaboration Type',
        prefixIcon: Icon(Icons.hub_rounded, size: AppSpacing.iconMD, color: cs.onSurfaceVariant),
        filled: true,
        fillColor: cs.surfaceContainerHighest.withAlpha((0.3 * 255).round()),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.md), borderSide: BorderSide(color: AppColors.borderLight)),
      ),
      items: BusinessCollaborationViewModel.types
          .map((t) => DropdownMenuItem(value: t, child: Text(t)))
          .toList(),
    );
  }
}

class _StickyFooter extends StatelessWidget {
  final BusinessCollaborationViewModel vm;
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
            gradient: vm.isSubmitting ? null : const LinearGradient(colors: [AppColors.info, AppColors.infoDark], begin: Alignment.topLeft, end: Alignment.bottomRight),
            color: vm.isSubmitting ? AppColors.infoContainer : null,
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: ElevatedButton(
            onPressed: vm.isSubmitting ? null : () async {
              if (await vm.submit() && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Collaboration recorded successfully!')));
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md))),
            child: vm.isSubmitting
                ? const Row(mainAxisAlignment: MainAxisAlignment.center, children: [SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.info)), SizedBox(width: 12), Text('Processing…')])
                : const Text('Save Collaboration', style: AppTextStyles.buttonL),
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
