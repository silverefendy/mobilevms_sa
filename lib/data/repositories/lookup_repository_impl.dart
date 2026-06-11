import 'package:mobile_vms/core/errors/app_exception.dart';
import 'package:mobile_vms/core/network/jwt_api_client.dart';
import 'package:mobile_vms/domain/models/lookup_models.dart';
import 'package:mobile_vms/domain/repositories/lookup_repository.dart';

class LookupRepositoryImpl implements LookupRepository {
  LookupRepositoryImpl(this._apiClient);

  final JwtApiClient _apiClient;

  @override
  Future<DepartmentLookupResponse> searchDepartments({
    required String query,
    int? limit,
  }) async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>(
        '/api/v1/lookups/departments',
        queryParameters: {
          'query': query,
          if (limit != null) 'limit': limit,
        },
      );
      return DepartmentLookupResponse.fromJson(response.data!);
    } on AppException {
      rethrow;
    } catch (e) {
      throw AppException('Failed to search departments');
    }
  }

  @override
  Future<EmployeeLookupResponse> searchEmployees({
    required String query,
    int? limit,
  }) async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>(
        '/api/v1/lookups/employees',
        queryParameters: {
          'query': query,
          if (limit != null) 'limit': limit,
        },
      );
      return EmployeeLookupResponse.fromJson(response.data!);
    } on AppException {
      rethrow;
    } catch (e) {
      throw AppException('Failed to search employees');
    }
  }

  @override
  Future<GateLookupResponse> searchGates({
    required String query,
    int? limit,
  }) async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>(
        '/api/v1/lookups/gates',
        queryParameters: {
          'query': query,
          if (limit != null) 'limit': limit,
        },
      );
      return GateLookupResponse.fromJson(response.data!);
    } on AppException {
      rethrow;
    } catch (e) {
      throw AppException('Failed to search gates');
    }
  }

  @override
  Future<VisitPurposeLookupResponse> searchVisitPurposes({
    required String query,
    int? limit,
  }) async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>(
        '/api/v1/lookups/visit-purposes',
        queryParameters: {
          'query': query,
          if (limit != null) 'limit': limit,
        },
      );
      return VisitPurposeLookupResponse.fromJson(response.data!);
    } on AppException {
      rethrow;
    } catch (e) {
      throw AppException('Failed to search visit purposes');
    }
  }
}
