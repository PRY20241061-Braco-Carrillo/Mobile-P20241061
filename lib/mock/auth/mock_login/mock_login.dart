import "dart:convert";

import "../../../shared/widgets/features/restaurant-card/restaurant_card.types.dart";
import "package:flutter/services.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

class MockRestaurantCardService {
  Future<List<RestaurantCardData>> cargarDatosDeTarjeta() async {
    // ignore: always_specify_types
    await Future.delayed(const Duration(seconds: 3));

    final String jsonString =
        await rootBundle.loadString("lib/mock/json/restaurant_card_data.json");
    final List<dynamic> jsonDataList = jsonDecode(jsonString);

    return jsonDataList
        // ignore: always_specify_types
        .map((jsonData) => RestaurantCardData.fromJson(jsonData))
        .toList();
  }
}

final Provider<MockRestaurantCardService> mockRestaurantCardServiceProvider =
    Provider<MockRestaurantCardService>(
        (ProviderRef<MockRestaurantCardService> ref) {
  return MockRestaurantCardService();
});

final AutoDisposeFutureProvider<List<RestaurantCardData>>
    restaurantCardProvider =
    FutureProvider.autoDispose<List<RestaurantCardData>>(
        (AutoDisposeFutureProviderRef<List<RestaurantCardData>> ref) async {
  final MockRestaurantCardService service =
      ref.watch(mockRestaurantCardServiceProvider);
  return service.cargarDatosDeTarjeta();
});
