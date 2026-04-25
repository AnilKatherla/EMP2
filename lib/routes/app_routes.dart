import 'package:flutter/material.dart';
import '../view/login_screen.dart';
import '../view/dashboard_screen.dart';
import '../view/store_visit_screen.dart';
import '../view/supplier_visit_screen.dart';
import '../view/collaboration_screen.dart';
import '../view/installation_screen.dart';
import '../view/order_screen.dart';
import '../view/history_screen.dart';
import '../view/notification_screen.dart';
import '../view/follow_up_screen.dart';

class AppRoutes {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static const String login = '/login';
  static const String dashboard = '/dashboard';
  static const String storeVisit = '/store-visit';
  static const String supplierVisit = '/supplier-visit';
  static const String collaboration = '/collaboration';
  static const String installation = '/installation';
  static const String order = '/order';
  static const String history = '/history';
  static const String notifications = '/notifications';
  static const String followUps = '/follow-ups';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      login: (context) => const LoginScreen(),
      dashboard: (context) => const DashboardScreen(),
      storeVisit: (context) => const StoreVisitScreen(),
      supplierVisit: (context) => const SupplierVisitScreen(),
      collaboration: (context) => const BusinessCollaborationScreen(),
      installation: (context) => const AppInstallationScreen(),
      order: (context) => const OrderScreen(),
      history: (context) => const VisitHistoryScreen(),
      notifications: (context) => const NotificationScreen(),
      followUps: (context) => const FollowUpScreen(),
    };
  }
}
