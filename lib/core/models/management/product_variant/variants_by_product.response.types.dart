class VariantsByProductResponse {
  Product product;
  List<ProductVariant> productVariants;
  List<Complement> complements;

  VariantsByProductResponse({
    required this.product,
    required this.productVariants,
    required this.complements,
  });

  factory VariantsByProductResponse.fromJson(Map<String, dynamic> json) =>
      VariantsByProductResponse(
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

class Complement {
  String complementId;
  String name;
  int? freeAmount;
  double amountPrice;
  String currencyPrice;
  bool isSauce;

  Complement({
    required this.complementId,
    required this.name,
    this.freeAmount,
    required this.amountPrice,
    required this.currencyPrice,
    required this.isSauce,
  });

  factory Complement.fromJson(Map<String, dynamic> json) => Complement(
        complementId: json["complementId"],
        name: json["name"],
        freeAmount: json["freeAmount"], // Permitir valores nulos
        amountPrice: json["amountPrice"]?.toDouble(),
        currencyPrice: json["currencyPrice"],
        isSauce: json["isSauce"],
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
        productId: json["productId"],
        name: json["name"],
        minCookingTime: json["minCookingTime"],
        maxCookingTime: json["maxCookingTime"],
        unitOfTimeCookingTime: json["unitOfTimeCookingTime"],
        description: json["description"],
        isBreakfast: json["isBreakfast"],
        isLunch: json["isLunch"],
        isDinner: json["isDinner"],
        urlImage: json["urlImage"],
        urlGlb: json["urlGlb"],
        freeSauce: json["freeSauce"],
        isAvailable: json["isAvailable"],
        hasVariant: json["hasVariant"],
        nutritionalInformation:
            NutritionalInformation.fromJson(json["nutritionalInformation"]),
      );

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
  double amountPrice;
  String currencyPrice;
  int variantOrder;
  String? variantInfo;

  ProductVariant({
    required this.productVariantId,
    required this.amountPrice,
    required this.currencyPrice,
    required this.variantOrder,
    this.variantInfo,
  });

  factory ProductVariant.fromJson(Map<String, dynamic> json) => ProductVariant(
        productVariantId: json["productVariantId"],
        amountPrice: json["amountPrice"]?.toDouble(),
        currencyPrice: json["currencyPrice"],
        variantOrder: json["variantOrder"],
        variantInfo: json["variantInfo"] == null ? null : json["variantInfo"],
      );

  Map<String, dynamic> toJson() => {
        "productVariantId": productVariantId,
        "amountPrice": amountPrice,
        "currencyPrice": currencyPrice,
        "variantOrder": variantOrder,
        "variantInfo": variantInfo == null ? null : variantInfo,
      };
}
