import "package:dio/dio.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "../../../constants/management_bc/category/category.constants.dart";
import "../../../models/base_response.dart";
import "../../../models/management/campus_category/campus_category.response.types.dart";
import "../../../network/api_service.dart";

final Provider<CampusCategoryRepository> campusCategoryRepositoryProvider =
    Provider<CampusCategoryRepository>(
        (ProviderRef<CampusCategoryRepository> ref) {
  final ApiService apiService = ref.read(apiServiceProvider);
  return CampusCategoryRepository(apiService);
});

class CampusCategoryRepository {
  final ApiService apiService;

  CampusCategoryRepository(this.apiService);

  Future<BaseResponse<List<CampusCategoryResponse>>> getCategoriesByCampus({
    required String campusId,
    required int pageNumber,
    required int pageSize,
  }) async {
    final Map<String, dynamic> queryParams = {
      'pageNumber': pageNumber,
      'pageSize': pageSize,
    };

    final String endpoint =
        "${CategoryEndpoints.category}${CategoryEndpoints.campus}/$campusId";

    final Response response = await apiService.getRequest(
      endpoint,
      queryParameters: queryParams,
    );
    final Map<String, dynamic> responseData = response.data;

    return BaseResponse<List<CampusCategoryResponse>>.fromJson(responseData,
        (json) {
      return List<CampusCategoryResponse>.from(
        (json as List).map(
            (e) => CampusCategoryResponse.fromJson(e as Map<String, dynamic>)),
      );
    });
  }
}
