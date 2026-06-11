// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SecurityDashboardMetrics _$SecurityDashboardMetricsFromJson(
  Map<String, dynamic> json,
) => SecurityDashboardMetrics(
  activeVisitors: (json['activeVisitors'] as num).toInt(),
  pendingApprovals: (json['pendingApprovals'] as num).toInt(),
  todayCheckIns: (json['todayCheckIns'] as num).toInt(),
  todayCheckOuts: (json['todayCheckOuts'] as num).toInt(),
  alerts: (json['alerts'] as num).toInt(),
);

Map<String, dynamic> _$SecurityDashboardMetricsToJson(
  SecurityDashboardMetrics instance,
) => <String, dynamic>{
  'activeVisitors': instance.activeVisitors,
  'pendingApprovals': instance.pendingApprovals,
  'todayCheckIns': instance.todayCheckIns,
  'todayCheckOuts': instance.todayCheckOuts,
  'alerts': instance.alerts,
};

ReceptionDashboardMetrics _$ReceptionDashboardMetricsFromJson(
  Map<String, dynamic> json,
) => ReceptionDashboardMetrics(
  expectedVisitors: (json['expectedVisitors'] as num).toInt(),
  checkedInVisitors: (json['checkedInVisitors'] as num).toInt(),
  pendingCheckOuts: (json['pendingCheckOuts'] as num).toInt(),
  gateActivity: (json['gateActivity'] as num).toInt(),
);

Map<String, dynamic> _$ReceptionDashboardMetricsToJson(
  ReceptionDashboardMetrics instance,
) => <String, dynamic>{
  'expectedVisitors': instance.expectedVisitors,
  'checkedInVisitors': instance.checkedInVisitors,
  'pendingCheckOuts': instance.pendingCheckOuts,
  'gateActivity': instance.gateActivity,
};

ManagerDashboardMetrics _$ManagerDashboardMetricsFromJson(
  Map<String, dynamic> json,
) => ManagerDashboardMetrics(
  teamVisitRequests: (json['teamVisitRequests'] as num).toInt(),
  approvalRate: (json['approvalRate'] as num).toDouble(),
  visitorStatistics: (json['visitorStatistics'] as num).toInt(),
);

Map<String, dynamic> _$ManagerDashboardMetricsToJson(
  ManagerDashboardMetrics instance,
) => <String, dynamic>{
  'teamVisitRequests': instance.teamVisitRequests,
  'approvalRate': instance.approvalRate,
  'visitorStatistics': instance.visitorStatistics,
};

HRDashboardMetrics _$HRDashboardMetricsFromJson(Map<String, dynamic> json) =>
    HRDashboardMetrics(
      visitorTrends: (json['visitorTrends'] as num).toInt(),
      departmentStatistics: (json['departmentStatistics'] as num).toInt(),
      complianceMetrics: (json['complianceMetrics'] as num).toInt(),
    );

Map<String, dynamic> _$HRDashboardMetricsToJson(HRDashboardMetrics instance) =>
    <String, dynamic>{
      'visitorTrends': instance.visitorTrends,
      'departmentStatistics': instance.departmentStatistics,
      'complianceMetrics': instance.complianceMetrics,
    };

ExecutiveDashboardMetrics _$ExecutiveDashboardMetricsFromJson(
  Map<String, dynamic> json,
) => ExecutiveDashboardMetrics(
  companyStatistics: (json['companyStatistics'] as num).toInt(),
  trends: (json['trends'] as num).toInt(),
  kpis: (json['kpis'] as num).toInt(),
);

Map<String, dynamic> _$ExecutiveDashboardMetricsToJson(
  ExecutiveDashboardMetrics instance,
) => <String, dynamic>{
  'companyStatistics': instance.companyStatistics,
  'trends': instance.trends,
  'kpis': instance.kpis,
};
