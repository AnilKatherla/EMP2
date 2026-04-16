import 'package:flutter/material.dart';

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

  // ── Business Details ──────────────────────────────────────────────────────
  static const List<String> storeTypes = [
    'Restaurants',
    'Food Court',
    'Tiffin Center',
    'Fast Food',
    'Kirana / General Store',
    'Supermarket',
    'Modern Kirana Store',
    'Catering',
    'Bakery',
  ];

  String? _selectedStoreType;
  String? get selectedStoreType => _selectedStoreType;

  void setStoreType(String? val) {
    _selectedStoreType = val;
    notifyListeners();
  }

  final monthlyPurchaseCtrl    = TextEditingController();
  final interestedProductsCtrl = TextEditingController();

  bool _appInstalled = false;
  bool _res          = false;
  bool _orderPlaced  = false;
  bool _appTraining  = false;

  bool get appInstalled => _appInstalled;
  bool get res          => _res;
  bool get orderPlaced  => _orderPlaced;
  bool get appTraining  => _appTraining;

  void toggleAppInstalled(bool val) { _appInstalled = val; notifyListeners(); }
  void toggleRes(bool val)          { _res = val;          notifyListeners(); }
  void toggleOrderPlaced(bool val)  { _orderPlaced = val;  notifyListeners(); }
  void toggleAppTraining(bool val)  { _appTraining = val;  notifyListeners(); }

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

  // ── Visit Proof ───────────────────────────────────────────────────────────
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
    followUpNotesCtrl.dispose();
    super.dispose();
  }
}
