class PromotionComboDetailResponse {
  String promotionId;
  String name;
  int discount;
  String discountType;
  String detail;
  String urlImage;
  int freeSauce;
  String comboId;
  ComboDetail comboDetail;

  PromotionComboDetailResponse({
    required this.promotionId,
    required this.name,
    required this.discount,
    required this.discountType,
    required this.detail,
    required this.urlImage,
    required this.freeSauce,
    required this.comboId,
    required this.comboDetail,
  });

  factory PromotionComboDetailResponse.fromJson(Map<String, dynamic> json) =>
      PromotionComboDetailResponse(
        promotionId: json["promotionId"],
        name: json["name"],
        discount: json["discount"],
        discountType: json["discountType"],
        detail: json["detail"],
        urlImage: json["urlImage"],
        freeSauce: json["freeSauce"],
        comboId: json["comboId"],
        comboDetail: ComboDetail.fromJson(json["comboDetail"]),
      );

  Map<String, dynamic> toJson() => {
        "promotionId": promotionId,
        "name": name,
        "discount": discount,
        "discountType": discountType,
        "detail": detail,
        "urlImage": urlImage,
        "freeSauce": freeSauce,
        "comboId": comboId,
        "comboDetail": comboDetail.toJson(),
      };
}

class ComboDetail {
  String comboId;
  String name;
  double amountPrice;
  String currencyPrice;
  String urlImage;
  int freeSauce;
  int minCookingTime;
  int maxCookingTime;
  String unitOfTimeCookingTime;
  List<Product> products;
  List<Complement> complements;

  ComboDetail({
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

  factory ComboDetail.fromJson(Map<String, dynamic> json) => ComboDetail(
        comboId: json["comboId"],
        name: json["name"],
        amountPrice: json["amountPrice"]?.toDouble(),
        currencyPrice: json["currencyPrice"],
        urlImage: json["urlImage"],
        freeSauce: json["freeSauce"],
        minCookingTime: json["minCookingTime"],
        maxCookingTime: json["maxCookingTime"],
        unitOfTimeCookingTime: json["unitOfTimeCookingTime"],
        products: List<Product>.from(
            json["products"].map((x) => Product.fromJson(x))),
        complements: List<Complement>.from(
            json["complements"].map((x) => Complement.fromJson(x))),
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

class Complement {
  String complementId;
  String name;
  double amountPrice;
  String currencyPrice;
  bool isSauce;
  String urlImage;
  int freeAmount;

  Complement({
    required this.complementId,
    required this.name,
    required this.amountPrice,
    required this.currencyPrice,
    required this.isSauce,
    required this.urlImage,
    required this.freeAmount,
  });

  factory Complement.fromJson(Map<String, dynamic> json) => Complement(
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

class Product {
  String productId;
  String name;
  String description;
  String urlImage;
  int productAmount;
  List<ProductVariant> productVariants;

  Product({
    required this.productId,
    required this.name,
    required this.description,
    required this.urlImage,
    required this.productAmount,
    required this.productVariants,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        productId: json["productId"],
        name: json["name"],
        description: json["description"],
        urlImage: json["urlImage"],
        productAmount: json["productAmount"],
        productVariants: List<ProductVariant>.from(
            json["productVariants"].map((x) => ProductVariant.fromJson(x))),
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

class ProductVariant {
  String productVariantId;
  String detail;
  int variantOrder;
  String variantInfo;

  ProductVariant({
    required this.productVariantId,
    required this.detail,
    required this.variantOrder,
    required this.variantInfo,
  });

  factory ProductVariant.fromJson(Map<String, dynamic> json) => ProductVariant(
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
