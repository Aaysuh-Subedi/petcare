import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:petcare/core/api/api_endpoints.dart';
import 'package:petcare/core/providers/session_providers.dart';
import 'package:petcare/core/services/session/session_service.dart';

final apiClientProvider = Provider<ApiClient>((ref) {
  final sessionService = ref.read(sessionServiceProvider);
  return ApiClient(sessionService: sessionService);
});

class ApiClient {
  final Dio _dio;
  final SessionService _sessionService;

  ApiClient({required SessionService sessionService})
    : _sessionService = sessionService,
      _dio = Dio(
        BaseOptions(
          baseUrl: ApiEndpoints.baseUrl,
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      ) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Adding JWT token for headers if available
          final token = _sessionService.getToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          // For multipart/form-data, Dio automatically sets the Content-Type, so we should not override it
          if (options.data is FormData) {
            options.headers.remove('Content-Type');
          }

          // LOG REQUEST
          print(
            '🌐 API REQUEST: ${options.method} ${options.baseUrl}${options.path}',
          );
          print('📤 Headers: ${options.headers}');
          if (options.data != null) {
            print('📦 Request Data Type: ${options.data.runtimeType}');
            print('📦 Request Data: ${options.data}');
            if (options.data is Map) {
              print(
                '📦 Request Data Keys: ${(options.data as Map).keys.toList()}',
              );
              print(
                '📦 Request Data Values: ${(options.data as Map).values.toList()}',
              );
            }
          }
          if (options.queryParameters.isNotEmpty) {
            print('🔍 Query Params: ${options.queryParameters}');
          }

          return handler.next(options);
        },
        onResponse: (response, handler) {
          // LOG RESPONSE
          print(
            '✅ API RESPONSE: ${response.statusCode} ${response.requestOptions.method} ${response.requestOptions.path}',
          );
          print('📥 Response Data: ${response.data}');

          return handler.next(response);
        },
        onError: (error, handler) {
          // LOG ERROR
          print('❌ API ERROR: ${error.type} - ${error.message}');
          if (error.response != null) {
            print(
              '📊 Error Response: ${error.response!.statusCode} - ${error.response!.data}',
            );
          }
          if (error.requestOptions.data != null) {
            print('📤 Failed Request Data: ${error.requestOptions.data}');
          }

          return handler.next(error);
        },
      ),
    );
  }

  // GET request
  Future<Response> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // POST request
  Future<Response> post(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // PUT request
  Future<Response> put(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.put(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // DELETE request
  Future<Response> delete(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.delete(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Error handling
  Exception _handleError(DioException error) {
    String message = 'An error occurred';

    print('🔍 Processing DioException: ${error.type}');
    print('🔍 Error message: ${error.message}');
    print('🔍 Error response: ${error.response}');

    if (error.response != null) {
      // Server responded with an error
      final statusCode = error.response!.statusCode;
      final data = error.response!.data;

      print('🔍 Server responded with status: $statusCode');
      print('🔍 Response data type: ${data.runtimeType}');
      print('🔍 Response data: $data');

      if (data is Map<String, dynamic>) {
        final payloadMessage =
            data['message'] ??
            data['error'] ??
            data['detail'] ??
            data['errors'];
        if (payloadMessage != null) {
          if (payloadMessage is List) {
            message = payloadMessage.join(', ');
          } else {
            message = payloadMessage.toString();
          }
        } else {
          message = 'Server error: $statusCode';
        }
      } else if (data is String && data.trim().isNotEmpty) {
        message = data;
      } else {
        message = 'Server error: $statusCode';
      }

      // Add specific messages for common HTTP status codes
      switch (statusCode) {
        case 400:
          message =
              'Bad request: ${message.isNotEmpty ? message : 'Please check your input'}';
          break;
        case 401:
          message =
              'Unauthorized: ${message.isNotEmpty ? message : 'Invalid credentials'}';
          break;
        case 403:
          message =
              'Forbidden: ${message.isNotEmpty ? message : 'Access denied'}';
          break;
        case 404:
          message =
              'Not found: ${message.isNotEmpty ? message : 'Resource not found'}';
          break;
        case 422:
          message =
              'Validation error: ${message.isNotEmpty ? message : 'Invalid data provided'}';
          break;
        case 500:
          message =
              'Server error: ${message.isNotEmpty ? message : 'Internal server error'}';
          break;
        default:
          if (!message.contains('Server error')) {
            message = 'Server error ($statusCode): $message';
          }
      }
    } else {
      // No response from server - Network level errors
      print('🔍 No response received from server');
      print('🔍 DioException type: ${error.type}');
      print('🔍 Raw error message: "${error.message}"');

      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          message =
              'Connection timeout: The server took too long to respond. Please check your internet connection and try again.';
          break;
        case DioExceptionType.receiveTimeout:
          message =
              'Receive timeout: The server stopped responding while sending data. Please try again.';
          break;
        case DioExceptionType.sendTimeout:
          message =
              'Send timeout: Failed to send request to server. Please check your internet connection.';
          break;
        case DioExceptionType.connectionError:
          message =
              'Connection error: Unable to connect to the server at ${error.requestOptions.baseUrl}. Please check:\n• Your internet connection\n• The server is running\n• The server address is correct (${error.requestOptions.baseUrl})';
          break;
        case DioExceptionType.cancel:
          message = 'Request cancelled';
          break;
        case DioExceptionType.badCertificate:
          message =
              'SSL certificate error: The server\'s security certificate is invalid or expired.';
          break;
        case DioExceptionType.badResponse:
          message = 'Bad response: The server returned an invalid response.';
          break;
        case DioExceptionType.unknown:
        default:
          final errorMsg = error.message ?? '';
          if (errorMsg.isNotEmpty) {
            message = 'Network error: $errorMsg';
          } else {
            message =
                'Network error: Unable to connect to server. Please check your internet connection and server status.';
          }
          print('🔍 Unknown DioException - Raw error: $error');
          print('🔍 Error stack trace: ${error.stackTrace}');
          print('🔍 Error request options: ${error.requestOptions}');
      }
    }

    print('🚨 Final error message: $message');
    return Exception(message);
  }
}
