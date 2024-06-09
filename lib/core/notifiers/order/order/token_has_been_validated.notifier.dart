import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../models/base_response.dart';
import '../../../repository/order_bc/order/order_repository.dart';

final StateNotifierProviderFamily<ValidateTokenNotifier,
        AsyncValue<BaseResponse<String>>, String>
    validateTokenNotifierProvider = StateNotifierProvider.family<
        ValidateTokenNotifier,
        AsyncValue<BaseResponse<String>>,
        String>((ref, token) {
  final orderRepository = ref.read(orderRepositoryProvider);
  return ValidateTokenNotifier(token, orderRepository);
});

class ValidateTokenNotifier
    extends StateNotifier<AsyncValue<BaseResponse<String>>> {
  final String token;
  final OrderRepository orderRepository;

  ValidateTokenNotifier(this.token, this.orderRepository)
      : super(AsyncValue.data(BaseResponse<String>(
            code: '', data: ''))); // Estado inicial sin cargar datos

  Future<void> validateToken() async {
    try {
      state = const AsyncValue.loading();
      final response = await orderRepository.getTokenHasBeenValidated(token);
      state = AsyncValue.data(response);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}
