import 'package:dio/dio.dart';
import 'package:mobile_vms/config/app_config.dart';
import 'package:mobile_vms/core/errors/app_exception.dart';
import 'package:mobile_vms/core/storage/secure_token_storage.dart';

class JwtApiClient {
  JwtApiClient({
    required SecureTokenStorage storage,
    Dio? dio,
  }) : _storage = storage, _dio = dio ?? Dio() {
    _setupDio();
  }

  final SecureTokenStorage _storage;
  late final Dio _dio;
  bool _isRefreshing = false;

  void _setupDio() {
    _dio.options = BaseOptions(
      baseUrl: AppConfig.baseUrl.isNotEmpty ? AppConfig.baseUrl : 'http://localhost',
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 20),
      sendTimeout: const Duration(seconds: 20),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        final currentBase = AppConfig.baseUrl;
        if (currentBase.isNotEmpty) {
          options.baseUrl = currentBase;
        }

        // Inject access token
        _injectToken(options);

        if (AppConfig.enableApiLog) {
          print('API Request: ${options.method} ${options.path}');
        }

        handler.next(options);
      },
      onResponse: (response, handler) {
        if (AppConfig.enableApiLog) {
          print('API Response: ${response.statusCode} ${response.requestOptions.path}');
        }
        handler.next(response);
      },
      onError: (error, handler) async {
        if (AppConfig.enableApiLog) {
          print('API Error: ${error.response?.statusCode} ${error.requestOptions.path}');
        }

        // Handle 401 - try to refresh token
        if (error.response?.statusCode == 401 && !_isRefreshing) {
          _isRefreshing = true;
          try {
            final refreshToken = await _storage.getRefreshToken();
            if (refreshToken != null) {
              // Call refresh endpoint directly to avoid circular dependency
              final response = await _dio.post(
                '/api/v1/auth/refresh',
                data: {'refresh_token': refreshToken},
                options: Options(
                  headers: {'Content-Type': 'application/json'},
                ),
              );

              final newAccessToken = response.data['access_token'];
              final newRefreshToken = response.data['refresh_token'];
              final tokenType = response.data['token_type'];
              final expiresIn = response.data['expires_in'];

              // Save new tokens
              await _storage.saveTokens(
                accessToken: newAccessToken,
                refreshToken: newRefreshToken,
                tokenType: tokenType,
                expiresIn: expiresIn,
              );

              // Retry original request with new token
              final opts = error.requestOptions;
              opts.headers['Authorization'] = '$tokenType $newAccessToken';
              final retryResponse = await _dio.fetch(opts);
              _isRefreshing = false;
              return handler.resolve(retryResponse);
            }
          } catch (e) {
            // Refresh failed, clear tokens
            await _storage.clear();
            _isRefreshing = false;
          }
        }

        handler.next(error);
      },
    ));
  }

  Future<void> _injectToken(RequestOptions options) async {
    final accessToken = await _storage.getAccessToken();
    final tokenType = await _storage.getTokenType() ?? 'bearer';

    if (accessToken != null && accessToken.isNotEmpty) {
      options.headers['Authorization'] = '$tokenType $accessToken';
    }
  }

  Dio get dio => _dio;

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  void updateBaseUrl(String url) {
    AppConfig.baseUrl = url;
    _dio.options.baseUrl = url;
  }

  AppException _handleDioError(DioException error) {
    final statusCode = error.response?.statusCode;
    final data = error.response?.data;

    String message = 'An error occurred';
    
    if (data is Map<String, dynamic>) {
      message = data['detail']?.toString() ?? data['message']?.toString() ?? message;
    }

    // Handle network errors
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout) {
      return AppException.network('Connection timeout');
    }
    
    if (error.type == DioExceptionType.connectionError) {
      return AppException.network('No internet connection');
    }

    // Handle HTTP errors with status codes
    if (statusCode != null) {
      return AppException.fromStatusCode(statusCode, message);
    }

    // Default error
    return AppException.network(message.isNotEmpty ? message : 'Network error');
  }
}
