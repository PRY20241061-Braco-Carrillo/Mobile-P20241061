class MenuDetailCardData {
  String menuId;
  String name;
  int amountPrice;
  String currencyPrice;
  int minCookingTime;
  int maxCookingTime;
  String unitOfTimeCookingTime;
  String urlImage;
  DishesDetailCardData desserts;
  DishesDetailCardData drinks;
  DishesDetailCardData initialDishes;
  DishesDetailCardData principalDishes;

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
        desserts: DishesDetailCardData.fromJson(json["desserts"]),
        drinks: DishesDetailCardData.fromJson(json["drinks"]),
        initialDishes: DishesDetailCardData.fromJson(json["initialDishes"]),
        principalDishes: DishesDetailCardData.fromJson(json["principalDishes"]),
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
        "desserts": desserts.toJson(),
        "drinks": drinks.toJson(),
        "initialDishes": initialDishes.toJson(),
        "principalDishes": principalDishes.toJson(),
      };
}

class DishesDetailCardData {
  String productId;
  String productMenuId;
  String name;
  String description;
  String urlImage;
  List<VariantMenuDetailCardData> variants;

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
        productId: json["productId"],
        productMenuId: json["productMenuId"],
        name: json["name"],
        description: json["description"],
        urlImage: json["urlImage"],
        variants: List<VariantMenuDetailCardData>.from(
            json["variants"].map((x) => VariantMenuDetailCardData.fromJson(x))),
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

class VariantMenuDetailCardData {
  String productVariantId;
  String detail;
  int variantOrder;
  String variantInfo;
  Map<String, String> variants;

  VariantMenuDetailCardData({
    required this.productVariantId,
    required this.detail,
    required this.variantOrder,
    required this.variantInfo,
    required this.variants,
  });

  factory VariantMenuDetailCardData.fromJson(Map<String, dynamic> json) =>
      VariantMenuDetailCardData(
        productVariantId: json["productVariantId"],
        detail: json["detail"],
        variantOrder: json["variantOrder"],
        variantInfo: json["variantInfo"],
        variants: Map<String, String>.from(json["variants"]),
      );

  Map<String, dynamic> toJson() => {
        "productVariantId": productVariantId,
        "detail": detail,
        "variantOrder": variantOrder,
        "variantInfo": variantInfo,
        "variants": variants,
      };
}
