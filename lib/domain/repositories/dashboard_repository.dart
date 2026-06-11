import 'package:mobile_vms/domain/models/dashboard_models.dart';

abstract class DashboardRepository {
  /// Get security dashboard metrics
  Future<SecurityDashboardMetrics> getSecurityDashboard();

  /// Get reception dashboard metrics
  Future<ReceptionDashboardMetrics> getReceptionDashboard();

  /// Get manager dashboard metrics
  Future<ManagerDashboardMetrics> getManagerDashboard();

  /// Get HR dashboard metrics
  Future<HRDashboardMetrics> getHRDashboard();

  /// Get executive dashboard metrics
  Future<ExecutiveDashboardMetrics> getExecutiveDashboard();
}
