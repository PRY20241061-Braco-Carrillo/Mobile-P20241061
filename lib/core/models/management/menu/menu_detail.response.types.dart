class MenuDetailResponse {
  String menuId;
  String name;
  double amountPrice;
  String currencyPrice;
  int minCookingTime;
  int maxCookingTime;
  String unitOfTimeCookingTime;
  String urlImage;
  List<PlatesDetailResponse> desserts;
  List<PlatesDetailResponse> drinks;
  List<PlatesDetailResponse> initialDishes;
  List<PlatesDetailResponse> principalDishes;

  MenuDetailResponse({
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

  factory MenuDetailResponse.fromJson(Map<String, dynamic> json) =>
      MenuDetailResponse(
        menuId: json["menuId"],
        name: json["name"],
        amountPrice: json["amountPrice"],
        currencyPrice: json["currencyPrice"],
        minCookingTime: json["minCookingTime"],
        maxCookingTime: json["maxCookingTime"],
        unitOfTimeCookingTime: json["unitOfTimeCookingTime"],
        urlImage: json["urlImage"],
        desserts: List<PlatesDetailResponse>.from(
            json["desserts"].map((x) => PlatesDetailResponse.fromJson(x))),
        drinks: List<PlatesDetailResponse>.from(
            json["drinks"].map((x) => PlatesDetailResponse.fromJson(x))),
        initialDishes: List<PlatesDetailResponse>.from(
            json["initialDishes"].map((x) => PlatesDetailResponse.fromJson(x))),
        principalDishes: List<PlatesDetailResponse>.from(json["principalDishes"]
            .map((x) => PlatesDetailResponse.fromJson(x))),
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
        "desserts": List<dynamic>.from(desserts.map((x) => x.toJson())),
        "drinks": List<dynamic>.from(drinks.map((x) => x.toJson())),
        "initialDishes":
            List<dynamic>.from(initialDishes.map((x) => x.toJson())),
        "principalDishes":
            List<dynamic>.from(principalDishes.map((x) => x.toJson())),
      };
}

class PlatesDetailResponse {
  String productId;
  String productMenuId;
  String name;
  String description;
  String urlImage;
  List<VariantDetailResponse> variants;

  PlatesDetailResponse({
    required this.productId,
    required this.productMenuId,
    required this.name,
    required this.description,
    required this.urlImage,
    required this.variants,
  });

  factory PlatesDetailResponse.fromJson(Map<String, dynamic> json) =>
      PlatesDetailResponse(
        productId: json["productId"],
        productMenuId: json["productMenuId"],
        name: json["name"],
        description: json["description"],
        urlImage: json["urlImage"],
        variants: List<VariantDetailResponse>.from(
            json["variants"].map((x) => VariantDetailResponse.fromJson(x))),
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

class VariantDetailResponse {
  String productVariantId;
  String detail;
  int variantOrder;
  String variantInfo;

  VariantDetailResponse({
    required this.productVariantId,
    required this.detail,
    required this.variantOrder,
    required this.variantInfo,
  });

  factory VariantDetailResponse.fromJson(Map<String, dynamic> json) =>
      VariantDetailResponse(
        productVariantId: json["productVariantId"],
        detail: json["detail"],
        variantOrder: json["variantOrder"],
        variantInfo: json["variantInfo"],
      );

  Map<String, dynamic> toJson() => {
        "productVariantId": productVariantId,
        "detail": detail,
        "variantOrder": variantOrder,
        "variantInfo": variantInfo,
      };
}
