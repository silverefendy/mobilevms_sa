import 'package:mobile_vms/core/errors/app_exception.dart';
import 'package:mobile_vms/core/network/jwt_api_client.dart';
import 'package:mobile_vms/domain/models/dashboard_models.dart';
import 'package:mobile_vms/domain/repositories/dashboard_repository.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  DashboardRepositoryImpl(this._apiClient);

  final JwtApiClient _apiClient;

  @override
  Future<SecurityDashboardMetrics> getSecurityDashboard() async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>(
        '/api/v1/dashboard/security',
      );
      return SecurityDashboardMetrics.fromJson(response.data!);
    } on AppException {
      rethrow;
    } catch (e) {
      throw AppException('Failed to get security dashboard');
    }
  }

  @override
  Future<ReceptionDashboardMetrics> getReceptionDashboard() async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>(
        '/api/v1/dashboard/reception',
      );
      return ReceptionDashboardMetrics.fromJson(response.data!);
    } on AppException {
      rethrow;
    } catch (e) {
      throw AppException('Failed to get reception dashboard');
    }
  }

  @override
  Future<ManagerDashboardMetrics> getManagerDashboard() async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>(
        '/api/v1/dashboard/manager',
      );
      return ManagerDashboardMetrics.fromJson(response.data!);
    } on AppException {
      rethrow;
    } catch (e) {
      throw AppException('Failed to get manager dashboard');
    }
  }

  @override
  Future<HRDashboardMetrics> getHRDashboard() async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>(
        '/api/v1/dashboard/hr',
      );
      return HRDashboardMetrics.fromJson(response.data!);
    } on AppException {
      rethrow;
    } catch (e) {
      throw AppException('Failed to get HR dashboard');
    }
  }

  @override
  Future<ExecutiveDashboardMetrics> getExecutiveDashboard() async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>(
        '/api/v1/dashboard/executive',
      );
      return ExecutiveDashboardMetrics.fromJson(response.data!);
    } on AppException {
      rethrow;
    } catch (e) {
      throw AppException('Failed to get executive dashboard');
    }
  }
}
