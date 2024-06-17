class PromotionDetailVariantCard {
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

  PromotionDetailVariantCard({
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

  factory PromotionDetailVariantCard.fromJson(Map<String, dynamic> json) =>
      PromotionDetailVariantCard(
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
