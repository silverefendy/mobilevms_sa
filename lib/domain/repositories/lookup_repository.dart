import 'package:mobile_vms/domain/models/lookup_models.dart';

abstract class LookupRepository {
  /// Search departments by query
  Future<DepartmentLookupResponse> searchDepartments({
    required String query,
    int? limit,
  });

  /// Search employees by query
  Future<EmployeeLookupResponse> searchEmployees({
    required String query,
    int? limit,
  });

  /// Search gates by query
  Future<GateLookupResponse> searchGates({
    required String query,
    int? limit,
  });

  /// Search visit purposes by query
  Future<VisitPurposeLookupResponse> searchVisitPurposes({
    required String query,
    int? limit,
  });
}
