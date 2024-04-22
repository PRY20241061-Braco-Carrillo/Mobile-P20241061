import "package:dio/dio.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "../../constants/auth.consts.dart";
import "../../managers/secure_storage_manager.dart";

class TokenInterceptor extends Interceptor {
  final Ref ref;
  Dio dio;

  TokenInterceptor(this.ref, this.dio);

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final Map<String, dynamic> authDataProv =
        await ref.read(authDataProvider.future);
    final String? token = authDataProv["token"] as String?;
    if (token == null) {
      handler.reject(DioException(
          requestOptions: options,
          error: "No token found",
          type: DioExceptionType.badResponse));
      return;
    }
    options.headers["Authorization"] = "Bearer $token";
    super.onRequest(options, handler);
  }

  @override
  Future<void> onError(
      DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      final RequestOptions options = err.response!.requestOptions;
      try {
        final Map<String, dynamic> newTokenData = await _refreshToken();
        final String? newToken = newTokenData["token"] as String?;
        if (newToken == null) {
          handler.reject(DioException(
              requestOptions: options,
              error: "Failed to refresh token",
              type: DioExceptionType.badResponse));
          return;
        }
        options.headers["Authorization"] = "Bearer $newToken";
        dio.options.headers["Authorization"] = "Bearer $newToken";
        return dio.fetch(options).then(
            (Response<dynamic> r) => handler.resolve(r),
            onError: (dynamic e) => handler.reject(e));
      } on Exception {
        super.onError(err, handler);
      }
    } else {
      super.onError(err, handler);
    }
  }

  Future<Map<String, dynamic>> _refreshToken() async {
    final Map<String, dynamic> authData =
        await ref.read(authDataProvider.future);
    final String? refreshToken = authData["token"] as String?;
    if (refreshToken == null) {
      throw Exception("No refresh token found");
    }
    final Dio tokenDio = Dio();
    final Response<dynamic> response = await tokenDio.post(
        "${APIAuthConstants.baseUrl}${APIAuthConstants.refreshTokenEndpoint}",
        options: Options(headers: <String, dynamic>{
          "Authorization": "Bearer $refreshToken"
        }));
    if (response.statusCode == 200) {
      await ref.read(secureStorageProvider).storeLoginData(
          // ignore: avoid_dynamic_calls
          response.data["accessToken"],
          // ignore: avoid_dynamic_calls
          response.data["userId"],
          // ignore: avoid_dynamic_calls
          response.data["role"]);
      return ref.read(secureStorageProvider).getLoginData();
    } else {
      throw Exception("Failed to refresh token");
    }
  }
}
