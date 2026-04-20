import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// ─────────────────────────────────────────────
// VISIT HISTORY VIEW MODEL (With Visit Proof)
// ─────────────────────────────────────────────

class VisitHistoryViewModel extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();

  // ── Form Controllers ─────────────────────────────────────────────────────
  final storeNameCtrl = TextEditingController();
  final visitDateCtrl  = TextEditingController(); // Or a date picker

  // ── Visit Proof (Store actual image files) ───────────────────────────────
  final Map<String, XFile?> _photos = {
    'store':  null,
    'board':  null,
    'owner':  null,
    'selfie': null,
  };

  bool isPhotoSelected(String key) => _photos[key] != null;
  XFile? getPhoto(String key) => _photos[key];

  Future<void> pickPhoto(String key) async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 70, // Optimize size
      );
      
      if (photo != null) {
        _photos[key] = photo;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error picking photo: $e');
    }
  }

  void removePhoto(String key) {
    _photos[key] = null;
    notifyListeners();
  }

  // ── Submission ───────────────────────────────────────────────────────────
  bool _isSubmitting = false;
  bool get isSubmitting => _isSubmitting;

  Future<bool> submit() async {
    if (!(formKey.currentState?.validate() ?? false)) return false;
    
    // Check if required proofs are selected
    if (_photos['store'] == null || _photos['board'] == null || _photos['selfie'] == null) {
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
