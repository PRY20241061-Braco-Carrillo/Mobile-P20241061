import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "../../../../mock/management/product_variant/mock_variants_by_product.dart";
import "../../../models/base_response.dart";
import "../../../models/management/product_variant/variants_by_product.response.types.dart";
import "../../base.notifier.dart";

final StateNotifierProviderFamily<VariantsByProductNotifier,
        AsyncValue<BaseResponse<VariantsByProductResponse>>, String>
    variantsByProductNotifierProvider = StateNotifierProvider.family<
        VariantsByProductNotifier,
        AsyncValue<BaseResponse<VariantsByProductResponse>>,
        String>((ref, productId) {
  return VariantsByProductNotifier(productId, ref);
});

class VariantsByProductNotifier
    extends BaseNotifier<VariantsByProductResponse> {
  final String campusCategoryId;
  static Map<String, VariantsByProductResponse> cachedDataMap = {};
  bool needsUpdate = true;

  VariantsByProductNotifier(this.campusCategoryId, super.ref) {
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
      final BaseResponse<VariantsByProductResponse> response = await ref
          .read(mockVariantsByProductServiceProvider)
          .getVariantsByProductService();
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
