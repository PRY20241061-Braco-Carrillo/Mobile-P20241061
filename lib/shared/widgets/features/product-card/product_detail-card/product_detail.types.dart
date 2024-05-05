class ProductDetailCardData {
  Product product;
  List<ProductVariant> productVariants;
  List<Complement> complements;

  ProductDetailCardData({
    required this.product,
    required this.productVariants,
    required this.complements,
  });

  factory ProductDetailCardData.fromJson(Map<String, dynamic> json) =>
      ProductDetailCardData(
        product: Product.fromJson(json["product"]),
        productVariants: List<ProductVariant>.from(
            json["productVariants"].map((x) => ProductVariant.fromJson(x))),
        complements: List<Complement>.from(
            json["complements"].map((x) => Complement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "product": product.toJson(),
        "productVariants":
            List<dynamic>.from(productVariants.map((x) => x.toJson())),
        "complements": List<dynamic>.from(complements.map((x) => x.toJson())),
      };
}

class Product {
  String productId;
  String name;
  int minCookingTime;
  int maxCookingTime;
  String unitOfTimeCookingTime;
  String description;
  bool isBreakfast;
  bool isLunch;
  bool isDinner;
  String urlImage;
  String urlGlb;
  int freeSauce;
  bool isAvailable;
  bool hasVariant;
  NutritionalInformation nutritionalInformation;

  Product({
    required this.productId,
    required this.name,
    required this.minCookingTime,
    required this.maxCookingTime,
    required this.unitOfTimeCookingTime,
    required this.description,
    required this.isBreakfast,
    required this.isLunch,
    required this.isDinner,
    required this.urlImage,
    required this.urlGlb,
    required this.freeSauce,
    required this.isAvailable,
    required this.hasVariant,
    required this.nutritionalInformation,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
      productId: json["productId"] ?? "",
      name: json["name"] ?? "",
      minCookingTime: json["minCookingTime"] ?? 0,
      maxCookingTime: json["maxCookingTime"] ?? 0,
      unitOfTimeCookingTime: json["unitOfTimeCookingTime"] ?? "MIN",
      description: json["description"] ?? "",
      isBreakfast: json["isBreakfast"] ?? false,
      isLunch: json["isLunch"] ?? false,
      isDinner: json["isDinner"] ?? false,
      urlImage: json["urlImage"] ?? "",
      urlGlb: json["urlGlb"] ?? "",
      freeSauce: json["freeSauce"] ?? 0,
      isAvailable: json["isAvailable"] ?? false,
      hasVariant: json["hasVariant"] ?? false,
      nutritionalInformation:
          NutritionalInformation.fromJson(json["nutritionalInformation"]));

  Map<String, dynamic> toJson() => {
        "productId": productId,
        "name": name,
        "minCookingTime": minCookingTime,
        "maxCookingTime": maxCookingTime,
        "unitOfTimeCookingTime": unitOfTimeCookingTime,
        "description": description,
        "isBreakfast": isBreakfast,
        "isLunch": isLunch,
        "isDinner": isDinner,
        "urlImage": urlImage,
        "urlGlb": urlGlb,
        "freeSauce": freeSauce,
        "isAvailable": isAvailable,
        "hasVariant": hasVariant,
        "nutritionalInformation": nutritionalInformation.toJson(),
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
        nutritionalInformationId: json["nutritionalInformationId"] ?? "",
        calories: json["calories"] ?? 0,
        proteins: json["proteins"] ?? 0,
        totalFat: json["totalFat"] ?? 0,
        carbohydrates: json["carbohydrates"] ?? 0,
        isVegan: json["isVegan"] ?? false,
        isVegetarian: json["isVegetarian"] ?? false,
        isLowCalories: json["isLowCalories"] ?? false,
        isHighProtein: json["isHighProtein"] ?? false,
        isWithoutGluten: json["isWithoutGluten"] ?? false,
        isWithoutNut: json["isWithoutNut"] ?? false,
        isWithoutLactose: json["isWithoutLactose"] ?? false,
        isWithoutEggs: json["isWithoutEggs"] ?? false,
        isWithoutSeafood: json["isWithoutSeafood"] ?? false,
        isWithoutPig: json["isWithoutPig"] ?? false,
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
  double amountPrice;
  String currencyPrice;
  String variantInfo;
  double variantOrder;

  ProductVariant({
    required this.productVariantId,
    required this.amountPrice,
    required this.currencyPrice,
    required this.variantInfo,
    required this.variantOrder,
  });

  factory ProductVariant.fromJson(Map<String, dynamic> json) => ProductVariant(
        productVariantId: json["productVariantId"],
        amountPrice: json["amountPrice"]?.toDouble(),
        currencyPrice: json["currencyPrice"],
        variantInfo: json["variantInfo"],
        variantOrder: json["variantOrder"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        "productVariantId": productVariantId,
        "amountPrice": amountPrice,
        "currencyPrice": currencyPrice,
        "variantInfo": variantInfo,
        "variantOrder": variantOrder,
      };
}

class Complement {
  String complementId;
  String name;
  double amountPrice;
  String currencyPrice;
  bool isSauce;

  Complement({
    required this.complementId,
    required this.name,
    required this.amountPrice,
    required this.currencyPrice,
    required this.isSauce,
  });

  factory Complement.fromJson(Map<String, dynamic> json) => Complement(
        complementId: json["complementId"] ?? "",
        name: json["name"] ?? "",
        amountPrice: json["amountPrice"]?.toDouble() ?? 0.0,
        currencyPrice: json["currencyPrice"] ?? "",
        isSauce: json["isSauce"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "complementId": complementId,
        "name": name,
        "amountPrice": amountPrice,
        "currencyPrice": currencyPrice,
        "isSauce": isSauce,
      };
}
