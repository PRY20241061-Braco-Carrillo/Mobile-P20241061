import "package:dio/dio.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "../../constants/auth/user/user.constants.dart";
import "../../managers/secure_storage_manager.dart";
import "../../models/auth/guest/guest_response.types.dart";
import "../../models/auth/login/login_request.types.dart";
import "../../models/auth/login/login_response.types.dart";
import "../../models/auth/sign_up/sign_up.request.types.dart";

import "../../models/base_response.dart";
import "../../network/api_service.dart";

final Provider<AuthenticationRepository> authenticationRepositoryProvider =
    Provider<AuthenticationRepository>(
        (ProviderRef<AuthenticationRepository> ref) {
  final ApiService apiService = ref.read(apiServiceProvider);
  final SecureStorageManager secureStorage = ref.read(secureStorageProvider);
  return AuthenticationRepository(apiService, secureStorage);
});

class AuthenticationRepository {
  final ApiService apiService;
  final SecureStorageManager secureStorage;

  AuthenticationRepository(this.apiService, this.secureStorage);

  Future<BaseResponse<LoginResponse>> login(LoginRequest loginRequest) async {
    final Response response = await apiService.postRequest(
      UserEndpoints.user + UserEndpoints.login,
      loginRequest.toJson(),
    );
    final Map<String, dynamic> responseData = response.data;

    final BaseResponse<LoginResponse> loginResponse =
        BaseResponse<LoginResponse>.fromJson(responseData, (Object? json) {
      return LoginResponse.fromJson(json as Map<String, dynamic>);
    });

    // Store login data if login is successful
    if (loginResponse.data.token.isNotEmpty) {
      await secureStorage.storeLoginData(
        loginResponse.data.token,
        loginResponse.data.userId,
        loginResponse.data.roles,
      );
    }

    return loginResponse;
  }

  Future<BaseResponse<GuestResponse>> authenticateGuest() async {
    final Response response =
        await apiService.postRequest(UserEndpoints.guest, {});
    final Map<String, dynamic> responseData = response.data;

    final BaseResponse<GuestResponse> guestResponse =
        BaseResponse<GuestResponse>.fromJson(responseData, (Object? json) {
      return GuestResponse.fromJson(json as Map<String, dynamic>);
    });

    // Store guest data
    await secureStorage.storeGuestData(
      guestResponse.data.token,
      guestResponse.data.roles,
    );

    return guestResponse;
  }

  Future<BaseResponse<String>> register(SignUpRequest signUpRequest) async {
    final Response response = await apiService.postRequest(
      UserEndpoints.user + UserEndpoints.register,
      signUpRequest.toJson(),
    );
    final Map<String, dynamic> responseData = response.data;

    return BaseResponse<String>.fromJson(responseData, (Object? json) {
      return json as String;
    });
  }
}
