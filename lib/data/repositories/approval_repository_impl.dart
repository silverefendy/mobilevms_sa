import 'package:mobile_vms/core/errors/app_exception.dart';
import 'package:mobile_vms/core/network/jwt_api_client.dart';
import 'package:mobile_vms/domain/models/approval_models.dart';
import 'package:mobile_vms/domain/repositories/approval_repository.dart';

class ApprovalRepositoryImpl implements ApprovalRepository {
  ApprovalRepositoryImpl(this._apiClient);

  final JwtApiClient _apiClient;

  @override
  Future<ApprovalTaskListResponse> getPendingApprovalTasks({
    int? page,
    int? pageSize,
  }) async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>(
        '/api/v1/approvals/tasks',
        queryParameters: {
          'status': 'pending',
          if (page != null) 'page': page,
          if (pageSize != null) 'page_size': pageSize,
        },
      );
      return ApprovalTaskListResponse.fromJson(response.data!);
    } on AppException {
      rethrow;
    } catch (e) {
      throw AppException('Failed to get pending approval tasks');
    }
  }

  @override
  Future<ApprovalTaskResponse> getApprovalTask(String taskId) async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>(
        '/api/v1/approvals/tasks/$taskId',
      );
      return ApprovalTaskResponse.fromJson(response.data!);
    } on AppException {
      rethrow;
    } catch (e) {
      throw AppException('Failed to get approval task');
    }
  }

  @override
  Future<ApprovalDecisionResponse> approveTask({
    required String taskId,
    String? reason,
    String? comments,
  }) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        '/api/v1/approvals/tasks/$taskId/approve',
        data: {
          if (reason != null) 'reason': reason,
          if (comments != null) 'comments': comments,
        },
      );
      return ApprovalDecisionResponse.fromJson(response.data!);
    } on AppException {
      rethrow;
    } catch (e) {
      throw AppException('Failed to approve task');
    }
  }

  @override
  Future<ApprovalDecisionResponse> rejectTask({
    required String taskId,
    required String reason,
    String? comments,
  }) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        '/api/v1/approvals/tasks/$taskId/reject',
        data: {
          'reason': reason,
          if (comments != null) 'comments': comments,
        },
      );
      return ApprovalDecisionResponse.fromJson(response.data!);
    } on AppException {
      rethrow;
    } catch (e) {
      throw AppException('Failed to reject task');
    }
  }

  @override
  Future<ApprovalTaskResponse> cancelTask(String taskId) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        '/api/v1/approvals/tasks/$taskId/cancel',
      );
      return ApprovalTaskResponse.fromJson(response.data!);
    } on AppException {
      rethrow;
    } catch (e) {
      throw AppException('Failed to cancel task');
    }
  }

  @override
  Future<ApprovalDecisionListResponse> getApprovalDecisions({
    String? taskId,
    String? visitRequestId,
    int? page,
    int? pageSize,
  }) async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>(
        '/api/v1/approvals/decisions',
        queryParameters: {
          if (taskId != null) 'task_id': taskId,
          if (visitRequestId != null) 'visit_request_id': visitRequestId,
          if (page != null) 'page': page,
          if (pageSize != null) 'page_size': pageSize,
        },
      );
      return ApprovalDecisionListResponse.fromJson(response.data!);
    } on AppException {
      rethrow;
    } catch (e) {
      throw AppException('Failed to get approval decisions');
    }
  }

  @override
  Future<ApprovalDecisionResponse> getApprovalDecision(String decisionId) async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>(
        '/api/v1/approvals/decisions/$decisionId',
      );
      return ApprovalDecisionResponse.fromJson(response.data!);
    } on AppException {
      rethrow;
    } catch (e) {
      throw AppException('Failed to get approval decision');
    }
  }
}
