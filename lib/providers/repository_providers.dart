import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'service_providers.dart';
import '../data/repositories/auth_repository.dart';
import '../data/repositories/dashboard_repository.dart';
import '../data/repositories/visit_repository.dart';

part 'repository_providers.g.dart';

@Riverpod(keepAlive: true)
AuthRepository authRepository(AuthRepositoryRef ref) {
  final apiService = ref.watch(apiServiceProvider);
  final storageService = ref.watch(storageServiceProvider);
  return AuthRepository(
    apiService: apiService,
    storageService: storageService,
  );
}

@Riverpod(keepAlive: true)
DashboardRepository dashboardRepository(DashboardRepositoryRef ref) {
  final apiService = ref.watch(apiServiceProvider);
  return DashboardRepository(apiService: apiService);
}

@Riverpod(keepAlive: true)
VisitRepository visitRepository(VisitRepositoryRef ref) {
  final apiService = ref.watch(apiServiceProvider);
  return VisitRepository(apiService: apiService);
}
