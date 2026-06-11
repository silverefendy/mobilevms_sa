// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginRequest _$LoginRequestFromJson(Map<String, dynamic> json) => LoginRequest(
  username: json['username'] as String,
  password: json['password'] as String,
  companyCode: json['companyCode'] as String,
  deviceId: json['deviceId'] as String?,
);

Map<String, dynamic> _$LoginRequestToJson(LoginRequest instance) =>
    <String, dynamic>{
      'username': instance.username,
      'password': instance.password,
      'companyCode': instance.companyCode,
      'deviceId': instance.deviceId,
    };

TokenResponse _$TokenResponseFromJson(Map<String, dynamic> json) =>
    TokenResponse(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      tokenType: json['tokenType'] as String,
      expiresIn: (json['expiresIn'] as num).toInt(),
      user: UserBasicInfo.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TokenResponseToJson(TokenResponse instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
      'tokenType': instance.tokenType,
      'expiresIn': instance.expiresIn,
      'user': instance.user,
    };

UserBasicInfo _$UserBasicInfoFromJson(Map<String, dynamic> json) =>
    UserBasicInfo(
      id: json['id'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      fullName: json['fullName'] as String,
      language: json['language'] as String,
      companyId: json['companyId'] as String,
      roles: (json['roles'] as List<dynamic>).map((e) => e as String).toList(),
      permissions: (json['permissions'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$UserBasicInfoToJson(UserBasicInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'email': instance.email,
      'fullName': instance.fullName,
      'language': instance.language,
      'companyId': instance.companyId,
      'roles': instance.roles,
      'permissions': instance.permissions,
    };

RefreshRequest _$RefreshRequestFromJson(Map<String, dynamic> json) =>
    RefreshRequest(refreshToken: json['refreshToken'] as String);

Map<String, dynamic> _$RefreshRequestToJson(RefreshRequest instance) =>
    <String, dynamic>{'refreshToken': instance.refreshToken};

ChangePasswordRequest _$ChangePasswordRequestFromJson(
  Map<String, dynamic> json,
) => ChangePasswordRequest(
  oldPassword: json['oldPassword'] as String,
  newPassword: json['newPassword'] as String,
);

Map<String, dynamic> _$ChangePasswordRequestToJson(
  ChangePasswordRequest instance,
) => <String, dynamic>{
  'oldPassword': instance.oldPassword,
  'newPassword': instance.newPassword,
};

LogoutRequest _$LogoutRequestFromJson(Map<String, dynamic> json) =>
    LogoutRequest(refreshToken: json['refreshToken'] as String?);

Map<String, dynamic> _$LogoutRequestToJson(LogoutRequest instance) =>
    <String, dynamic>{'refreshToken': instance.refreshToken};

MeResponse _$MeResponseFromJson(Map<String, dynamic> json) => MeResponse(
  id: json['id'] as String,
  username: json['username'] as String,
  email: json['email'] as String,
  fullName: json['fullName'] as String,
  phone: json['phone'] as String?,
  language: json['language'] as String,
  companyId: json['companyId'] as String,
  companyName: json['companyName'] as String,
  roles: (json['roles'] as List<dynamic>).map((e) => e as String).toList(),
  permissions: (json['permissions'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  lastLoginAt: json['lastLoginAt'] == null
      ? null
      : DateTime.parse(json['lastLoginAt'] as String),
  mfaEnabled: json['mfaEnabled'] as bool,
);

Map<String, dynamic> _$MeResponseToJson(MeResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'email': instance.email,
      'fullName': instance.fullName,
      'phone': instance.phone,
      'language': instance.language,
      'companyId': instance.companyId,
      'companyName': instance.companyName,
      'roles': instance.roles,
      'permissions': instance.permissions,
      'lastLoginAt': instance.lastLoginAt?.toIso8601String(),
      'mfaEnabled': instance.mfaEnabled,
    };
