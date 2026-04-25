import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:emp/core/theme/app_colors.dart';
import 'package:emp/core/theme/app_spacing.dart';
import 'package:emp/core/theme/app_text_styles.dart';
import 'package:emp/viewmodel/store_visit/store_visit_viewmodel.dart';
import 'package:emp/data/repositories/visit_repository.dart';
import 'package:image_picker/image_picker.dart';

// ─────────────────────────────────────────────
// STORE VISIT SCREEN  (entry point)
// ─────────────────────────────────────────────
class StoreVisitScreen extends StatelessWidget {
  const StoreVisitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => StoreVisitViewModel(
        repository: ctx.read<VisitRepository>(),
      ),
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

                    // ── 2. Business Details ─────────────────────────────────────
                    _SectionCard(
                      label: 'Business Details',
                      icon: Icons.business_center_rounded,
                      iconColor: AppColors.secondary,
                      iconTint: AppColors.secondaryContainer,
                      child: Column(
                        children: [
                          // Store Type Dropdown
                          _StoreTypeDropdown(vm: vm),
                          if (vm.selectedStoreType == 'Other') ...[
                            SizedBox(height: AppSpacing.gapMD),
                            _TfField(
                              controller: vm.otherStoreTypeCtrl,
                              label: 'Other Store Type',
                              hint: 'Specify store type',
                              prefixIcon: Icons.edit_note_rounded,
                              validator: _required,
                            ),
                          ],
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
                          const _Divider(),
                          SizedBox(height: AppSpacing.gapMD),

                          // 1. App Installation
                          _RadioQuestion(
                            label: 'App Installation?',
                            icon: Icons.install_mobile_rounded,
                            value: vm.isAppInstalled,
                            onChanged: vm.setAppInstalled,
                          ),
                          if (vm.isAppInstalled == false) ...[
                            SizedBox(height: AppSpacing.gapSM),
                            _ReasonDropdown(
                              label: 'Select Installation Status',
                              value: vm.appNotInstalledReason,
                              items: StoreVisitViewModel.installationFailureReasons,
                              onChanged: vm.setAppNotInstalledReason,
                            ),
                            if (vm.appNotInstalledReason == 'Enter any other reason') ...[
                              SizedBox(height: AppSpacing.gapSM),
                              _TfField(
                                controller: vm.appNotInstalledOtherCtrl,
                                label: 'Enter Reason',
                                hint: 'Specify your reason',
                                prefixIcon: Icons.edit_note_rounded,
                                validator: _required,
                              ),
                            ],
                          ],

                          const _Divider(),
                          SizedBox(height: AppSpacing.gapMD),

                          // 2. Registration Completed
                          _RadioQuestion(
                            label: 'Registration completed?',
                            icon: Icons.app_registration_rounded,
                            value: vm.isRegistrationCompleted,
                            onChanged: vm.setRegistrationCompleted,
                          ),
                          if (vm.isRegistrationCompleted == true) ...[
                            SizedBox(height: AppSpacing.gapSM),
                            _TfField(
                              controller: vm.regFeedbackCtrl,
                              label: 'Feedback',
                              hint: 'Enter registration feedback',
                              prefixIcon: Icons.feedback_outlined,
                            ),
                          ] else if (vm.isRegistrationCompleted == false) ...[
                            SizedBox(height: AppSpacing.gapSM),
                            _TfField(
                              controller: vm.regNoReasonCtrl,
                              label: 'Reason',
                              hint: 'Why registration not completed?',
                              prefixIcon: Icons.error_outline_rounded,
                              validator: _required,
                            ),
                          ],

                          const _Divider(),
                          SizedBox(height: AppSpacing.gapMD),

                          // 3. App Training
                          _RadioQuestion(
                            label: 'App training?',
                            icon: Icons.school_rounded,
                            value: vm.isAppTrainingProvided,
                            onChanged: vm.setAppTrainingProvided,
                          ),
                          if (vm.isAppTrainingProvided == true) ...[
                            SizedBox(height: AppSpacing.gapSM),
                            _TfField(
                              controller: vm.trainingFeedbackCtrl,
                              label: 'Feedback',
                              hint: 'Enter training feedback',
                              prefixIcon: Icons.thumb_up_outlined,
                            ),
                          ] else if (vm.isAppTrainingProvided == false) ...[
                            SizedBox(height: AppSpacing.gapSM),
                            _TfField(
                              controller: vm.trainingNoReasonCtrl,
                              label: 'Reason',
                              hint: 'Why training not provided?',
                              prefixIcon: Icons.help_outline_rounded,
                              validator: _required,
                            ),
                          ],

                          const _Divider(),
                          SizedBox(height: AppSpacing.gapMD),

                          // 4. First Order Placed
                          _RadioQuestion(
                            label: 'First Order placed?',
                            icon: Icons.shopping_bag_rounded,
                            value: vm.isOrderPlaced,
                            onChanged: vm.setOrderPlaced,
                          ),
                          if (vm.isOrderPlaced == true) ...[
                            SizedBox(height: AppSpacing.gapSM),
                            _TfField(
                              controller: vm.orderFeedbackCtrl,
                              label: 'Feedback',
                              hint: 'Enter order feedback',
                              prefixIcon: Icons.shopping_cart_outlined,
                            ),
                          ] else if (vm.isOrderPlaced == false) ...[
                            SizedBox(height: AppSpacing.gapSM),
                            _TfField(
                              controller: vm.orderNoReasonCtrl,
                              label: 'Reason',
                              hint: 'Why order not placed?',
                              prefixIcon: Icons.remove_shopping_cart_rounded,
                              validator: _required,
                            ),
                          ],
                        ],
                      ),
                    ),

                    SizedBox(height: AppSpacing.gapMD),

                    // ── 3. Visit Status ─────────────────────────────────────────
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

                    // ── 4. Visit Proof ──────────────────────────────────────────
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
                            crossAxisCount: 4,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisSpacing: AppSpacing.gapSM,
                            mainAxisSpacing: AppSpacing.gapSM,
                            childAspectRatio: 1.0,
                            children: [
                              _PhotoTile(
                                vm: vm,
                                photoKey: 'store',
                                label: 'Store',
                                icon: Icons.storefront_rounded,
                                isRequired: true,
                              ),
                              _PhotoTile(
                                vm: vm,
                                photoKey: 'board',
                                label: 'Board',
                                icon: Icons.signpost_rounded,
                                isRequired: true,
                              ),
                              _PhotoTile(
                                vm: vm,
                                photoKey: 'owner',
                                label: 'Owner',
                                icon: Icons.person_pin_circle_rounded,
                                isRequired: false,
                              ),
                              _PhotoTile(
                                vm: vm,
                                photoKey: 'selfie',
                                label: 'Selfie',
                                icon: Icons.portrait_rounded,
                                isRequired: true,
                              ),
                            ],
                          ),
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
          vertical: AppSpacing.sm,
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
// STORE TYPE SELECTION (Improved)
// ─────────────────────────────────────────────
class _StoreTypeDropdown extends StatelessWidget {
  final StoreVisitViewModel vm;
  const _StoreTypeDropdown({required this.vm});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return FormField<String>(
      validator: (v) => v == null ? 'Please select a store type' : null,
      initialValue: vm.selectedStoreType,
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
                    Icon(Icons.category_rounded, size: AppSpacing.iconMD, color: state.hasError ? AppColors.error : cs.onSurfaceVariant),
                    SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Store Type', style: AppTextStyles.caption.copyWith(color: cs.onSurfaceVariant)),
                          Text(
                            vm.selectedStoreType ?? 'Select Store Type',
                            style: AppTextStyles.bodyM.copyWith(
                              color: vm.selectedStoreType == null ? cs.onSurfaceVariant.withAlpha(150) : cs.onSurface,
                              fontWeight: vm.selectedStoreType == null ? FontWeight.normal : FontWeight.w600,
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
    final items = StoreVisitViewModel.storeTypes;

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
              Container(
                margin: EdgeInsets.symmetric(vertical: AppSpacing.md),
                width: 40, height: 4,
                decoration: BoxDecoration(color: cs.onSurfaceVariant.withAlpha(50), borderRadius: BorderRadius.circular(2)),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
                child: Row(
                  children: [
                    const Icon(Icons.category_rounded, color: AppColors.primary, size: AppSpacing.iconMD),
                    SizedBox(width: AppSpacing.md),
                    Text('Choose Store Type', style: AppTextStyles.labelL.copyWith(fontWeight: FontWeight.w700)),
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
                    final isSelected = item == vm.selectedStoreType;

                    return ListTile(
                      onTap: () {
                        vm.setStoreType(item);
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
                      title: Text(item, style: AppTextStyles.bodyM.copyWith(color: isSelected ? AppColors.primary : cs.onSurface, fontWeight: isSelected ? FontWeight.w700 : FontWeight.normal)),
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

// ─────────────────────────────────────────────
// PHOTO TILE COMPONENT
// ─────────────────────────────────────────────
class _PhotoTile extends StatelessWidget {
  final StoreVisitViewModel vm;
  final String photoKey;
  final String label;
  final IconData icon;
  final bool isRequired;

  const _PhotoTile({
    required this.vm,
    required this.photoKey,
    required this.label,
    required this.icon,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final photo = vm.getPhoto(photoKey);

    return InkWell(
      onTap: () {
        if (photo != null) {
          _showImagePreview(context, photo);
        } else {
          vm.pickPhoto(photoKey);
        }
      },
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: photo != null 
            ? AppColors.success.withOpacity(0.05) 
            : cs.surfaceContainerHighest.withAlpha((0.3 * 255).round()),
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: photo != null ? AppColors.success : AppColors.borderLight,
            width: photo != null ? 1.5 : 1,
          ),
        ),
        child: photo != null
            ? Stack(
                children: [
                   Center(
                     child: Column(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                         const Icon(Icons.description_rounded, color: AppColors.success, size: 20),
                         const SizedBox(height: 2),
                         Text(
                           'Captured',
                           style: AppTextStyles.caption.copyWith(
                             fontSize: 8, 
                             color: AppColors.success,
                             fontWeight: FontWeight.bold,
                           ),
                         ),
                       ],
                     ),
                   ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: GestureDetector(
                      onTap: () => vm.removePhoto(photoKey),
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: AppColors.error,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.close_rounded, size: 10, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.xs),
                      decoration: BoxDecoration(
                        color: cs.surface,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, color: cs.onSurfaceVariant, size: 16),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      label,
                      style: AppTextStyles.caption.copyWith(fontSize: 9, color: cs.onSurface),
                      textAlign: TextAlign.center,
                    ),
                  ],
              ),
      ),
    );
  }

  void _showImagePreview(BuildContext context, XFile photo) {
    showDialog(
      context: context,
      builder: (context) => Dialog.fullscreen(
        backgroundColor: Colors.black,
        child: Stack(
          children: [
            Center(
              child: InteractiveViewer(
                child: Image.file(
                  File(photo.path),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Positioned(
              top: 40,
              right: 20,
              child: IconButton(
                icon: const Icon(Icons.close_rounded, color: Colors.white, size: 30),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// RADIO QUESTION COMPONENT
// ─────────────────────────────────────────────
class _RadioQuestion extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool? value;
  final ValueChanged<bool?> onChanged;

  const _RadioQuestion({
    required this.label,
    required this.icon,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        children: [
          Icon(icon, size: AppSpacing.iconSM, color: cs.primary),
          SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.labelL.copyWith(
                color: cs.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(width: AppSpacing.md),
          _RadioOption(
            label: 'Yes',
            isSelected: value == true,
            onTap: () => onChanged(true),
          ),
          SizedBox(width: AppSpacing.sm),
          _RadioOption(
            label: 'No',
            isSelected: value == false,
            onTap: () => onChanged(false),
          ),
        ],
      ),
    );
  }
}

class _RadioOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _RadioOption({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.xs, vertical: AppSpacing.xs),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded,
              size: 20,
              color: isSelected ? AppColors.primary : cs.onSurfaceVariant,
            ),
            SizedBox(width: 4),
            Text(
              label,
              style: AppTextStyles.labelM.copyWith(
                color: isSelected ? AppColors.primary : cs.onSurface,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// REASON DROPDOWN (Reusable for failures)
// ─────────────────────────────────────────────
class _ReasonDropdown extends StatelessWidget {
  final String label;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const _ReasonDropdown({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return InkWell(
      onTap: () => _showPicker(context),
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
        decoration: BoxDecoration(
          color: cs.surfaceContainerHighest.withAlpha((0.3 * 255).round()),
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Row(
          children: [
            Icon(Icons.report_problem_rounded, size: AppSpacing.iconSM, color: cs.onSurfaceVariant),
            SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: AppTextStyles.caption.copyWith(color: cs.onSurfaceVariant)),
                  Text(
                    value ?? 'Select Reason',
                    style: AppTextStyles.bodyM.copyWith(
                      color: value == null ? cs.onSurfaceVariant.withAlpha(150) : cs.onSurface,
                      fontWeight: value == null ? FontWeight.normal : FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.keyboard_arrow_down_rounded, color: cs.onSurfaceVariant, size: AppSpacing.iconMD),
          ],
        ),
      ),
    );
  }

  void _showPicker(BuildContext context) {
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
              Container(
                margin: EdgeInsets.symmetric(vertical: AppSpacing.md),
                width: 40, height: 4,
                decoration: BoxDecoration(color: cs.onSurfaceVariant.withAlpha(50), borderRadius: BorderRadius.circular(2)),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
                child: Row(
                  children: [
                    const Icon(Icons.list_alt_rounded, color: AppColors.primary, size: AppSpacing.iconMD),
                    SizedBox(width: AppSpacing.md),
                    Text('Choose Reason', style: AppTextStyles.labelL.copyWith(fontWeight: FontWeight.w700)),
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
                        Navigator.pop(context);
                      },
                      title: Text(item, style: AppTextStyles.bodyM.copyWith(
                        color: isSelected ? AppColors.primary : cs.onSurface,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.normal,
                      )),
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

// ─────────────────────────────────────────────
// TOGGLE TILE (Deprecated - keep for other uses if needed, or remove)
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
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: AppSpacing.gapXS,
      mainAxisSpacing: AppSpacing.gapXS,
      childAspectRatio: 0.85,
      children: _statuses.map((s) {
        final isActive = vm.visitStatus == s.$1;
        return GestureDetector(
          onTap: () => vm.setVisitStatus(s.$1),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(AppSpacing.xs),
            decoration: BoxDecoration(
              color: isActive ? s.$5 : theme.colorScheme.surfaceContainerHighest.withAlpha((0.2 * 255).round()),
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(
                color: isActive ? s.$4 : AppColors.borderLight.withAlpha(100),
                width: isActive ? 1.5 : 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  s.$3,
                  size: AppSpacing.iconSM,
                  color: isActive ? s.$4 : theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(height: 4),
                Text(
                  s.$2,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.caption.copyWith(
                    fontSize: 8,
                    color: isActive ? s.$4 : theme.colorScheme.onSurface,
                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
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
          color: vm.isSubmitting ? AppColors.primaryContainer : AppColors.primary,
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
