import 'package:mobile_vms/domain/models/auth_models.dart';

abstract class JwtAuthRepository {
  /// Authenticate user and return tokens
  Future<TokenResponse> login({
    required String username,
    required String password,
    required String companyCode,
    String? deviceId,
  });

  /// Refresh access token using refresh token
  Future<TokenResponse> refreshTokens(String refreshToken);

  /// Logout user and invalidate session
  Future<void> logout({String? refreshToken});

  /// Get current user information
  Future<MeResponse> getCurrentUser();

  /// Change current user's password
  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  });

  /// Clear local auth state
  Future<void> clearLocalAuthState();

  /// Restore session from local storage
  Future<TokenResponse?> restoreSession();
}
