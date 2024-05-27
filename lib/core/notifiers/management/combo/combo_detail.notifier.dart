import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "../../../models/base_response.dart";
import "../../../models/management/combo/combo_detail.response.types.dart";
import "../../../repository/management_bc/combo/combo.repository.dart";
import "../../base.notifier.dart";

final StateNotifierProviderFamily<ComboDetailNotifier,
        AsyncValue<BaseResponse<ComboDetailResponse>>, String>
    comboDetailNotifierProvider = StateNotifierProvider.family<
        ComboDetailNotifier,
        AsyncValue<BaseResponse<ComboDetailResponse>>,
        String>((StateNotifierProviderRef<ComboDetailNotifier,
                AsyncValue<BaseResponse<ComboDetailResponse>>>
            ref,
        String comboId) {
  return ComboDetailNotifier(comboId, ref);
});

class ComboDetailNotifier extends BaseNotifier<ComboDetailResponse> {
  final String comboId;
  static Map<String, ComboDetailResponse> cachedDataMap =
      <String, ComboDetailResponse>{};
  bool needsUpdate = true;

  ComboDetailNotifier(this.comboId, super.ref) {
    loadData();
  }

  bool needToUpdate() {
    return needsUpdate || !cachedDataMap.containsKey(comboId);
  }

  Future<void> loadData() async {
    if (cachedDataMap.containsKey(comboId) && !needToUpdate()) {
      state = AsyncValue<BaseResponse<ComboDetailResponse>>.data(
          BaseResponse<ComboDetailResponse>(
              code: 'SUCCESS', data: cachedDataMap[comboId]!));
      return;
    }
    await _fetchData();
  }

  Future<void> _fetchData() async {
    state = const AsyncValue<BaseResponse<ComboDetailResponse>>.loading();
    await performAction(() {}, (String msg) {}, (String err) {});
  }

  @override
  Future<void> performAction(VoidCallback onLoading, Function(String) onSuccess,
      Function(String) onError) async {
    onLoading();
    try {
      final BaseResponse<ComboDetailResponse> response =
          await ref.read(comboRepositoryProvider).getComboDetail(
                comboId: comboId,
              );
      cachedDataMap[comboId] = response.data;
      handleResponse(response, onSuccess, onError);
      needsUpdate = false;
      state = AsyncValue<BaseResponse<ComboDetailResponse>>.data(response);
    } on Exception catch (e) {
      state = AsyncValue<BaseResponse<ComboDetailResponse>>.error(
          e, StackTrace.current);
      needsUpdate = true;
    }
  }

  Future<void> reloadData() async {
    needsUpdate = true;
    await loadData();
  }
}
