class ComboDetailResponse {
  String comboId;
  String name;
  double amountPrice;
  String currencyPrice;
  String urlImage;
  int freeSauce;
  int minCookingTime;
  int maxCookingTime;
  String unitOfTimeCookingTime;
  List<ProductComboDetailResponse> products;
  List<ComplementComboDetailResponse> complements;

  ComboDetailResponse({
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

  factory ComboDetailResponse.fromJson(Map<String, dynamic> json) =>
      ComboDetailResponse(
        comboId: json["comboId"],
        name: json["name"],
        amountPrice: json["amountPrice"]?.toDouble(),
        currencyPrice: json["currencyPrice"],
        urlImage: json["urlImage"],
        freeSauce: json["freeSauce"],
        minCookingTime: json["minCookingTime"],
        maxCookingTime: json["maxCookingTime"],
        unitOfTimeCookingTime: json["unitOfTimeCookingTime"],
        products: List<ProductComboDetailResponse>.from(json["products"]
            .map((x) => ProductComboDetailResponse.fromJson(x))),
        complements: List<ComplementComboDetailResponse>.from(
            json["complements"]
                .map((x) => ComplementComboDetailResponse.fromJson(x))),
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

class ComplementComboDetailResponse {
  String complementId;
  String name;
  double amountPrice;
  String currencyPrice;
  bool isSauce;
  String urlImage;
  int freeAmount;

  ComplementComboDetailResponse({
    required this.complementId,
    required this.name,
    required this.amountPrice,
    required this.currencyPrice,
    required this.isSauce,
    required this.urlImage,
    required this.freeAmount,
  });

  factory ComplementComboDetailResponse.fromJson(Map<String, dynamic> json) =>
      ComplementComboDetailResponse(
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

class ProductComboDetailResponse {
  String productId;
  String name;
  String description;
  String urlImage;
  int productAmount;
  List<ProductVariantComboDetailResponse> productVariants;

  ProductComboDetailResponse({
    required this.productId,
    required this.name,
    required this.description,
    required this.urlImage,
    required this.productAmount,
    required this.productVariants,
  });

  factory ProductComboDetailResponse.fromJson(Map<String, dynamic> json) =>
      ProductComboDetailResponse(
        productId: json["productId"],
        name: json["name"],
        description: json["description"],
        urlImage: json["urlImage"],
        productAmount: json["productAmount"],
        productVariants: List<ProductVariantComboDetailResponse>.from(
            json["productVariants"]
                .map((x) => ProductVariantComboDetailResponse.fromJson(x))),
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
}

class ProductVariantComboDetailResponse {
  String productVariantId;
  String detail;
  int variantOrder;
  String variantInfo;

  ProductVariantComboDetailResponse({
    required this.productVariantId,
    required this.detail,
    required this.variantOrder,
    required this.variantInfo,
  });

  factory ProductVariantComboDetailResponse.fromJson(
          Map<String, dynamic> json) =>
      ProductVariantComboDetailResponse(
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
