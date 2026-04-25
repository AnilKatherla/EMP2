import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/services/api_service.dart';
import '../data/services/storage_service.dart';

part 'base_providers.g.dart';

@Riverpod(keepAlive: true)
StorageService storageService(StorageServiceRef ref) {
  return StorageService();
}

@Riverpod(keepAlive: true)
ApiService apiService(ApiServiceRef ref) {
  final storage = ref.watch(storageServiceProvider);
  return ApiService(storage);
}
