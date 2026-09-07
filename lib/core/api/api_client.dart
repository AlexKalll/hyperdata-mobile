import 'package:dio/dio.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import '../errors/exceptions.dart';
import 'api_constants.dart';
import 'api_interceptor.dart';

class ApiClient {
  late final Dio _dio;

  ApiClient({Dio? dio}) {
    _dio = dio ?? Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 120),
        receiveTimeout: const Duration(seconds: 120),
      ),
    );
    if (dio == null) {
      _dio.interceptors.add(ApiInterceptor());
    }
  }

  Future<Response> get(String endpoint, {bool includeToken = false , Map<String, dynamic>? params}) async {
    try {
      final response = await _dio.get(endpoint, queryParameters: params);
      return response;
    } catch (e) {
      print(e);
      if(e is DioException && e.response != null) {
        print(e.response?.data ?? "hey");
      }
      throw _handleError(e, endpoint);
    }
  }

  Future<Response> post(String endpoint, {dynamic data , Options? options}) async {
    try {
      return await _dio.post(endpoint, data: data,options: options);
    } catch (e) {
      throw _handleError(e, endpoint);
    }
  }

  Future<Response> patch(String endpoint, {dynamic data}) async {
    try {
      return await _dio.patch(endpoint, data: data);
    } catch (e) {
      throw _handleError(e, endpoint);
    }
  }

  Future<Response> put(String endpoint, {dynamic data , Options? options}) async {
    try {
      return await _dio.put(endpoint, data: data);
    } catch (e) {
      throw _handleError(e, endpoint);
    }
  }

  Future<Response> delete(String endpoint, {dynamic data}) async {
    try {
      return await _dio.delete(endpoint, data: data);
    } catch (e) {
      throw _handleError(e, endpoint);
    }
  }

  /// 🛑 Handles errors gracefully and returns meaningful exceptions
  Exception _handleError(dynamic error, String endpoint) {
    try{
    String errorMessage = "Something went wrong";
    int statusCode = 500;

    if (error is DioException) {
      print(error);
      print("❌ API Error: ${error.message} $endpoint");
      print(error.response?.data);

      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          return TimeoutException("Connection timeout. Please try again.");
        case DioExceptionType.sendTimeout:
          return TimeoutException("Request timeout. Please check your connection.");
        case DioExceptionType.receiveTimeout:
          return TimeoutException("Server took too long to respond.");
        case DioExceptionType.cancel:
          return Exception("Request was cancelled.");
        case DioExceptionType.connectionError:
          return NetworkException("No internet connection.");

        case DioExceptionType.badResponse:
          statusCode = error.response?.statusCode ?? 500;
          final responseData = error.response?.data;
          if (statusCode == 400) {
            return BadRequestException(responseData?["message"] ?? "Bad request.");
          } else if (statusCode == 401) {
            return UnauthorizedException(responseData?["message"] ?? "Unauthorized.");
          } else if (statusCode == 403) {
            return ForbiddenException("Forbidden access.");
          } else if (statusCode == 404) {
            return NotFoundException(responseData?["message"] ?? "Resource not found.");
          } else if (statusCode == 500) {
            return ServerException(responseData?["message"] ?? "Internal server error.");
          } else {
            return Exception(responseData?["message"] ?? "Unexpected API error.");
          }

        default:
          return Exception("Unexpected error occurred.");
      }
    }
    else {
      print("❌ Unexpected Error: $error");
      return Exception("Unexpected error: $error");
    }
  }
    catch(e) {
      return Exception("Unexpected error: $error");
    }
  }
}
