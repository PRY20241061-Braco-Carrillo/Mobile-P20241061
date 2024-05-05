import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "../../../../mock/management/campus/mock_campus.dart";
import "../../../models/base_response.dart";
import "../../../models/management/campus/campus.response.types.dart";
import "../../base.notifier.dart";

final StateNotifierProviderFamily<CampusNotifier,
        AsyncValue<BaseResponse<List<CampusResponse>>>, String>
    campusNotifierProvider = StateNotifierProvider.family<
        CampusNotifier,
        AsyncValue<BaseResponse<List<CampusResponse>>>,
        String>((ref, restaurantId) {
  return CampusNotifier(restaurantId, ref);
});

class CampusNotifier extends BaseNotifier<List<CampusResponse>> {
  final String restaurantId;
  static Map<String, List<CampusResponse>> cachedDataMap = {};
  bool needsUpdate = true;

  CampusNotifier(this.restaurantId, super.ref) {
    loadData();
  }

  bool needToUpdate() {
    return needsUpdate || !cachedDataMap.containsKey(restaurantId);
  }

  Future<void> loadData() async {
    if (cachedDataMap.containsKey(restaurantId) && !needToUpdate()) {
      state = AsyncValue.data(
          BaseResponse(code: "SUCCESS", data: cachedDataMap[restaurantId]!));
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
      final BaseResponse<List<CampusResponse>> response =
          await ref.read(mockRestaurantCampusServiceProvider).getRestaurants();
      cachedDataMap[restaurantId] = response.data;
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
