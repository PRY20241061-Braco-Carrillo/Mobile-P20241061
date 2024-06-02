class PromotionByCampusResponse {
  String promotionId;
  String name;
  int discount;
  String discountType;
  String urlImage;
  bool hasVariant;
  String? comboId;

  PromotionByCampusResponse({
    required this.promotionId,
    required this.name,
    required this.discount,
    required this.discountType,
    required this.urlImage,
    required this.hasVariant,
    this.comboId,
  });

  factory PromotionByCampusResponse.fromJson(Map<String, dynamic> json) =>
      PromotionByCampusResponse(
        promotionId: json["promotionId"],
        name: json["name"],
        discount: json["discount"],
        discountType: json["discountType"],
        urlImage: json["urlImage"],
        hasVariant: json["hasVariant"],
        comboId: json["comboId"],
      );

  Map<String, dynamic> toJson() => {
        "promotionId": promotionId,
        "name": name,
        "discount": discount,
        "discountType": discountType,
        "urlImage": urlImage,
        "hasVariant": hasVariant,
        "comboId": comboId,
      };
}
