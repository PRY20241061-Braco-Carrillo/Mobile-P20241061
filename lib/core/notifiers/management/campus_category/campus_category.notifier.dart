import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "../../../../mock/management/campus category/mock_campus_category.dart";
import "../../../models/base_response.dart";
import "../../../models/management/campus_category/campus_category.response.types.dart";
import "../../base.notifier.dart";

final StateNotifierProviderFamily<CampusCategoryNotifier,
        AsyncValue<BaseResponse<List<CampusCategoryResponse>>>, String>
    campusCategoryNotifierProvider = StateNotifierProvider.family<
        CampusCategoryNotifier,
        AsyncValue<BaseResponse<List<CampusCategoryResponse>>>,
        String>((ref, campusId) {
  return CampusCategoryNotifier(campusId, ref);
});

class CampusCategoryNotifier
    extends BaseNotifier<List<CampusCategoryResponse>> {
  final String restaurantId;
  static Map<String, List<CampusCategoryResponse>> cachedDataMap =
      <String, List<CampusCategoryResponse>>{};
  bool needsUpdate = true;

  CampusCategoryNotifier(this.restaurantId, super.ref) {
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
      final BaseResponse<List<CampusCategoryResponse>> response =
          await ref.read(mockCampusCategoryServiceProvider).getCampusCategory();
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
