class ApiConstants {
  // Use your computer's local IP address for mobile devices.
  static const String baseUrl = 'http://192.168.100.111:5001/reatchall';
  
  // Auth Endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String me = '/auth/me';
  static const String logout = '/auth/logout';
  
  // Employee Endpoints
  static const String employeeStats = '/employee/stats/dashboard';
  static const String employeeVisits = '/employee/visits';
  static const String employeeOrders = '/employee/orders';
  static const String employeeProfile = '/employee/profile';
  static const String employeeFollowUps = '/employee/follow-ups';
  static const String trackingStart = '/employee/tracking/start';
  static const String trackingStop = '/employee/tracking/stop';
  static const String trackingStatus = '/employee/tracking/status';
}
