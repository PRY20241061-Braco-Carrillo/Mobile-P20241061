import "package:dio/dio.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "../../../constants/management_bc/campus/campus.constants.dart";

import "../../../models/base_response.dart";
import "../../../models/management/campus/campus.response.types.dart";
import "../../../network/api_service.dart";

final Provider<CampusRepository> campusRepositoryProvider =
    Provider<CampusRepository>((ProviderRef<CampusRepository> ref) {
  final ApiService apiService = ref.read(apiServiceProvider);
  return CampusRepository(apiService);
});

class CampusRepository {
  final ApiService apiService;

  CampusRepository(this.apiService);

  Future<BaseResponse<List<CampusResponse>>> getCampusByRestaurantId({
    required String restaurantId,
    required int pageNumber,
    required int pageSize,
    bool available = true,
  }) async {
    final Map<String, dynamic> queryParams = {
      "pageNumber": pageNumber,
      "pageSize": pageSize,
      "available": available,
    };

    final String endpoint =
        "${CampusEndpoints.campus}${CampusEndpoints.restaurant}/$restaurantId";

    final Response response = await apiService.getRequest(
      endpoint,
      queryParameters: queryParams,
    );
    final Map<String, dynamic> responseData = response.data;

    return BaseResponse<List<CampusResponse>>.fromJson(responseData,
        (Object? json) {
      return List<CampusResponse>.from(
        (json as List)
            .map((e) => CampusResponse.fromJson(e as Map<String, dynamic>)),
      );
    });
  }
}
