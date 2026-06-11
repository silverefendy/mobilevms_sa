import 'package:flutter/foundation.dart';
import 'package:mobile_vms/domain/models/auth_models.dart';
import 'package:mobile_vms/domain/repositories/jwt_auth_repository.dart';
import 'package:mobile_vms/core/errors/app_exception.dart';

enum AuthStatus { booting, authenticated, unauthenticated }

class AuthController extends ChangeNotifier {
  AuthController({
    required JwtAuthRepository authRepository,
  }) : _authRepository = authRepository;

  final JwtAuthRepository _authRepository;

  AuthStatus status = AuthStatus.booting;
  TokenResponse? session;
  MeResponse? currentUser;
  String? error;
  bool restoring = false;

  Future<void> restoreSession({bool showBooting = true}) async {
    if (restoring) return;
    restoring = true;
    error = null;

    if (showBooting) {
      status = AuthStatus.booting;
      notifyListeners();
    }

    try {
      final existing = await _authRepository.restoreSession();
      if (existing == null) {
        await forceLogout();
        restoring = false;
        return;
      }

      session = existing;
      
      // Get current user info
      currentUser = await _authRepository.getCurrentUser();
      
      status = AuthStatus.authenticated;
      notifyListeners();
    } on AppException catch (e) {
      if (_isInvalidSessionStatus(e.statusCode)) {
        await forceLogout();
        return;
      }

      error = 'Unable to validate session. Using cached session.';
      status = AuthStatus.authenticated;
      notifyListeners();
    } finally {
      restoring = false;
    }
  }

  Future<void> restoreSessionOnResume() => restoreSession(showBooting: false);

  Future<bool> login({
    required String username,
    required String password,
    required String companyCode,
    String? deviceId,
  }) async {
    error = null;
    notifyListeners();

    try {
      final result = await _authRepository.login(
        username: username,
        password: password,
        companyCode: companyCode,
        deviceId: deviceId,
      );

      session = result;
      
      // Get current user info
      currentUser = await _authRepository.getCurrentUser();

      status = AuthStatus.authenticated;
      notifyListeners();

      return true;
    } on AppException catch (e) {
      error = e.message;
      status = AuthStatus.unauthenticated;
      notifyListeners();
      return false;
    } catch (e) {
      error = e.toString();
      status = AuthStatus.unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    try {
      await _authRepository.logout(refreshToken: session?.refreshToken);
    } catch (_) {
      // Ignore logout errors
    }
    _clearRuntimeAuthState();
    notifyListeners();
  }

  Future<void> forceLogout() async {
    await _authRepository.clearLocalAuthState();
    _clearRuntimeAuthState();
    notifyListeners();
  }

  Future<bool> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      await _authRepository.changePassword(
        oldPassword: oldPassword,
        newPassword: newPassword,
      );
      return true;
    } on AppException catch (e) {
      error = e.message;
      notifyListeners();
      return false;
    } catch (e) {
      error = e.toString();
      notifyListeners();
      return false;
    }
  }

  bool _isInvalidSessionStatus(int? statusCode) =>
      statusCode == 401 || statusCode == 403;

  void _clearRuntimeAuthState() {
    error = null;
    restoring = false;
    session = null;
    currentUser = null;
    status = AuthStatus.unauthenticated;
  }
}
