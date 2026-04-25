import 'dart:developer' as developer;
import '../../core/services/api_service.dart';
import '../../core/services/storage_service.dart';
import '../../core/services/token_service.dart';
import '../models/auth_models.dart';

class AuthRepository {
  final ApiService _apiService;
  final StorageService _storageService;
  final TokenService _tokenService;

  AuthRepository({
    required ApiService apiService,
    required StorageService storageService,
    required TokenService tokenService,
  })  : _apiService = apiService,
        _storageService = storageService,
        _tokenService = tokenService;

  Future<LoginResponse> login(String email, String password) async {
    try {
      final response = await _apiService.login(email, password);
      final loginResponse = LoginResponse.fromJson(response);

      // Extract and Save token securely
      final token = loginResponse.token;
      await _tokenService.saveToken(token);
      
      // Log token for debugging (as requested)
      developer.log('AuthRepository: Token extracted: $token', name: 'AUTH');

      // Save other user data
      await _storageService.saveUserId(loginResponse.id);
      
      // Ensure ApiService has the latest token for future requests
      _apiService.setToken(token);

      return loginResponse;
    } catch (e) {
      developer.log('AuthRepository: Login failed: $e', name: 'AUTH', error: e);
      rethrow;
    }
  }

  Future<ForgotPasswordResponse> forgotPassword(String identifier) async {
    try {
      final response = await _apiService.forgotPassword(identifier);
      return ForgotPasswordResponse.fromJson(response);
    } catch (e) {
      throw Exception('Forgot password failed: $e');
    }
  }

  Future<VerifyOtpResponse> verifyOtp(String identifier, String otp) async {
    try {
      final response = await _apiService.verifyOtp(identifier, otp);
      return VerifyOtpResponse.fromJson(response);
    } catch (e) {
      throw Exception('OTP verification failed: $e');
    }
  }

  Future<ChangePasswordResponse> changePassword(String newPassword) async {
    try {
      final token = await _tokenService.getToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }

      final response = await _apiService.changePassword(token, newPassword);
      return ChangePasswordResponse.fromJson(response);
    } catch (e) {
      throw Exception('Change password failed: $e');
    }
  }

  Future<void> resendOtp(String identifier) async {
    try {
      await _apiService.resendOtp(identifier);
    } catch (e) {
      throw Exception('Resend OTP failed: $e');
    }
  }

  Future<void> logout() async {
    await _tokenService.deleteToken();
    await _storageService.clearAll();
    _apiService.setToken(null);
  }

  Future<bool> isLoggedIn() async {
    final token = await _tokenService.getToken();
    return token != null && token.isNotEmpty;
  }

  Future<String?> getToken() async {
    return await _tokenService.getToken();
  }
}