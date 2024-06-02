import "package:dio/dio.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "../../../constants/management_bc/promotion/promotion.constants.dart";
import "../../../models/base_response.dart";
import "../../../models/management/promotion/promotion_by_campus.response.types.dart";
import "../../../models/management/promotion/promotion_combo_detail.response.types.dart";
import "../../../models/management/promotion/promotion_product_detail.response.types.dart";
import "../../../network/api_service.dart";

final Provider<PromotionRepository> promotionRepositoryProvider =
    Provider<PromotionRepository>((ProviderRef<PromotionRepository> ref) {
  final ApiService apiService = ref.read(apiServiceProvider);
  return PromotionRepository(apiService);
});

class PromotionRepository {
  final ApiService apiService;

  PromotionRepository(this.apiService);

  Future<BaseResponse<List<PromotionByCampusResponse>>> getPromotionsByCampus({
    required String campusId,
  }) async {
    final String endpoint =
        "${PromotionEndpoints.promotion}${PromotionEndpoints.campus}/$campusId";

    final Response response = await apiService.getRequest(
      endpoint,
    );
    final Map<String, dynamic> responseData = response.data;

    return BaseResponse<List<PromotionByCampusResponse>>.fromJson(responseData,
        (Object? json) {
      return List<PromotionByCampusResponse>.from(
        (json as List).map((e) =>
            PromotionByCampusResponse.fromJson(e as Map<String, dynamic>)),
      );
    });
  }

  Future<BaseResponse<PromotionComboDetailResponse>> getComboPromotionDetail({
    required String comboId,
  }) async {
    final String endpoint =
        "${PromotionEndpoints.promotion}${PromotionEndpoints.combo}/$comboId";

    final Response response = await apiService.getRequest(
      endpoint,
    );
    final Map<String, dynamic> responseData = response.data;

    return BaseResponse<PromotionComboDetailResponse>.fromJson(responseData,
        (Object? json) {
      return PromotionComboDetailResponse.fromJson(
          json as Map<String, dynamic>);
    });
  }

  Future<BaseResponse<PromotionProductDetailResponse>>
      getProductPromotionDetail({
    required String productVariantId,
  }) async {
    final String endpoint =
        "${PromotionEndpoints.promotion}${PromotionEndpoints.productVariant}/$productVariantId";

    final Response response = await apiService.getRequest(
      endpoint,
    );
    final Map<String, dynamic> responseData = response.data;

    return BaseResponse<PromotionProductDetailResponse>.fromJson(responseData,
        (Object? json) {
      return PromotionProductDetailResponse.fromJson(
          json as Map<String, dynamic>);
    });
  }
}
