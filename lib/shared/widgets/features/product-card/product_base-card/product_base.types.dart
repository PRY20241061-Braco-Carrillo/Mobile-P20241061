import "package:json_annotation/json_annotation.dart";

part "product_base.types.g.dart";

@JsonSerializable()
class ProductBaseCardData {
  String productId;
  String name;
  int minCookingTime;
  int maxCookingTime;
  String unitOfTimeCookingTime;
  String urlImage;
  double amountPrice;
  bool hasVariant;
  String currencyPrice;

  ProductBaseCardData({
    required this.productId,
    required this.name,
    required this.minCookingTime,
    required this.maxCookingTime,
    required this.unitOfTimeCookingTime,
    required this.urlImage,
    required this.amountPrice,
    required this.hasVariant,
    required this.currencyPrice,
  });

  factory ProductBaseCardData.fromJson(Map<String, dynamic> json) =>
      _$ProductBaseCardDataFromJson(json);

  Map<String, dynamic> toJson() => _$ProductBaseCardDataToJson(this);
}
