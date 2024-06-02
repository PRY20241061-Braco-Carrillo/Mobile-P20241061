class PromotionProductDetailResponse {
  Promotion promotion;
  List<ProductVariant> productVariants;
  NutritionalInformation nutritionalInformation;
  List<Complement> complements;

  PromotionProductDetailResponse({
    required this.promotion,
    required this.productVariants,
    required this.nutritionalInformation,
    required this.complements,
  });

  factory PromotionProductDetailResponse.fromJson(Map<String, dynamic> json) =>
      PromotionProductDetailResponse(
        promotion: Promotion.fromJson(json["promotion"]),
        productVariants: List<ProductVariant>.from(
            json["productVariants"].map((x) => ProductVariant.fromJson(x))),
        nutritionalInformation:
            NutritionalInformation.fromJson(json["nutritionalInformation"]),
        complements: List<Complement>.from(
            json["complements"].map((x) => Complement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "promotion": promotion.toJson(),
        "productVariants":
            List<dynamic>.from(productVariants.map((x) => x.toJson())),
        "nutritionalInformation": nutritionalInformation.toJson(),
        "complements": List<dynamic>.from(complements.map((x) => x.toJson())),
      };
}

class Complement {
  String complementId;
  String name;
  int freeAmount;
  double amountPrice;
  String currencyPrice;
  bool isSauce;
  String urlImage;

  Complement({
    required this.complementId,
    required this.name,
    required this.freeAmount,
    required this.amountPrice,
    required this.currencyPrice,
    required this.isSauce,
    required this.urlImage,
  });

  factory Complement.fromJson(Map<String, dynamic> json) => Complement(
        complementId: json["complementId"],
        name: json["name"],
        freeAmount: json["freeAmount"],
        amountPrice: json["amountPrice"]?.toDouble(),
        currencyPrice: json["currencyPrice"],
        isSauce: json["isSauce"],
        urlImage: json["urlImage"],
      );

  Map<String, dynamic> toJson() => {
        "complementId": complementId,
        "name": name,
        "freeAmount": freeAmount,
        "amountPrice": amountPrice,
        "currencyPrice": currencyPrice,
        "isSauce": isSauce,
        "urlImage": urlImage,
      };
}

class NutritionalInformation {
  String nutritionalInformationId;
  int calories;
  int proteins;
  int totalFat;
  int carbohydrates;
  bool isVegan;
  bool isVegetarian;
  bool isLowCalories;
  bool isHighProtein;
  bool isWithoutGluten;
  bool isWithoutNut;
  bool isWithoutLactose;
  bool isWithoutEggs;
  bool isWithoutSeafood;
  bool isWithoutPig;

  NutritionalInformation({
    required this.nutritionalInformationId,
    required this.calories,
    required this.proteins,
    required this.totalFat,
    required this.carbohydrates,
    required this.isVegan,
    required this.isVegetarian,
    required this.isLowCalories,
    required this.isHighProtein,
    required this.isWithoutGluten,
    required this.isWithoutNut,
    required this.isWithoutLactose,
    required this.isWithoutEggs,
    required this.isWithoutSeafood,
    required this.isWithoutPig,
  });

  factory NutritionalInformation.fromJson(Map<String, dynamic> json) =>
      NutritionalInformation(
        nutritionalInformationId: json["nutritionalInformationId"],
        calories: json["calories"],
        proteins: json["proteins"],
        totalFat: json["totalFat"],
        carbohydrates: json["carbohydrates"],
        isVegan: json["isVegan"],
        isVegetarian: json["isVegetarian"],
        isLowCalories: json["isLowCalories"],
        isHighProtein: json["isHighProtein"],
        isWithoutGluten: json["isWithoutGluten"],
        isWithoutNut: json["isWithoutNut"],
        isWithoutLactose: json["isWithoutLactose"],
        isWithoutEggs: json["isWithoutEggs"],
        isWithoutSeafood: json["isWithoutSeafood"],
        isWithoutPig: json["isWithoutPig"],
      );

  Map<String, dynamic> toJson() => {
        "nutritionalInformationId": nutritionalInformationId,
        "calories": calories,
        "proteins": proteins,
        "totalFat": totalFat,
        "carbohydrates": carbohydrates,
        "isVegan": isVegan,
        "isVegetarian": isVegetarian,
        "isLowCalories": isLowCalories,
        "isHighProtein": isHighProtein,
        "isWithoutGluten": isWithoutGluten,
        "isWithoutNut": isWithoutNut,
        "isWithoutLactose": isWithoutLactose,
        "isWithoutEggs": isWithoutEggs,
        "isWithoutSeafood": isWithoutSeafood,
        "isWithoutPig": isWithoutPig,
      };
}

class ProductVariant {
  String productVariantId;
  String detail;
  double amountPrice;
  String currencyPrice;
  String name;
  int minCookingTime;
  int maxCookingTime;
  String unitOfTimeCookingTime;
  String description;
  String nutritionalInformationId;
  String productId;

  ProductVariant({
    required this.productVariantId,
    required this.detail,
    required this.amountPrice,
    required this.currencyPrice,
    required this.name,
    required this.minCookingTime,
    required this.maxCookingTime,
    required this.unitOfTimeCookingTime,
    required this.description,
    required this.nutritionalInformationId,
    required this.productId,
  });

  factory ProductVariant.fromJson(Map<String, dynamic> json) => ProductVariant(
        productVariantId: json["productVariantId"],
        detail: json["detail"],
        amountPrice: json["amountPrice"]?.toDouble(),
        currencyPrice: json["currencyPrice"],
        name: json["name"],
        minCookingTime: json["minCookingTime"],
        maxCookingTime: json["maxCookingTime"],
        unitOfTimeCookingTime: json["unitOfTimeCookingTime"],
        description: json["description"],
        nutritionalInformationId: json["nutritionalInformationId"],
        productId: json["productId"],
      );

  Map<String, dynamic> toJson() => {
        "productVariantId": productVariantId,
        "detail": detail,
        "amountPrice": amountPrice,
        "currencyPrice": currencyPrice,
        "name": name,
        "minCookingTime": minCookingTime,
        "maxCookingTime": maxCookingTime,
        "unitOfTimeCookingTime": unitOfTimeCookingTime,
        "description": description,
        "nutritionalInformationId": nutritionalInformationId,
        "productId": productId,
      };
}

class Promotion {
  String promotionId;
  String name;
  int discount;
  String discountType;
  String detail;
  String urlImage;
  int freeSauce;
  bool isAvailable;
  bool hasVariant;
  int freeComplements;

  Promotion({
    required this.promotionId,
    required this.name,
    required this.discount,
    required this.discountType,
    required this.detail,
    required this.urlImage,
    required this.freeSauce,
    required this.isAvailable,
    required this.hasVariant,
    required this.freeComplements,
  });

  factory Promotion.fromJson(Map<String, dynamic> json) => Promotion(
        promotionId: json["promotionId"],
        name: json["name"],
        discount: json["discount"],
        discountType: json["discountType"],
        detail: json["detail"],
        urlImage: json["urlImage"],
        freeSauce: json["freeSauce"],
        isAvailable: json["isAvailable"],
        hasVariant: json["hasVariant"],
        freeComplements: json["freeComplements"],
      );

  Map<String, dynamic> toJson() => {
        "promotionId": promotionId,
        "name": name,
        "discount": discount,
        "discountType": discountType,
        "detail": detail,
        "urlImage": urlImage,
        "freeSauce": freeSauce,
        "isAvailable": isAvailable,
        "hasVariant": hasVariant,
        "freeComplements": freeComplements,
      };
}
