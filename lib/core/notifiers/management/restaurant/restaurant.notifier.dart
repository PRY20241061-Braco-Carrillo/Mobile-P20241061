import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "../../../../mock/management/restaurant/mock_restaurant.dart";
import "../../../models/base_response.dart";
import "../../../models/management/restaurant/restaurant.response.types.dart";
import "../../base.notifier.dart";

final StateNotifierProvider<RestaurantNotifier,
        AsyncValue<BaseResponse<List<RestaurantResponse>>>>
    allRestaurantsNotifierProvider = StateNotifierProvider<RestaurantNotifier,
        AsyncValue<BaseResponse<List<RestaurantResponse>>>>((ref) {
  return RestaurantNotifier(ref);
});

class RestaurantNotifier extends BaseNotifier<List<RestaurantResponse>> {
  static Map<String, List<RestaurantResponse>> cachedDataMap = {};
  bool needsUpdate = true;

  RestaurantNotifier(super.ref) {
    loadData();
  }

  bool needToUpdate() {
    return needsUpdate || !cachedDataMap.containsKey("global");
  }

  Future<void> loadData() async {
    if (cachedDataMap.containsKey("global") && !needToUpdate()) {
      state = AsyncValue.data(
          BaseResponse(code: "SUCCESS", data: cachedDataMap["global"]!));
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
      final BaseResponse<List<RestaurantResponse>> response =
          await ref.read(mockRestaurantServiceProvider).getRestaurants();
      cachedDataMap["global"] = response.data;
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
