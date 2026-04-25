import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:developer' as developer;

class TokenService {
  final _storage = const FlutterSecureStorage();
  static const String _tokenKey = 'auth_token';

  /// Saves the JWT token securely.
  Future<void> saveToken(String token) async {
    try {
      await _storage.write(key: _tokenKey, value: token);
      developer.log('TokenService: Token saved successfully', name: 'AUTH');
    } catch (e) {
      developer.log('TokenService: Error saving token: $e', name: 'AUTH', error: e);
    }
  }

  /// Retrieves the stored JWT token.
  Future<String?> getToken() async {
    try {
      final token = await _storage.read(key: _tokenKey);
      if (token != null && token.isNotEmpty) {
        developer.log('TokenService: Token fetched successfully', name: 'AUTH');
      } else {
        developer.log('TokenService: No token found or token is empty', name: 'AUTH');
      }
      return token;
    } catch (e) {
      developer.log('TokenService: Error fetching token: $e', name: 'AUTH', error: e);
      return null;
    }
  }

  /// Deletes the stored JWT token.
  Future<void> deleteToken() async {
    try {
      await _storage.delete(key: _tokenKey);
      developer.log('TokenService: Token deleted successfully', name: 'AUTH');
    } catch (e) {
      developer.log('TokenService: Error deleting token: $e', name: 'AUTH', error: e);
    }
  }
}
