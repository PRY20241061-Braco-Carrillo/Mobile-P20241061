import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "../../../../shared/widgets/features/restaurant_info-dialog/restaurant.types.dart";
import "../../../models/base_response.dart";
import "../../../repository/management_bc/campus_category/campus_info.repository.dart";
import "../../base.notifier.dart";

final StateNotifierProviderFamily<RestaurantInfoProvider,
        AsyncValue<BaseResponse<CampusResponse>>, String>
    restaurantDetailNotifierProvider = StateNotifierProvider.family<
        RestaurantInfoProvider,
        AsyncValue<BaseResponse<CampusResponse>>,
        String>((StateNotifierProviderRef<RestaurantInfoProvider,
                AsyncValue<BaseResponse<CampusResponse>>>
            ref,
        String comboId) {
  return RestaurantInfoProvider(comboId, ref);
});

class RestaurantInfoProvider extends BaseNotifier<CampusResponse> {
  final String comboId;
  static Map<String, CampusResponse> cachedDataMap = <String, CampusResponse>{};
  bool needsUpdate = true;

  RestaurantInfoProvider(this.comboId, super.ref) {
    loadData();
  }

  bool needToUpdate() {
    return needsUpdate || !cachedDataMap.containsKey(comboId);
  }

  Future<void> loadData() async {
    if (cachedDataMap.containsKey(comboId) && !needToUpdate()) {
      state = AsyncValue<BaseResponse<CampusResponse>>.data(
          BaseResponse<CampusResponse>(
              code: 'SUCCESS', data: cachedDataMap[comboId]!));
      return;
    }
    await _fetchData();
  }

  Future<void> _fetchData() async {
    state = const AsyncValue<BaseResponse<CampusResponse>>.loading();
    await performAction(() {}, (String msg) {}, (String err) {});
  }

  @override
  Future<void> performAction(VoidCallback onLoading, Function(String) onSuccess,
      Function(String) onError) async {
    onLoading();
    try {
      final BaseResponse<CampusResponse> response =
          await ref.read(campusInfoRepositoryProvider).getComboDetail(
                comboId: comboId,
              );
      cachedDataMap[comboId] = response.data;
      handleResponse(response, onSuccess, onError);
      needsUpdate = false;
      state = AsyncValue<BaseResponse<CampusResponse>>.data(response);
    } on Exception catch (e) {
      state =
          AsyncValue<BaseResponse<CampusResponse>>.error(e, StackTrace.current);
      needsUpdate = true;
    }
  }

  Future<void> reloadData() async {
    needsUpdate = true;
    await loadData();
  }
}
