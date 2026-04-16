import 'package:flutter/material.dart';

// ─────────────────────────────────────────────
// ORDER VIEW MODEL
// ─────────────────────────────────────────────

class OrderViewModel extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();

  // ── Controllers ──────────────────────────────────────────────────────────
  final storeNameCtrl  = TextEditingController();
  final orderValueCtrl = TextEditingController();
  final itemsCountCtrl  = TextEditingController();

  // ── Date ─────────────────────────────────────────────────────────────────
  DateTime _orderDate = DateTime.now();
  DateTime get orderDate => _orderDate;

  void setOrderDate(DateTime date) {
    _orderDate = date;
    notifyListeners();
  }

  // ── Payment Mode ─────────────────────────────────────────────────────────
  static const paymentModes = ['Cash', 'UPI', 'Card', 'Net Banking', 'Credit'];
  String? _selectedPaymentMode;
  String? get selectedPaymentMode => _selectedPaymentMode;

  void setPaymentMode(String? val) {
    _selectedPaymentMode = val;
    notifyListeners();
  }

  // ── Order Status ─────────────────────────────────────────────────────────
  static const orderStatuses = ['Pending', 'Processed', 'Delivered', 'Cancelled'];
  String? _selectedStatus = 'Pending';
  String? get selectedStatus => _selectedStatus;

  void setStatus(String? val) {
    _selectedStatus = val;
    notifyListeners();
  }

  // ── Submission State ─────────────────────────────────────────────────────
  bool _isSubmitting = false;
  bool get isSubmitting => _isSubmitting;

  Future<bool> submit() async {
    if (!(formKey.currentState?.validate() ?? false)) return false;
    if (_selectedPaymentMode == null) return false;

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
    orderValueCtrl.dispose();
    itemsCountCtrl.dispose();
    super.dispose();
  }
}
