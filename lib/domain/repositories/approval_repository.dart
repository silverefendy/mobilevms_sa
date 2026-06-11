import 'package:mobile_vms/domain/models/approval_models.dart';

abstract class ApprovalRepository {
  /// List pending approval tasks for the current user
  Future<ApprovalTaskListResponse> getPendingApprovalTasks({
    int? page,
    int? pageSize,
  });

  /// Get a specific approval task
  Future<ApprovalTaskResponse> getApprovalTask(String taskId);

  /// Approve an approval task
  Future<ApprovalDecisionResponse> approveTask({
    required String taskId,
    String? reason,
    String? comments,
  });

  /// Reject an approval task
  Future<ApprovalDecisionResponse> rejectTask({
    required String taskId,
    required String reason,
    String? comments,
  });

  /// Cancel an approval task
  Future<ApprovalTaskResponse> cancelTask(String taskId);

  /// List approval decisions
  Future<ApprovalDecisionListResponse> getApprovalDecisions({
    String? taskId,
    String? visitRequestId,
    int? page,
    int? pageSize,
  });

  /// Get a specific approval decision
  Future<ApprovalDecisionResponse> getApprovalDecision(String decisionId);
}
