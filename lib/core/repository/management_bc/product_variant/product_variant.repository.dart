import "package:dio/dio.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "../../../constants/management_bc/product_variant/product_variant.constants.dart";
import "../../../models/base_response.dart";
import "../../../models/management/product_variant/variants_by_product.response.types.dart";
import "../../../network/api_service.dart";

final Provider<ProductVariantRepository> productVariantRepositoryProvider =
    Provider<ProductVariantRepository>(
        (ProviderRef<ProductVariantRepository> ref) {
  final ApiService apiService = ref.read(apiServiceProvider);
  return ProductVariantRepository(apiService);
});

class ProductVariantRepository {
  final ApiService apiService;

  ProductVariantRepository(this.apiService);

  Future<BaseResponse<VariantsByProductResponse>> getVariantsProductById({
    required String productId,
  }) async {
    final String endpoint =
        "${ProductVariantEndpoints.productVariant}${ProductVariantEndpoints.product}/$productId";

    final Response response = await apiService.getRequest(
      endpoint,
    );
    final Map<String, dynamic> responseData = response.data;

    return BaseResponse<VariantsByProductResponse>.fromJson(responseData,
        (json) {
      return VariantsByProductResponse.fromJson(json as Map<String, dynamic>);
    });
  }
}
