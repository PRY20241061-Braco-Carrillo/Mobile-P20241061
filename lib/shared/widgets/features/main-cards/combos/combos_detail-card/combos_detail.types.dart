import "variants/combo/combo_detail.variant.types.dart";

class ComboDetailCardData {
  String comboId;
  String name;
  double amountPrice;
  String currencyPrice;
  String urlImage;
  int freeSauce;
  int minCookingTime;
  int maxCookingTime;
  String unitOfTimeCookingTime;
  List<ProductComboDetailCardData> products;
  List<ComplementComboDetailCardData> complements;

  ComboDetailCardData({
    required this.comboId,
    required this.name,
    required this.amountPrice,
    required this.currencyPrice,
    required this.urlImage,
    required this.freeSauce,
    required this.minCookingTime,
    required this.maxCookingTime,
    required this.unitOfTimeCookingTime,
    required this.products,
    required this.complements,
  });

  factory ComboDetailCardData.fromJson(Map<String, dynamic> json) =>
      ComboDetailCardData(
        comboId: json["comboId"],
        name: json["name"],
        amountPrice: json["amountPrice"]?.toDouble(),
        currencyPrice: json["currencyPrice"],
        urlImage: json["urlImage"],
        freeSauce: json["freeSauce"],
        minCookingTime: json["minCookingTime"],
        maxCookingTime: json["maxCookingTime"],
        unitOfTimeCookingTime: json["unitOfTimeCookingTime"],
        products: List<ProductComboDetailCardData>.from(json["products"]
            .map((x) => ProductComboDetailCardData.fromJson(x))),
        complements: List<ComplementComboDetailCardData>.from(
            json["complements"]
                .map((x) => ComplementComboDetailCardData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "comboId": comboId,
        "name": name,
        "amountPrice": amountPrice,
        "currencyPrice": currencyPrice,
        "urlImage": urlImage,
        "freeSauce": freeSauce,
        "minCookingTime": minCookingTime,
        "maxCookingTime": maxCookingTime,
        "unitOfTimeCookingTime": unitOfTimeCookingTime,
        "products": List<dynamic>.from(products.map((x) => x.toJson())),
        "complements": List<dynamic>.from(complements.map((x) => x.toJson())),
      };
}

class ComplementComboDetailCardData {
  String complementId;
  String name;
  double amountPrice;
  String currencyPrice;
  bool isSauce;
  String urlImage;
  int freeAmount;

  ComplementComboDetailCardData({
    required this.complementId,
    required this.name,
    required this.amountPrice,
    required this.currencyPrice,
    required this.isSauce,
    required this.urlImage,
    required this.freeAmount,
  });

  factory ComplementComboDetailCardData.fromJson(Map<String, dynamic> json) =>
      ComplementComboDetailCardData(
        complementId: json["complementId"],
        name: json["name"],
        amountPrice: json["amountPrice"]?.toDouble(),
        currencyPrice: json["currencyPrice"],
        isSauce: json["isSauce"],
        urlImage: json["urlImage"],
        freeAmount: json["freeAmount"],
      );

  Map<String, dynamic> toJson() => {
        "complementId": complementId,
        "name": name,
        "amountPrice": amountPrice,
        "currencyPrice": currencyPrice,
        "isSauce": isSauce,
        "urlImage": urlImage,
        "freeAmount": freeAmount,
      };
}

class ProductComboDetailCardData {
  String productId;
  String name;
  String description;
  String urlImage;
  int productAmount;
  List<ProductVariantComboDetailCardData> productVariants;

  ProductComboDetailCardData({
    required this.productId,
    required this.name,
    required this.description,
    required this.urlImage,
    required this.productAmount,
    required this.productVariants,
  });

  factory ProductComboDetailCardData.fromJson(Map<String, dynamic> json) =>
      ProductComboDetailCardData(
        productId: json["productId"],
        name: json["name"],
        description: json["description"],
        urlImage: json["urlImage"],
        productAmount: json["productAmount"],
        productVariants: List<ProductVariantComboDetailCardData>.from(
            json["productVariants"]
                .map((x) => ProductVariantComboDetailCardData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "productId": productId,
        "name": name,
        "description": description,
        "urlImage": urlImage,
        "productAmount": productAmount,
        "productVariants":
            List<dynamic>.from(productVariants.map((x) => x.toJson())),
      };

  List<ComboDetailVariantCard> toComboDetailVariantCards() {
    return productVariants
        .map((variant) => ComboDetailVariantCard(
              productVariantId: variant.productVariantId,
              detail: variant.detail,
              variantOrder: variant.variantOrder,
              variantInfo: variant.variantInfo,
              variants: variant.getVariantsMap(),
            ))
        .toList();
  }
}

class ProductVariantComboDetailCardData {
  final String productVariantId;
  final String detail;
  final int variantOrder;
  final String variantInfo;

  ProductVariantComboDetailCardData({
    required this.productVariantId,
    required this.detail,
    required this.variantOrder,
    required this.variantInfo,
  });

  String get getProductVariantId => productVariantId;
  String get getDetail => detail;
  double get getAmountPrice => 0.0; // Placeholder value
  String get getCurrencyPrice => ''; // Placeholder value
  String get getVariantInfo => variantInfo;
  double get getVariantOrder => variantOrder.toDouble();

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

  factory ProductVariantComboDetailCardData.fromJson(
          Map<String, dynamic> json) =>
      ProductVariantComboDetailCardData(
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
