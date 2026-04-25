import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../core/constants/app_constants.dart';

class StorageService {
  final _storage = const FlutterSecureStorage();

  Future<void> saveToken(String token) async {
    await _storage.write(key: AppConstants.tokenKey, value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: AppConstants.tokenKey);
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: AppConstants.tokenKey);
  }

  Future<void> saveUserData(String userData) async {
    await _storage.write(key: AppConstants.userKey, value: userData);
  }

  Future<String?> getUserData() async {
    return await _storage.read(key: AppConstants.userKey);
  }

  Future<void> saveUserId(String userId) async {
    await _storage.write(key: 'user_id', value: userId);
  }

  Future<String?> getUserId() async {
    return await _storage.read(key: 'user_id');
  }

  Future<void> saveDeviceId(String deviceId) async {
    await _storage.write(key: 'device_id', value: deviceId);
  }

  Future<String?> getDeviceId() async {
    return await _storage.read(key: 'device_id');
  }

  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
