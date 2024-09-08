import "package:dio/dio.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "../../../../shared/widgets/features/restaurant_info-dialog/restaurant.types.dart";
import "../../../constants/management_bc/category/category.constants.dart";
import "../../../models/base_response.dart";
import "../../../network/api_service.dart";

final Provider<CampusInfoRepository> campusInfoRepositoryProvider =
    Provider<CampusInfoRepository>((ProviderRef<CampusInfoRepository> ref) {
  final ApiService apiService = ref.read(apiServiceProvider);
  return CampusInfoRepository(apiService);
});

class CampusInfoRepository {
  final ApiService apiService;

  CampusInfoRepository(this.apiService);

  Future<BaseResponse<CampusResponse>> getComboDetail({
    required String comboId,
  }) async {
    final String endpoint = "${CategoryEndpoints.campus}/$comboId";

    final Response response = await apiService.getRequest(
      endpoint,
    );
    final Map<String, dynamic> responseData = response.data;

    return BaseResponse<CampusResponse>.fromJson(responseData, (Object? json) {
      return CampusResponse.fromJson(json as Map<String, dynamic>);
    });
  }
}
