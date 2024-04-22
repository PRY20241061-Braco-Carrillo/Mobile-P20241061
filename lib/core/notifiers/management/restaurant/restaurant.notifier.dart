import "../../../../mock/management/restaurant/mock_restaurant.dart";
import "../../../models/base_response.dart";
import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "../../../models/management/restaurant/restaurant.response.types.dart";
import "../../base.notifier.dart";

final AutoDisposeStateNotifierProvider<RestaurantNotifier,
        AsyncValue<BaseResponse<RestaurantResponse>>> signUpNotifierProvider =
    StateNotifierProvider.autoDispose<RestaurantNotifier,
            AsyncValue<BaseResponse<RestaurantResponse>>>(
        (AutoDisposeStateNotifierProviderRef<RestaurantNotifier,
                AsyncValue<BaseResponse<RestaurantResponse>>>
            ref) {
  return RestaurantNotifier(ref);
});

class RestaurantNotifier extends BaseNotifier<RestaurantResponse> {
  RestaurantNotifier(super.ref);

  @override
  Future<void> performAction(VoidCallback onLoading, Function(String) onSuccess,
      Function(String) onError) async {
    onLoading();
    try {
      final BaseResponse<RestaurantResponse> response =
          await ref.read(mockRestaurantServiceProvider).getRestaurants();
      handleResponse(response, onSuccess, onError);
    } on Exception {
      onError("Registration Failed. Please try again later.");
    }
  }
}
