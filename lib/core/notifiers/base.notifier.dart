import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "../../shared/utils/constants/constants.dart";
import "../models/base_response.dart";

abstract class BaseNotifierRequestResponse<T, X>
    extends StateNotifier<AsyncValue<BaseResponse<X>>> {
  final Ref ref;

  BaseNotifierRequestResponse(this.ref)
      : super(const AsyncValue<BaseResponse<Never>>.loading());

  Future<void> performAction(T requestData, VoidCallback onLoading,
      Function(String) onSuccess, Function(String) onError);

  void handleResponse(BaseResponse<X> response, Function(String) onSuccess,
      Function(String) onError) {
    if (<String>["CREATED", "UPDATED", "DELETED", "SUCCESS"]
        .contains(response.code)) {
      onSuccess("Operation Successful: ${response.data}");
    } else {
      onError("Error: ${ResponseCodes.getMessage(response.code)}");
    }
  }
}

abstract class BaseNotifier<T>
    extends StateNotifier<AsyncValue<BaseResponse<T>>> {
  final Ref ref;

  BaseNotifier(this.ref)
      : super(const AsyncValue<BaseResponse<Never>>.loading());

  Future<void> performAction(VoidCallback onLoading, Function(String) onSuccess,
      Function(String) onError);

  void handleResponse(BaseResponse<T> response, Function(String) onSuccess,
      Function(String) onError) {
    if (response.code == "SUCCESS") {
      state = AsyncValue<BaseResponse<T>>.data(response);
      onSuccess("Operation Successful: ${response.data}");
    } else {
      state = AsyncValue<BaseResponse<T>>.error(
          Exception("Error: ${ResponseCodes.getMessage(response.code)}"),
          StackTrace.current);

      onError("Error: ${ResponseCodes.getMessage(response.code)}");
    }
  }
}

abstract class BaseNotifierWithId<T>
    extends StateNotifier<AsyncValue<BaseResponse<T>>> {
  final Ref ref;

  BaseNotifierWithId(this.ref)
      : super(const AsyncValue<BaseResponse<Never>>.loading());

  Future<void> performActionWithId(String id, VoidCallback onLoading,
      Function(String) onSuccess, Function(String) onError);

  void handleResponse(BaseResponse<T> response, Function(String) onSuccess,
      Function(String) onError) {
    if (response.code == "SUCCESS") {
      state = AsyncValue<BaseResponse<T>>.data(response);
      onSuccess("Operation Successful: ${response.data}");
    } else {
      state = AsyncValue<BaseResponse<T>>.error(
          Exception("Error: ${ResponseCodes.getMessage(response.code)}"),
          StackTrace.current);
      onError("Error: ${ResponseCodes.getMessage(response.code)}");
    }
  }
}
