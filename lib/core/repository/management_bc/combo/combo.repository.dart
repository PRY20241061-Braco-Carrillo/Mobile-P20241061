import "package:dio/dio.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "../../../constants/management_bc/combo/combo.constants.dart";
import "../../../models/base_response.dart";
import "../../../models/management/combo/combo_by_campus.response.types.dart";
import "../../../models/management/combo/combo_detail.response.types.dart";
import "../../../network/api_service.dart";

final Provider<ComboRepository> comboRepositoryProvider =
    Provider<ComboRepository>((ProviderRef<ComboRepository> ref) {
  final ApiService apiService = ref.read(apiServiceProvider);
  return ComboRepository(apiService);
});

class ComboRepository {
  final ApiService apiService;

  ComboRepository(this.apiService);

  Future<BaseResponse<List<ComboByCampusResponse>>> getComboByCampus({
    required String campusId,
  }) async {
    final String endpoint =
        "${ComboEndpoints.combo}${ComboEndpoints.campus}/$campusId";

    final Response response = await apiService.getRequest(
      endpoint,
    );
    final Map<String, dynamic> responseData = response.data;

    return BaseResponse<List<ComboByCampusResponse>>.fromJson(responseData,
        (Object? json) {
      return List<ComboByCampusResponse>.from(
        (json as List).map(
            (e) => ComboByCampusResponse.fromJson(e as Map<String, dynamic>)),
      );
    });
  }

  Future<BaseResponse<ComboDetailResponse>> getComboDetail({
    required String comboId,
  }) async {
    final String endpoint = "${ComboEndpoints.combo}/$comboId";

    final Response response = await apiService.getRequest(
      endpoint,
    );
    final Map<String, dynamic> responseData = response.data;

    return BaseResponse<ComboDetailResponse>.fromJson(responseData,
        (Object? json) {
      return ComboDetailResponse.fromJson(json as Map<String, dynamic>);
    });
  }
}
