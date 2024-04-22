import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "../../../mock/auth/mock_sign_up/mock_sign_up.dart";
import "../../models/auth/sign_up/sign_up.request.types.dart";
import "../../models/auth/sign_up/sign_up.response.types.dart";
import "../../models/base_response.dart";
import "../base.notifier.dart";

final AutoDisposeStateNotifierProvider<SignUpNotifier,
        AsyncValue<BaseResponse<SignUpResponse>>> signUpNotifierProvider =
    StateNotifierProvider.autoDispose<SignUpNotifier,
            AsyncValue<BaseResponse<SignUpResponse>>>(
        (AutoDisposeStateNotifierProviderRef<SignUpNotifier,
                AsyncValue<BaseResponse<SignUpResponse>>>
            ref) {
  return SignUpNotifier(ref);
});

class SignUpNotifier
    extends BaseNotifierRequestResponse<SignUpRequest, SignUpResponse> {
  SignUpNotifier(super.ref);

  @override
  Future<void> performAction(SignUpRequest requestData, VoidCallback onLoading,
      Function(String) onSuccess, Function(String) onError) async {
    onLoading();
    try {
      final BaseResponse<SignUpResponse> response =
          await ref.read(mockSignUpServiceProvider).signUpUser(requestData);
      handleResponse(response, onSuccess, onError);
    } on Exception {
      onError("Registration Failed. Please try again later.");
    }
  }
}
