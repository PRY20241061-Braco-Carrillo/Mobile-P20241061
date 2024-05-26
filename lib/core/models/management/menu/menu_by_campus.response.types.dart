import "package:json_annotation/json_annotation.dart";

part "menu_by_campus.response.types.g.dart";

@JsonSerializable()
class MenuByCampusResponse {
  String menuId;
  String name;
  double amountPrice;
  String currencyPrice;
  int minCookingTime;
  int maxCookingTime;
  String unitOfTimeCookingTime;
  String urlImage;

  MenuByCampusResponse({
    required this.menuId,
    required this.name,
    required this.amountPrice,
    required this.currencyPrice,
    required this.minCookingTime,
    required this.maxCookingTime,
    required this.unitOfTimeCookingTime,
    required this.urlImage,
  });
  factory MenuByCampusResponse.fromJson(Map<String, dynamic> json) =>
      _$MenuByCampusResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MenuByCampusResponseToJson(this);
}

@JsonSerializable()
class ListMenuByCampusResponse {
  final List<MenuByCampusResponse> products;

  ListMenuByCampusResponse({required this.products});

  factory ListMenuByCampusResponse.fromJson(Map<String, dynamic> json) =>
      _$ListMenuByCampusResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ListMenuByCampusResponseToJson(this);
}
