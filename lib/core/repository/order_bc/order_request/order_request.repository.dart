import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import "../../../constants/order_bc/order_request/order_request.constants.dart";
import '../../../models/base_response.dart';
import "../../../models/order/order_request/saver_order_request.response.types.dart";
import '../../../network/api_service.dart';

final Provider<OrderRequestRepository> orderRequestRepositoryProvider =
    Provider<OrderRequestRepository>((ProviderRef<OrderRequestRepository> ref) {
  final ApiService apiService = ref.read(apiServiceProvider);
  return OrderRequestRepository(apiService);
});

class OrderRequestRepository {
  final ApiService apiService;

  OrderRequestRepository(this.apiService);

  Future<BaseResponse<SaveOrderRequestResponse>> createOrderRequest() async {
    const String endpoint = OrderRequestEndpoints.orderRequest;

    final Response response = await apiService.postRequest(
      endpoint,
      {},
    );
    final Map<String, dynamic> responseData = response.data;

    return BaseResponse<SaveOrderRequestResponse>.fromJson(responseData,
        (Object? json) {
      return SaveOrderRequestResponse.fromJson(json as Map<String, dynamic>);
    });
  }

  Future<BaseResponse<String>> cancelOrderRequest(String orderId) async {
    const String endpoint = OrderRequestEndpoints.orderRequest;

    final Response response =
        await apiService.deleteRequestById(endpoint, orderId);
    final Map<String, dynamic> responseData = response.data;

    return BaseResponse<String>.fromJson(responseData, (Object? json) {
      return json as String;
    });
  }
}
