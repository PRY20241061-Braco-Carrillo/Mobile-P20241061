import "dart:convert";

import "package:hooks_riverpod/hooks_riverpod.dart";

import "../../../core/models/base_response.dart";
import "../../../core/models/management/product_variant/variants_by_product.response.types.dart";

final Provider<MockVariantsByProductService>
    mockVariantsByProductServiceProvider =
    Provider<MockVariantsByProductService>(
        (ProviderRef<MockVariantsByProductService> ref) {
  return MockVariantsByProductService();
});

class MockVariantsByProductService {
  Future<BaseResponse<VariantsByProductResponse>>
      getVariantsByProductService() async {
    await Future.delayed(const Duration(seconds: 3));

    const String responseJson = '''
{
    "code": "SUCCESS",
    "data": {
        "product": {
            "productId": "86a1e63a-95a3-4540-95c8-dfe7b3b48a4b",
            "name": "Pollo a la Horneado",
            "minCookingTime": 30,
            "maxCookingTime": 35,
            "unitOfTimeCookingTime": "MIN",
            "description": "A grill peruvian chicken with extra fries potatoes",
            "isBreakfast": false,
            "isLunch": false,
            "isDinner": true,
            "urlImage": "https://via.placeholder.com/150",
            "urlGlb": "pollo_brasa.glb",
            "freeSauce": 2,
            "isAvailable": true,
            "hasVariant": true,
            "nutritionalInformation": {
                "nutritionalInformationId": "b5df9dd8-25d1-4ee8-a3f5-1e3e4715b001",
                "calories": 400,
                "proteins": 15,
                "totalFat": 20,
                "carbohydrates": 40,
                "isVegan": true,
                "isVegetarian": true,
                "isLowCalories": true,
                "isHighProtein": false,
                "isWithoutGluten": true,
                "isWithoutNut": true,
                "isWithoutLactose": false,
                "isWithoutEggs": true,
                "isWithoutSeafood": false,
                "isWithoutPig": true
            }
        },
        "productVariants": [
            {
                "productVariantId": "1b2463eb-cd36-41cb-a67d-3e5a475b6ec1",
                "amountPrice": 12.99,
                "currencyPrice": "USD",
                "variantInfo": "CC06: 1, CC01: Leña"
            },
            {
                "productVariantId": "5c63e9e9-ebc6-4e15-b77d-5a0fb2d8a1a7",
                "amountPrice": 10.99,
                "currencyPrice": "USD",
                "variantInfo": "CC01: Leña, CC06: 1/4"
            },
            {
                "productVariantId": "5c63e9e9-ebc6-4e15-b77d-5a0fb2d8a1a9",
                "amountPrice": 15.99,
                "currencyPrice": "USD",
                "variantInfo": "CC01: Brasa, CC06: 1"
            },
            {
                "productVariantId": "8015ed4a-1d05-4c8e-8481-582d669f2e18",
                "amountPrice": 8,
                "currencyPrice": "USD",
                "variantInfo": "CC06: 1/8, CC01: Brasa"
            },
            {
                "productVariantId": "a482c179-12c0-4a58-bdc2-4d4f8eef64cf",
                "amountPrice": 8.99,
                "currencyPrice": "USD",
                "variantInfo": "CC06: 1/8, CC01: Leña"
            },
            {
                "productVariantId": "d5f8c758-76f4-49e7-a979-7a479926a72a",
                "amountPrice": 10,
                "currencyPrice": "USD",
                "variantInfo": "CC06: 1/4, CC01: Brasa"
            }
        ],
        "complements": [
            {
                "complementId": "22ed25d2-6178-49a2-8a82-3908c38e8c5a",
                "name": "Mayonesa",
                "amountPrice": 0.2,
                "currencyPrice": "PEN",
                "isSauce": true
            },
            {
                "complementId": "c8b7f6cb-4b78-4973-9d6f-4741d0072cb9",
                "name": "Mostaza",
                "amountPrice": 0.2,
                "currencyPrice": "PEN",
                "isSauce": true
            },
            {
                "complementId": "f5b7f6cb-4b78-4973-9d6f-4741d0072cb9",
                "name": "Porcion de Papas ",
                "amountPrice": 7,
                "currencyPrice": "PEN",
                "isSauce": false
            }
        ]
    }
}
  ''';

    final Map<String, dynamic> responseMap = json.decode(responseJson);

    final BaseResponse<VariantsByProductResponse> response =
        BaseResponse<VariantsByProductResponse>.fromJson(responseMap,
            (Object? json) {
      return VariantsByProductResponse.fromJson(json as Map<String, dynamic>);
    });

    return response;
  }
}
