import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import "../../../../modules/order/order_request/providers/order_in_progress.notifier.dart";
import '../../../models/base_response.dart';
import '../../../repository/order_bc/order_request/order_request.repository.dart';
import '../../base.notifier.dart';

final StateNotifierProvider<CancelOrderRequestNotifier,
        AsyncValue<BaseResponse<String>>> cancelOrderRequestNotifierProvider =
    StateNotifierProvider<CancelOrderRequestNotifier,
        AsyncValue<BaseResponse<String>>>(
  (StateNotifierProviderRef<CancelOrderRequestNotifier,
          AsyncValue<BaseResponse<String>>>
      ref) {
    return CancelOrderRequestNotifier(ref);
  },
);

class CancelOrderRequestNotifier extends BaseNotifierWithId<String> {
  CancelOrderRequestNotifier(super.ref);

  Future<void> cancelOrder(String orderId) async {
    state = const AsyncValue<BaseResponse<String>>.loading();
    await performActionWithId(
      orderId,
      () {},
      (String msg) {
        if (msg == "DELETED") {
          ref.read(orderInProgressProvider.notifier).clearOrderInProgress();
          state = AsyncValue<BaseResponse<String>>.data(
              BaseResponse(code: "DELETED", data: "Order Request deleted"));
        }
      },
      (String err) {
        state = AsyncValue<BaseResponse<String>>.error(
            Exception(err), StackTrace.current);
      },
    );
  }

  @override
  Future<void> performActionWithId(
    String orderId,
    VoidCallback onLoading,
    Function(String) onSuccess,
    Function(String) onError,
  ) async {
    onLoading();
    try {
      final BaseResponse<String> response = await ref
          .read(orderRequestRepositoryProvider)
          .cancelOrderRequest(orderId);
      if (response.code == "DELETED") {
        onSuccess(response.code);
      } else {
        onError("Failed to delete order");
      }
    } on Exception catch (e) {
      state = AsyncValue<BaseResponse<String>>.error(e, StackTrace.current);
    }
  }
}
