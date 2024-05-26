import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "../../../models/base_response.dart";
import "../../../models/management/menu/menu_detail.response.types.dart";
import "../../../repository/management_bc/menu/menu.repository.dart";
import "../../base.notifier.dart";

final StateNotifierProviderFamily<MenuDetailNotifier,
        AsyncValue<BaseResponse<MenuDetailResponse>>, String>
    menuDetailNotifierProvider = StateNotifierProvider.family<
        MenuDetailNotifier,
        AsyncValue<BaseResponse<MenuDetailResponse>>,
        String>((StateNotifierProviderRef<MenuDetailNotifier,
                AsyncValue<BaseResponse<MenuDetailResponse>>>
            ref,
        String menuId) {
  return MenuDetailNotifier(menuId, ref);
});

class MenuDetailNotifier extends BaseNotifier<MenuDetailResponse> {
  final String menuId;
  static Map<String, MenuDetailResponse> cachedDataMap =
      <String, MenuDetailResponse>{};
  bool needsUpdate = true;

  MenuDetailNotifier(this.menuId, super.ref) {
    loadData();
  }

  bool needToUpdate() {
    return needsUpdate || !cachedDataMap.containsKey(menuId);
  }

  Future<void> loadData() async {
    if (cachedDataMap.containsKey(menuId) && !needToUpdate()) {
      state = AsyncValue<BaseResponse<MenuDetailResponse>>.data(
          BaseResponse<MenuDetailResponse>(
              code: 'SUCCESS', data: cachedDataMap[menuId]!));
      return;
    }
    await _fetchData();
  }

  Future<void> _fetchData() async {
    state = const AsyncValue<BaseResponse<MenuDetailResponse>>.loading();
    await performAction(() {}, (String msg) {}, (String err) {});
  }

  @override
  Future<void> performAction(VoidCallback onLoading, Function(String) onSuccess,
      Function(String) onError) async {
    onLoading();
    try {
      final BaseResponse<MenuDetailResponse> response =
          await ref.read(menuRepositoryProvider).getMenuDetail(
                menuId: menuId,
              );
      cachedDataMap[menuId] = response.data;
      handleResponse(response, onSuccess, onError);
      needsUpdate = false;
      state = AsyncValue<BaseResponse<MenuDetailResponse>>.data(response);
    } on Exception catch (e) {
      state = AsyncValue<BaseResponse<MenuDetailResponse>>.error(
          e, StackTrace.current);
      needsUpdate = true;
    }
  }

  Future<void> reloadData() async {
    needsUpdate = true;
    await loadData();
  }
}
