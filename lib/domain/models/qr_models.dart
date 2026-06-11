import 'package:json_annotation/json_annotation.dart';

part 'qr_models.g.dart';

/// QR Code response schema matching backend QRCodeResponse
@JsonSerializable()
class QRCodeResponse {
  final String id;
  final String companyId;
  final String? visitId;
  final String? visitRequestId;
  final String? tokenId;
  final String status;
  final DateTime issuedAt;
  final DateTime? expiresAt;
  final DateTime? usedAt;
  final int scanCount;

  QRCodeResponse({
    required this.id,
    required this.companyId,
    this.visitId,
    this.visitRequestId,
    this.tokenId,
    required this.status,
    required this.issuedAt,
    this.expiresAt,
    this.usedAt,
    required this.scanCount,
  });

  factory QRCodeResponse.fromJson(Map<String, dynamic> json) =>
      _$QRCodeResponseFromJson(json);

  Map<String, dynamic> toJson() => _$QRCodeResponseToJson(this);
}

/// QR Code generation request schema matching backend QRCodeGenerateRequest
@JsonSerializable()
class QRCodeGenerateRequest {
  final String visitId;
  final int? expires_in_minutes;

  QRCodeGenerateRequest({
    required this.visitId,
    this.expires_in_minutes,
  });

  factory QRCodeGenerateRequest.fromJson(Map<String, dynamic> json) =>
      _$QRCodeGenerateRequestFromJson(json);

  Map<String, dynamic> toJson() => _$QRCodeGenerateRequestToJson(this);
}

/// QR Code generation response schema matching backend QRCodeGenerateResponse
@JsonSerializable()
class QRCodeGenerateResponse {
  final String qrCode;
  final String rawToken;

  QRCodeGenerateResponse({
    required this.qrCode,
    required this.rawToken,
  });

  factory QRCodeGenerateResponse.fromJson(Map<String, dynamic> json) =>
      _$QRCodeGenerateResponseFromJson(json);

  Map<String, dynamic> toJson() => _$QRCodeGenerateResponseToJson(this);
}

/// Scan resolve request schema matching backend ScanResolveRequest
@JsonSerializable()
class ScanResolveRequest {
  final String token;

  ScanResolveRequest({required this.token});

  factory ScanResolveRequest.fromJson(Map<String, dynamic> json) =>
      _$ScanResolveRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ScanResolveRequestToJson(this);
}

/// Scan resolve response schema matching backend ScanResolveResponse
@JsonSerializable()
class ScanResolveResponse {
  final bool valid;
  final Map<String, dynamic>? visitor;
  final Map<String, dynamic>? visit;
  final List<String> warnings;

  ScanResolveResponse({
    required this.valid,
    this.visitor,
    this.visit,
    required this.warnings,
  });

  factory ScanResolveResponse.fromJson(Map<String, dynamic> json) =>
      _$ScanResolveResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ScanResolveResponseToJson(this);
}

/// Scan execute request schema matching backend ScanExecuteRequest
@JsonSerializable()
class ScanExecuteRequest {
  final String token;
  final String? gateId;
  final String? gateDeviceId;
  final String? notes;

  ScanExecuteRequest({
    required this.token,
    this.gateId,
    this.gateDeviceId,
    this.notes,
  });

  factory ScanExecuteRequest.fromJson(Map<String, dynamic> json) =>
      _$ScanExecuteRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ScanExecuteRequestToJson(this);
}

/// Check-in event response schema matching backend CheckInEventResponse
@JsonSerializable()
class CheckInEventResponse {
  final String id;
  final String visitId;
  final String? visitRequestId;
  final String visitorId;
  final String companyId;
  final String? gateId;
  final String? gateDeviceId;
  final String performedBy;
  final String? qrCodeId;
  final DateTime checkedInAt;
  final String method;
  final String? notes;

  CheckInEventResponse({
    required this.id,
    required this.visitId,
    this.visitRequestId,
    required this.visitorId,
    required this.companyId,
    this.gateId,
    this.gateDeviceId,
    required this.performedBy,
    this.qrCodeId,
    required this.checkedInAt,
    required this.method,
    this.notes,
  });

  factory CheckInEventResponse.fromJson(Map<String, dynamic> json) =>
      _$CheckInEventResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CheckInEventResponseToJson(this);
}

/// Check-out event response schema matching backend CheckOutEventResponse
@JsonSerializable()
class CheckOutEventResponse {
  final String id;
  final String visitId;
  final String? visitRequestId;
  final String visitorId;
  final String companyId;
  final String? gateId;
  final String? gateDeviceId;
  final String performedBy;
  final String? qrCodeId;
  final DateTime checkedOutAt;
  final String method;
  final String? notes;

  CheckOutEventResponse({
    required this.id,
    required this.visitId,
    this.visitRequestId,
    required this.visitorId,
    required this.companyId,
    this.gateId,
    this.gateDeviceId,
    required this.performedBy,
    this.qrCodeId,
    required this.checkedOutAt,
    required this.method,
    this.notes,
  });

  factory CheckOutEventResponse.fromJson(Map<String, dynamic> json) =>
      _$CheckOutEventResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CheckOutEventResponseToJson(this);
}

/// Check-out request schema matching backend CheckOutRequest
@JsonSerializable()
class CheckOutRequest {
  final String? gateId;
  final String? gateDeviceId;
  final String? notes;

  CheckOutRequest({
    this.gateId,
    this.gateDeviceId,
    this.notes,
  });

  factory CheckOutRequest.fromJson(Map<String, dynamic> json) =>
      _$CheckOutRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CheckOutRequestToJson(this);
}

/// Visit response schema matching backend VisitResponse
@JsonSerializable()
class VisitResponse {
  final String id;
  final String? visitRequestId;
  final String visitorId;
  final String hostEmployeeId;
  final String? visitPurposeId;
  final DateTime scheduledStartAt;
  final DateTime scheduledEndAt;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  VisitResponse({
    required this.id,
    this.visitRequestId,
    required this.visitorId,
    required this.hostEmployeeId,
    this.visitPurposeId,
    required this.scheduledStartAt,
    required this.scheduledEndAt,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory VisitResponse.fromJson(Map<String, dynamic> json) =>
      _$VisitResponseFromJson(json);

  Map<String, dynamic> toJson() => _$VisitResponseToJson(this);
}

/// Visitor log response schema matching backend VisitorLogResponse
@JsonSerializable()
class VisitorLogResponse {
  final String id;
  final String? visitorId;
  final String? visitId;
  final String? visitRequestId;
  final String companyId;
  final String eventType;
  final DateTime eventTime;
  final String? performedBy;
  final String? details;

  VisitorLogResponse({
    required this.id,
    this.visitorId,
    this.visitId,
    this.visitRequestId,
    required this.companyId,
    required this.eventType,
    required this.eventTime,
    this.performedBy,
    this.details,
  });

  factory VisitorLogResponse.fromJson(Map<String, dynamic> json) =>
      _$VisitorLogResponseFromJson(json);

  Map<String, dynamic> toJson() => _$VisitorLogResponseToJson(this);
}

/// Visitor log list response with pagination
@JsonSerializable()
class VisitorLogListResponse {
  final List<VisitorLogResponse> items;
  final int total;
  final int page;
  final int pageSize;
  final int pages;

  VisitorLogListResponse({
    required this.items,
    required this.total,
    required this.page,
    required this.pageSize,
    required this.pages,
  });

  factory VisitorLogListResponse.fromJson(Map<String, dynamic> json) =>
      _$VisitorLogListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$VisitorLogListResponseToJson(this);
}
