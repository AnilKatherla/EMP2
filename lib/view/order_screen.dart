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
                          _SelectionField(
                            label: 'Payment Mode',
                            value: vm.selectedPaymentMode,
                            onChanged: vm.setPaymentMode,
                            items: OrderViewModel.paymentModes,
                            icon: Icons.account_balance_wallet_rounded,
                            hint: 'Select Payment Method',
                          ),
                          SizedBox(height: AppSpacing.gapMD),
                          _SelectionField(
                            label: 'Order Status',
                            value: vm.selectedStatus,
                            onChanged: vm.setStatus,
                            items: OrderViewModel.orderStatuses,
                            icon: Icons.info_outline_rounded,
                            hint: 'Set Status',
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
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
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

class _SelectionField extends StatelessWidget {
  final String label;
  final String? value;
  final String hint;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final IconData icon;

  const _SelectionField({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.icon,
    required this.hint,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return FormField<String>(
      validator: (v) => v == null ? 'Please select $label' : null,
      initialValue: value,
      builder: (state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () => _showPicker(context, state),
              borderRadius: BorderRadius.circular(AppRadius.md),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
                decoration: BoxDecoration(
                  color: cs.surfaceContainerHighest.withAlpha((0.3 * 255).round()),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(
                    color: state.hasError ? AppColors.error : AppColors.borderLight,
                    width: state.hasError ? 1.5 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(icon, size: AppSpacing.iconMD, color: state.hasError ? AppColors.error : cs.onSurfaceVariant),
                    SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(label, style: AppTextStyles.caption.copyWith(color: cs.onSurfaceVariant)),
                          Text(
                            value ?? hint,
                            style: AppTextStyles.bodyM.copyWith(
                              color: value == null ? cs.onSurfaceVariant.withAlpha(150) : cs.onSurface,
                              fontWeight: value == null ? FontWeight.normal : FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.keyboard_arrow_down_rounded, color: cs.onSurfaceVariant, size: AppSpacing.iconLG),
                  ],
                ),
              ),
            ),
            if (state.hasError) ...[
              Padding(
                padding: EdgeInsets.only(left: AppSpacing.md, top: AppSpacing.xs),
                child: Text(
                  state.errorText!,
                  style: AppTextStyles.caption.copyWith(color: AppColors.error),
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  void _showPicker(BuildContext context, FormFieldState<String> state) {
    final cs = Theme.of(context).colorScheme;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl2)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle
              Container(
                margin: EdgeInsets.symmetric(vertical: AppSpacing.md),
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: cs.onSurfaceVariant.withAlpha(50), borderRadius: BorderRadius.circular(2)),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
                child: Row(
                  children: [
                    Icon(icon, color: AppColors.primary, size: AppSpacing.iconMD),
                    SizedBox(width: AppSpacing.md),
                    Text('Select $label', style: AppTextStyles.labelL.copyWith(fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
              const Divider(),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final isSelected = item == value;

                    return ListTile(
                      onTap: () {
                        onChanged(item);
                        state.didChange(item);
                        Navigator.pop(context);
                      },
                      leading: Container(
                        padding: EdgeInsets.all(AppSpacing.xs),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primaryContainer : cs.surfaceContainerHighest.withAlpha(100),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isSelected ? Icons.check_rounded : Icons.radio_button_unchecked_rounded,
                          size: AppSpacing.iconSM,
                          color: isSelected ? AppColors.primary : cs.onSurfaceVariant,
                        ),
                      ),
                      title: Text(
                        item,
                        style: AppTextStyles.bodyM.copyWith(
                          color: isSelected ? AppColors.primary : cs.onSurface,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.normal,
                        ),
                      ),
                      trailing: isSelected ? Icon(Icons.check_circle_rounded, color: AppColors.primary, size: AppSpacing.iconMD) : null,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
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
            color: vm.isSubmitting ? AppColors.primaryContainer : AppColors.primary,
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
                ? const Row(mainAxisAlignment: MainAxisAlignment.center, children: [SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary)), SizedBox(width: 12), Text('Saving…')])
                : Text('Save Order', style: AppTextStyles.buttonL),
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
