import 'package:emp/view/login_screen.dart';
import 'package:emp/view/store_visit_screen.dart';
import 'package:emp/view/supplier_visit_screen.dart';
import 'package:emp/view/collaboration_screen.dart';
import 'package:emp/view/installation_screen.dart';
import 'package:emp/view/order_screen.dart';
import 'package:emp/view/history_screen.dart';
import 'package:emp/view/notification_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/services/api_service.dart';
import 'core/services/storage_service.dart';
import 'core/theme/app_theme.dart';
import 'data/repositories/auth_repository.dart';
import 'view/dashboard_screen.dart';
import 'viewmodel/auth/auth_viewmodel.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const TrackForceApp());
}

class TrackForceApp extends StatelessWidget {
  const TrackForceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // ── Services ──────────────────────────────────────────────────────────
        Provider<ApiService>(
          create: (_) => ApiService(),
        ),
        Provider<StorageService>(
          create: (_) => StorageService(),
        ),

        // ── Repositories ──────────────────────────────────────────────────────
        ProxyProvider2<ApiService, StorageService, AuthRepository>(
          update: (_, apiService, storageService, __) => AuthRepository(
            apiService: apiService,
            storageService: storageService,
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
      ],
      child: MaterialApp(
        title: 'TrackForce',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: const DashboardScreen(),
        routes: {
          // Named routes for top-level screens only.
          // Screens that require arguments (ForgotPassword, OTP, ResetPassword)
          // are pushed via Navigator.push + MaterialPageRoute in the caller.
          '/login':           (context) => const LoginScreen(),
          '/dashboard':      (context) => const DashboardScreen(),
          '/store-visit':    (context) => const StoreVisitScreen(),
          '/supplier-visit':  (context) => const SupplierVisitScreen(),
          '/collaboration':  (context) => const BusinessCollaborationScreen(),
          '/installation':   (context) => const AppInstallationScreen(),
          '/order':          (context) => const OrderScreen(),
          '/history':        (context) => const VisitHistoryScreen(),
          '/notifications':  (context) => const NotificationScreen(),
        },
      ),
    );
  }
}