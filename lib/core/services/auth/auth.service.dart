import "package:dio/dio.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "../../constants/auth.consts.dart";
import "../../models/auth/login/login_request.types.dart";
import "../../models/auth/login/login_response.types.dart";
import "../../models/auth/sign_up/sign_up.request.types.dart";
import "../../models/auth/sign_up/sign_up.response.types.dart";
import "../../models/base_response.dart";
import "token_interceptor.dart";

class AuthenticationService {
  final Dio _dio;
  final Ref ref;

  AuthenticationService(this.ref) : _dio = Dio() {
    _dio.interceptors.add(TokenInterceptor(ref, _dio));
  }

  Future<BaseResponse<LoginResponse>> logInUser(
      LoginRequest loginRequest) async {
    final Response<BaseResponse<LoginResponse>> response = await _dio.post(
      "${APIAuthConstants.baseUrl}${APIAuthConstants.loginEndpoint}",
      data: loginRequest.toJson(),
    );
    return BaseResponse<LoginResponse>.fromJson(
        response.data as Map<String, dynamic>, LoginResponse.fromJson);
  }

  Future<BaseResponse<SignUpResponse>> signUpUser(
      SignUpRequest signUpRequest) async {
    final Response<BaseResponse<SignUpResponse>> response = await _dio.post(
      "${APIAuthConstants.baseUrl}${APIAuthConstants.signUpEndpoint}",
      data: signUpRequest.toJson(),
    );
    return BaseResponse<SignUpResponse>.fromJson(
        response.data as Map<String, dynamic>, SignUpResponse.fromJson);
  }
}
