import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../models/base_response.dart';
import '../../../models/order/order_request/saver_order_request.response.types.dart';
import '../../../repository/order_bc/order_request/order_request.repository.dart';

final StateNotifierProvider<SaveOrderRequestNotifier,
        AsyncValue<BaseResponse<SaveOrderRequestResponse>>>
    orderRequestNotifierProvider = StateNotifierProvider<
            SaveOrderRequestNotifier,
            AsyncValue<BaseResponse<SaveOrderRequestResponse>>>(
        (StateNotifierProviderRef<SaveOrderRequestNotifier,
                AsyncValue<BaseResponse<SaveOrderRequestResponse>>>
            ref) {
  return SaveOrderRequestNotifier(ref);
});

class SaveOrderRequestNotifier
    extends StateNotifier<AsyncValue<BaseResponse<SaveOrderRequestResponse>>> {
  SaveOrderRequestNotifier(this.ref) : super(const AsyncValue.loading());

  final StateNotifierProviderRef<SaveOrderRequestNotifier,
      AsyncValue<BaseResponse<SaveOrderRequestResponse>>> ref;

  Future<void> createOrder() async {
    state = const AsyncValue.loading();
    try {
      final BaseResponse<SaveOrderRequestResponse> response =
          await ref.read(orderRequestRepositoryProvider).createOrderRequest();
      state = AsyncValue.data(response);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}
