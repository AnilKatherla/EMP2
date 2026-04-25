import 'package:flutter/material.dart';
import '../../data/models/visit_models.dart';
import '../../data/repositories/visit_repository.dart';

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
  final VisitRepository _repository;

  SupplierVisitViewModel({required VisitRepository repository})
      : _repository = repository;

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
    
    try {
      final statusMap = {
        SupplierVisitOutcome.interested: 'completed',
        SupplierVisitOutcome.notInterested: 'not_interested',
        SupplierVisitOutcome.negotiation: 'partially_completed',
        SupplierVisitOutcome.followUpRequired: 'follow_up',
      };

      final request = VisitRequest(
        storeName: supplierNameCtrl.text,
        ownerName: contactPersonCtrl.text,
        mobileNumber: phoneCtrl.text,
        visitType: 'supplier',
        status: statusMap[_outcome] ?? 'completed',
        address: locationCtrl.text,
        notes: interestDetailsCtrl.text,
        visitForm: {
          'productCategory': productCategoryCtrl.text,
          'interestDetails': interestDetailsCtrl.text,
        },
      );

      await _repository.createVisit(request);

      _isSubmitting = false;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Submission Error: $e');
      _isSubmitting = false;
      notifyListeners();
      return false;
    }
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
