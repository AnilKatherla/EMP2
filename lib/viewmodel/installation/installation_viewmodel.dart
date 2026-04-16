import 'package:flutter/material.dart';

// ─────────────────────────────────────────────
// APP INSTALLATION VIEW MODEL
// ─────────────────────────────────────────────

class AppInstallationViewModel extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();

  // ── Controllers ──────────────────────────────────────────────────────────
  final storeNameCtrl  = TextEditingController();
  final ownerNameCtrl  = TextEditingController();
  final phoneCtrl      = TextEditingController();

  // ── Selections ───────────────────────────────────────────────────────────
  static const apps = ['ReatchAll Retailer App', 'VillagKart Customer App'];
  String? _selectedApp;
  String? get selectedApp => _selectedApp;

  bool _isTrainingCompleted = false;
  bool get isTrainingCompleted => _isTrainingCompleted;

  bool _isFirstOrderPlaced = false;
  bool get isFirstOrderPlaced => _isFirstOrderPlaced;

  // ── Setters ──────────────────────────────────────────────────────────────
  void setApp(String? val) {
    _selectedApp = val;
    notifyListeners();
  }

  void toggleTraining(bool val) {
    _isTrainingCompleted = val;
    notifyListeners();
  }

  void toggleFirstOrder(bool val) {
    _isFirstOrderPlaced = val;
    notifyListeners();
  }

  // ── Submission State ─────────────────────────────────────────────────────
  bool _isSubmitting = false;
  bool get isSubmitting => _isSubmitting;

  Future<bool> submit() async {
    if (!(formKey.currentState?.validate() ?? false)) return false;
    if (_selectedApp == null) return false;

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
    ownerNameCtrl.dispose();
    phoneCtrl.dispose();
    super.dispose();
  }
}
