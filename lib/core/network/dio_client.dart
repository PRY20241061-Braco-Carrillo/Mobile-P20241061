import "package:dio/dio.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "../constants/api.constants.dart";
import "../managers/secure_storage_manager.dart";
import "interceptors/auth_interceptor.dart";
import "interceptors/logging_interceptor.dart";
import "interceptors/retry_interceptor.dart";

class DioClient {
  final Dio _dio;

  DioClient({
    required String baseUrl,
    required SecureStorageManager secureStorage,
  }) : _dio = Dio(BaseOptions(
          baseUrl: baseUrl,
          connectTimeout:
              const Duration(milliseconds: ApiConstants.connectionTimeout),
          receiveTimeout:
              const Duration(milliseconds: ApiConstants.receiveTimeout),
        )) {
    _dio.interceptors.addAll(<Interceptor>[
      AuthInterceptor(secureStorage: secureStorage),
      LoggingInterceptor(),
      RetryInterceptor(dio: _dio),
    ]);
  }

  Dio get dio => _dio;

  Future<Response<T>> get<T>(String endpoint,
      {Map<String, dynamic>? queryParameters}) async {
    return await _dio.get<T>(endpoint, queryParameters: queryParameters);
  }

  Future<Response<T>> post<T>(String endpoint,
      {Map<String, dynamic>? data}) async {
    return await _dio.post<T>(endpoint, data: data);
  }

  Future<Response<T>> put<T>(String endpoint,
      {Map<String, dynamic>? data}) async {
    return await _dio.put<T>(endpoint, data: data);
  }

  Future<Response<T>> delete<T>(String endpoint,
      {Map<String, dynamic>? data}) async {
    return await _dio.delete<T>(endpoint, data: data);
  }

  Future<Response<T>> patch<T>(String endpoint,
      {Map<String, dynamic>? data}) async {
    return await _dio.patch<T>(endpoint, data: data);
  }
}

final Provider<DioClient> dioClientProvider =
    Provider<DioClient>((ProviderRef<DioClient> ref) {
  final SecureStorageManager secureStorage = ref.read(secureStorageProvider);
  return DioClient(
    baseUrl: ApiConstants.baseUrl,
    secureStorage: secureStorage,
  );
});
