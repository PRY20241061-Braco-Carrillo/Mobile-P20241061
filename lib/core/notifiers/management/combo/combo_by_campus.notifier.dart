import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "../../../models/base_response.dart";
import "../../../models/management/combo/combo_by_campus.response.types.dart";
import "../../../repository/management_bc/combo/combo.repository.dart";
import "../../base.notifier.dart";

final StateNotifierProviderFamily<ComboByCampusNotifier,
        AsyncValue<BaseResponse<List<ComboByCampusResponse>>>, String>
    comboByCampusNotifierProvider = StateNotifierProvider.family<
        ComboByCampusNotifier,
        AsyncValue<BaseResponse<List<ComboByCampusResponse>>>,
        String>((StateNotifierProviderRef<ComboByCampusNotifier,
                AsyncValue<BaseResponse<List<ComboByCampusResponse>>>>
            ref,
        String campusCategoryId) {
  return ComboByCampusNotifier(campusCategoryId, ref);
});

class ComboByCampusNotifier extends BaseNotifier<List<ComboByCampusResponse>> {
  final String campusCategoryId;
  static Map<String, List<ComboByCampusResponse>> cachedDataMap =
      <String, List<ComboByCampusResponse>>{};
  bool needsUpdate = true;

  ComboByCampusNotifier(this.campusCategoryId, super.ref) {
    loadData();
  }

  bool needToUpdate() {
    return needsUpdate || !cachedDataMap.containsKey(campusCategoryId);
  }

  Future<void> loadData() async {
    if (cachedDataMap.containsKey(campusCategoryId) && !needToUpdate()) {
      state = AsyncValue<BaseResponse<List<ComboByCampusResponse>>>.data(
          BaseResponse<List<ComboByCampusResponse>>(
              code: "SUCCESS", data: cachedDataMap[campusCategoryId]!));
      return;
    }
    await _fetchData();
  }

  Future<void> _fetchData() async {
    state =
        const AsyncValue<BaseResponse<List<ComboByCampusResponse>>>.loading();
    await performAction(() {}, (String msg) {}, (String err) {});
  }

  @override
  Future<void> performAction(VoidCallback onLoading, Function(String) onSuccess,
      Function(String) onError) async {
    onLoading();
    try {
      final BaseResponse<List<ComboByCampusResponse>> response =
          await ref.read(comboRepositoryProvider).getComboByCampus(
                campusId: campusCategoryId,
              );
      cachedDataMap[campusCategoryId] = response.data;
      handleResponse(response, onSuccess, onError);
      needsUpdate = false;
      state =
          AsyncValue<BaseResponse<List<ComboByCampusResponse>>>.data(response);
    } on Exception catch (e) {
      state = AsyncValue<BaseResponse<List<ComboByCampusResponse>>>.error(
          e, StackTrace.current);
      needsUpdate = true;
    }
  }

  Future<void> reloadData() async {
    needsUpdate = true;
    await loadData();
  }
}
