import '../../core/services/api_service.dart';
import '../models/visit_models.dart';

class VisitRepository {
  final ApiService _apiService;

  VisitRepository({required ApiService apiService})
      : _apiService = apiService;

  Future<VisitResponse> createVisit(VisitRequest request) async {
    try {
      final response = await _apiService.createVisit(request.toJson());
      return VisitResponse.fromJson(response);
    } catch (e) {
      throw Exception('Failed to submit visit: $e');
    }
  }

  Future<List<VisitResponse>> getVisits() async {
    try {
      final response = await _apiService.getVisits();
      final List<dynamic> list = response as List<dynamic>;
      return list.map((json) => VisitResponse.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load visits: $e');
    }
  }

  Future<Map<String, dynamic>> getVisitDetail(String id) async {
    try {
      return await _apiService.getVisitById(id);
    } catch (e) {
      throw Exception('Failed to load visit details: $e');
    }
  }

  Future<List<FollowUpResponse>> getFollowUps() async {
    try {
      final response = await _apiService.getFollowUps();
      final List<dynamic> list = response as List<dynamic>;
      return list.map((json) => FollowUpResponse.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load follow-ups: $e');
    }
  }
}
