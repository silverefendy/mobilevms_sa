enum ErrorType {
  network,
  authentication,
  authorization,
  validation,
  notFound,
  server,
  unknown,
}

class AppException implements Exception {
  final String message;
  final int? statusCode;
  final ErrorType type;
  final String? details;
  final String? code;

  AppException(
    this.message, {
    this.statusCode,
    this.type = ErrorType.unknown,
    this.details,
    this.code,
  });

  factory AppException.network(String message, {String? details, int? statusCode}) {
    return AppException(
      message,
      type: ErrorType.network,
      details: details,
      statusCode: statusCode,
    );
  }

  factory AppException.authentication(String message, {String? details, int? statusCode}) {
    return AppException(
      message,
      type: ErrorType.authentication,
      details: details,
      statusCode: statusCode,
    );
  }

  factory AppException.authorization(String message, {String? details, int? statusCode}) {
    return AppException(
      message,
      type: ErrorType.authorization,
      details: details,
      statusCode: statusCode,
    );
  }

  factory AppException.validation(String message, {String? details, int? statusCode}) {
    return AppException(
      message,
      type: ErrorType.validation,
      details: details,
      statusCode: statusCode,
    );
  }

  factory AppException.notFound(String message, {String? details, int? statusCode}) {
    return AppException(
      message,
      type: ErrorType.notFound,
      details: details,
      statusCode: statusCode,
    );
  }

  factory AppException.server(String message, {String? details, int? statusCode}) {
    return AppException(
      message,
      type: ErrorType.server,
      details: details,
      statusCode: statusCode,
    );
  }

  factory AppException.fromStatusCode(int statusCode, String message) {
    switch (statusCode) {
      case 400:
        return AppException.validation(message, statusCode: statusCode);
      case 401:
        return AppException.authentication(message, statusCode: statusCode);
      case 403:
        return AppException.authorization(message, statusCode: statusCode);
      case 404:
        return AppException.notFound(message, statusCode: statusCode);
      case 500:
      case 502:
      case 503:
      case 504:
        return AppException.server(message, statusCode: statusCode);
      default:
        return AppException(message, statusCode: statusCode);
    }
  }

  @override
  String toString() => message;

  String get userFriendlyMessage {
    switch (type) {
      case ErrorType.network:
        return 'Network error. Please check your internet connection.';
      case ErrorType.authentication:
        return 'Authentication failed. Please log in again.';
      case ErrorType.authorization:
        return 'You do not have permission to perform this action.';
      case ErrorType.validation:
        return message;
      case ErrorType.notFound:
        return 'The requested resource was not found.';
      case ErrorType.server:
        return 'Server error. Please try again later.';
      case ErrorType.unknown:
        return 'An unexpected error occurred.';
    }
  }
}
