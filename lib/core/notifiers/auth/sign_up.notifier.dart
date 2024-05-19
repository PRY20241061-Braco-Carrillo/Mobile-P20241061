import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "../../models/auth/sign_up/sign_up.request.types.dart";
import "../../models/base_response.dart";
import "../../repository/auth/auth.repository.dart";
import "../base.notifier.dart";

final AutoDisposeStateNotifierProvider<SignUpNotifier,
        AsyncValue<BaseResponse<String>>> signUpNotifierProvider =
    StateNotifierProvider.autoDispose<SignUpNotifier,
        AsyncValue<BaseResponse<String>>>((AutoDisposeStateNotifierProviderRef<
            SignUpNotifier, AsyncValue<BaseResponse<String>>>
        ref) {
  return SignUpNotifier(ref);
});

class SignUpNotifier
    extends BaseNotifierRequestResponse<SignUpRequest, String> {
  SignUpNotifier(super.ref);

  @override
  Future<void> performAction(SignUpRequest requestData, VoidCallback onLoading,
      Function(String) onSuccess, Function(String) onError) async {
    onLoading();
    try {
      final AuthenticationRepository authRepo =
          ref.read(authenticationRepositoryProvider);
      final BaseResponse<String> response =
          await authRepo.register(requestData);
      handleResponse(response, onSuccess, onError);
    } on Exception catch (e) {
      print("Sign Up Exception: $e");
      onError("Registration Failed. Please try again later.");
    }
  }
}
