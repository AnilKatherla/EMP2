import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:emp/core/theme/app_colors.dart';
import 'package:emp/core/theme/app_spacing.dart';
import 'package:emp/core/theme/app_text_styles.dart';
import 'package:emp/viewmodel/store_visit/store_visit_viewmodel.dart';

// ─────────────────────────────────────────────
// STORE VISIT SCREEN  (entry point)
// ─────────────────────────────────────────────
class StoreVisitScreen extends StatelessWidget {
  const StoreVisitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => StoreVisitViewModel(),
      child: const _StoreVisitView(),
    );
  }
}

// ─────────────────────────────────────────────
// INTERNAL VIEW
// ─────────────────────────────────────────────
class _StoreVisitView extends StatelessWidget {
  const _StoreVisitView();

  @override
  Widget build(BuildContext context) {
    final vm     = context.watch<StoreVisitViewModel>();
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── 1. Basic Information ────────────────────────────────────
                    _SectionCard(
                      label: 'Basic Information',
                      icon: Icons.store_rounded,
                      iconColor: AppColors.primary,
                      iconTint: AppColors.primaryContainer,
                      child: Column(
                        children: [
                          _TfField(
                            controller: vm.storeNameCtrl,
                            label: 'Store Name',
                            hint: 'e.g. Lakshmi Super Market',
                            prefixIcon: Icons.storefront_rounded,
                            validator: _required,
                          ),
                          SizedBox(height: AppSpacing.gapMD),
                          _TfField(
                            controller: vm.ownerNameCtrl,
                            label: 'Owner Name',
                            hint: 'e.g. Ramesh Kumar',
                            prefixIcon: Icons.person_rounded,
                            validator: _required,
                          ),
                          SizedBox(height: AppSpacing.gapMD),
                          _TfField(
                            controller: vm.mobileCtrl,
                            label: 'Mobile Number',
                            hint: '10-digit mobile',
                            prefixIcon: Icons.phone_rounded,
                            keyboardType: TextInputType.phone,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(10),
                            ],
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) return 'Mobile is required';
                              if (v.trim().length < 10) return 'Enter a valid 10-digit number';
                              return null;
                            },
                          ),
                          SizedBox(height: AppSpacing.gapMD),
                          _TfField(
                            controller: vm.addressCtrl,
                            label: 'Address',
                            hint: 'Full store address',
                            prefixIcon: Icons.location_on_rounded,
                            maxLines: 3,
                            validator: _required,
                          ),
                          SizedBox(height: AppSpacing.gapMD),
                          _TfField(
                            controller: vm.gstCtrl,
                            label: 'GST Number',
                            hint: 'Optional',
                            prefixIcon: Icons.receipt_long_rounded,
                            isOptional: true,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: AppSpacing.gapMD),

                    // ── 2. Location ─────────────────────────────────────────────
                    _SectionCard(
                      label: 'Location',
                      icon: Icons.my_location_rounded,
                      iconColor: AppColors.info,
                      iconTint: AppColors.infoContainer,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // GPS Fetch Button
                          _GpsButton(vm: vm),
                          SizedBox(height: AppSpacing.gapMD),
                          _TfField(
                            controller: vm.pinCodeCtrl,
                            label: 'Pin Code',
                            hint: '6-digit pin code',
                            prefixIcon: Icons.pin_drop_rounded,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(6),
                            ],
                            validator: _required,
                          ),
                          SizedBox(height: AppSpacing.gapMD),
                          Row(
                            children: [
                              Expanded(
                                child: _TfField(
                                  controller: vm.cityCtrl,
                                  label: 'City',
                                  hint: 'City',
                                  prefixIcon: Icons.location_city_rounded,
                                  validator: _required,
                                ),
                              ),
                              SizedBox(width: AppSpacing.gapMD),
                              Expanded(
                                child: _TfField(
                                  controller: vm.stateCtrl,
                                  label: 'State',
                                  hint: 'State',
                                  prefixIcon: Icons.map_rounded,
                                  validator: _required,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: AppSpacing.gapMD),

                    // ── 3. Business Details ─────────────────────────────────────
                    _SectionCard(
                      label: 'Business Details',
                      icon: Icons.business_center_rounded,
                      iconColor: AppColors.secondary,
                      iconTint: AppColors.secondaryContainer,
                      child: Column(
                        children: [
                          // Store Type Dropdown
                          _StoreTypeDropdown(vm: vm),
                          SizedBox(height: AppSpacing.gapMD),
                          _TfField(
                            controller: vm.monthlyPurchaseCtrl,
                            label: 'Monthly Purchase',
                            hint: 'e.g. ₹50,000',
                            prefixIcon: Icons.currency_rupee_rounded,
                            keyboardType: TextInputType.number,
                            validator: _required,
                          ),
                          SizedBox(height: AppSpacing.gapMD),
                          _TfField(
                            controller: vm.interestedProductsCtrl,
                            label: 'Interested Products',
                            hint: 'e.g. Beverages, Snacks',
                            prefixIcon: Icons.inventory_2_rounded,
                            maxLines: 2,
                            validator: _required,
                          ),
                          SizedBox(height: AppSpacing.gapSM),
                          const _Divider(),
                          SizedBox(height: AppSpacing.gapSM),
                          // Toggle switches
                          _ToggleTile(
                            label: 'App Installed',
                            subtitle: 'Is the TrackForce app installed on store?',
                            icon: Icons.install_mobile_rounded,
                            value: vm.appInstalled,
                            onChanged: vm.toggleAppInstalled,
                          ),
                          _ToggleTile(
                            label: 'RES',
                            subtitle: 'Is the retailer enrolled in RES?',
                            icon: Icons.assignment_turned_in_rounded,
                            value: vm.res,
                            onChanged: vm.toggleRes,
                          ),
                          _ToggleTile(
                            label: 'Order Placed',
                            subtitle: 'Was an order placed during this visit?',
                            icon: Icons.shopping_cart_checkout_rounded,
                            value: vm.orderPlaced,
                            onChanged: vm.toggleOrderPlaced,
                          ),
                          _ToggleTile(
                            label: 'App Training',
                            subtitle: 'Was app training provided?',
                            icon: Icons.school_rounded,
                            value: vm.appTraining,
                            onChanged: vm.toggleAppTraining,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: AppSpacing.gapMD),

                    // ── 4. Visit Status ─────────────────────────────────────────
                    _SectionCard(
                      label: 'Visit Status',
                      icon: Icons.flag_rounded,
                      iconColor: AppColors.warning,
                      iconTint: AppColors.warningContainer,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _VisitStatusGrid(vm: vm),
                          // Conditional: Not Interested
                          if (vm.visitStatus == VisitStatus.notInterested) ...[
                            SizedBox(height: AppSpacing.gapMD),
                            _NotInterestedPanel(vm: vm),
                          ],
                          // Conditional: Need Follow-up
                          if (vm.visitStatus == VisitStatus.needFollowUp) ...[
                            SizedBox(height: AppSpacing.gapMD),
                            _FollowUpPanel(vm: vm),
                          ],
                        ],
                      ),
                    ),

                    SizedBox(height: AppSpacing.gapMD),
                  ],
                ),
              ),
            ),
            // ── Sticky Submit Button ───────────────────────────────────────────
            Container(
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
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: _SubmitButton(vm: vm),
            ),
          ],
        ),
      ),
    );
  }

  // ── Validators ────────────────────────────────────────────────────────────
  static String? _required(String? v) {
    if (v == null || v.trim().isEmpty) return 'This field is required';
    return null;
  }

  // ── App Bar ───────────────────────────────────────────────────────────────
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
                'Store Visit',
                style: AppTextStyles.headingS.copyWith(color: Colors.white),
              ),
              Text(
                'Record your retailer visit',
                style: AppTextStyles.caption.copyWith(
                  color: Colors.white.withAlpha((0.8 * 255).round()),
                ),
              ),
            ],
          ),
          actions: [
            Container(
              margin: EdgeInsets.only(right: AppSpacing.gapMD),
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha((0.2 * 255).round()),
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.route_rounded, color: Colors.white, size: AppSpacing.iconSM),
                  SizedBox(width: AppSpacing.xs),
                  Text(
                    'Visit #1',
                    style: AppTextStyles.labelM.copyWith(color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
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
  final IconData icon;
  final Color    iconColor;
  final Color    iconTint;
  final Widget   child;

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
            color: Colors.black.withAlpha((0.06 * 255).round()),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
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
              Text(
                label,
                style: AppTextStyles.headingS.copyWith(
                  color: theme.colorScheme.onSurface,
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
// REUSABLE: TEXT FORM FIELD
// ─────────────────────────────────────────────
class _TfField extends StatelessWidget {
  final TextEditingController  controller;
  final String                 label;
  final String                 hint;
  final IconData              prefixIcon;
  final int                   maxLines;
  final TextInputType?         keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final bool                   isOptional;

  const _TfField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.prefixIcon,
    this.maxLines = 1,
    this.keyboardType,
    this.inputFormatters,
    this.validator,
    this.isOptional = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme      = Theme.of(context);
    final cs         = theme.colorScheme;

    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: isOptional ? null : validator,
      style: AppTextStyles.bodyM.copyWith(color: cs.onSurface),
      decoration: InputDecoration(
        labelText: isOptional ? '$label (Optional)' : label,
        hintText: hint,
        prefixIcon: Icon(prefixIcon, size: AppSpacing.iconMD, color: cs.onSurfaceVariant),
        labelStyle: AppTextStyles.labelM.copyWith(color: cs.onSurfaceVariant),
        hintStyle: AppTextStyles.bodyM.copyWith(
          color: cs.onSurfaceVariant.withAlpha((0.5 * 255).round()),
        ),
        filled: true,
        fillColor: cs.surfaceContainerHighest.withAlpha((0.4 * 255).round()),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: AppColors.borderLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: AppColors.borderLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: AppColors.error, width: 1.5),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// GPS BUTTON WIDGET
// ─────────────────────────────────────────────
class _GpsButton extends StatelessWidget {
  final StoreVisitViewModel vm;
  const _GpsButton({required this.vm});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs    = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'GPS Location',
          style: AppTextStyles.labelL.copyWith(color: cs.onSurfaceVariant),
        ),
        SizedBox(height: AppSpacing.gapSM),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: vm.isGpsLoading ? null : vm.fetchGpsLocation,
            icon: vm.isGpsLoading
                ? SizedBox(
                    width: AppSpacing.iconMD,
                    height: AppSpacing.iconMD,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.primary,
                    ),
                  )
                : Icon(
                    vm.gpsCoordinates != null
                        ? Icons.gps_fixed_rounded
                        : Icons.gps_not_fixed_rounded,
                    size: AppSpacing.iconMD,
                  ),
            label: Text(
              vm.isGpsLoading
                  ? 'Fetching Location…'
                  : vm.gpsCoordinates != null
                      ? 'Location Captured'
                      : 'Capture GPS Location',
              style: AppTextStyles.labelL,
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: vm.gpsCoordinates != null ? AppColors.success : AppColors.primary,
              side: BorderSide(
                color: vm.gpsCoordinates != null ? AppColors.success : AppColors.primary,
              ),
              padding: EdgeInsets.symmetric(
                vertical: AppSpacing.md,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
            ),
          ),
        ),
        if (vm.gpsCoordinates != null) ...[
          SizedBox(height: AppSpacing.gapSM),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: AppColors.successContainer,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Row(
              children: [
                Icon(Icons.check_circle_rounded,
                    color: AppColors.success, size: AppSpacing.iconSM),
                SizedBox(width: AppSpacing.gapSM),
                Expanded(
                  child: Text(
                    vm.gpsCoordinates!,
                    style: AppTextStyles.labelM.copyWith(
                      color: AppColors.onSuccessContainer,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

// ─────────────────────────────────────────────
// STORE TYPE DROPDOWN
// ─────────────────────────────────────────────
class _StoreTypeDropdown extends StatelessWidget {
  final StoreVisitViewModel vm;
  const _StoreTypeDropdown({required this.vm});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs    = theme.colorScheme;

    return DropdownButtonFormField<String>(
      value: vm.selectedStoreType,
      onChanged: vm.setStoreType,
      validator: (v) => v == null ? 'Please select a store type' : null,
      style: AppTextStyles.bodyM.copyWith(color: cs.onSurface),
      decoration: InputDecoration(
        labelText: 'Store Type',
        prefixIcon: Icon(Icons.category_rounded,
            size: AppSpacing.iconMD, color: cs.onSurfaceVariant),
        labelStyle: AppTextStyles.labelM.copyWith(color: cs.onSurfaceVariant),
        filled: true,
        fillColor: cs.surfaceContainerHighest.withAlpha((0.4 * 255).round()),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: AppColors.borderLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: AppColors.borderLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: AppColors.error),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
      ),
      isExpanded: true,
      items: StoreVisitViewModel.storeTypes
          .map((t) => DropdownMenuItem(
                value: t,
                child: Text(t, style: AppTextStyles.bodyM.copyWith(color: cs.onSurface)),
              ))
          .toList(),
    );
  }
}

// ─────────────────────────────────────────────
// TOGGLE TILE
// ─────────────────────────────────────────────
class _ToggleTile extends StatelessWidget {
  final String   label;
  final String   subtitle;
  final IconData icon;
  final bool     value;
  final ValueChanged<bool> onChanged;

  const _ToggleTile({
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs    = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.only(top: AppSpacing.sm),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(AppSpacing.xs),
            decoration: BoxDecoration(
              color: value
                  ? AppColors.primaryContainer
                  : cs.surfaceContainerHighest.withAlpha((0.5 * 255).round()),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Icon(
              icon,
              size: AppSpacing.iconSM,
              color: value ? AppColors.primary : cs.onSurfaceVariant,
            ),
          ),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.labelL.copyWith(color: cs.onSurface),
                ),
                Text(
                  subtitle,
                  style: AppTextStyles.caption.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// VISIT STATUS GRID  (2×2 selectable cards)
// ─────────────────────────────────────────────
class _VisitStatusGrid extends StatelessWidget {
  final StoreVisitViewModel vm;
  const _VisitStatusGrid({required this.vm});

  static const _statuses = [
    (VisitStatus.completed,         'Completed',           Icons.check_circle_rounded,    AppColors.success,   AppColors.successContainer),
    (VisitStatus.partiallyCompleted,'Partially Completed', Icons.timelapse_rounded,        AppColors.warning,   AppColors.warningContainer),
    (VisitStatus.notInterested,     'Not Interested',      Icons.cancel_rounded,           AppColors.error,     AppColors.errorContainer),
    (VisitStatus.needFollowUp,      'Need Follow-up',      Icons.event_repeat_rounded,     AppColors.info,      AppColors.infoContainer),
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
      childAspectRatio: 2.4,
      children: _statuses.map((s) {
        final isActive = vm.visitStatus == s.$1;
        return GestureDetector(
          onTap: () => vm.setVisitStatus(s.$1),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: isActive ? s.$5 : theme.colorScheme.surfaceContainerHighest.withAlpha((0.3 * 255).round()),
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(
                color: isActive ? s.$4 : AppColors.borderLight,
                width: isActive ? 1.5 : 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  s.$3,
                  size: AppSpacing.iconMD,
                  color: isActive ? s.$4 : theme.colorScheme.onSurfaceVariant,
                ),
                SizedBox(width: AppSpacing.gapSM),
                Expanded(
                  child: Text(
                    s.$2,
                    style: AppTextStyles.labelM.copyWith(
                      color: isActive ? s.$4 : theme.colorScheme.onSurface,
                      fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
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
// NOT INTERESTED PANEL
// ─────────────────────────────────────────────
class _NotInterestedPanel extends StatelessWidget {
  final StoreVisitViewModel vm;
  const _NotInterestedPanel({required this.vm});

  static const _reasons = [
    (NotInterestedReason.usingCompetitor, 'Already using competitor'),
    (NotInterestedReason.priceIssue,      'Price issue'),
    (NotInterestedReason.notRequired,     'Not required'),
    (NotInterestedReason.ownerNotAvailable,'Owner not available'),
    (NotInterestedReason.other,           'Other'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs    = theme.colorScheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.errorBackground,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.errorContainer),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline_rounded,
                  color: AppColors.error, size: AppSpacing.iconSM),
              SizedBox(width: AppSpacing.gapSM),
              Text(
                'Select reason for not interested',
                style: AppTextStyles.labelL.copyWith(color: AppColors.error),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md),
          ..._reasons.map((r) {
            final isSelected = vm.notInterestedReason == r.$1;
            return GestureDetector(
              onTap: () => vm.setNotInterestedReason(r.$1),
              child: Container(
                margin: EdgeInsets.only(bottom: AppSpacing.gapSM),
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.errorContainer : cs.surface,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(
                    color: isSelected ? AppColors.error : AppColors.borderLight,
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      isSelected
                          ? Icons.radio_button_checked_rounded
                          : Icons.radio_button_off_rounded,
                      size: AppSpacing.iconMD,
                      color: isSelected ? AppColors.error : cs.onSurfaceVariant,
                    ),
                    SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Text(
                        r.$2,
                        style: AppTextStyles.bodyM.copyWith(
                          color: isSelected ? AppColors.onErrorContainer : cs.onSurface,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// FOLLOW-UP PANEL
// ─────────────────────────────────────────────
class _FollowUpPanel extends StatelessWidget {
  final StoreVisitViewModel vm;
  const _FollowUpPanel({required this.vm});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs    = theme.colorScheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.infoBackground,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.infoContainer),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.event_rounded,
                  color: AppColors.info, size: AppSpacing.iconSM),
              SizedBox(width: AppSpacing.gapSM),
              Text(
                'Follow-up Details',
                style: AppTextStyles.labelL.copyWith(color: AppColors.info),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md),
          // Date picker
          GestureDetector(
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now().add(const Duration(days: 1)),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 90)),
                builder: (ctx, child) => Theme(
                  data: Theme.of(ctx).copyWith(
                    colorScheme: Theme.of(ctx).colorScheme.copyWith(
                          primary: AppColors.primary,
                        ),
                  ),
                  child: child!,
                ),
              );
              if (picked != null) vm.setFollowUpDate(picked);
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
              decoration: BoxDecoration(
                color: cs.surface,
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(
                  color: vm.followUpDate != null
                      ? AppColors.info
                      : AppColors.borderLight,
                  width: vm.followUpDate != null ? 1.5 : 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_today_rounded,
                    size: AppSpacing.iconMD,
                    color: vm.followUpDate != null
                        ? AppColors.info
                        : cs.onSurfaceVariant,
                  ),
                  SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      vm.followUpDate != null
                          ? '${vm.followUpDate!.day}/${vm.followUpDate!.month}/${vm.followUpDate!.year}'
                          : 'Select follow-up date',
                      style: AppTextStyles.bodyM.copyWith(
                        color: vm.followUpDate != null
                            ? cs.onSurface
                            : cs.onSurfaceVariant.withAlpha((0.6 * 255).round()),
                      ),
                    ),
                  ),
                  Icon(Icons.chevron_right_rounded,
                      color: cs.onSurfaceVariant, size: AppSpacing.iconMD),
                ],
              ),
            ),
          ),
          SizedBox(height: AppSpacing.md),
          // Notes
          TextFormField(
            controller: vm.followUpNotesCtrl,
            maxLines: 3,
            style: AppTextStyles.bodyM.copyWith(color: cs.onSurface),
            decoration: InputDecoration(
              labelText: 'Follow-up Notes',
              hintText: 'What needs to be done during follow-up?',
              prefixIcon: Icon(Icons.notes_rounded,
                  size: AppSpacing.iconMD, color: cs.onSurfaceVariant),
              labelStyle: AppTextStyles.labelM.copyWith(color: cs.onSurfaceVariant),
              hintStyle: AppTextStyles.bodyM.copyWith(
                color: cs.onSurfaceVariant.withAlpha((0.5 * 255).round()),
              ),
              filled: true,
              fillColor: cs.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
                borderSide: BorderSide(color: AppColors.borderLight),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
                borderSide: BorderSide(color: AppColors.borderLight),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
                borderSide: BorderSide(color: AppColors.info, width: 1.5),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
            ),
          ),
        ],
      ),
    );
  }
}



// ─────────────────────────────────────────────
// SUBMIT BUTTON
// ─────────────────────────────────────────────
class _SubmitButton extends StatelessWidget {
  final StoreVisitViewModel vm;
  const _SubmitButton({required this.vm});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
          boxShadow: vm.isSubmitting
              ? []
              : [
                  BoxShadow(
                    color: AppColors.primaryAlpha(0.35),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
        ),
        child: ElevatedButton(
          onPressed: vm.isSubmitting
              ? null
              : () async {
                  final success = await vm.submit();
                  if (success && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: AppColors.success,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.md),
                        ),
                        content: Row(
                          children: [
                            const Icon(Icons.check_circle_rounded,
                                color: Colors.white),
                            SizedBox(width: AppSpacing.md),
                            Text(
                              'Store visit saved successfully!',
                              style: AppTextStyles.labelL
                                  .copyWith(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    );
                    Navigator.of(context).pop();
                  }
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            disabledBackgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
          ),
          child: vm.isSubmitting
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: AppSpacing.iconMD,
                      height: AppSpacing.iconMD,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(width: AppSpacing.md),
                    Text(
                      'Saving Visit…',
                      style: AppTextStyles.buttonL.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.save_rounded, color: Colors.white),
                    SizedBox(width: AppSpacing.md),
                    Text(
                      'Save Store Visit',
                      style: AppTextStyles.buttonL.copyWith(color: Colors.white),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// DIVIDER HELPER
// ─────────────────────────────────────────────
class _Divider extends StatelessWidget {
  const _Divider();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      color: Theme.of(context).dividerColor,
    );
  }
}
