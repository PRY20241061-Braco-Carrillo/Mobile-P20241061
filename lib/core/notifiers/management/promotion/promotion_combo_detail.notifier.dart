import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "../../../models/base_response.dart";
import "../../../models/management/promotion/promotion_combo_detail.response.types.dart";
import "../../../repository/management_bc/promotion/promotion.repository.dart";
import "../../base.notifier.dart";

final StateNotifierProviderFamily<ComboPromotionDetailNotifier,
        AsyncValue<BaseResponse<PromotionComboDetailResponse>>, String>
    comboPromotionDetailNotifierProvider = StateNotifierProvider.family<
        ComboPromotionDetailNotifier,
        AsyncValue<BaseResponse<PromotionComboDetailResponse>>,
        String>((StateNotifierProviderRef<ComboPromotionDetailNotifier,
                AsyncValue<BaseResponse<PromotionComboDetailResponse>>>
            ref,
        String comboId) {
  return ComboPromotionDetailNotifier(comboId, ref);
});

class ComboPromotionDetailNotifier
    extends BaseNotifier<PromotionComboDetailResponse> {
  final String comboId;
  static Map<String, PromotionComboDetailResponse> cachedDataMap =
      <String, PromotionComboDetailResponse>{};
  bool needsUpdate = true;

  ComboPromotionDetailNotifier(this.comboId, super.ref) {
    loadData();
  }

  bool needToUpdate() {
    return needsUpdate || !cachedDataMap.containsKey(comboId);
  }

  Future<void> loadData() async {
    if (cachedDataMap.containsKey(comboId) && !needToUpdate()) {
      state = AsyncValue<BaseResponse<PromotionComboDetailResponse>>.data(
          BaseResponse<PromotionComboDetailResponse>(
              code: "SUCCESS", data: cachedDataMap[comboId]!));
      return;
    }
    await _fetchData();
  }

  Future<void> _fetchData() async {
    state =
        const AsyncValue<BaseResponse<PromotionComboDetailResponse>>.loading();
    await performAction(() {}, (String msg) {}, (String err) {});
  }

  @override
  Future<void> performAction(VoidCallback onLoading, Function(String) onSuccess,
      Function(String) onError) async {
    onLoading();
    try {
      final BaseResponse<PromotionComboDetailResponse> response =
          await ref.read(promotionRepositoryProvider).getComboPromotionDetail(
                comboId: comboId,
              );
      cachedDataMap[comboId] = response.data;
      handleResponse(response, onSuccess, onError);
      needsUpdate = false;
      state =
          AsyncValue<BaseResponse<PromotionComboDetailResponse>>.data(response);
    } on Exception catch (e) {
      state = AsyncValue<BaseResponse<PromotionComboDetailResponse>>.error(
          e, StackTrace.current);
      needsUpdate = true;
    }
  }

  Future<void> reloadData() async {
    needsUpdate = true;
    await loadData();
  }
}
