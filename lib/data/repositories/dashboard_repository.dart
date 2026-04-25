import 'package:flutter/foundation.dart';
import '../../core/services/api_service.dart';
import '../models/dashboard_models.dart';

class DashboardRepository {
  final ApiService _apiService;

  DashboardRepository({required ApiService apiService})
      : _apiService = apiService;

  Future<DashboardStats> getStats() async {
    try {
      final response = await _apiService.getDashboardStats();
      return DashboardStats.fromJson(response);
    } catch (e) {
      throw Exception('Failed to load dashboard data: $e');
    }
  }

  Future<bool> startTracking() async {
    try {
      final response = await _apiService.startTracking();
      return response['message'] == 'Tracking started' || response['message'] == 'Tracking already active';
    } catch (e) {
      throw Exception('Failed to start tracking: $e');
    }
  }

  Future<bool> stopTracking() async {
    try {
      final response = await _apiService.stopTracking();
      return response['message'] == 'Tracking stopped';
    } catch (e) {
      throw Exception('Failed to stop tracking: $e');
    }
  }

  Future<Map<String, dynamic>> getTrackingStatus() async {
    try {
      return await _apiService.getTrackingStatus();
    } catch (e) {
      throw Exception('Failed to fetch tracking status: $e');
    }
  }

  Future<void> pingTracking(Map<String, dynamic> data) async {
    try {
      await _apiService.pingTracking(data);
    } catch (e) {
      // Fail silently for pings to avoid interrupting user flow
      debugPrint('Ping failed: $e');
    }
  }
}
