import "variants/product/product_detail_variant.types.dart";

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
        "productVariants": List<dynamic>.from(
            productVariants.map((ProductVariant x) => x.toJson())),
        "complements":
            List<dynamic>.from(complements.map((Complement x) => x.toJson())),
      };

  List<ProductDetailVariantCard> toProductDetailVariantCards() {
    return productVariants.map((variant) {
      return ProductDetailVariantCard(
        productVariantId: variant.productVariantId,
        amountPrice: variant.amountPrice,
        currencyPrice: variant.currencyPrice,
        variantInfo: variant.variantInfo,
        variantOrder: variant.variantOrder,
        variants: variant.getVariantsMap(),
      );
    }).toList();
  }
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
  double calories;
  double proteins;
  double totalFat;
  double carbohydrates;
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
        calories: json["calories"] ?? 0.0,
        proteins: json["proteins"] ?? 0.0,
        totalFat: json["totalFat"] ?? 0.0,
        carbohydrates: json["carbohydrates"] ?? 0.0,
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
  final String productVariantId;
  final double amountPrice;
  final String currencyPrice;
  final String variantInfo;
  final double variantOrder;

  ProductVariant({
    required this.productVariantId,
    required this.amountPrice,
    required this.currencyPrice,
    required this.variantInfo,
    required this.variantOrder,
  });

  factory ProductVariant.fromJson(Map<String, dynamic> json) => ProductVariant(
        productVariantId: json["productVariantId"] ?? "",
        amountPrice: json["amountPrice"]?.toDouble() ?? 0.0,
        currencyPrice: json["currencyPrice"] ?? "",
        variantInfo: json["variantInfo"] ?? "",
        variantOrder: json["variantOrder"]?.toDouble() ?? 0.0,
      );

  Map<String, dynamic> toJson() => {
        "productVariantId": productVariantId,
        "amountPrice": amountPrice,
        "currencyPrice": currencyPrice,
        "variantInfo": variantInfo,
        "variantOrder": variantOrder,
      };

  Map<String, String> getVariantsMap() {
    return _parseVariantInfo(variantInfo);
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

class Complement {
  String complementId;
  String name;
  double amountPrice;
  String currencyPrice;
  int? freeAmount;
  bool isSauce;

  Complement({
    required this.complementId,
    required this.name,
    required this.amountPrice,
    this.freeAmount,
    required this.currencyPrice,
    required this.isSauce,
  });

  factory Complement.fromJson(Map<String, dynamic> json) => Complement(
        complementId: json["complementId"] ?? "",
        name: json["name"] ?? "",
        freeAmount: json["freeAmount"] ?? 0,
        amountPrice: json["amountPrice"]?.toDouble() ?? 0.0,
        currencyPrice: json["currencyPrice"] ?? "",
        isSauce: json["isSauce"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "complementId": complementId,
        "name": name,
        "freeAmount": freeAmount,
        "amountPrice": amountPrice,
        "currencyPrice": currencyPrice,
        "isSauce": isSauce,
      };
}
