import "package:dio/dio.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "../../../constants/management_bc/restaurant/restaurant.constants.dart";
import "../../../models/base_response.dart";
import "../../../models/management/restaurant/restaurant.response.types.dart";
import "../../../network/api_service.dart";

final Provider<RestaurantRepository> restaurantRepositoryProvider =
    Provider<RestaurantRepository>((ProviderRef<RestaurantRepository> ref) {
  final ApiService apiService = ref.read(apiServiceProvider);
  return RestaurantRepository(apiService);
});

class RestaurantRepository {
  final ApiService apiService;

  RestaurantRepository(this.apiService);

  Future<BaseResponse<List<RestaurantResponse>>> getRestaurants({
    required int pageNumber,
    required int pageSize,
    bool available = true,
  }) async {
    final Map<String, dynamic> queryParams = {
      "pageNumber": pageNumber,
      "pageSize": pageSize,
      "available": available,
    };

    final Response response = await apiService.getRequest(
      RestaurantEndpoints.restaurant,
      queryParameters: queryParams,
    );
    final Map<String, dynamic> responseData = response.data;

    return BaseResponse<List<RestaurantResponse>>.fromJson(responseData,
        (Object? json) {
      return List<RestaurantResponse>.from(
        (json as List)
            .map((e) => RestaurantResponse.fromJson(e as Map<String, dynamic>)),
      );
    });
  }
}
