import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "../../../models/base_response.dart";
import "../../../models/management/menu/menu_by_campus.response.types.dart";
import "../../../repository/management_bc/menu/menu.repository.dart";
import "../../base.notifier.dart";

final StateNotifierProviderFamily<MenuByCampusNotifier,
        AsyncValue<BaseResponse<List<MenuByCampusResponse>>>, String>
    menuByCampusNotifierProvider = StateNotifierProvider.family<
        MenuByCampusNotifier,
        AsyncValue<BaseResponse<List<MenuByCampusResponse>>>,
        String>((StateNotifierProviderRef<MenuByCampusNotifier,
                AsyncValue<BaseResponse<List<MenuByCampusResponse>>>>
            ref,
        String campusCategoryId) {
  return MenuByCampusNotifier(campusCategoryId, ref);
});

class MenuByCampusNotifier extends BaseNotifier<List<MenuByCampusResponse>> {
  final String campusCategoryId;
  static Map<String, List<MenuByCampusResponse>> cachedDataMap =
      <String, List<MenuByCampusResponse>>{};
  bool needsUpdate = true;

  MenuByCampusNotifier(this.campusCategoryId, super.ref) {
    loadData();
  }

  bool needToUpdate() {
    return needsUpdate || !cachedDataMap.containsKey(campusCategoryId);
  }

  Future<void> loadData() async {
    if (cachedDataMap.containsKey(campusCategoryId) && !needToUpdate()) {
      state = AsyncValue<BaseResponse<List<MenuByCampusResponse>>>.data(
          BaseResponse<List<MenuByCampusResponse>>(
              code: "SUCCESS", data: cachedDataMap[campusCategoryId]!));
      return;
    }
    await _fetchData();
  }

  Future<void> _fetchData() async {
    state =
        const AsyncValue<BaseResponse<List<MenuByCampusResponse>>>.loading();
    await performAction(() {}, (String msg) {}, (String err) {});
  }

  @override
  Future<void> performAction(VoidCallback onLoading, Function(String) onSuccess,
      Function(String) onError) async {
    onLoading();
    try {
      final BaseResponse<List<MenuByCampusResponse>> response =
          await ref.read(menuRepositoryProvider).getMenuByCampus(
                campusId: campusCategoryId,
              );
      cachedDataMap[campusCategoryId] = response.data;
      handleResponse(response, onSuccess, onError);
      needsUpdate = false;
      state =
          AsyncValue<BaseResponse<List<MenuByCampusResponse>>>.data(response);
    } on Exception catch (e) {
      state = AsyncValue<BaseResponse<List<MenuByCampusResponse>>>.error(
          e, StackTrace.current);
      needsUpdate = true;
    }
  }

  Future<void> reloadData() async {
    needsUpdate = true;
    await loadData();
  }
}
