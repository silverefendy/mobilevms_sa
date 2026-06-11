// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lookup_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LookupRequest _$LookupRequestFromJson(Map<String, dynamic> json) =>
    LookupRequest(
      query: json['query'] as String,
      limit: (json['limit'] as num?)?.toInt(),
    );

Map<String, dynamic> _$LookupRequestToJson(LookupRequest instance) =>
    <String, dynamic>{'query': instance.query, 'limit': instance.limit};

DepartmentLookupResponse _$DepartmentLookupResponseFromJson(
  Map<String, dynamic> json,
) => DepartmentLookupResponse(
  items: (json['items'] as List<dynamic>)
      .map((e) => DepartmentLookupItem.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$DepartmentLookupResponseToJson(
  DepartmentLookupResponse instance,
) => <String, dynamic>{'items': instance.items};

DepartmentLookupItem _$DepartmentLookupItemFromJson(
  Map<String, dynamic> json,
) => DepartmentLookupItem(
  id: json['id'] as String,
  name: json['name'] as String,
  code: json['code'] as String?,
);

Map<String, dynamic> _$DepartmentLookupItemToJson(
  DepartmentLookupItem instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'code': instance.code,
};

EmployeeLookupResponse _$EmployeeLookupResponseFromJson(
  Map<String, dynamic> json,
) => EmployeeLookupResponse(
  items: (json['items'] as List<dynamic>)
      .map((e) => EmployeeLookupItem.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$EmployeeLookupResponseToJson(
  EmployeeLookupResponse instance,
) => <String, dynamic>{'items': instance.items};

EmployeeLookupItem _$EmployeeLookupItemFromJson(Map<String, dynamic> json) =>
    EmployeeLookupItem(
      id: json['id'] as String,
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      department: json['department'] as String?,
    );

Map<String, dynamic> _$EmployeeLookupItemToJson(EmployeeLookupItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fullName': instance.fullName,
      'email': instance.email,
      'department': instance.department,
    };

GateLookupResponse _$GateLookupResponseFromJson(Map<String, dynamic> json) =>
    GateLookupResponse(
      items: (json['items'] as List<dynamic>)
          .map((e) => GateLookupItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GateLookupResponseToJson(GateLookupResponse instance) =>
    <String, dynamic>{'items': instance.items};

GateLookupItem _$GateLookupItemFromJson(Map<String, dynamic> json) =>
    GateLookupItem(
      id: json['id'] as String,
      name: json['name'] as String,
      location: json['location'] as String?,
    );

Map<String, dynamic> _$GateLookupItemToJson(GateLookupItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'location': instance.location,
    };

VisitPurposeLookupResponse _$VisitPurposeLookupResponseFromJson(
  Map<String, dynamic> json,
) => VisitPurposeLookupResponse(
  items: (json['items'] as List<dynamic>)
      .map((e) => VisitPurposeLookupItem.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$VisitPurposeLookupResponseToJson(
  VisitPurposeLookupResponse instance,
) => <String, dynamic>{'items': instance.items};

VisitPurposeLookupItem _$VisitPurposeLookupItemFromJson(
  Map<String, dynamic> json,
) => VisitPurposeLookupItem(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String?,
);

Map<String, dynamic> _$VisitPurposeLookupItemToJson(
  VisitPurposeLookupItem instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
};
