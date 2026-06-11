import 'package:json_annotation/json_annotation.dart';

part 'approval_models.g.dart';

/// Approval task response schema matching backend ApprovalTaskResponse
@JsonSerializable()
class ApprovalTaskResponse {
  final String id;
  final String companyId;
  final String visitRequestId;
  final String approverUserId;
  final String approvalType;
  final int level;
  final String status;
  final DateTime dueAt;
  final DateTime assignedAt;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final String? escalatedFromId;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  ApprovalTaskResponse({
    required this.id,
    required this.companyId,
    required this.visitRequestId,
    required this.approverUserId,
    required this.approvalType,
    required this.level,
    required this.status,
    required this.dueAt,
    required this.assignedAt,
    this.startedAt,
    this.completedAt,
    this.escalatedFromId,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ApprovalTaskResponse.fromJson(Map<String, dynamic> json) =>
      _$ApprovalTaskResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ApprovalTaskResponseToJson(this);
}

/// Approval task approve request schema matching backend ApprovalTaskApproveRequest
@JsonSerializable()
class ApprovalTaskApproveRequest {
  final String? reason;
  final String? comments;

  ApprovalTaskApproveRequest({
    this.reason,
    this.comments,
  });

  factory ApprovalTaskApproveRequest.fromJson(Map<String, dynamic> json) =>
      _$ApprovalTaskApproveRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ApprovalTaskApproveRequestToJson(this);
}

/// Approval task reject request schema matching backend ApprovalTaskRejectRequest
@JsonSerializable()
class ApprovalTaskRejectRequest {
  final String reason;
  final String? comments;

  ApprovalTaskRejectRequest({
    required this.reason,
    this.comments,
  });

  factory ApprovalTaskRejectRequest.fromJson(Map<String, dynamic> json) =>
      _$ApprovalTaskRejectRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ApprovalTaskRejectRequestToJson(this);
}

/// Approval decision response schema matching backend ApprovalDecisionResponse
@JsonSerializable()
class ApprovalDecisionResponse {
  final String id;
  final String approvalTaskId;
  final String decidedBy;
  final String decision;
  final String? reason;
  final String? comments;
  final DateTime decidedAt;
  final String? metadataJson;
  final DateTime createdAt;

  ApprovalDecisionResponse({
    required this.id,
    required this.approvalTaskId,
    required this.decidedBy,
    required this.decision,
    this.reason,
    this.comments,
    required this.decidedAt,
    this.metadataJson,
    required this.createdAt,
  });

  factory ApprovalDecisionResponse.fromJson(Map<String, dynamic> json) =>
      _$ApprovalDecisionResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ApprovalDecisionResponseToJson(this);
}

/// Approval task list response with pagination
@JsonSerializable()
class ApprovalTaskListResponse {
  final List<ApprovalTaskResponse> items;
  final int total;
  final int page;
  final int pageSize;
  final int pages;

  ApprovalTaskListResponse({
    required this.items,
    required this.total,
    required this.page,
    required this.pageSize,
    required this.pages,
  });

  factory ApprovalTaskListResponse.fromJson(Map<String, dynamic> json) =>
      _$ApprovalTaskListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ApprovalTaskListResponseToJson(this);
}

/// Approval decision list response with pagination
@JsonSerializable()
class ApprovalDecisionListResponse {
  final List<ApprovalDecisionResponse> items;
  final int total;
  final int page;
  final int pageSize;
  final int pages;

  ApprovalDecisionListResponse({
    required this.items,
    required this.total,
    required this.page,
    required this.pageSize,
    required this.pages,
  });

  factory ApprovalDecisionListResponse.fromJson(Map<String, dynamic> json) =>
      _$ApprovalDecisionListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ApprovalDecisionListResponseToJson(this);
}
