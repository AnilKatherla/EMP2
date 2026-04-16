import 'package:flutter/material.dart';

// ─────────────────────────────────────────────
// ENUMS
// ─────────────────────────────────────────────

enum SupplierVisitOutcome {
  interested,
  notInterested,
  negotiation,
  followUpRequired,
}

// ─────────────────────────────────────────────
// SUPPLIER VISIT VIEW MODEL
// ─────────────────────────────────────────────

class SupplierVisitViewModel extends ChangeNotifier {
  // ── Form Key ─────────────────────────────────────────────────────────────
  final formKey = GlobalKey<FormState>();

  // ── Form Fields ──────────────────────────────────────────────────────────
  final supplierNameCtrl    = TextEditingController();
  final contactPersonCtrl   = TextEditingController();
  final phoneCtrl           = TextEditingController();
  final productCategoryCtrl = TextEditingController();
  final locationCtrl        = TextEditingController();
  final interestDetailsCtrl = TextEditingController();

  // ── Visit Outcome ────────────────────────────────────────────────────────
  SupplierVisitOutcome? _outcome;
  SupplierVisitOutcome? get outcome => _outcome;

  void setOutcome(SupplierVisitOutcome? val) {
    _outcome = val;
    notifyListeners();
  }

  // ── Submission ───────────────────────────────────────────────────────────
  bool _isSubmitting = false;
  bool get isSubmitting => _isSubmitting;

  Future<bool> submit() async {
    if (!(formKey.currentState?.validate() ?? false)) return false;
    if (_outcome == null) return false;

    _isSubmitting = true;
    notifyListeners();
    
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));
    
    _isSubmitting = false;
    notifyListeners();
    return true;
  }

  // ── Dispose ──────────────────────────────────────────────────────────────
  @override
  void dispose() {
    supplierNameCtrl.dispose();
    contactPersonCtrl.dispose();
    phoneCtrl.dispose();
    productCategoryCtrl.dispose();
    locationCtrl.dispose();
    interestDetailsCtrl.dispose();
    super.dispose();
  }
}
