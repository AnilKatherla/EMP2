import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// ─────────────────────────────────────────────
// ENUMS
// ─────────────────────────────────────────────

enum VisitStatus {
  completed,
  partiallyCompleted,
  notInterested,
  needFollowUp,
}

enum NotInterestedReason {
  usingCompetitor,
  priceIssue,
  notRequired,
  ownerNotAvailable,
  other,
}

// ─────────────────────────────────────────────
// STORE VISIT VIEW MODEL
// ─────────────────────────────────────────────

class StoreVisitViewModel extends ChangeNotifier {
  // ── Form Key ─────────────────────────────────────────────────────────────
  final formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();

  // ── Basic Information ─────────────────────────────────────────────────────
  final storeNameCtrl = TextEditingController();
  final ownerNameCtrl = TextEditingController();
  final mobileCtrl    = TextEditingController();
  final addressCtrl   = TextEditingController();
  final gstCtrl       = TextEditingController();

  // ── Location ──────────────────────────────────────────────────────────────
  final pinCodeCtrl = TextEditingController();
  final cityCtrl    = TextEditingController();
  final stateCtrl   = TextEditingController();

  bool    _isGpsLoading   = false;
  String? _gpsCoordinates;

  bool    get isGpsLoading   => _isGpsLoading;
  String? get gpsCoordinates => _gpsCoordinates;

  Future<void> fetchGpsLocation() async {
    _isGpsLoading = true;
    notifyListeners();
    // Simulates a GPS fetch request — replace with geolocator in production
    await Future.delayed(const Duration(seconds: 2));
    _gpsCoordinates = '17.3850° N, 78.4867° E';
    _isGpsLoading = false;
    notifyListeners();
  }

  // ── Business Details (Installation & Onboarding) ──────────────────────────
  static const List<String> storeTypes = [
    'Restaurants', 'Food Court', 'Tiffin Center', 'Fast Food',
    'Kirana / General Store', 'Supermarket', 'Modern Kirana Store',
    'Catering', 'Bakery', 'Other',
  ];

  static const List<String> installationFailureReasons = [
    'Got error',
    'Asked me to come again',
    'Decision maker not available',
    'Not using smart phone',
    'Not interested in online purchase',
    'I have credit in the wholesale market',
    'Enter any other reason',
  ];

  String? _selectedStoreType;
  String? get selectedStoreType => _selectedStoreType;
  void setStoreType(String? val) {
    _selectedStoreType = val;
    if (val != 'Other') otherStoreTypeCtrl.clear();
    notifyListeners();
  }

  final monthlyPurchaseCtrl    = TextEditingController();
  final interestedProductsCtrl = TextEditingController();
  final otherStoreTypeCtrl     = TextEditingController();

  // 1. App Installed
  bool? _isAppInstalled;
  bool? get isAppInstalled => _isAppInstalled;
  String? _appNotInstalledReason;
  String? get appNotInstalledReason => _appNotInstalledReason;
  final appNotInstalledOtherCtrl = TextEditingController();

  void setAppInstalled(bool? val) {
    _isAppInstalled = val;
    if (val == true) {
      _appNotInstalledReason = null;
      appNotInstalledOtherCtrl.clear();
    }
    notifyListeners();
  }
  void setAppNotInstalledReason(String? val) {
    _appNotInstalledReason = val;
    notifyListeners();
  }

  // 2. Registration Completed
  bool? _isRegistrationCompleted;
  bool? get isRegistrationCompleted => _isRegistrationCompleted;
  final regNoReasonCtrl   = TextEditingController();
  final regFeedbackCtrl   = TextEditingController();

  void setRegistrationCompleted(bool? val) {
    _isRegistrationCompleted = val;
    if (val == true) regNoReasonCtrl.clear();
    if (val == false) regFeedbackCtrl.clear();
    notifyListeners();
  }

  // 3. App Training
  bool? _isAppTrainingProvided;
  bool? get isAppTrainingProvided => _isAppTrainingProvided;
  final trainingNoReasonCtrl = TextEditingController();
  final trainingFeedbackCtrl = TextEditingController();

  void setAppTrainingProvided(bool? val) {
    _isAppTrainingProvided = val;
    if (val == true) trainingNoReasonCtrl.clear();
    if (val == false) trainingFeedbackCtrl.clear();
    notifyListeners();
  }

  // 4. First Order Placed
  bool? _isOrderPlaced;
  bool? get isOrderPlaced => _isOrderPlaced;
  final orderNoReasonCtrl = TextEditingController();
  final orderFeedbackCtrl = TextEditingController();

  void setOrderPlaced(bool? val) {
    _isOrderPlaced = val;
    if (val == true) orderNoReasonCtrl.clear();
    if (val == false) orderFeedbackCtrl.clear();
    notifyListeners();
  }

  // ── Visit Status ──────────────────────────────────────────────────────────
  VisitStatus? _visitStatus;
  VisitStatus? get visitStatus => _visitStatus;

  void setVisitStatus(VisitStatus? status) {
    _visitStatus = status;
    if (status != VisitStatus.notInterested) _notInterestedReason = null;
    if (status != VisitStatus.needFollowUp) {
      _followUpDate = null;
      followUpNotesCtrl.clear();
    }
    notifyListeners();
  }

  // Not Interested reason
  NotInterestedReason? _notInterestedReason;
  NotInterestedReason? get notInterestedReason => _notInterestedReason;

  void setNotInterestedReason(NotInterestedReason? reason) {
    _notInterestedReason = reason;
    notifyListeners();
  }

  // Follow-up
  DateTime?              _followUpDate;
  DateTime?              get followUpDate => _followUpDate;
  final followUpNotesCtrl = TextEditingController();

  void setFollowUpDate(DateTime? date) {
    _followUpDate = date;
    notifyListeners();
  }

  // ── Visit Proof ─────────────────────────────────────────────────────────────
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
        imageQuality: 70,
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
    
    _isSubmitting = true;
    notifyListeners();

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    _isSubmitting = false;
    notifyListeners();
    return true;
  }

  // ── Dispose ───────────────────────────────────────────────────────────────
  @override
  void dispose() {
    storeNameCtrl.dispose();
    ownerNameCtrl.dispose();
    mobileCtrl.dispose();
    addressCtrl.dispose();
    gstCtrl.dispose();
    pinCodeCtrl.dispose();
    cityCtrl.dispose();
    stateCtrl.dispose();
    monthlyPurchaseCtrl.dispose();
    interestedProductsCtrl.dispose();
    appNotInstalledOtherCtrl.dispose();
    regNoReasonCtrl.dispose();
    regFeedbackCtrl.dispose();
    trainingNoReasonCtrl.dispose();
    trainingFeedbackCtrl.dispose();
    orderNoReasonCtrl.dispose();
    orderFeedbackCtrl.dispose();
    followUpNotesCtrl.dispose();
    otherStoreTypeCtrl.dispose();
    super.dispose();
  }
}
