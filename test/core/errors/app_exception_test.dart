import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_vms/core/errors/app_exception.dart';

void main() {
  group('AppException', () {
    test('should create basic exception', () {
      final exception = AppException('Test error');
      expect(exception.message, 'Test error');
      expect(exception.type, ErrorType.unknown);
      expect(exception.statusCode, isNull);
    });

    test('should create exception with status code', () {
      final exception = AppException('Test error', statusCode: 404);
      expect(exception.message, 'Test error');
      expect(exception.statusCode, 404);
    });

    test('should create network exception', () {
      final exception = AppException.network('Network error');
      expect(exception.type, ErrorType.network);
      expect(exception.message, 'Network error');
    });

    test('should create authentication exception', () {
      final exception = AppException.authentication('Auth failed');
      expect(exception.type, ErrorType.authentication);
      expect(exception.message, 'Auth failed');
    });

    test('should create authorization exception', () {
      final exception = AppException.authorization('Access denied');
      expect(exception.type, ErrorType.authorization);
      expect(exception.message, 'Access denied');
    });

    test('should create validation exception', () {
      final exception = AppException.validation('Invalid input');
      expect(exception.type, ErrorType.validation);
      expect(exception.message, 'Invalid input');
    });

    test('should create not found exception', () {
      final exception = AppException.notFound('Resource not found');
      expect(exception.type, ErrorType.notFound);
      expect(exception.message, 'Resource not found');
    });

    test('should create server exception', () {
      final exception = AppException.server('Server error');
      expect(exception.type, ErrorType.server);
      expect(exception.message, 'Server error');
    });

    test('should create exception from status code 400', () {
      final exception = AppException.fromStatusCode(400, 'Bad request');
      expect(exception.type, ErrorType.validation);
      expect(exception.statusCode, 400);
    });

    test('should create exception from status code 401', () {
      final exception = AppException.fromStatusCode(401, 'Unauthorized');
      expect(exception.type, ErrorType.authentication);
      expect(exception.statusCode, 401);
    });

    test('should create exception from status code 403', () {
      final exception = AppException.fromStatusCode(403, 'Forbidden');
      expect(exception.type, ErrorType.authorization);
      expect(exception.statusCode, 403);
    });

    test('should create exception from status code 404', () {
      final exception = AppException.fromStatusCode(404, 'Not found');
      expect(exception.type, ErrorType.notFound);
      expect(exception.statusCode, 404);
    });

    test('should create exception from status code 500', () {
      final exception = AppException.fromStatusCode(500, 'Server error');
      expect(exception.type, ErrorType.server);
      expect(exception.statusCode, 500);
    });

    test('should return user friendly message for network error', () {
      final exception = AppException.network('Connection failed');
      expect(exception.userFriendlyMessage, 'Network error. Please check your internet connection.');
    });

    test('should return user friendly message for authentication error', () {
      final exception = AppException.authentication('Auth failed');
      expect(exception.userFriendlyMessage, 'Authentication failed. Please log in again.');
    });

    test('should return user friendly message for authorization error', () {
      final exception = AppException.authorization('Access denied');
      expect(exception.userFriendlyMessage, 'You do not have permission to perform this action.');
    });

    test('should return user friendly message for validation error', () {
      final exception = AppException.validation('Invalid email');
      expect(exception.userFriendlyMessage, 'Invalid email');
    });

    test('should return user friendly message for not found error', () {
      final exception = AppException.notFound('Resource not found');
      expect(exception.userFriendlyMessage, 'The requested resource was not found.');
    });

    test('should return user friendly message for server error', () {
      final exception = AppException.server('Server error');
      expect(exception.userFriendlyMessage, 'Server error. Please try again later.');
    });

    test('should return user friendly message for unknown error', () {
      final exception = AppException('Unknown error');
      expect(exception.userFriendlyMessage, 'An unexpected error occurred.');
    });
  });
}
