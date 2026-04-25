import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../core/services/api_service.dart';
import '../core/services/storage_service.dart';
import '../core/services/location_service.dart';

part 'service_providers.g.dart';

@Riverpod(keepAlive: true)
ApiService apiService(ApiServiceRef ref) {
  return ApiService();
}

@Riverpod(keepAlive: true)
StorageService storageService(StorageServiceRef ref) {
  return StorageService();
}

@Riverpod(keepAlive: true)
LocationService locationService(LocationServiceRef ref) {
  return LocationService();
}
