import 'package:json_annotation/json_annotation.dart';

part 'visitor_models.g.dart';

/// Visitor response schema matching backend VisitorResponse
@JsonSerializable()
class VisitorResponse {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String company;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  VisitorResponse({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.company,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory VisitorResponse.fromJson(Map<String, dynamic> json) =>
      _$VisitorResponseFromJson(json);

  Map<String, dynamic> toJson() => _$VisitorResponseToJson(this);

  String get fullName => '$firstName $lastName';
}

/// Visit request response schema matching backend VisitRequestResponse
@JsonSerializable()
class VisitRequestResponse {
  final String id;
  final String visitorId;
  final String hostEmployeeId;
  final String? purposeId;
  final DateTime scheduledStart;
  final DateTime scheduledEnd;
  final String status;
  final String requestNo;
  final DateTime createdAt;
  final DateTime updatedAt;

  VisitRequestResponse({
    required this.id,
    required this.visitorId,
    required this.hostEmployeeId,
    this.purposeId,
    required this.scheduledStart,
    required this.scheduledEnd,
    required this.status,
    required this.requestNo,
    required this.createdAt,
    required this.updatedAt,
  });

  factory VisitRequestResponse.fromJson(Map<String, dynamic> json) =>
      _$VisitRequestResponseFromJson(json);

  Map<String, dynamic> toJson() => _$VisitRequestResponseToJson(this);
}

/// Visitor list response with pagination
@JsonSerializable()
class VisitorListResponse {
  final List<VisitorResponse> items;
  final int total;
  final int page;
  final int pageSize;
  final int pages;

  VisitorListResponse({
    required this.items,
    required this.total,
    required this.page,
    required this.pageSize,
    required this.pages,
  });

  factory VisitorListResponse.fromJson(Map<String, dynamic> json) =>
      _$VisitorListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$VisitorListResponseToJson(this);
}

/// Visit request list response with pagination
@JsonSerializable()
class VisitRequestListResponse {
  final List<VisitRequestResponse> items;
  final int total;
  final int page;
  final int pageSize;
  final int pages;

  VisitRequestListResponse({
    required this.items,
    required this.total,
    required this.page,
    required this.pageSize,
    required this.pages,
  });

  factory VisitRequestListResponse.fromJson(Map<String, dynamic> json) =>
      _$VisitRequestListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$VisitRequestListResponseToJson(this);
}

/// Visitor create request schema
@JsonSerializable()
class VisitorCreateRequest {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String company;

  VisitorCreateRequest({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.company,
  });

  factory VisitorCreateRequest.fromJson(Map<String, dynamic> json) =>
      _$VisitorCreateRequestFromJson(json);

  Map<String, dynamic> toJson() => _$VisitorCreateRequestToJson(this);
}

/// Visit request create request schema
@JsonSerializable()
class VisitRequestCreateRequest {
  final String visitorId;
  final String hostEmployeeId;
  final String? purposeId;
  final DateTime scheduledStart;
  final DateTime scheduledEnd;

  VisitRequestCreateRequest({
    required this.visitorId,
    required this.hostEmployeeId,
    this.purposeId,
    required this.scheduledStart,
    required this.scheduledEnd,
  });

  factory VisitRequestCreateRequest.fromJson(Map<String, dynamic> json) =>
      _$VisitRequestCreateRequestFromJson(json);

  Map<String, dynamic> toJson() => _$VisitRequestCreateRequestToJson(this);
}
