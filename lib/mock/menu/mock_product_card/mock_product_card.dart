import "dart:convert";

import "../../../shared/widgets/features/product-card/product_card.types.dart";
import "package:flutter/services.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

class MockCategoryCardService {
  Future<List<MenuCardData>> cargarDatosDeTarjeta() async {
    // ignore: always_specify_types
    await Future.delayed(const Duration(seconds: 3));

    final String jsonString =
        await rootBundle.loadString("lib/mock/json/menu_card_data.json");
    final List<dynamic> jsonDataList = jsonDecode(jsonString);

    return jsonDataList
        // ignore: always_specify_types
        .map((jsonData) => MenuCardData.fromJson(jsonData))
        .toList();
  }

  Future<MenuCardData> cargarDatosPorId(String id) async {
    // ignore: always_specify_types
    await Future.delayed(const Duration(seconds: 3));

    final String jsonString =
        await rootBundle.loadString("lib/mock/json/menu_card_data.json");
    final List<dynamic> jsonDataList = jsonDecode(jsonString);

    return jsonDataList
        // ignore: always_specify_types
        .map((jsonData) => MenuCardData.fromJson(jsonData))
        .firstWhere((MenuCardData element) => element.id == id);
  }
}

final Provider<MockCategoryCardService> mockCategoryCardServiceProvider =
    Provider<MockCategoryCardService>(
        (ProviderRef<MockCategoryCardService> ref) {
  return MockCategoryCardService();
});

final AutoDisposeFutureProvider<List<MenuCardData>> categoryCardProvider =
    FutureProvider.autoDispose<List<MenuCardData>>(
        (AutoDisposeFutureProviderRef<List<MenuCardData>> ref) async {
  final MockCategoryCardService service =
      ref.watch(mockCategoryCardServiceProvider);
  return service.cargarDatosDeTarjeta();
});

final AutoDisposeFutureProviderFamily<MenuCardData, String>
    categoryCardByIdProvider = FutureProvider.autoDispose
        .family<MenuCardData, String>(
            (AutoDisposeFutureProviderRef<MenuCardData> ref, String id) async {
  final MockCategoryCardService service =
      ref.watch(mockCategoryCardServiceProvider);
  return service.cargarDatosPorId(id);
});
