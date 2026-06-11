import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureTokenStorage {
  SecureTokenStorage() : _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock,
    ),
  );

  final FlutterSecureStorage _storage;

  static const _keyAccessToken = 'access_token';
  static const _keyRefreshToken = 'refresh_token';
  static const _keyTokenType = 'token_type';
  static const _keyExpiresAt = 'expires_at';

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
    required String tokenType,
    required int expiresIn,
  }) async {
    final expiresAt = DateTime.now().add(Duration(seconds: expiresIn));
    await _storage.write(key: _keyAccessToken, value: accessToken);
    await _storage.write(key: _keyRefreshToken, value: refreshToken);
    await _storage.write(key: _keyTokenType, value: tokenType);
    await _storage.write(
      key: _keyExpiresAt,
      value: expiresAt.toIso8601String(),
    );
  }

  Future<String?> getAccessToken() async {
    return await _storage.read(key: _keyAccessToken);
  }

  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _keyRefreshToken);
  }

  Future<String?> getTokenType() async {
    return await _storage.read(key: _keyTokenType);
  }

  Future<DateTime?> getExpiresAt() async {
    final expiresAtStr = await _storage.read(key: _keyExpiresAt);
    if (expiresAtStr == null) return null;
    return DateTime.parse(expiresAtStr);
  }

  Future<bool> isAccessTokenExpired() async {
    final expiresAt = await getExpiresAt();
    if (expiresAt == null) return true;
    return DateTime.now().isAfter(expiresAt);
  }

  Future<bool> shouldRefreshToken() async {
    final expiresAt = await getExpiresAt();
    if (expiresAt == null) return true;
    // Refresh 5 minutes before expiration
    return DateTime.now().add(const Duration(minutes: 5)).isAfter(expiresAt);
  }

  Future<void> clear() async {
    await _storage.delete(key: _keyAccessToken);
    await _storage.delete(key: _keyRefreshToken);
    await _storage.delete(key: _keyTokenType);
    await _storage.delete(key: _keyExpiresAt);
  }
}
