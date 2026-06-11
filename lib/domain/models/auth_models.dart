import 'package:json_annotation/json_annotation.dart';

part 'auth_models.g.dart';

/// Login request schema matching backend LoginRequest
@JsonSerializable()
class LoginRequest {
  final String username;
  final String password;
  final String companyCode;
  final String? deviceId;

  LoginRequest({
    required this.username,
    required this.password,
    required this.companyCode,
    this.deviceId,
  });

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);

  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}

/// Token response schema matching backend TokenResponse
@JsonSerializable()
class TokenResponse {
  final String accessToken;
  final String refreshToken;
  final String tokenType;
  final int expiresIn;
  final UserBasicInfo user;

  TokenResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.tokenType,
    required this.expiresIn,
    required this.user,
  });

  factory TokenResponse.fromJson(Map<String, dynamic> json) =>
      _$TokenResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TokenResponseToJson(this);
}

/// User basic info schema matching backend UserBasicInfo
@JsonSerializable()
class UserBasicInfo {
  final String id;
  final String username;
  final String email;
  final String fullName;
  final String language;
  final String companyId;
  final List<String> roles;
  final List<String> permissions;

  UserBasicInfo({
    required this.id,
    required this.username,
    required this.email,
    required this.fullName,
    required this.language,
    required this.companyId,
    required this.roles,
    required this.permissions,
  });

  factory UserBasicInfo.fromJson(Map<String, dynamic> json) =>
      _$UserBasicInfoFromJson(json);

  Map<String, dynamic> toJson() => _$UserBasicInfoToJson(this);
}

/// Refresh token request schema matching backend RefreshRequest
@JsonSerializable()
class RefreshRequest {
  final String refreshToken;

  RefreshRequest({required this.refreshToken});

  factory RefreshRequest.fromJson(Map<String, dynamic> json) =>
      _$RefreshRequestFromJson(json);

  Map<String, dynamic> toJson() => _$RefreshRequestToJson(this);
}

/// Change password request schema matching backend ChangePasswordRequest
@JsonSerializable()
class ChangePasswordRequest {
  final String oldPassword;
  final String newPassword;

  ChangePasswordRequest({
    required this.oldPassword,
    required this.newPassword,
  });

  factory ChangePasswordRequest.fromJson(Map<String, dynamic> json) =>
      _$ChangePasswordRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ChangePasswordRequestToJson(this);
}

/// Logout request schema matching backend LogoutRequest
@JsonSerializable()
class LogoutRequest {
  final String? refreshToken;

  LogoutRequest({this.refreshToken});

  factory LogoutRequest.fromJson(Map<String, dynamic> json) =>
      _$LogoutRequestFromJson(json);

  Map<String, dynamic> toJson() => _$LogoutRequestToJson(this);
}

/// Current user information response matching backend MeResponse
@JsonSerializable()
class MeResponse {
  final String id;
  final String username;
  final String email;
  final String fullName;
  final String? phone;
  final String language;
  final String companyId;
  final String companyName;
  final List<String> roles;
  final List<String> permissions;
  final DateTime? lastLoginAt;
  final bool mfaEnabled;

  MeResponse({
    required this.id,
    required this.username,
    required this.email,
    required this.fullName,
    this.phone,
    required this.language,
    required this.companyId,
    required this.companyName,
    required this.roles,
    required this.permissions,
    this.lastLoginAt,
    required this.mfaEnabled,
  });

  factory MeResponse.fromJson(Map<String, dynamic> json) =>
      _$MeResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MeResponseToJson(this);
}
