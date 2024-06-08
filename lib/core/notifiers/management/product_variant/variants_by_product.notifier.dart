import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "../../../models/base_response.dart";
import "../../../models/management/product_variant/variants_by_product.response.types.dart";
import "../../../repository/management_bc/product_variant/product_variant.repository.dart";
import "../../base.notifier.dart";

final StateNotifierProviderFamily<ProductVariantNotifier,
        AsyncValue<BaseResponse<VariantsByProductResponse>>, String>
    productVariantNotifierProvider = StateNotifierProvider.family<
        ProductVariantNotifier,
        AsyncValue<BaseResponse<VariantsByProductResponse>>,
        String>((StateNotifierProviderRef<ProductVariantNotifier,
                AsyncValue<BaseResponse<VariantsByProductResponse>>>
            ref,
        String productId) {
  return ProductVariantNotifier(productId, ref);
});

class ProductVariantNotifier extends BaseNotifier<VariantsByProductResponse> {
  final String productId;
  static Map<String, VariantsByProductResponse> cachedDataMap =
      <String, VariantsByProductResponse>{};
  bool needsUpdate = true;

  ProductVariantNotifier(this.productId, super.ref) {
    loadData();
  }

  bool needToUpdate() {
    return needsUpdate || !cachedDataMap.containsKey(productId);
  }

  Future<void> loadData() async {
    if (cachedDataMap.containsKey(productId) && !needToUpdate()) {
      state = AsyncValue<BaseResponse<VariantsByProductResponse>>.data(
          BaseResponse<VariantsByProductResponse>(
              code: "SUCCESS", data: cachedDataMap[productId]!));
      return;
    }
    await _fetchData();
  }

  Future<void> _fetchData() async {
    state = const AsyncValue<BaseResponse<VariantsByProductResponse>>.loading();
    await performAction(() {}, (String msg) {}, (String err) {});
  }

  @override
  Future<void> performAction(VoidCallback onLoading, Function(String) onSuccess,
      Function(String) onError) async {
    onLoading();
    try {
      final BaseResponse<VariantsByProductResponse> response = await ref
          .read(productVariantRepositoryProvider)
          .getVariantsProductById(
            productId: productId,
          );
      cachedDataMap[productId] = response.data;
      handleResponse(response, onSuccess, onError);
      needsUpdate = false;
      state =
          AsyncValue<BaseResponse<VariantsByProductResponse>>.data(response);
    } on Exception catch (e) {
      state = AsyncValue<BaseResponse<VariantsByProductResponse>>.error(
          e, StackTrace.current);
      needsUpdate = true;
    }
  }

  Future<void> reloadData() async {
    needsUpdate = true;
    await loadData();
  }
}
