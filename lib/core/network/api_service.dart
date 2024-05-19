import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:dio/dio.dart";

import "dio_client.dart";

abstract class ApiService {
  final DioClient dioClient;

  ApiService(this.dioClient);

  Future<Response<T>> getRequest<T>(String endpoint,
      {Map<String, dynamic>? queryParameters});
  Future<Response<T>> postRequest<T>(
      String endpoint, Map<String, dynamic> data);
  Future<Response<T>> putRequest<T>(String endpoint, Map<String, dynamic> data);
  Future<Response<T>> deleteRequest<T>(
      String endpoint, Map<String, dynamic> data);
}

class DioApiService extends ApiService {
  DioApiService(super.dioClient);

  @override
  Future<Response<T>> getRequest<T>(String endpoint,
      {Map<String, dynamic>? queryParameters}) async {
    return await dioClient.get(endpoint, queryParameters: queryParameters);
  }

  @override
  Future<Response<T>> postRequest<T>(
      String endpoint, Map<String, dynamic> data) async {
    return await dioClient.post(endpoint, data: data);
  }

  @override
  Future<Response<T>> putRequest<T>(
      String endpoint, Map<String, dynamic> data) async {
    return await dioClient.put(endpoint, data: data);
  }

  @override
  Future<Response<T>> deleteRequest<T>(
      String endpoint, Map<String, dynamic> data) async {
    return await dioClient.delete(endpoint, data: data);
  }
}

final Provider<ApiService> apiServiceProvider =
    Provider<ApiService>((ProviderRef<ApiService> ref) {
  final DioClient dioClient = ref.watch(dioClientProvider);
  return DioApiService(dioClient);
});
