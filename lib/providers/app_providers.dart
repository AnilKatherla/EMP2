import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import '../core/services/api_service.dart';
import '../core/services/storage_service.dart';
import '../core/services/token_service.dart';
import '../core/services/location_service.dart';
import '../data/repositories/auth_repository.dart';
import '../data/repositories/dashboard_repository.dart';
import '../data/repositories/visit_repository.dart';
import '../viewmodel/employee/dashboard_viewmodel.dart';
import '../viewmodel/auth/auth_viewmodel.dart';
import '../viewmodel/history/history_viewmodel.dart';

class AppProviders {
  static List<SingleChildWidget> getProviders({
    required ApiService apiService,
    required StorageService storageService,
    required TokenService tokenService,
    required LocationService locationService,
  }) {
    return [
      // ── Services ──────────────────────────────────────────────────────────
      Provider<ApiService>.value(value: apiService),
      Provider<StorageService>.value(value: storageService),
      Provider<TokenService>.value(value: tokenService),
      Provider<LocationService>.value(value: locationService),

      // ── Repositories ──────────────────────────────────────────────────────
      ProxyProvider<ApiService, AuthRepository>(
        update: (_, api, __) => AuthRepository(
          apiService: api,
          storageService: storageService,
          tokenService: tokenService,
        ),
      ),
      
      ProxyProvider<ApiService, DashboardRepository>(
        update: (_, api, __) => DashboardRepository(
          apiService: api,
        ),
      ),

      ProxyProvider<ApiService, VisitRepository>(
        update: (_, api, __) => VisitRepository(
          apiService: api,
        ),
      ),

      // ── ViewModels ────────────────────────────────────────────────────────
      ChangeNotifierProxyProvider<AuthRepository, AuthViewModel>(
        create: (ctx) => AuthViewModel(
          repository: ctx.read<AuthRepository>(),
        ),
        update: (_, repo, prev) =>
            prev ?? AuthViewModel(repository: repo),
      ),

      ChangeNotifierProxyProvider3<DashboardRepository, VisitRepository, LocationService, DashboardViewModel>(
        create: (ctx) => DashboardViewModel(
          repository: ctx.read<DashboardRepository>(),
          visitRepository: ctx.read<VisitRepository>(),
          locationService: ctx.read<LocationService>(),
        ),
        update: (_, dashRepo, visitRepo, locService, prev) =>
            prev ?? DashboardViewModel(
              repository: dashRepo,
              visitRepository: visitRepo,
              locationService: locService,
            ),
      ),
      
      ChangeNotifierProxyProvider<VisitRepository, VisitHistoryViewModel>(
        create: (ctx) => VisitHistoryViewModel(
          repository: ctx.read<VisitRepository>(),
        ),
        update: (_, repo, prev) =>
            prev ?? VisitHistoryViewModel(repository: repo),
      ),
    ];
  }
}
