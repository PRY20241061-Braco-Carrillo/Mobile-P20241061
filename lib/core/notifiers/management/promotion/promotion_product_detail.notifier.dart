import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "../../../models/base_response.dart";
import "../../../models/management/promotion/promotion_product_detail.response.types.dart";
import "../../../repository/management_bc/promotion/promotion.repository.dart";
import "../../base.notifier.dart";

final StateNotifierProviderFamily<ProductPromotionDetailNotifier,
        AsyncValue<BaseResponse<PromotionProductDetailResponse>>, String>
    productPromotionDetailNotifierProvider = StateNotifierProvider.family<
        ProductPromotionDetailNotifier,
        AsyncValue<BaseResponse<PromotionProductDetailResponse>>,
        String>((StateNotifierProviderRef<ProductPromotionDetailNotifier,
                AsyncValue<BaseResponse<PromotionProductDetailResponse>>>
            ref,
        String productVariantId) {
  return ProductPromotionDetailNotifier(productVariantId, ref);
});

class ProductPromotionDetailNotifier
    extends BaseNotifier<PromotionProductDetailResponse> {
  final String productVariantId;
  static Map<String, PromotionProductDetailResponse> cachedDataMap =
      <String, PromotionProductDetailResponse>{};
  bool needsUpdate = true;

  ProductPromotionDetailNotifier(this.productVariantId, super.ref) {
    loadData();
  }

  bool needToUpdate() {
    return needsUpdate || !cachedDataMap.containsKey(productVariantId);
  }

  Future<void> loadData() async {
    if (cachedDataMap.containsKey(productVariantId) && !needToUpdate()) {
      state = AsyncValue<BaseResponse<PromotionProductDetailResponse>>.data(
          BaseResponse<PromotionProductDetailResponse>(
              code: "SUCCESS", data: cachedDataMap[productVariantId]!));
      return;
    }
    await _fetchData();
  }

  Future<void> _fetchData() async {
    state = const AsyncValue<
        BaseResponse<PromotionProductDetailResponse>>.loading();
    await performAction(() {}, (String msg) {}, (String err) {});
  }

  @override
  Future<void> performAction(VoidCallback onLoading, Function(String) onSuccess,
      Function(String) onError) async {
    onLoading();
    try {
      final BaseResponse<PromotionProductDetailResponse> response =
          await ref.read(promotionRepositoryProvider).getProductPromotionDetail(
                productVariantId: productVariantId,
              );
      cachedDataMap[productVariantId] = response.data;
      handleResponse(response, onSuccess, onError);
      needsUpdate = false;
      state = AsyncValue<BaseResponse<PromotionProductDetailResponse>>.data(
          response);
    } on Exception catch (e) {
      state = AsyncValue<BaseResponse<PromotionProductDetailResponse>>.error(
          e, StackTrace.current);
      needsUpdate = true;
    }
  }

  Future<void> reloadData() async {
    needsUpdate = true;
    await loadData();
  }
}
