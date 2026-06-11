import 'package:json_annotation/json_annotation.dart';

part 'lookup_models.g.dart';

/// Lookup request schema
@JsonSerializable()
class LookupRequest {
  final String query;
  final int? limit;

  LookupRequest({
    required this.query,
    this.limit,
  });

  factory LookupRequest.fromJson(Map<String, dynamic> json) =>
      _$LookupRequestFromJson(json);

  Map<String, dynamic> toJson() => _$LookupRequestToJson(this);
}

/// Department lookup response schema
@JsonSerializable()
class DepartmentLookupResponse {
  final List<DepartmentLookupItem> items;

  DepartmentLookupResponse({required this.items});

  factory DepartmentLookupResponse.fromJson(Map<String, dynamic> json) =>
      _$DepartmentLookupResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DepartmentLookupResponseToJson(this);
}

@JsonSerializable()
class DepartmentLookupItem {
  final String id;
  final String name;
  final String? code;

  DepartmentLookupItem({
    required this.id,
    required this.name,
    this.code,
  });

  factory DepartmentLookupItem.fromJson(Map<String, dynamic> json) =>
      _$DepartmentLookupItemFromJson(json);

  Map<String, dynamic> toJson() => _$DepartmentLookupItemToJson(this);
}

/// Employee lookup response schema
@JsonSerializable()
class EmployeeLookupResponse {
  final List<EmployeeLookupItem> items;

  EmployeeLookupResponse({required this.items});

  factory EmployeeLookupResponse.fromJson(Map<String, dynamic> json) =>
      _$EmployeeLookupResponseFromJson(json);

  Map<String, dynamic> toJson() => _$EmployeeLookupResponseToJson(this);
}

@JsonSerializable()
class EmployeeLookupItem {
  final String id;
  final String fullName;
  final String email;
  final String? department;

  EmployeeLookupItem({
    required this.id,
    required this.fullName,
    required this.email,
    this.department,
  });

  factory EmployeeLookupItem.fromJson(Map<String, dynamic> json) =>
      _$EmployeeLookupItemFromJson(json);

  Map<String, dynamic> toJson() => _$EmployeeLookupItemToJson(this);
}

/// Gate lookup response schema
@JsonSerializable()
class GateLookupResponse {
  final List<GateLookupItem> items;

  GateLookupResponse({required this.items});

  factory GateLookupResponse.fromJson(Map<String, dynamic> json) =>
      _$GateLookupResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GateLookupResponseToJson(this);
}

@JsonSerializable()
class GateLookupItem {
  final String id;
  final String name;
  final String? location;

  GateLookupItem({
    required this.id,
    required this.name,
    this.location,
  });

  factory GateLookupItem.fromJson(Map<String, dynamic> json) =>
      _$GateLookupItemFromJson(json);

  Map<String, dynamic> toJson() => _$GateLookupItemToJson(this);
}

/// Visit purpose lookup response schema
@JsonSerializable()
class VisitPurposeLookupResponse {
  final List<VisitPurposeLookupItem> items;

  VisitPurposeLookupResponse({required this.items});

  factory VisitPurposeLookupResponse.fromJson(Map<String, dynamic> json) =>
      _$VisitPurposeLookupResponseFromJson(json);

  Map<String, dynamic> toJson() => _$VisitPurposeLookupResponseToJson(this);
}

@JsonSerializable()
class VisitPurposeLookupItem {
  final String id;
  final String name;
  final String? description;

  VisitPurposeLookupItem({
    required this.id,
    required this.name,
    this.description,
  });

  factory VisitPurposeLookupItem.fromJson(Map<String, dynamic> json) =>
      _$VisitPurposeLookupItemFromJson(json);

  Map<String, dynamic> toJson() => _$VisitPurposeLookupItemToJson(this);
}
