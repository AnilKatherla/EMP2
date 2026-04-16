import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:emp/core/theme/app_colors.dart';
import 'package:emp/core/theme/app_spacing.dart';
import 'package:emp/core/theme/app_text_styles.dart';
import 'package:emp/viewmodel/order/order_viewmodel.dart';

// ─────────────────────────────────────────────
// ORDER SCREEN
// ─────────────────────────────────────────────
class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OrderViewModel(),
      child: const _OrderView(),
    );
  }
}

class _OrderView extends StatelessWidget {
  const _OrderView();

  @override
  Widget build(BuildContext context) {
    final vm     = context.watch<OrderViewModel>();
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
                    // ── Basic Info ─────────────────────────────────────────
                    _SectionCard(
                      label: 'Store Information',
                      icon: Icons.storefront_rounded,
                      iconColor: AppColors.primary,
                      iconTint: AppColors.primaryContainer,
                      child: Column(
                        children: [
                          _TfField(
                            controller: vm.storeNameCtrl,
                            label: 'Store Name',
                            hint: 'e.g. S.R. Enterprises',
                            prefixIcon: Icons.store_rounded,
                            validator: _required,
                          ),
                          SizedBox(height: AppSpacing.gapMD),
                          _DatePickerTile(vm: vm),
                        ],
                      ),
                    ),

                    SizedBox(height: AppSpacing.gapMD),

                    // ── Order Details ──────────────────────────────────────
                    _SectionCard(
                      label: 'Order Details',
                      icon: Icons.shopping_bag_rounded,
                      iconColor: AppColors.secondary,
                      iconTint: AppColors.secondaryContainer,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: _TfField(
                                  controller: vm.orderValueCtrl,
                                  label: 'Order Value (₹)',
                                  hint: '0.00',
                                  prefixIcon: Icons.payments_rounded,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                  validator: _required,
                                ),
                              ),
                              SizedBox(width: AppSpacing.gapMD),
                              Expanded(
                                child: _TfField(
                                  controller: vm.itemsCountCtrl,
                                  label: 'Items Count',
                                  hint: 'Total items',
                                  prefixIcon: Icons.list_alt_rounded,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                  validator: _required,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: AppSpacing.gapMD),
                          _DropdownField(
                            label: 'Payment Mode',
                            value: vm.selectedPaymentMode,
                            onChanged: vm.setPaymentMode,
                            items: OrderViewModel.paymentModes,
                            icon: Icons.account_balance_wallet_rounded,
                          ),
                          SizedBox(height: AppSpacing.gapMD),
                          _DropdownField(
                            label: 'Order Status',
                            value: vm.selectedStatus,
                            onChanged: vm.setStatus,
                            items: OrderViewModel.orderStatuses,
                            icon: Icons.info_outline_rounded,
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
            colors: [AppColors.secondary, AppColors.secondaryDark],
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
                'Record Order',
                style: AppTextStyles.headingS.copyWith(color: Colors.white),
              ),
              Text(
                'Collect orders from retailers manually',
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

class _DatePickerTile extends StatelessWidget {
  final OrderViewModel vm;
  const _DatePickerTile({required this.vm});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: vm.orderDate,
          firstDate: DateTime(2024),
          lastDate: DateTime.now(),
        );
        if (picked != null) vm.setOrderDate(picked);
      },
      child: Container(
        padding: EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: cs.surfaceContainerHighest.withAlpha((0.3 * 255).round()),
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_month_rounded, color: AppColors.primary, size: AppSpacing.iconMD),
            SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Order Date', style: AppTextStyles.caption.copyWith(color: cs.onSurfaceVariant)),
                  Text('${vm.orderDate.day}/${vm.orderDate.month}/${vm.orderDate.year}', style: AppTextStyles.labelL),
                ],
              ),
            ),
            Icon(Icons.edit_calendar_rounded, color: cs.onSurfaceVariant, size: AppSpacing.iconSM),
          ],
        ),
      ),
    );
  }
}

class _DropdownField extends StatelessWidget {
  final String label;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final IconData icon;

  const _DropdownField({required this.label, required this.value, required this.items, required this.onChanged, required this.icon});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return DropdownButtonFormField<String>(
      value: value,
      onChanged: onChanged,
      validator: (v) => v == null ? 'Required' : null,
      style: AppTextStyles.bodyM.copyWith(color: cs.onSurface),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: AppSpacing.iconMD, color: cs.onSurfaceVariant),
        filled: true,
        fillColor: cs.surfaceContainerHighest.withAlpha((0.3 * 255).round()),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.md), borderSide: BorderSide(color: AppColors.borderLight)),
      ),
      items: items.map((i) => DropdownMenuItem(value: i, child: Text(i))).toList(),
    );
  }
}

class _StickyFooter extends StatelessWidget {
  final OrderViewModel vm;
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
            gradient: vm.isSubmitting ? null : const LinearGradient(colors: [AppColors.secondary, AppColors.secondaryDark], begin: Alignment.topLeft, end: Alignment.bottomRight),
            color: vm.isSubmitting ? AppColors.secondaryContainer : null,
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: ElevatedButton(
            onPressed: vm.isSubmitting ? null : () async {
              if (await vm.submit() && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Order saved successfully!')));
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md))),
            child: vm.isSubmitting
                ? const Row(mainAxisAlignment: MainAxisAlignment.center, children: [SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.secondary)), SizedBox(width: 12), Text('Saving…')])
                : const Text('Save Order', style: AppTextStyles.buttonL),
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
