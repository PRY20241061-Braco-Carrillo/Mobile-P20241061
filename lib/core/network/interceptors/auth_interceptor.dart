import "package:dio/dio.dart";
import "../../managers/secure_storage_manager.dart";

class AuthInterceptor extends Interceptor {
  final SecureStorageManager secureStorage;

  AuthInterceptor({required this.secureStorage});

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final Map<String, dynamic> loginData = await secureStorage.getLoginData();
    final String? token = loginData[SecureStorageManager.keyToken];
    if (token != null && token.isNotEmpty) {
      options.headers["Authorization"] = "Bearer $token";
    }
    handler.next(options);
  }
}
