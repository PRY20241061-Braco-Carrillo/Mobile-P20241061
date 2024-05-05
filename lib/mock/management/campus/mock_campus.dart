import "dart:convert";

import "package:hooks_riverpod/hooks_riverpod.dart";

import "../../../core/models/base_response.dart";
import "../../../core/models/management/campus/campus.response.types.dart";

final Provider<MockCampusService> mockRestaurantCampusServiceProvider =
    Provider<MockCampusService>((ProviderRef<MockCampusService> ref) {
  return MockCampusService();
});

class MockCampusService {
  Future<BaseResponse<List<CampusResponse>>> getRestaurants() async {
    // ignore: always_specify_types
    await Future.delayed(const Duration(seconds: 3));

    const String responseJson = '''
{
    "code": "SUCCESS",
    "data": [
        {"imageUrl": "https://via.placeholder.com/150",
            "logoUrl": "https://via.placeholder.com/150",
            "campusId": "6c77ea7d-461d-4472-9800-69908a117bdd",
            "name": "Lima Norte",
            "address": "123 Calle Principal, Ciudad",
            "phoneNumber": "123-456-7890",
            "openHour": {
                "Monday": {
                    "breakfast": {
                        "opening": "12:00",
                        "closing": "14:00"
                    },
                    "lunch": {
                        "opening": "12:00",
                        "closing": "14:00"
                    },
                    "dinner": {
                        "opening": "19:00",
                        "closing": "22:00"
                    }
                },
                "Tuesday": {
                    "breakfast": {
                        "opening": "12:00",
                        "closing": "14:00"
                    },
                    "lunch": {
                        "opening": "12:00",
                        "closing": "14:00"
                    },
                    "dinner": {
                        "opening": "19:00",
                        "closing": "22:00"
                    }
                }
            },
            "toTakeHome": true,
            "toDelivery": true,
            "restaurantId": "3a732920-fd47-4940-a4a0-749cc444b43c",
            "isAvailable": false
        },
        {
            "campusId": "f4c20c26-1487-4e5d-8cd5-d4775abad5f5",
            "name": "Lima Sur",
            "address": "123 Calle Principal, Ciudad",
            "phoneNumber": "123-456-7890",
            "openHour": {
                "Monday": {
                    "breakfast": {
                        "opening": "12:00",
                        "closing": "14:00"
                    },
                    "lunch": {
                        "opening": "12:00",
                        "closing": "14:00"
                    },
                    "dinner": {
                        "opening": "19:00",
                        "closing": "22:00"
                    }
                },
                "Tuesday": {
                    "breakfast": {
                        "opening": "12:00",
                        "closing": "14:00"
                    },
                    "lunch": {
                        "opening": "12:00",
                        "closing": "14:00"
                    },
                    "dinner": {
                        "opening": "19:00",
                        "closing": "22:00"
                    }
                }
            },
            "imageUrl": "https://via.placeholder.com/150",
            "logoUrl": "https://via.placeholder.com/150",
            "toTakeHome": true,
            "toDelivery": true,
            "restaurantId": "3a732920-fd47-4940-a4a0-749cc444b43c",
            "isAvailable": false
        }
    ]
}
  ''';

    final Map<String, dynamic> responseData = jsonDecode(responseJson);

    return BaseResponse<List<CampusResponse>>.fromJson(
      responseData,
      (Object? json) {
        if (json is! List) {
          throw ArgumentError("The JSON argument must be of type List");
        }
        return (json).map((dynamic e) {
          if (e is Map<String, dynamic>) {
            return CampusResponse.fromJson(e);
          } else {
            throw ArgumentError("Each item must be a Map<String, dynamic>");
          }
        }).toList();
      },
    );
  }
}
