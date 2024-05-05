import "dart:convert";

import "package:hooks_riverpod/hooks_riverpod.dart";

import "../../../core/models/base_response.dart";
import "../../../core/models/management/campus_category/campus_category.response.types.dart";

final Provider<MockCampusCategoryService> mockCampusCategoryServiceProvider =
    Provider<MockCampusCategoryService>(
        (ProviderRef<MockCampusCategoryService> ref) {
  return MockCampusCategoryService();
});

class MockCampusCategoryService {
  Future<BaseResponse<List<CampusCategoryResponse>>> getCampusCategory() async {
    // ignore: always_specify_types
    await Future.delayed(const Duration(seconds: 3));

    const String responseJson = '''
{
    "code": "SUCCESS",
    "data": [
        {
            "campus_category_id": "21b2beb2-5971-4f18-b60f-8cc1671c8a8d",
            "name": "Bebidas",
            "urlImage": "https://via.placeholder.com/150"
        },
        {
            "campus_category_id": "dc4f6ae3-6646-4fdc-89e2-ca51a77af664",
            "name": "Marinas",
            "urlImage": "https://via.placeholder.com/150"
        },
        {
            "campus_category_id": "60558fd5-550e-4a2e-a1ed-8686df383133",
            "name": "Tradicional",
            "urlImage": "https://via.placeholder.com/150"
        }
    ]
}
  ''';

    final Map<String, dynamic> responseData = jsonDecode(responseJson);

    return BaseResponse<List<CampusCategoryResponse>>.fromJson(
      responseData,
      (Object? json) {
        if (json is! List) {
          throw ArgumentError("The JSON argument must be of type List");
        }
        return (json).map((dynamic e) {
          if (e is Map<String, dynamic>) {
            return CampusCategoryResponse.fromJson(e);
          } else {
            throw ArgumentError("Each item must be a Map<String, dynamic>");
          }
        }).toList();
      },
    );
  }
}
