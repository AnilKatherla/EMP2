import 'package:flutter/material.dart';

// ─────────────────────────────────────────────
// BUSINESS COLLABORATION VIEW MODEL
// ─────────────────────────────────────────────

class BusinessCollaborationViewModel extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();

  // ── Controllers ──────────────────────────────────────────────────────────
  final orgNameCtrl       = TextEditingController();
  final contactPersonCtrl = TextEditingController();
  final oppValueCtrl      = TextEditingController();
  final notesCtrl         = TextEditingController();

  // ── Collaboration Type ───────────────────────────────────────────────────
  static const types = ['Partnership', 'Association', 'Distributor', 'Warehouse'];
  String? _selectedType;
  String? get selectedType => _selectedType;

  void setType(String? val) {
    _selectedType = val;
    notifyListeners();
  }

  // ── Submission State ─────────────────────────────────────────────────────
  bool _isSubmitting = false;
  bool get isSubmitting => _isSubmitting;

  Future<bool> submit() async {
    if (!(formKey.currentState?.validate() ?? false)) return false;
    if (_selectedType == null) return false;

    _isSubmitting = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2));

    _isSubmitting = false;
    notifyListeners();
    return true;
  }

  @override
  void dispose() {
    orgNameCtrl.dispose();
    contactPersonCtrl.dispose();
    oppValueCtrl.dispose();
    notesCtrl.dispose();
    super.dispose();
  }
}
