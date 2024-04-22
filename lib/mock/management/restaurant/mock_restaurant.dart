import "dart:convert";

import "package:hooks_riverpod/hooks_riverpod.dart";

import "../../../core/models/base_response.dart";
import "../../../core/models/management/restaurant/restaurant.response.types.dart";

final Provider<MockRestaurantService> mockRestaurantServiceProvider =
    Provider<MockRestaurantService>((ProviderRef<MockRestaurantService> ref) {
  return MockRestaurantService();
});

class MockRestaurantService {
  Future<BaseResponse<RestaurantResponse>> getRestaurants() async {
    // ignore: always_specify_types
    await Future.delayed(const Duration(seconds: 3));

    const String responseJson = '''
[
  {
      "code": "SUCCESS",
      "data": {
         "restaurantId": "017e1380-7e1c-46db-a732-73718f1f4390",
        "name": "Norkys",
        "imageUrl": null,
        "isAvailable": true
      }
    }
]
  ''';

    final Map<String, dynamic> responseData = jsonDecode(responseJson);
    return BaseResponse<RestaurantResponse>.fromJson(
        responseData, RestaurantResponse.fromJson);
  }
}
