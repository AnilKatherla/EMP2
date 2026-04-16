import '../../core/services/api_service.dart';
import '../../core/services/storage_service.dart';
import '../models/auth_models.dart';

class AuthRepository {
  final ApiService _apiService;
  final StorageService _storageService;

  AuthRepository({
    required ApiService apiService,
    required StorageService storageService,
  })  : _apiService = apiService,
        _storageService = storageService;

  Future<LoginResponse> login(String identifier, String password) async {
    try {
      final response = await _apiService.login(identifier, password);
      final loginResponse = LoginResponse.fromJson(response);

      // Save token and user data
      await _storageService.saveToken(loginResponse.token);
      await _storageService.saveUserId(loginResponse.userId);

      // Mock device binding
      await _storageService.saveDeviceId('device_${DateTime.now().millisecondsSinceEpoch}');

      return loginResponse;
    } catch (e) {
      throw Exception('Login failed: $e');
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
      final token = await _storageService.getToken();
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
    await _storageService.clearAll();
  }

  Future<bool> isLoggedIn() async {
    return await _storageService.isLoggedIn();
  }

  Future<String?> getToken() async {
    return await _storageService.getToken();
  }
}