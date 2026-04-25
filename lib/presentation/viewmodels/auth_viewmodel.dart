import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../data/services/storage_service.dart';
import '../../../providers/base_providers.dart';

part 'auth_viewmodel.g.dart';

enum AuthStatus { initial, authenticated, unauthenticated }

class AuthState {
  final AuthStatus status;
  final String? errorMessage;

  AuthState({required this.status, this.errorMessage});

  AuthState copyWith({AuthStatus? status, String? errorMessage}) {
    return AuthState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

@Riverpod(keepAlive: true)
class AuthViewModel extends _$AuthViewModel {
  late StorageService _storageService;

  @override
  FutureOr<AuthState> build() async {
    _storageService = ref.watch(storageServiceProvider);
    return _checkAuthStatus();
  }

  Future<AuthState> _checkAuthStatus() async {
    final token = await _storageService.getToken();
    if (token != null) {
      return AuthState(status: AuthStatus.authenticated);
    }
    return AuthState(status: AuthStatus.unauthenticated);
  }

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final api = ref.read(apiServiceProvider);
      final response = await api.post('/login', data: {
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200) {
        final token = response.data['token'];
        await _storageService.saveToken(token);
        state = AsyncValue.data(AuthState(status: AuthStatus.authenticated));
      } else {
        state = AsyncValue.data(AuthState(
          status: AuthStatus.unauthenticated,
          errorMessage: 'Login failed: ${response.data['message']}',
        ));
      }
    } catch (e) {
      state = AsyncValue.data(AuthState(
        status: AuthStatus.unauthenticated,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> logout() async {
    await _storageService.deleteToken();
    state = AsyncValue.data(AuthState(status: AuthStatus.unauthenticated));
  }
}
