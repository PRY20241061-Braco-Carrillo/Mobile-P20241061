import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "../../../models/base_response.dart";
import "../../../models/management/promotion/promotion_by_campus.response.types.dart";
import "../../../repository/management_bc/promotion/promotion.repository.dart";
import "../../base.notifier.dart";

final StateNotifierProviderFamily<PromotionsByCampusNotifier,
        AsyncValue<BaseResponse<List<PromotionByCampusResponse>>>, String>
    promotionsByCampusNotifierProvider = StateNotifierProvider.family<
        PromotionsByCampusNotifier,
        AsyncValue<BaseResponse<List<PromotionByCampusResponse>>>,
        String>((StateNotifierProviderRef<PromotionsByCampusNotifier,
                AsyncValue<BaseResponse<List<PromotionByCampusResponse>>>>
            ref,
        String campusId) {
  return PromotionsByCampusNotifier(campusId, ref);
});

class PromotionsByCampusNotifier
    extends BaseNotifier<List<PromotionByCampusResponse>> {
  final String campusId;
  static Map<String, List<PromotionByCampusResponse>> cachedDataMap =
      <String, List<PromotionByCampusResponse>>{};
  bool needsUpdate = true;

  PromotionsByCampusNotifier(this.campusId, super.ref) {
    loadData();
  }

  bool needToUpdate() {
    return needsUpdate || !cachedDataMap.containsKey(campusId);
  }

  Future<void> loadData() async {
    if (cachedDataMap.containsKey(campusId) && !needToUpdate()) {
      state = AsyncValue<BaseResponse<List<PromotionByCampusResponse>>>.data(
          BaseResponse<List<PromotionByCampusResponse>>(
              code: "SUCCESS", data: cachedDataMap[campusId]!));
      return;
    }
    await _fetchData();
  }

  Future<void> _fetchData() async {
    state = const AsyncValue<
        BaseResponse<List<PromotionByCampusResponse>>>.loading();
    await performAction(() {}, (String msg) {}, (String err) {});
  }

  @override
  Future<void> performAction(VoidCallback onLoading, Function(String) onSuccess,
      Function(String) onError) async {
    onLoading();
    try {
      final BaseResponse<List<PromotionByCampusResponse>> response =
          await ref.read(promotionRepositoryProvider).getPromotionsByCampus(
                campusId: campusId,
              );
      cachedDataMap[campusId] = response.data;
      handleResponse(response, onSuccess, onError);
      needsUpdate = false;
      state = AsyncValue<BaseResponse<List<PromotionByCampusResponse>>>.data(
          response);
    } on Exception catch (e) {
      state = AsyncValue<BaseResponse<List<PromotionByCampusResponse>>>.error(
          e, StackTrace.current);
      needsUpdate = true;
    }
  }

  Future<void> reloadData() async {
    needsUpdate = true;
    await loadData();
  }
}
