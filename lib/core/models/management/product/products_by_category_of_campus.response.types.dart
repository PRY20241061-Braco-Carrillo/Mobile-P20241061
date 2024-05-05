import "package:json_annotation/json_annotation.dart";

part "products_by_category_of_campus.response.types.g.dart";

@JsonSerializable()
class ProductByCategoryOfCampusResponse {
  final String productId;

  final String name;

  final int minCookingTime;

  final int maxCookingTime;

  final String unitOfTimeCookingTime;

  final String urlImage;

  final int price;

  final bool hasVariant;

  final String currencyPrice;

  ProductByCategoryOfCampusResponse({
    required this.productId,
    required this.name,
    required this.minCookingTime,
    required this.maxCookingTime,
    required this.unitOfTimeCookingTime,
    required this.urlImage,
    required this.price,
    required this.hasVariant,
    required this.currencyPrice,
  });

  factory ProductByCategoryOfCampusResponse.fromJson(
          Map<String, dynamic> json) =>
      _$ProductByCategoryOfCampusResponseFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ProductByCategoryOfCampusResponseToJson(this);
}

@JsonSerializable()
class ListProductByCategoryOfCampusResponse {
  final List<ProductByCategoryOfCampusResponse> products;

  ListProductByCategoryOfCampusResponse({required this.products});

  factory ListProductByCategoryOfCampusResponse.fromJson(
          Map<String, dynamic> json) =>
      _$ListProductByCategoryOfCampusResponseFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ListProductByCategoryOfCampusResponseToJson(this);
}
