class PromotionProductDetailResponse {
  Promotion? promotion;
  List<ProductVariant> productVariants;
  NutritionalInformation? nutritionalInformation;
  List<Complement>? complements;

  PromotionProductDetailResponse({
    this.promotion,
    required this.productVariants,
    this.nutritionalInformation,
    this.complements,
  });

  factory PromotionProductDetailResponse.fromJson(Map<String, dynamic> json) =>
      PromotionProductDetailResponse(
        promotion: json["promotion"] == null
            ? null
            : Promotion.fromJson(json["promotion"]),
        productVariants: json["productVariants"] == null
            ? []
            : List<ProductVariant>.from(json["productVariants"]!
                .map((x) => ProductVariant.fromJson(x))),
        nutritionalInformation: json["nutritionalInformation"] == null
            ? null
            : NutritionalInformation.fromJson(json["nutritionalInformation"]),
        complements: json["complements"] == null
            ? []
            : List<Complement>.from(
                json["complements"]!.map((x) => Complement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "promotion": promotion?.toJson(),
        "productVariants": productVariants == null
            ? []
            : List<dynamic>.from(productVariants!.map((x) => x.toJson())),
        "nutritionalInformation": nutritionalInformation?.toJson(),
        "complements": complements == null
            ? []
            : List<dynamic>.from(complements!.map((x) => x.toJson())),
      };
}

class Complement {
  String? complementId;
  String? name;
  double? amountPrice;
  String? currencyPrice;
  bool? isSauce;
  String? urlImage;

  Complement({
    this.complementId,
    this.name,
    this.amountPrice,
    this.currencyPrice,
    this.isSauce,
    this.urlImage,
  });

  factory Complement.fromJson(Map<String, dynamic> json) => Complement(
        complementId: json["complementId"],
        name: json["name"],
        amountPrice: json["amountPrice"]?.toDouble(),
        currencyPrice: json["currencyPrice"],
        isSauce: json["isSauce"],
        urlImage: json["urlImage"],
      );

  Map<String, dynamic> toJson() => {
        "complementId": complementId,
        "name": name,
        "amountPrice": amountPrice,
        "currencyPrice": currencyPrice,
        "isSauce": isSauce,
        "urlImage": urlImage,
      };
}

class NutritionalInformation {
  String? nutritionalInformationId;
  double? calories;
  double? proteins;
  double? totalFat;
  double? carbohydrates;
  bool? isVegan;
  bool? isVegetarian;
  bool? isLowCalories;
  bool? isHighProtein;
  bool? isWithoutGluten;
  bool? isWithoutNut;
  bool? isWithoutLactose;
  bool? isWithoutEggs;
  bool? isWithoutSeafood;
  bool? isWithoutPig;

  NutritionalInformation({
    this.nutritionalInformationId,
    this.calories,
    this.proteins,
    this.totalFat,
    this.carbohydrates,
    this.isVegan,
    this.isVegetarian,
    this.isLowCalories,
    this.isHighProtein,
    this.isWithoutGluten,
    this.isWithoutNut,
    this.isWithoutLactose,
    this.isWithoutEggs,
    this.isWithoutSeafood,
    this.isWithoutPig,
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
  String? productVariantId;
  String? detail;
  double amountPrice;
  String? currencyPrice;
  String? name;
  int? minCookingTime;
  int? maxCookingTime;
  String? unitOfTimeCookingTime;
  String? description;
  String? nutritionalInformationId;
  String? productId;

  ProductVariant({
    this.productVariantId,
    this.detail,
    required this.amountPrice,
    this.currencyPrice,
    this.name,
    this.minCookingTime,
    this.maxCookingTime,
    this.unitOfTimeCookingTime,
    this.description,
    this.nutritionalInformationId,
    this.productId,
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
  String? promotionId;
  String? name;
  double? discount;
  String? discountType;
  String? detail;
  String? urlImage;
  int? freeSauce;
  bool? isAvailable;
  bool? hasVariant;
  int? freeComplements;
  dynamic comboId;

  Promotion({
    this.promotionId,
    this.name,
    this.discount,
    this.discountType,
    this.detail,
    this.urlImage,
    this.freeSauce,
    this.isAvailable,
    this.hasVariant,
    this.freeComplements,
    this.comboId,
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
        comboId: json["comboId"],
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
        "comboId": comboId,
      };
}
