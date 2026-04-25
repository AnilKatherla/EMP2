import 'package:flutter/material.dart';
import 'dart:developer' as developer;
import '../../data/models/auth_models.dart';
import '../../data/repositories/auth_repository.dart';

/// AuthViewModel — manages authentication state for the login flow.
///
/// Follows MVVM: no Navigator / BuildContext usage inside business logic.
/// UI listens via [ChangeNotifier] and navigates based on exposed state.
class AuthViewModel extends ChangeNotifier {
  final AuthRepository _repository;

  AuthViewModel({required AuthRepository repository})
      : _repository = repository;

  // ── State ──────────────────────────────────────────────────────────────────
  bool    _isLoading    = false;
  String? _errorMessage;

  bool    get isLoading    => _isLoading;
  String? get errorMessage => _errorMessage;

  // ── Login ──────────────────────────────────────────────────────────────────

  /// Authenticates the user with [email] and [password].
  ///
  /// Returns `true` on success, `false` on failure.
  /// On success, the token is saved securely by the repository.
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    if (email.trim().isEmpty || password.isEmpty) {
      _errorMessage = 'Please fill in all fields.';
      notifyListeners();
      return false;
    }

    _setLoading(true);
    _errorMessage = null;

    try {
      developer.log('AuthViewModel: Initiating login for $email', name: 'AUTH');
      await _repository.login(email.trim(), password);
      _setLoading(false);
      developer.log('AuthViewModel: Login successful', name: 'AUTH');
      return true;
    } catch (e) {
      developer.log('AuthViewModel: Login failed: $e', name: 'AUTH', error: e);
      _errorMessage = _friendlyError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  /// Checks if the user is currently logged in (token exists).
  Future<bool> checkLoginStatus() async {
    final isLoggedIn = await _repository.isLoggedIn();
    developer.log('AuthViewModel: Checking login status: ${isLoggedIn ? "Logged In" : "Logged Out"}', name: 'AUTH');
    return isLoggedIn;
  }

  /// Logs out the user and clears all session data.
  Future<void> logout() async {
    developer.log('AuthViewModel: Logging out...', name: 'AUTH');
    await _repository.logout();
    notifyListeners();
  }

  // ── Verify OTP ─────────────────────────────────────────────────────────────

  Future<bool> verifyOTP(OTPModel model) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      await _repository.verifyOtp(model.email, model.otp);
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = _friendlyError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  // ── Reset Password ─────────────────────────────────────────────────────────

  Future<bool> resetPassword(ResetPasswordModel model) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      await _repository.changePassword(model.newPassword);
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = _friendlyError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// Converts raw exception messages into user-friendly strings.
  String _friendlyError(String raw) {
    if (raw.contains('401') || raw.contains('Unauthorized')) {
      return 'Invalid email or password. Please try again.';
    }
    if (raw.contains('SocketException') || raw.contains('network')) {
      return 'No internet connection. Please check your network.';
    }
    return 'Something went wrong. Please try again.';
  }
}
