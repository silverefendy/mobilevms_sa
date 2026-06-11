import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:mobile_vms/core/auth/auth_controller.dart';
import 'package:mobile_vms/core/errors/app_exception.dart';
import 'package:mobile_vms/data/repositories/jwt_auth_repository.dart';

@GenerateMocks([JwtAuthRepository])
import 'auth_controller_test.mocks.dart';

void main() {
  group('AuthController', () {
    late AuthController authController;
    late MockJwtAuthRepository mockAuthRepository;

    setUp(() {
      mockAuthRepository = MockJwtAuthRepository();
      authController = AuthController(mockAuthRepository);
    });

    tearDown(() {
      authController.dispose();
    });

    test('should login successfully with valid credentials', () async {
      // Arrange
      final companyCode = 'TEST001';
      final username = 'testuser';
      final password = 'password123';
      
      when(mockAuthRepository.login(companyCode, username, password))
          .thenAnswer((_) async => {});

      // Act
      await authController.login(companyCode, username, password);

      // Assert
      verify(mockAuthRepository.login(companyCode, username, password)).called(1);
      expect(authController.state, AuthState.authenticated);
    });

    test('should fail login with wrong credentials', () async {
      // Arrange
      final companyCode = 'TEST001';
      final username = 'testuser';
      final password = 'wrongpassword';
      
      when(mockAuthRepository.login(companyCode, username, password))
          .thenThrow(AppException.authentication('Invalid credentials'));

      // Act
      await authController.login(companyCode, username, password);

      // Assert
      verify(mockAuthRepository.login(companyCode, username, password)).called(1);
      expect(authController.state, AuthState.unauthenticated);
      expect(authController.error, isNotNull);
      expect(authController.error!.type, ErrorType.authentication);
    });

    test('should fail login with network error', () async {
      // Arrange
      final companyCode = 'TEST001';
      final username = 'testuser';
      final password = 'password123';
      
      when(mockAuthRepository.login(companyCode, username, password))
          .thenThrow(AppException.network('Network error'));

      // Act
      await authController.login(companyCode, username, password);

      // Assert
      verify(mockAuthRepository.login(companyCode, username, password)).called(1);
      expect(authController.state, AuthState.unauthenticated);
      expect(authController.error, isNotNull);
      expect(authController.error!.type, ErrorType.network);
    });

    test('should refresh token successfully', () async {
      // Arrange
      when(mockAuthRepository.refreshToken())
          .thenAnswer((_) async => {});

      // Act
      await authController.refreshToken();

      // Assert
      verify(mockAuthRepository.refreshToken()).called(1);
      expect(authController.state, AuthState.authenticated);
    });

    test('should fail token refresh', () async {
      // Arrange
      when(mockAuthRepository.refreshToken())
          .thenThrow(AppException.authentication('Token refresh failed'));

      // Act
      await authController.refreshToken();

      // Assert
      verify(mockAuthRepository.refreshToken()).called(1);
      expect(authController.error, isNotNull);
      expect(authController.error!.type, ErrorType.authentication);
    });

    test('should logout successfully', () async {
      // Arrange
      when(mockAuthRepository.logout())
          .thenAnswer((_) async => {});

      // Act
      await authController.logout();

      // Assert
      verify(mockAuthRepository.logout()).called(1);
      expect(authController.state, AuthState.unauthenticated);
    });

    test('should restore session on boot', () async {
      // Arrange
      when(mockAuthRepository.hasValidToken())
          .thenAnswer((_) async => true);

      // Act
      await authController.boot();

      // Assert
      verify(mockAuthRepository.hasValidToken()).called(1);
      expect(authController.state, AuthState.authenticated);
    });

    test('should not restore session when no valid token', () async {
      // Arrange
      when(mockAuthRepository.hasValidToken())
          .thenAnswer((_) async => false);

      // Act
      await authController.boot();

      // Assert
      verify(mockAuthRepository.hasValidToken()).called(1);
      expect(authController.state, AuthState.unauthenticated);
    });
  });
}
