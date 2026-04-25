class DashboardStats {
  final int visitsToday;
  final int ordersToday;
  final int tasksToday;
  final int visitsCompleted;
  final int tasksCompleted;
  final int appInstalled;
  final int trainingCompleted;
  final int firstOrderPlaced;
  final RevenueData revenueData;
  final List<int> capabilities;
  final NextTarget? nextTarget;
  final int monthlyTarget;
  final int monthlyVisits;
  final Map<String, dynamic> user;

  DashboardStats({
    required this.visitsToday,
    required this.ordersToday,
    required this.tasksToday,
    required this.visitsCompleted,
    required this.tasksCompleted,
    required this.appInstalled,
    required this.trainingCompleted,
    required this.firstOrderPlaced,
    required this.revenueData,
    required this.capabilities,
    this.nextTarget,
    required this.monthlyTarget,
    required this.monthlyVisits,
    required this.user,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    return DashboardStats(
      visitsToday: json['visitsToday'] ?? 0,
      ordersToday: json['ordersToday'] ?? 0,
      tasksToday: json['tasksToday'] ?? 0,
      visitsCompleted: json['visitsCompleted'] ?? 0,
      tasksCompleted: json['tasksCompleted'] ?? 0,
      appInstalled: json['appInstalled'] ?? 0,
      trainingCompleted: json['trainingCompleted'] ?? 0,
      firstOrderPlaced: json['firstOrderPlaced'] ?? 0,
      revenueData: RevenueData.fromJson(json['revenueData'] ?? {}),
      capabilities: List<int>.from(json['capabilities'] ?? []),
      nextTarget: json['nextTarget'] != null ? NextTarget.fromJson(json['nextTarget']) : null,
      monthlyTarget: json['monthlyTarget'] ?? 0,
      monthlyVisits: json['monthlyVisits'] ?? 0,
      user: json['user'] ?? {},
    );
  }
}

class RevenueData {
  final List<num> weeklyData;
  final num totalWeekly;
  final num dailyRevenue;
  final num monthlyRevenue;
  final int conversionRate;

  RevenueData({
    required this.weeklyData,
    required this.totalWeekly,
    required this.dailyRevenue,
    required this.monthlyRevenue,
    required this.conversionRate,
  });

  factory RevenueData.fromJson(Map<String, dynamic> json) {
    return RevenueData(
      weeklyData: List<num>.from(json['weeklyData'] ?? []),
      totalWeekly: json['totalWeekly'] ?? 0,
      dailyRevenue: json['dailyRevenue'] ?? 0,
      monthlyRevenue: json['monthlyRevenue'] ?? 0,
      conversionRate: json['conversionRate'] ?? 0,
    );
  }
}

class NextTarget {
  final String store;
  final String address;
  final String priority;
  final String travelTime;
  final String distance;

  NextTarget({
    required this.store,
    required this.address,
    required this.priority,
    required this.travelTime,
    required this.distance,
  });

  factory NextTarget.fromJson(Map<String, dynamic> json) {
    return NextTarget(
      store: json['store'] ?? 'Unknown',
      address: json['address'] ?? '',
      priority: json['priority'] ?? 'medium',
      travelTime: json['travelTime'] ?? '',
      distance: json['distance'] ?? '',
    );
  }
}
