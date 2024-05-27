import "../../../../../../core/models/management/menu/menu_detail.response.types.dart";
import "../../products/product_detail-card/variants/variant_abstract.types.dart";

class MenuDetailCardData {
  String menuId;
  String name;
  int amountPrice;
  String currencyPrice;
  int minCookingTime;
  int maxCookingTime;
  String unitOfTimeCookingTime;
  String urlImage;
  List<DishesDetailCardData> desserts;
  List<DishesDetailCardData> drinks;
  List<DishesDetailCardData> initialDishes;
  List<DishesDetailCardData> principalDishes;

  MenuDetailCardData({
    required this.menuId,
    required this.name,
    required this.amountPrice,
    required this.currencyPrice,
    required this.minCookingTime,
    required this.maxCookingTime,
    required this.unitOfTimeCookingTime,
    required this.urlImage,
    required this.desserts,
    required this.drinks,
    required this.initialDishes,
    required this.principalDishes,
  });

  factory MenuDetailCardData.fromJson(Map<String, dynamic> json) =>
      MenuDetailCardData(
        menuId: json["menuId"],
        name: json["name"],
        amountPrice: json["amountPrice"],
        currencyPrice: json["currencyPrice"],
        minCookingTime: json["minCookingTime"],
        maxCookingTime: json["maxCookingTime"],
        unitOfTimeCookingTime: json["unitOfTimeCookingTime"],
        urlImage: json["urlImage"],
        desserts: List<DishesDetailCardData>.from(
            json["desserts"].map((x) => DishesDetailCardData.fromJson(x))),
        drinks: List<DishesDetailCardData>.from(
            json["drinks"].map((x) => DishesDetailCardData.fromJson(x))),
        initialDishes: List<DishesDetailCardData>.from(
            json["initialDishes"].map((x) => DishesDetailCardData.fromJson(x))),
        principalDishes: List<DishesDetailCardData>.from(json["principalDishes"]
            .map((x) => DishesDetailCardData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "menuId": menuId,
        "name": name,
        "amountPrice": amountPrice,
        "currencyPrice": currencyPrice,
        "minCookingTime": minCookingTime,
        "maxCookingTime": maxCookingTime,
        "unitOfTimeCookingTime": unitOfTimeCookingTime,
        "urlImage": urlImage,
        "desserts": desserts.map((e) => e.toJson()).toList(),
        "drinks": drinks.map((e) => e.toJson()).toList(),
        "initialDishes": initialDishes.map((e) => e.toJson()).toList(),
        "principalDishes": principalDishes.map((e) => e.toJson()).toList(),
      };
}

class DishesDetailCardData {
  String productId;
  String productMenuId;
  String name;
  String description;
  String urlImage;
  List<VariantMenuSelectorDetail> variants;

  DishesDetailCardData({
    required this.productId,
    required this.productMenuId,
    required this.name,
    required this.description,
    required this.urlImage,
    required this.variants,
  });

  factory DishesDetailCardData.fromJson(Map<String, dynamic> json) =>
      DishesDetailCardData(
        productId: json["productId"] ?? '',
        productMenuId: json["productMenuId"] ?? '',
        name: json["name"] ?? '',
        description: json["description"] ?? '',
        urlImage: json["urlImage"] ?? '',
        variants: json["variants"] != null
            ? List<VariantMenuSelectorDetail>.from(json["variants"]
                .map((x) => VariantMenuSelectorDetail.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "productId": productId,
        "productMenuId": productMenuId,
        "name": name,
        "description": description,
        "urlImage": urlImage,
        "variants": List<dynamic>.from(variants.map((x) => x.toJson())),
      };
}

class VariantMenuSelectorDetail implements Variant {
  String _productVariantId;
  String _detail;
  int _variantOrder;
  String _variantInfo;
  Map<String, String> _variants;

  VariantMenuSelectorDetail({
    required String productVariantId,
    required String detail,
    required int variantOrder,
    required String variantInfo,
    required Map<String, String> variants,
  })  : _productVariantId = productVariantId,
        _detail = detail,
        _variantOrder = variantOrder,
        _variantInfo = variantInfo,
        _variants = variants;

  @override
  String get productVariantId => _productVariantId;

  @override
  double get amountPrice => 0.0; // Implementación específica

  @override
  String get currencyPrice => ''; // Implementación específica

  @override
  String get variantInfo => _variantInfo;

  @override
  double get variantOrder => _variantOrder.toDouble();

  factory VariantMenuSelectorDetail.fromJson(Map<String, dynamic> json) =>
      VariantMenuSelectorDetail(
        productVariantId: json["productVariantId"] ?? '',
        detail: json["detail"] ?? '',
        variantOrder: json["variantOrder"] ?? 0,
        variantInfo: json["variantInfo"] ?? '',
        variants: json["variants"] != null
            ? Map<String, String>.from(json["variants"])
            : {},
      );

  Map<String, dynamic> toJson() => {
        "productVariantId": _productVariantId,
        "detail": _detail,
        "variantOrder": _variantOrder,
        "variantInfo": _variantInfo,
        "variants": _variants,
      };

  @override
  Map<String, String> getVariantsMap() {
    // Implementación específica para ProductVariant
    return _parseVariantInfo(_variantInfo);
  }

  Map<String, String> _parseVariantInfo(String info) {
    final Map<String, String> variantsMap = {};
    final List<String> parts = info.split(", ");
    for (final part in parts) {
      final List<String> keyValue = part.split(": ");
      if (keyValue.length == 2) {
        variantsMap[keyValue[0]] = keyValue[1];
      }
    }
    return variantsMap;
  }
}
