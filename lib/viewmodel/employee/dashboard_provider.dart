import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/models/dashboard_models.dart';
import '../../data/models/visit_models.dart';
import '../../providers/repository_providers.dart';
import '../../providers/service_providers.dart';

part 'dashboard_provider.g.dart';

class DashboardState {
  final DashboardStats? stats;
  final List<VisitResponse> recentVisits;
  final bool isLoading;
  final String? errorMessage;
  final bool isTracking;

  const DashboardState({
    this.stats,
    this.recentVisits = const [],
    this.isLoading = false,
    this.errorMessage,
    this.isTracking = false,
  });

  DashboardState copyWith({
    DashboardStats? stats,
    List<VisitResponse>? recentVisits,
    bool? isLoading,
    String? errorMessage,
    bool? isTracking,
  }) {
    return DashboardState(
      stats: stats ?? this.stats,
      recentVisits: recentVisits ?? this.recentVisits,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      isTracking: isTracking ?? this.isTracking,
    );
  }
}

@riverpod
class Dashboard extends _$Dashboard {
  Timer? _pingTimer;

  @override
  DashboardState build() {
    ref.onDispose(() {
      _pingTimer?.cancel();
    });
    return const DashboardState();
  }

  Future<void> fetchDashboardData() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final dashRepo = ref.read(dashboardRepositoryProvider);
      final visitRepo = ref.read(visitRepositoryProvider);

      final results = await Future.wait([
        dashRepo.getStats(),
        visitRepo.getVisits(),
        dashRepo.getTrackingStatus(),
      ]);

      final stats = results[0] as DashboardStats;
      final allVisits = results[1] as List<VisitResponse>;
      final recentVisits = allVisits.take(5).toList();
      
      final trackingStatus = results[2] as Map<String, dynamic>;
      final isTracking = trackingStatus['isTracking'] ?? false;

      if (isTracking) {
        _startPingTimer();
      } else {
        _stopPingTimer();
      }
      
      state = state.copyWith(
        stats: stats,
        recentVisits: recentVisits,
        isTracking: isTracking,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        errorMessage: e.toString(),
        isLoading: false,
      );
    }
  }

  Future<void> toggleTracking() async {
    state = state.copyWith(isLoading: true);

    try {
      final dashRepo = ref.read(dashboardRepositoryProvider);
      final locService = ref.read(locationServiceProvider);

      if (!state.isTracking) {
        // Punch In
        await locService.getCurrentLocation(); // Permission check
        final success = await dashRepo.startTracking();
        if (success) {
          state = state.copyWith(isTracking: true);
          _startPingTimer();
        }
      } else {
        // Punch Out
        final success = await dashRepo.stopTracking();
        if (success) {
          state = state.copyWith(isTracking: false);
          _stopPingTimer();
        }
      }
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        errorMessage: e.toString(),
        isLoading: false,
      );
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
    if (!state.isTracking) return;

    try {
      final dashRepo = ref.read(dashboardRepositoryProvider);
      final locService = ref.read(locationServiceProvider);
      final position = await locService.getCurrentLocation();
      if (position != null) {
        await dashRepo.pingTracking({
          'latitude': position.latitude,
          'longitude': position.longitude,
          'accuracy': position.accuracy,
          'timestamp': DateTime.now().toIso8601String(),
          'status': 'active',
        });
      }
    } catch (e) {
      // ignore
    }
  }

  void refresh() {
    fetchDashboardData();
  }
}
