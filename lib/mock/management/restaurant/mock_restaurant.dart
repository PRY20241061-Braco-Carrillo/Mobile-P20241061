import "dart:convert";

import "package:hooks_riverpod/hooks_riverpod.dart";

import "../../../core/models/base_response.dart";
import "../../../core/models/management/restaurant/restaurant.response.types.dart";

final Provider<MockRestaurantService> mockRestaurantServiceProvider =
    Provider<MockRestaurantService>((ProviderRef<MockRestaurantService> ref) {
  return MockRestaurantService();
});

class MockRestaurantService {
  Future<BaseResponse<List<RestaurantResponse>>> getRestaurants() async {
    // ignore: always_specify_types
    await Future.delayed(const Duration(seconds: 3));

    const String responseJson = '''
{
    "code": "SUCCESS",
    "data": [
        {
            "restaurantId": "3a732920-fd47-4940-a4a0-749cc444b43c",
            "name": "Barquero",
            "imageUrl": "https://via.placeholder.com/150",
            "logoUrl": "https://via.placeholder.com/150",
            "isAvailable": true
        },
        {
            "restaurantId": "1bbf3a9b-d905-406f-92f5-04446492a25e",
            "name": "Parador",
            "imageUrl": "https://via.placeholder.com/150",
            "logoUrl": "https://via.placeholder.com/150",
            "isAvailable": true
        },
        {
            "restaurantId": "7d6497c3-f25a-4de2-8e33-0abf4eaa674b",
            "name": "Rustica Seafood",
            "imageUrl": "https://via.placeholder.com/150",
            "logoUrl": "https://via.placeholder.com/150",
            "isAvailable": true
        }
    ]
}
  ''';

    final Map<String, dynamic> responseData = jsonDecode(responseJson);

    return BaseResponse<List<RestaurantResponse>>.fromJson(responseData,
        (Object? json) {
      if (json is! List) {
        throw ArgumentError("The JSON argument must be of type List");
      }
      return (json as List<Object?>)
          .map((Object? e) => RestaurantResponse.fromJson(e))
          .toList();
    });
  }
}
