import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/models/auth_models.dart';
import '../../providers/repository_providers.dart';

part 'auth_provider.g.dart';

class AuthState {
  final bool isLoading;
  final String? errorMessage;

  const AuthState({
    this.isLoading = false,
    this.errorMessage,
  });

  AuthState copyWith({
    bool? isLoading,
    String? errorMessage,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

@riverpod
class Auth extends _$Auth {
  @override
  AuthState build() {
    return const AuthState();
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    if (email.trim().isEmpty || password.isEmpty) {
      state = state.copyWith(errorMessage: 'Please fill in all fields.');
      return false;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final repository = ref.read(authRepositoryProvider);
      await repository.login(email.trim(), password);
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: _friendlyError(e.toString()),
      );
      return false;
    }
  }

  Future<bool> verifyOTP(OTPModel model) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final repository = ref.read(authRepositoryProvider);
      await repository.verifyOtp(model.email, model.otp);
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: _friendlyError(e.toString()),
      );
      return false;
    }
  }

  Future<bool> resetPassword(ResetPasswordModel model) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final repository = ref.read(authRepositoryProvider);
      await repository.changePassword(model.newPassword);
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: _friendlyError(e.toString()),
      );
      return false;
    }
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

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
