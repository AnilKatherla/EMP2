import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/models/visit_models.dart';
import '../../data/repositories/visit_repository.dart';

// ─────────────────────────────────────────────
// VISIT HISTORY VIEW MODEL
// ─────────────────────────────────────────────

class VisitHistoryViewModel extends ChangeNotifier {
  final VisitRepository _repository;

  VisitHistoryViewModel({required VisitRepository repository})
      : _repository = repository;

  final formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();

  List<VisitResponse> _visits = [];
  String _searchQuery = '';

  List<VisitResponse> get visits {
    if (_searchQuery.isEmpty) return _visits;
    return _visits.where((v) => v.storeName.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> fetchVisits() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _visits = await _repository.getVisits();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

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
