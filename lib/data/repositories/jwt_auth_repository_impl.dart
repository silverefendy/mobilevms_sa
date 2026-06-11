import 'package:dio/dio.dart';
import 'package:mobile_vms/core/errors/app_exception.dart';
import 'package:mobile_vms/core/storage/secure_token_storage.dart';
import 'package:mobile_vms/domain/models/auth_models.dart';
import 'package:mobile_vms/domain/repositories/jwt_auth_repository.dart';

class JwtAuthRepositoryImpl implements JwtAuthRepository {
  JwtAuthRepositoryImpl({
    required Dio dio,
    required SecureTokenStorage storage,
  }) : _dio = dio, _storage = storage;

  final Dio _dio;
  final SecureTokenStorage _storage;

  @override
  Future<TokenResponse> login({
    required String username,
    required String password,
    required String companyCode,
    String? deviceId,
  }) async {
    try {
      final response = await _dio.post(
        '/api/v1/auth/login',
        data: LoginRequest(
          username: username,
          password: password,
          companyCode: companyCode,
          deviceId: deviceId,
        ).toJson(),
      );

      final tokenResponse = TokenResponse.fromJson(response.data);
      
      // Save tokens to secure storage
      await _storage.saveTokens(
        accessToken: tokenResponse.accessToken,
        refreshToken: tokenResponse.refreshToken,
        tokenType: tokenResponse.tokenType,
        expiresIn: tokenResponse.expiresIn,
      );

      return tokenResponse;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<TokenResponse> refreshTokens(String refreshToken) async {
    try {
      final response = await _dio.post(
        '/api/v1/auth/refresh',
        data: RefreshRequest(refreshToken: refreshToken).toJson(),
      );

      final tokenResponse = TokenResponse.fromJson(response.data);
      
      // Save new tokens to secure storage
      await _storage.saveTokens(
        accessToken: tokenResponse.accessToken,
        refreshToken: tokenResponse.refreshToken,
        tokenType: tokenResponse.tokenType,
        expiresIn: tokenResponse.expiresIn,
      );

      return tokenResponse;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<void> logout({String? refreshToken}) async {
    try {
      final storedRefreshToken = refreshToken ?? await _storage.getRefreshToken();
      
      if (storedRefreshToken != null) {
        await _dio.post(
          '/api/v1/auth/logout',
          data: LogoutRequest(refreshToken: storedRefreshToken).toJson(),
        );
      }
    } catch (_) {
      // Ignore logout errors, proceed to clear local state
    } finally {
      await clearLocalAuthState();
    }
  }

  @override
  Future<MeResponse> getCurrentUser() async {
    try {
      final response = await _dio.get('/api/v1/auth/me');
      return MeResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      await _dio.post(
        '/api/v1/auth/change-password',
        data: ChangePasswordRequest(
          oldPassword: oldPassword,
          newPassword: newPassword,
        ).toJson(),
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<void> clearLocalAuthState() async {
    await _storage.clear();
  }

  @override
  Future<TokenResponse?> restoreSession() async {
    final accessToken = await _storage.getAccessToken();
    final refreshToken = await _storage.getRefreshToken();
    
    if (accessToken == null || refreshToken == null) {
      return null;
    }

    // Check if access token is expired
    if (await _storage.isAccessTokenExpired()) {
      // Try to refresh
      try {
        return await refreshTokens(refreshToken);
      } catch (_) {
        await clearLocalAuthState();
        return null;
      }
    }

    // Return stored token info
    final tokenType = await _storage.getTokenType() ?? 'bearer';
    final expiresIn = await _storage.getExpiresAt();
    final expiresInSeconds = expiresIn != null
        ? expiresIn.difference(DateTime.now()).inSeconds
        : 0;

    return TokenResponse(
      accessToken: accessToken,
      refreshToken: refreshToken,
      tokenType: tokenType,
      expiresIn: expiresInSeconds > 0 ? expiresInSeconds : 3600,
      user: UserBasicInfo(
        id: '',
        username: '',
        email: '',
        fullName: '',
        language: 'en',
        companyId: '',
        roles: [],
        permissions: [],
      ),
    );
  }

  AppException _handleDioError(DioException error) {
    final statusCode = error.response?.statusCode;
    final data = error.response?.data;

    String message = 'An error occurred';
    
    if (data is Map<String, dynamic>) {
      message = data['detail']?.toString() ?? data['message']?.toString() ?? message;
    }

    switch (statusCode) {
      case 401:
        return AppException('Authentication failed', statusCode: statusCode);
      case 403:
        return AppException('Access denied', statusCode: statusCode);
      case 404:
        return AppException('Resource not found', statusCode: statusCode);
      case 422:
        return AppException('Validation error: $message', statusCode: statusCode);
      case 429:
        return AppException('Too many requests', statusCode: statusCode);
      case 500:
        return AppException('Server error', statusCode: statusCode);
      default:
        return AppException(message.isNotEmpty ? message : 'Network error', 
            statusCode: statusCode);
    }
  }
}
