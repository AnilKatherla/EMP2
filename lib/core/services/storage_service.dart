import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as developer;

/// Handles non-sensitive persistent storage like User ID, Device ID, etc.
/// Sensitive data like JWT tokens are handled by TokenService.
class StorageService {
  static const String _userIdKey = 'user_id';
  static const String _deviceIdKey = 'device_id';

  Future<void> saveUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userIdKey, userId);
    developer.log('StorageService: User ID saved', name: 'STORAGE');
  }

  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userIdKey);
  }

  Future<void> saveDeviceId(String deviceId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_deviceIdKey, deviceId);
    developer.log('StorageService: Device ID saved', name: 'STORAGE');
  }

  Future<String?> getDeviceId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_deviceIdKey);
  }

  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    developer.log('StorageService: All cleared', name: 'STORAGE');
  }
}