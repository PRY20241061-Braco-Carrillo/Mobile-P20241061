import "package:json_annotation/json_annotation.dart";

part "menu_base.types.g.dart";

@JsonSerializable()
class MenuBaseCardData {
  String menuId;
  String name;
  double amountPrice;
  String currencyPrice;
  int minCookingTime;
  int maxCookingTime;
  String unitOfTimeCookingTime;
  String urlImage;

  MenuBaseCardData({
    required this.menuId,
    required this.name,
    required this.amountPrice,
    required this.currencyPrice,
    required this.minCookingTime,
    required this.maxCookingTime,
    required this.unitOfTimeCookingTime,
    required this.urlImage,
  });
  factory MenuBaseCardData.fromJson(Map<String, dynamic> json) =>
      _$MenuBaseCardDataFromJson(json);

  Map<String, dynamic> toJson() => _$MenuBaseCardDataToJson(this);
}

@JsonSerializable()
class ListMenuByCampusResponse {
  final List<MenuBaseCardData> products;

  ListMenuByCampusResponse({required this.products});

  factory ListMenuByCampusResponse.fromJson(Map<String, dynamic> json) =>
      _$ListMenuByCampusResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ListMenuByCampusResponseToJson(this);
}
