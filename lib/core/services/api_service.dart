import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;
import '../api_constants.dart';
import 'token_service.dart';

class ApiService {
  String? _token;
  final TokenService _tokenService;
  
  /// Callback triggered when a 401 Unauthorized response is received.
  Function? onUnauthorized;

  ApiService(this._tokenService);

  void setToken(String? token) {
    _token = token;
    if (token != null) {
      developer.log('ApiService: Token updated in memory', name: 'API');
    }
  }

  Map<String, String> get _headers {
    if (_token == null || _token!.isEmpty) {
      developer.log('ApiService: Warning - Authorization token is missing', name: 'API');
    }
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (_token != null && _token!.isNotEmpty) 'Authorization': 'Bearer $_token',
    };
  }

  /// Helper to handle common response logic like 401 errors.
  dynamic _handleResponse(http.Response response) {
    developer.log('ApiService: Response [${response.statusCode}] from ${response.request?.url}', name: 'API');
    
    if (response.statusCode == 401) {
      developer.log('ApiService: 401 Unauthorized detected. Clearing token...', name: 'API');
      _token = null;
      _tokenService.deleteToken();
      if (onUnauthorized != null) {
        onUnauthorized!();
      }
      throw Exception('Unauthorized: Please login again.');
    }

    final data = jsonDecode(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return data;
    } else {
      throw Exception(data['message'] ?? 'Request failed with status: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    developer.log('ApiService: Sending login request for $email', name: 'API');
    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.login}'),
      headers: _headers,
      body: jsonEncode({
        'email': email.toLowerCase(),
        'password': password,
        'portal': 'EMPLOYEE',
      }),
    );

    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> getDashboardStats() async {
    developer.log('ApiService: Fetching dashboard stats', name: 'API');
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.employeeStats}'),
      headers: _headers,
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> createVisit(Map<String, dynamic> visitData) async {
    developer.log('ApiService: Creating visit', name: 'API');
    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.employeeVisits}'),
      headers: _headers,
      body: jsonEncode(visitData),
    );
    return _handleResponse(response);
  }

  Future<dynamic> getVisits() async {
    developer.log('ApiService: Fetching visits', name: 'API');
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.employeeVisits}'),
      headers: _headers,
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> getVisitById(String id) async {
    developer.log('ApiService: Fetching visit details for ID: $id', name: 'API');
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.employeeVisits}/$id'),
      headers: _headers,
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> forgotPassword(String identifier) async {
    developer.log('ApiService: Sending forgot password request', name: 'API');
    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}/auth/forgot-password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'identifier': identifier,
      }),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> verifyOtp(String identifier, String otp) async {
    developer.log('ApiService: Verifying OTP', name: 'API');
    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}/auth/verify-otp'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'identifier': identifier,
        'otp': otp,
      }),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> changePassword(String token, String newPassword) async {
    developer.log('ApiService: Changing password', name: 'API');
    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}/auth/change-password'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'newPassword': newPassword,
      }),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> resendOtp(String identifier) async {
    developer.log('ApiService: Resending OTP', name: 'API');
    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}/auth/resend-otp'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'identifier': identifier,
      }),
    );
    return _handleResponse(response);
  }

  Future<dynamic> getFollowUps() async {
    developer.log('ApiService: Fetching follow-ups', name: 'API');
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.employeeFollowUps}'),
      headers: _headers,
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> startTracking() async {
    developer.log('ApiService: Starting tracking', name: 'API');
    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.trackingStart}'),
      headers: _headers,
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> stopTracking() async {
    developer.log('ApiService: Stopping tracking', name: 'API');
    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.trackingStop}'),
      headers: _headers,
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> getTrackingStatus() async {
    developer.log('ApiService: Fetching tracking status', name: 'API');
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.trackingStatus}'),
      headers: _headers,
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> pingTracking(Map<String, dynamic> data) async {
    developer.log('ApiService: Pinging tracking', name: 'API');
    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}/employee/tracking/ping'),
      headers: _headers,
      body: jsonEncode(data),
    );
    return _handleResponse(response);
  }
}