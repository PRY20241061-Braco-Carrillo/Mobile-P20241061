import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "../../../../mock/management/products_by_category/mock_products_by_category.dart";

import "../../../models/base_response.dart";
import "../../../models/management/product/products_by_category_of_campus.response.types.dart";
import "../../base.notifier.dart";

final StateNotifierProviderFamily<
        ProductsByCategoryOfCampusNotifier,
        AsyncValue<BaseResponse<List<ProductByCategoryOfCampusResponse>>>,
        String> productsByCategoryOfCampusNotifierProvider =
    StateNotifierProvider.family<
        ProductsByCategoryOfCampusNotifier,
        AsyncValue<BaseResponse<List<ProductByCategoryOfCampusResponse>>>,
        String>((ref, campusCategoryId) {
  return ProductsByCategoryOfCampusNotifier(campusCategoryId, ref);
});

class ProductsByCategoryOfCampusNotifier
    extends BaseNotifier<List<ProductByCategoryOfCampusResponse>> {
  final String campusCategoryId;
  static Map<String, List<ProductByCategoryOfCampusResponse>> cachedDataMap =
      {};
  bool needsUpdate = true;

  ProductsByCategoryOfCampusNotifier(this.campusCategoryId, super.ref) {
    loadData();
  }

  bool needToUpdate() {
    return needsUpdate || !cachedDataMap.containsKey(campusCategoryId);
  }

  Future<void> loadData() async {
    if (cachedDataMap.containsKey(campusCategoryId) && !needToUpdate()) {
      state = AsyncValue.data(BaseResponse(
          code: "SUCCESS", data: cachedDataMap[campusCategoryId]!));
      return;
    }
    _fetchData();
  }

  void _fetchData() async {
    state = const AsyncValue.loading();
    await performAction(() {}, (String msg) {}, (String err) {});
  }

  @override
  Future<void> performAction(VoidCallback onLoading, Function(String) onSuccess,
      Function(String) onError) async {
    onLoading();
    try {
      final BaseResponse<List<ProductByCategoryOfCampusResponse>> response =
          await ref
              .read(mockProductsByCategoryServiceProvider)
              .getProductsByCategoryService();
      cachedDataMap[campusCategoryId] = response.data;
      handleResponse(response, onSuccess, onError);
      needsUpdate = false;
      state = AsyncValue.data(response);
    } on Exception catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      needsUpdate = true;
    }
  }

  // Método para reiniciar o actualizar los datos
  Future<void> reloadData() async {
    needsUpdate = true; // Forzar actualización en la próxima carga
    await loadData();
  }
}
