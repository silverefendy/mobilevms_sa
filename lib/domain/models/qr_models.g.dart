// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'qr_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QRCodeResponse _$QRCodeResponseFromJson(Map<String, dynamic> json) =>
    QRCodeResponse(
      id: json['id'] as String,
      companyId: json['companyId'] as String,
      visitId: json['visitId'] as String?,
      visitRequestId: json['visitRequestId'] as String?,
      tokenId: json['tokenId'] as String?,
      status: json['status'] as String,
      issuedAt: DateTime.parse(json['issuedAt'] as String),
      expiresAt: json['expiresAt'] == null
          ? null
          : DateTime.parse(json['expiresAt'] as String),
      usedAt: json['usedAt'] == null
          ? null
          : DateTime.parse(json['usedAt'] as String),
      scanCount: (json['scanCount'] as num).toInt(),
    );

Map<String, dynamic> _$QRCodeResponseToJson(QRCodeResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'companyId': instance.companyId,
      'visitId': instance.visitId,
      'visitRequestId': instance.visitRequestId,
      'tokenId': instance.tokenId,
      'status': instance.status,
      'issuedAt': instance.issuedAt.toIso8601String(),
      'expiresAt': instance.expiresAt?.toIso8601String(),
      'usedAt': instance.usedAt?.toIso8601String(),
      'scanCount': instance.scanCount,
    };

QRCodeGenerateRequest _$QRCodeGenerateRequestFromJson(
  Map<String, dynamic> json,
) => QRCodeGenerateRequest(
  visitId: json['visitId'] as String,
  expires_in_minutes: (json['expires_in_minutes'] as num?)?.toInt(),
);

Map<String, dynamic> _$QRCodeGenerateRequestToJson(
  QRCodeGenerateRequest instance,
) => <String, dynamic>{
  'visitId': instance.visitId,
  'expires_in_minutes': instance.expires_in_minutes,
};

QRCodeGenerateResponse _$QRCodeGenerateResponseFromJson(
  Map<String, dynamic> json,
) => QRCodeGenerateResponse(
  qrCode: json['qrCode'] as String,
  rawToken: json['rawToken'] as String,
);

Map<String, dynamic> _$QRCodeGenerateResponseToJson(
  QRCodeGenerateResponse instance,
) => <String, dynamic>{
  'qrCode': instance.qrCode,
  'rawToken': instance.rawToken,
};

ScanResolveRequest _$ScanResolveRequestFromJson(Map<String, dynamic> json) =>
    ScanResolveRequest(token: json['token'] as String);

Map<String, dynamic> _$ScanResolveRequestToJson(ScanResolveRequest instance) =>
    <String, dynamic>{'token': instance.token};

ScanResolveResponse _$ScanResolveResponseFromJson(Map<String, dynamic> json) =>
    ScanResolveResponse(
      valid: json['valid'] as bool,
      visitor: json['visitor'] as Map<String, dynamic>?,
      visit: json['visit'] as Map<String, dynamic>?,
      warnings: (json['warnings'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$ScanResolveResponseToJson(
  ScanResolveResponse instance,
) => <String, dynamic>{
  'valid': instance.valid,
  'visitor': instance.visitor,
  'visit': instance.visit,
  'warnings': instance.warnings,
};

ScanExecuteRequest _$ScanExecuteRequestFromJson(Map<String, dynamic> json) =>
    ScanExecuteRequest(
      token: json['token'] as String,
      gateId: json['gateId'] as String?,
      gateDeviceId: json['gateDeviceId'] as String?,
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$ScanExecuteRequestToJson(ScanExecuteRequest instance) =>
    <String, dynamic>{
      'token': instance.token,
      'gateId': instance.gateId,
      'gateDeviceId': instance.gateDeviceId,
      'notes': instance.notes,
    };

CheckInEventResponse _$CheckInEventResponseFromJson(
  Map<String, dynamic> json,
) => CheckInEventResponse(
  id: json['id'] as String,
  visitId: json['visitId'] as String,
  visitRequestId: json['visitRequestId'] as String?,
  visitorId: json['visitorId'] as String,
  companyId: json['companyId'] as String,
  gateId: json['gateId'] as String?,
  gateDeviceId: json['gateDeviceId'] as String?,
  performedBy: json['performedBy'] as String,
  qrCodeId: json['qrCodeId'] as String?,
  checkedInAt: DateTime.parse(json['checkedInAt'] as String),
  method: json['method'] as String,
  notes: json['notes'] as String?,
);

Map<String, dynamic> _$CheckInEventResponseToJson(
  CheckInEventResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'visitId': instance.visitId,
  'visitRequestId': instance.visitRequestId,
  'visitorId': instance.visitorId,
  'companyId': instance.companyId,
  'gateId': instance.gateId,
  'gateDeviceId': instance.gateDeviceId,
  'performedBy': instance.performedBy,
  'qrCodeId': instance.qrCodeId,
  'checkedInAt': instance.checkedInAt.toIso8601String(),
  'method': instance.method,
  'notes': instance.notes,
};

CheckOutEventResponse _$CheckOutEventResponseFromJson(
  Map<String, dynamic> json,
) => CheckOutEventResponse(
  id: json['id'] as String,
  visitId: json['visitId'] as String,
  visitRequestId: json['visitRequestId'] as String?,
  visitorId: json['visitorId'] as String,
  companyId: json['companyId'] as String,
  gateId: json['gateId'] as String?,
  gateDeviceId: json['gateDeviceId'] as String?,
  performedBy: json['performedBy'] as String,
  qrCodeId: json['qrCodeId'] as String?,
  checkedOutAt: DateTime.parse(json['checkedOutAt'] as String),
  method: json['method'] as String,
  notes: json['notes'] as String?,
);

Map<String, dynamic> _$CheckOutEventResponseToJson(
  CheckOutEventResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'visitId': instance.visitId,
  'visitRequestId': instance.visitRequestId,
  'visitorId': instance.visitorId,
  'companyId': instance.companyId,
  'gateId': instance.gateId,
  'gateDeviceId': instance.gateDeviceId,
  'performedBy': instance.performedBy,
  'qrCodeId': instance.qrCodeId,
  'checkedOutAt': instance.checkedOutAt.toIso8601String(),
  'method': instance.method,
  'notes': instance.notes,
};

CheckOutRequest _$CheckOutRequestFromJson(Map<String, dynamic> json) =>
    CheckOutRequest(
      gateId: json['gateId'] as String?,
      gateDeviceId: json['gateDeviceId'] as String?,
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$CheckOutRequestToJson(CheckOutRequest instance) =>
    <String, dynamic>{
      'gateId': instance.gateId,
      'gateDeviceId': instance.gateDeviceId,
      'notes': instance.notes,
    };

VisitResponse _$VisitResponseFromJson(Map<String, dynamic> json) =>
    VisitResponse(
      id: json['id'] as String,
      visitRequestId: json['visitRequestId'] as String?,
      visitorId: json['visitorId'] as String,
      hostEmployeeId: json['hostEmployeeId'] as String,
      visitPurposeId: json['visitPurposeId'] as String?,
      scheduledStartAt: DateTime.parse(json['scheduledStartAt'] as String),
      scheduledEndAt: DateTime.parse(json['scheduledEndAt'] as String),
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$VisitResponseToJson(VisitResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'visitRequestId': instance.visitRequestId,
      'visitorId': instance.visitorId,
      'hostEmployeeId': instance.hostEmployeeId,
      'visitPurposeId': instance.visitPurposeId,
      'scheduledStartAt': instance.scheduledStartAt.toIso8601String(),
      'scheduledEndAt': instance.scheduledEndAt.toIso8601String(),
      'status': instance.status,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

VisitorLogResponse _$VisitorLogResponseFromJson(Map<String, dynamic> json) =>
    VisitorLogResponse(
      id: json['id'] as String,
      visitorId: json['visitorId'] as String?,
      visitId: json['visitId'] as String?,
      visitRequestId: json['visitRequestId'] as String?,
      companyId: json['companyId'] as String,
      eventType: json['eventType'] as String,
      eventTime: DateTime.parse(json['eventTime'] as String),
      performedBy: json['performedBy'] as String?,
      details: json['details'] as String?,
    );

Map<String, dynamic> _$VisitorLogResponseToJson(VisitorLogResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'visitorId': instance.visitorId,
      'visitId': instance.visitId,
      'visitRequestId': instance.visitRequestId,
      'companyId': instance.companyId,
      'eventType': instance.eventType,
      'eventTime': instance.eventTime.toIso8601String(),
      'performedBy': instance.performedBy,
      'details': instance.details,
    };

VisitorLogListResponse _$VisitorLogListResponseFromJson(
  Map<String, dynamic> json,
) => VisitorLogListResponse(
  items: (json['items'] as List<dynamic>)
      .map((e) => VisitorLogResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
  total: (json['total'] as num).toInt(),
  page: (json['page'] as num).toInt(),
  pageSize: (json['pageSize'] as num).toInt(),
  pages: (json['pages'] as num).toInt(),
);

Map<String, dynamic> _$VisitorLogListResponseToJson(
  VisitorLogListResponse instance,
) => <String, dynamic>{
  'items': instance.items,
  'total': instance.total,
  'page': instance.page,
  'pageSize': instance.pageSize,
  'pages': instance.pages,
};
