import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "../../../models/base_response.dart";
import "../../../models/management/product/products_by_category_of_campus.response.types.dart";
import "../../../repository/management_bc/product/product.repository.dart";
import "../../base.notifier.dart";

final StateNotifierProviderFamily<
        ProductsByCategoryOfCampusNotifier,
        AsyncValue<BaseResponse<List<ProductByCategoryOfCampusResponse>>>,
        String> productsByCategoryOfCampusNotifierProvider =
    StateNotifierProvider.family<
        ProductsByCategoryOfCampusNotifier,
        AsyncValue<BaseResponse<List<ProductByCategoryOfCampusResponse>>>,
        String>((StateNotifierProviderRef<
                ProductsByCategoryOfCampusNotifier,
                AsyncValue<
                    BaseResponse<List<ProductByCategoryOfCampusResponse>>>>
            ref,
        String campusCategoryId) {
  return ProductsByCategoryOfCampusNotifier(campusCategoryId, ref);
});

class ProductsByCategoryOfCampusNotifier
    extends BaseNotifier<List<ProductByCategoryOfCampusResponse>> {
  final String campusCategoryId;
  static Map<String, List<ProductByCategoryOfCampusResponse>> cachedDataMap =
      <String, List<ProductByCategoryOfCampusResponse>>{};
  bool needsUpdate = true;

  ProductsByCategoryOfCampusNotifier(this.campusCategoryId, super.ref) {
    loadData();
  }

  bool needToUpdate() {
    return needsUpdate || !cachedDataMap.containsKey(campusCategoryId);
  }

  Future<void> loadData() async {
    if (cachedDataMap.containsKey(campusCategoryId) && !needToUpdate()) {
      state = AsyncValue<
              BaseResponse<List<ProductByCategoryOfCampusResponse>>>.data(
          BaseResponse<List<ProductByCategoryOfCampusResponse>>(
              code: "SUCCESS", data: cachedDataMap[campusCategoryId]!));
      return;
    }
    await _fetchData();
  }

  Future<void> _fetchData() async {
    state = const AsyncValue<
        BaseResponse<List<ProductByCategoryOfCampusResponse>>>.loading();
    await performAction(() {}, (String msg) {}, (String err) {});
  }

  @override
  Future<void> performAction(VoidCallback onLoading, Function(String) onSuccess,
      Function(String) onError) async {
    onLoading();
    try {
      final BaseResponse<List<ProductByCategoryOfCampusResponse>> response =
          await ref
              .read(productRepositoryProvider)
              .getProductByCategoryOfCampus(
                campusId: campusCategoryId,
                available: true,
              );
      cachedDataMap[campusCategoryId] = response.data;
      handleResponse(response, onSuccess, onError);
      needsUpdate = false;
      state = AsyncValue<
          BaseResponse<List<ProductByCategoryOfCampusResponse>>>.data(response);
    } on Exception catch (e) {
      state = AsyncValue<
              BaseResponse<List<ProductByCategoryOfCampusResponse>>>.error(
          e, StackTrace.current);
      needsUpdate = true;
    }
  }

  Future<void> reloadData() async {
    needsUpdate = true;
    await loadData();
  }
}
