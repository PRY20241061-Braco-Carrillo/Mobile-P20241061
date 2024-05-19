import "package:dio/dio.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "../../../constants/management_bc/product/product.constants.dart";
import "../../../models/base_response.dart";

import "../../../models/management/product/products_by_category_of_campus.response.types.dart";
import "../../../network/api_service.dart";

final Provider<ProductRepository> productRepositoryProvider =
    Provider<ProductRepository>((ProviderRef<ProductRepository> ref) {
  final ApiService apiService = ref.read(apiServiceProvider);
  return ProductRepository(apiService);
});

class ProductRepository {
  final ApiService apiService;

  ProductRepository(this.apiService);

  Future<BaseResponse<List<ProductByCategoryOfCampusResponse>>>
      getProductByCategoryOfCampus({
    required String campusId,
    required bool available,
  }) async {
    final Map<String, dynamic> queryParams = {
      'available': available,
    };

    final String endpoint =
        "${ProductEndpoints.product}${ProductEndpoints.campusCategory}/$campusId";

    final Response response = await apiService.getRequest(
      endpoint,
      queryParameters: queryParams,
    );
    final Map<String, dynamic> responseData = response.data;

    return BaseResponse<List<ProductByCategoryOfCampusResponse>>.fromJson(
        responseData, (json) {
      return List<ProductByCategoryOfCampusResponse>.from(
        (json as List).map((e) => ProductByCategoryOfCampusResponse.fromJson(
            e as Map<String, dynamic>)),
      );
    });
  }
}
