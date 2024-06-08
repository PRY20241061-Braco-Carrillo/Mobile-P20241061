import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../constants/order_bc/order/order.constants.dart';
import '../../../models/base_response.dart';
import "../../../models/order/order/save_order.request.types.dart";
import '../../../network/api_service.dart';

final Provider<OrderRepository> orderRepositoryProvider =
    Provider<OrderRepository>((ProviderRef<OrderRepository> ref) {
  final ApiService apiService = ref.read(apiServiceProvider);
  return OrderRepository(apiService);
});

class OrderRepository {
  final ApiService apiService;

  OrderRepository(this.apiService);

  Future<BaseResponse<String>> createOrder(
      SaveOrderRequest orderRequest) async {
    const String endpoint = OrderEndpoints.order;

    final Response response = await apiService.postRequest(
      endpoint,
      orderRequest.toJson(),
    );
    final Map<String, dynamic> responseData = response.data;

    return BaseResponse<String>.fromJson(responseData, (Object? json) {
      return json as String;
    });
  }
}
