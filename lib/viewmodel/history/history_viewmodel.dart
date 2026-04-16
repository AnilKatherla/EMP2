import 'package:flutter/material.dart';

// ─────────────────────────────────────────────
// VISIT HISTORY VIEW MODEL (With Visit Proof)
// ─────────────────────────────────────────────

class VisitHistoryViewModel extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();

  // ── Form Controllers ─────────────────────────────────────────────────────
  final storeNameCtrl = TextEditingController();
  final visitDateCtrl  = TextEditingController(); // Or a date picker

  // ── Visit Proof (Moved from Store Visit) ─────────────────────────────────
  final Map<String, bool> _photoSelected = {
    'store':  false,
    'board':  false,
    'owner':  false,
    'selfie': false,
  };

  bool isPhotoSelected(String key) => _photoSelected[key] ?? false;

  void togglePhoto(String key) {
    _photoSelected[key] = !(_photoSelected[key] ?? false);
    notifyListeners();
  }

  // ── Submission ───────────────────────────────────────────────────────────
  bool _isSubmitting = false;
  bool get isSubmitting => _isSubmitting;

  Future<bool> submit() async {
    if (!(formKey.currentState?.validate() ?? false)) return false;
    
    // Check if required proofs are selected
    if (!_photoSelected['store']! || !_photoSelected['board']! || !_photoSelected['selfie']!) {
      return false;
    }

    _isSubmitting = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2));

    _isSubmitting = false;
    notifyListeners();
    return true;
  }

  @override
  void dispose() {
    storeNameCtrl.dispose();
    visitDateCtrl.dispose();
    super.dispose();
  }
}
