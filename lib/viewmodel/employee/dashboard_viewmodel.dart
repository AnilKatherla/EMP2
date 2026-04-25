import 'dart:async';
import 'package:flutter/material.dart';
import '../../data/models/dashboard_models.dart';
import '../../data/models/visit_models.dart';
import '../../data/repositories/dashboard_repository.dart';
import '../../data/repositories/visit_repository.dart';
import '../../core/services/location_service.dart';

class DashboardViewModel extends ChangeNotifier {
  final DashboardRepository _repository;
  final VisitRepository _visitRepository;
  final LocationService _locationService;

  DashboardViewModel({
    required DashboardRepository repository,
    required VisitRepository visitRepository,
    required LocationService locationService,
  })  : _repository = repository,
        _visitRepository = visitRepository,
        _locationService = locationService;

  DashboardStats? _stats;
  List<VisitResponse> _recentVisits = [];
  bool _isLoading = false;
  String? _errorMessage;
  bool _isTracking = false;
  Timer? _pingTimer;

  DashboardStats? get stats => _stats;
  List<VisitResponse> get recentVisits => _recentVisits;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isTracking => _isTracking;

  Future<void> fetchDashboardData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        _repository.getStats(),
        _visitRepository.getVisits(),
        _repository.getTrackingStatus(),
      ]);

      _stats = results[0] as DashboardStats;
      final allVisits = results[1] as List<VisitResponse>;
      // Take only recent 5
      _recentVisits = allVisits.take(5).toList();
      
      final trackingStatus = results[2] as Map<String, dynamic>;
      _isTracking = trackingStatus['isTracking'] ?? false;

      if (_isTracking) {
        _startPingTimer();
      } else {
        _stopPingTimer();
      }
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleTracking() async {
    _isLoading = true;
    notifyListeners();

    try {
      if (!_isTracking) {
        // Punch In
        await _locationService.getCurrentLocation(); // Permission check
        final success = await _repository.startTracking();
        if (success) {
          _isTracking = true;
          _startPingTimer();
        }
      } else {
        // Punch Out
        final success = await _repository.stopTracking();
        if (success) {
          _isTracking = false;
          _stopPingTimer();
        }
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  void _startPingTimer() {
    _pingTimer?.cancel();
    // Ping every 2 minutes
    _pingTimer = Timer.periodic(const Duration(minutes: 2), (timer) {
      _pingLocation();
    });
    // Initial ping
    _pingLocation();
  }

  void _stopPingTimer() {
    _pingTimer?.cancel();
    _pingTimer = null;
  }

  Future<void> _pingLocation() async {
    if (!_isTracking) return;

    try {
      final position = await _locationService.getCurrentLocation();
      if (position != null) {
        await _repository.pingTracking({
          'latitude': position.latitude,
          'longitude': position.longitude,
          'accuracy': position.accuracy,
          'timestamp': DateTime.now().toIso8601String(),
          'status': 'active',
        });
      }
    } catch (e) {
      debugPrint('Periodic location ping failed: $e');
    }
  }

  void refresh() {
    fetchDashboardData();
  }

  @override
  void dispose() {
    _pingTimer?.cancel();
    super.dispose();
  }
}
