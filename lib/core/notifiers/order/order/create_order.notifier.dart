import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "../../../models/base_response.dart";

import "../../../models/order/order/save_order.request.types.dart";
import "../../../repository/order_bc/order/order_repository.dart";
import "../../base.notifier.dart";

final StateNotifierProviderFamily<
    OrderNotifier,
    AsyncValue<BaseResponse<String>>,
    SaveOrderRequest> orderNotifierProvider = StateNotifierProvider.family<
        OrderNotifier, AsyncValue<BaseResponse<String>>, SaveOrderRequest>(
    (StateNotifierProviderRef<OrderNotifier, AsyncValue<BaseResponse<String>>>
            ref,
        SaveOrderRequest orderRequest) {
  return OrderNotifier(orderRequest, ref);
});

class OrderNotifier extends BaseNotifier<String> {
  final SaveOrderRequest orderRequest;

  OrderNotifier(this.orderRequest, super.ref) {
    createOrder();
  }

  Future<void> createOrder() async {
    state = const AsyncValue<BaseResponse<String>>.loading();
    await performAction(() {}, (String msg) {}, (String err) {});
  }

  @override
  Future<void> performAction(VoidCallback onLoading, Function(String) onSuccess,
      Function(String) onError) async {
    onLoading();
    try {
      final BaseResponse<String> response =
          await ref.read(orderRepositoryProvider).createOrder(orderRequest);
      handleResponse(response, onSuccess, onError);
      state = AsyncValue<BaseResponse<String>>.data(response);
    } on Exception catch (e) {
      state = AsyncValue<BaseResponse<String>>.error(e, StackTrace.current);
    }
  }
}
