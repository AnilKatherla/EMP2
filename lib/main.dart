import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/services/api_service.dart';
import 'core/services/storage_service.dart';
import 'core/services/token_service.dart';
import 'core/services/location_service.dart';
import 'core/theme/app_theme.dart';
import 'routes/app_routes.dart';
import 'providers/app_providers.dart';
import 'view/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final tokenService = TokenService();
  final storageService = StorageService();
  final apiService = ApiService(tokenService);
  final locationService = LocationService();
  
  // Load stored token on startup and initialize ApiService
  final token = await tokenService.getToken();
  if (token != null) {
    apiService.setToken(token);
  }

  // Setup global unauthorized (401) handling
  apiService.onUnauthorized = () {
    AppRoutes.navigatorKey.currentState?.pushNamedAndRemoveUntil(
      AppRoutes.login,
      (route) => false,
    );
  };
  
  runApp(TrackForceApp(
    apiService: apiService,
    storageService: storageService,
    tokenService: tokenService,
    locationService: locationService,
  ));
}

class TrackForceApp extends StatelessWidget {
  final ApiService apiService;
  final StorageService storageService;
  final TokenService tokenService;
  final LocationService locationService;

  const TrackForceApp({
    super.key,
    required this.apiService,
    required this.storageService,
    required this.tokenService,
    required this.locationService,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: AppProviders.getProviders(
        apiService: apiService,
        storageService: storageService,
        tokenService: tokenService,
        locationService: locationService,
      ),
      child: MaterialApp(
        title: 'TrackForce',
        navigatorKey: AppRoutes.navigatorKey,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: const LoginScreen(),
        routes: AppRoutes.getRoutes(),
      ),
    );
  }
}