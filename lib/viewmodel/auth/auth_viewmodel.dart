import 'package:flutter/material.dart';
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

  /// Authenticates the user with [identifier] and [password].
  ///
  /// Returns `true` on success, `false` on failure.
  /// On success, navigation is handled by the caller (UI layer).
  Future<bool> login({
    required BuildContext context,
    required String identifier,
    required String password,
  }) async {
    if (identifier.trim().isEmpty || password.isEmpty) {
      _errorMessage = 'Please fill in all fields.';
      notifyListeners();
      return false;
    }

    _setLoading(true);
    _errorMessage = null;

    try {
      await _repository.login(identifier.trim(), password);
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = _friendlyError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  // ── Verify OTP ─────────────────────────────────────────────────────────────

  /// Verifies the OTP for the given [model.email].
  ///
  /// Returns `true` on success. Navigation is handled by the caller.
  Future<bool> verifyOTP(BuildContext context, OTPModel model) async {
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

  /// Resets the password for [model.email] to [model.newPassword].
  ///
  /// Returns `true` on success. Navigation is handled by the caller.
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
