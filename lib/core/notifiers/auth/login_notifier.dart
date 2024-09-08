import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "../../managers/secure_storage_manager.dart";
import "../../models/auth/login/login_request.types.dart";
import "../../models/auth/login/login_response.types.dart";
import "../../models/base_response.dart";

import "../../repository/auth/auth.repository.dart";
import "../base.notifier.dart";

final AutoDisposeStateNotifierProvider<LogInNotifier,
        AsyncValue<BaseResponse<LoginResponse>>> logInNotifierProvider =
    StateNotifierProvider.autoDispose<LogInNotifier,
            AsyncValue<BaseResponse<LoginResponse>>>(
        (AutoDisposeStateNotifierProviderRef<LogInNotifier,
                AsyncValue<BaseResponse<LoginResponse>>>
            ref) {
  return LogInNotifier(ref);
});

class LogInNotifier
    extends BaseNotifierRequestResponse<LoginRequest, LoginResponse> {
  LogInNotifier(super.ref);

  @override
  Future<void> performAction(LoginRequest requestData, VoidCallback onLoading,
      Function(String) onSuccess, Function(String) onError) async {
    onLoading();
    try {
      final AuthenticationRepository authRepo =
          ref.read(authenticationRepositoryProvider);
      final BaseResponse<LoginResponse> response =
          await authRepo.login(requestData);

      handleResponse(response, (String successMessage) {
        // Verificar si el usuario tiene el rol "ROLE_CLIENT"
        if (response.data.roles.contains("ROLE_CLIENT")) {
          // Almacenar los datos de inicio de sesión
          storeSecureData(response.data);
          onSuccess(successMessage);
        } else {
          // Si no tiene el rol adecuado, mostrar un error
          onError("No tienes permisos para acceder a esta aplicación.");
        }
      }, onError);
    } on Exception catch (e) {
      print("Login Exception: $e");
      onError("Login Failed. Please try again later.");
    }
  }

  Future<void> storeSecureData(LoginResponse data) async {
    if (data.token.isNotEmpty) {
      print("Attempting to store data with token: ${data.token}");
      await ref
          .read(secureStorageProvider)
          .storeLoginData(data.token, data.userId, data.roles);
    } else {
      print("Data token is empty, not storing data.");
    }
  }
}
