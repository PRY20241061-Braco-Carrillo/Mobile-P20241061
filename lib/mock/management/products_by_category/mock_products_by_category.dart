import "dart:convert";

import "package:hooks_riverpod/hooks_riverpod.dart";

import "../../../core/models/base_response.dart";
import "../../../core/models/management/product/products_by_category_of_campus.response.types.dart";

final Provider<MockProductsByCategoryService>
    mockProductsByCategoryServiceProvider =
    Provider<MockProductsByCategoryService>(
        (ProviderRef<MockProductsByCategoryService> ref) {
  return MockProductsByCategoryService();
});

class MockProductsByCategoryService {
  Future<BaseResponse<List<ProductByCategoryOfCampusResponse>>>
      getProductsByCategoryService() async {
    // ignore: always_specify_types
    await Future.delayed(const Duration(seconds: 3));

    const String responseJson = '''
{
    "code": "SUCCESS",
    "data": [
        {
            "productId": "4b8e6b5e-dcc3-4150-89e6-faa6e187a72c",
            "name": "Salquipapa",
            "minCookingTime": 10,
            "maxCookingTime": 20,
            "unitOfTimeCookingTime": "MIN",
            "urlImage": "https://via.placeholder.com/150",
            "price": 30,
            "hasVariant": true,
            "currencyPrice": "USD"
        },
        {
            "productId": "4b8e6b5e-dc44-4150-89e6-faa6e187a72c",
            "name": "Estofado",
            "minCookingTime": 10,
            "maxCookingTime": 20,
            "unitOfTimeCookingTime": "MIN",
            "urlImage": "https://via.placeholder.com/150",
            "price": 30,
            "hasVariant": true,
            "currencyPrice": "PEN"
        },
        {
            "productId": "4b8e6b5e-dc55-4150-89e6-faa6e187a72c",
            "name": "Pollo broaester",
            "minCookingTime": 10,
            "maxCookingTime": 20,
            "unitOfTimeCookingTime": "MIN",
            "urlImage": "https://via.placeholder.com/150",
            "price": 30,
            "hasVariant": false,
            "currencyPrice": "EUR"
        },

        {
            "productId": "4b8e6b5e-dc44-4150-89e6-faa6e187a72c",
            "name": "Estofado",
            "minCookingTime": 10,
            "maxCookingTime": 20,
            "unitOfTimeCookingTime": "MIN",
            "urlImage": "https://via.placeholder.com/150",
            "price": 30,
            "hasVariant": true,
            "currencyPrice": "PEN"
        },
        {
            "productId": "4b8e6b5e-dc55-4150-89e6-faa6e187a72c",
            "name": "Pollo broaester",
            "minCookingTime": 10,
            "maxCookingTime": 20,
            "unitOfTimeCookingTime": "MIN",
            "urlImage": "https://via.placeholder.com/150",
            "price": 30,
            "hasVariant": false,
            "currencyPrice": "EUR"

        },
         {
            "productId": "4b8e6b5e-dcc3-4150-89e6-faa6e187a72c",
            "name": "Salquipapa",
            "minCookingTime": 10,
            "maxCookingTime": 20,
            "unitOfTimeCookingTime": "MIN",
            "urlImage": "https://via.placeholder.com/150",
            "price": 30,
            "hasVariant": true,
            "currencyPrice": "USD"
        },
        {
            "productId": "4b8e6b5e-dc44-4150-89e6-faa6e187a72c",
            "name": "Estofado",
            "minCookingTime": 10,
            "maxCookingTime": 20,
            "unitOfTimeCookingTime": "MIN",
            "urlImage": "https://via.placeholder.com/150",
            "price": 30,
            "hasVariant": true,
            "currencyPrice": "PEN"
        },
        {
            "productId": "4b8e6b5e-dc55-4150-89e6-faa6e187a72c",
            "name": "Pollo broaester",
            "minCookingTime": 10,
            "maxCookingTime": 20,
            "unitOfTimeCookingTime": "MIN",
            "urlImage": "https://via.placeholder.com/150",
            "price": 30,
            "hasVariant": false,
            "currencyPrice": "EUR"
        },

        {
            "productId": "4b8e6b5e-dc44-4150-89e6-faa6e187a72c",
            "name": "Estofado",
            "minCookingTime": 10,
            "maxCookingTime": 20,
            "unitOfTimeCookingTime": "MIN",
            "urlImage": "https://via.placeholder.com/150",
            "price": 30,
            "hasVariant": true,
            "currencyPrice": "PEN"
        },
        {
            "productId": "4b8e6b5e-dc55-4150-89e6-faa6e187a72c",
            "name": "Pollo broaester",
            "minCookingTime": 10,
            "maxCookingTime": 20,
            "unitOfTimeCookingTime": "MIN",
            "urlImage": "https://via.placeholder.com/150",
            "price": 30,
            "hasVariant": false,
            "currencyPrice": "EUR"

        },
         {
            "productId": "4b8e6b5e-dcc3-4150-89e6-faa6e187a72c",
            "name": "Salquipapa",
            "minCookingTime": 10,
            "maxCookingTime": 20,
            "unitOfTimeCookingTime": "MIN",
            "urlImage": "https://via.placeholder.com/150",
            "price": 30,
            "hasVariant": true,
            "currencyPrice": "USD"
        },
        {
            "productId": "4b8e6b5e-dc44-4150-89e6-faa6e187a72c",
            "name": "Estofado",
            "minCookingTime": 10,
            "maxCookingTime": 20,
            "unitOfTimeCookingTime": "MIN",
            "urlImage": "https://via.placeholder.com/150",
            "price": 30,
            "hasVariant": true,
            "currencyPrice": "PEN"
        },
        {
            "productId": "4b8e6b5e-dc55-4150-89e6-faa6e187a72c",
            "name": "Pollo broaester",
            "minCookingTime": 10,
            "maxCookingTime": 20,
            "unitOfTimeCookingTime": "MIN",
            "urlImage": "https://via.placeholder.com/150",
            "price": 30,
            "hasVariant": false,
            "currencyPrice": "EUR"
        },

        {
            "productId": "4b8e6b5e-dc44-4150-89e6-faa6e187a72c",
            "name": "Estofado",
            "minCookingTime": 10,
            "maxCookingTime": 20,
            "unitOfTimeCookingTime": "MIN",
            "urlImage": "https://via.placeholder.com/150",
            "price": 30,
            "hasVariant": true,
            "currencyPrice": "PEN"
        },
        {
            "productId": "4b8e6b5e-dc55-4150-89e6-faa6e187a72c",
            "name": "Pollo broaester",
            "minCookingTime": 10,
            "maxCookingTime": 20,
            "unitOfTimeCookingTime": "MIN",
            "urlImage": "https://via.placeholder.com/150",
            "price": 30,
            "hasVariant": false,
            "currencyPrice": "EUR"

        }
    ]
}
  ''';

    final Map<String, dynamic> responseData = jsonDecode(responseJson);

    return BaseResponse<List<ProductByCategoryOfCampusResponse>>.fromJson(
      responseData,
      (Object? json) {
        if (json is! List) {
          throw ArgumentError("The JSON argument must be of type List");
        }
        return (json).map((dynamic e) {
          if (e is Map<String, dynamic>) {
            return ProductByCategoryOfCampusResponse.fromJson(e);
          } else {
            throw ArgumentError("Each item must be a Map<String, dynamic>");
          }
        }).toList();
      },
    );
  }
}
