import 'package:json_annotation/json_annotation.dart';

part 'dashboard_models.g.dart';

/// Security dashboard metrics schema
@JsonSerializable()
class SecurityDashboardMetrics {
  final int activeVisitors;
  final int pendingApprovals;
  final int todayCheckIns;
  final int todayCheckOuts;
  final int alerts;

  SecurityDashboardMetrics({
    required this.activeVisitors,
    required this.pendingApprovals,
    required this.todayCheckIns,
    required this.todayCheckOuts,
    required this.alerts,
  });

  factory SecurityDashboardMetrics.fromJson(Map<String, dynamic> json) =>
      _$SecurityDashboardMetricsFromJson(json);

  Map<String, dynamic> toJson() => _$SecurityDashboardMetricsToJson(this);
}

/// Reception dashboard metrics schema
@JsonSerializable()
class ReceptionDashboardMetrics {
  final int expectedVisitors;
  final int checkedInVisitors;
  final int pendingCheckOuts;
  final int gateActivity;

  ReceptionDashboardMetrics({
    required this.expectedVisitors,
    required this.checkedInVisitors,
    required this.pendingCheckOuts,
    required this.gateActivity,
  });

  factory ReceptionDashboardMetrics.fromJson(Map<String, dynamic> json) =>
      _$ReceptionDashboardMetricsFromJson(json);

  Map<String, dynamic> toJson() => _$ReceptionDashboardMetricsToJson(this);
}

/// Manager dashboard metrics schema
@JsonSerializable()
class ManagerDashboardMetrics {
  final int teamVisitRequests;
  final double approvalRate;
  final int visitorStatistics;

  ManagerDashboardMetrics({
    required this.teamVisitRequests,
    required this.approvalRate,
    required this.visitorStatistics,
  });

  factory ManagerDashboardMetrics.fromJson(Map<String, dynamic> json) =>
      _$ManagerDashboardMetricsFromJson(json);

  Map<String, dynamic> toJson() => _$ManagerDashboardMetricsToJson(this);
}

/// HR dashboard metrics schema
@JsonSerializable()
class HRDashboardMetrics {
  final int visitorTrends;
  final int departmentStatistics;
  final int complianceMetrics;

  HRDashboardMetrics({
    required this.visitorTrends,
    required this.departmentStatistics,
    required this.complianceMetrics,
  });

  factory HRDashboardMetrics.fromJson(Map<String, dynamic> json) =>
      _$HRDashboardMetricsFromJson(json);

  Map<String, dynamic> toJson() => _$HRDashboardMetricsToJson(this);
}

/// Executive dashboard metrics schema
@JsonSerializable()
class ExecutiveDashboardMetrics {
  final int companyStatistics;
  final int trends;
  final int kpis;

  ExecutiveDashboardMetrics({
    required this.companyStatistics,
    required this.trends,
    required this.kpis,
  });

  factory ExecutiveDashboardMetrics.fromJson(Map<String, dynamic> json) =>
      _$ExecutiveDashboardMetricsFromJson(json);

  Map<String, dynamic> toJson() => _$ExecutiveDashboardMetricsToJson(this);
}
