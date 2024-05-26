// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu_by_campus.response.types.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MenuByCampusResponse _$MenuByCampusResponseFromJson(
        Map<String, dynamic> json) =>
    MenuByCampusResponse(
      menuId: json['menuId'] as String,
      name: json['name'] as String,
      amountPrice: (json['amountPrice'] as num).toDouble(),
      currencyPrice: json['currencyPrice'] as String,
      minCookingTime: json['minCookingTime'] as int,
      maxCookingTime: json['maxCookingTime'] as int,
      unitOfTimeCookingTime: json['unitOfTimeCookingTime'] as String,
      urlImage: json['urlImage'] as String,
    );

Map<String, dynamic> _$MenuByCampusResponseToJson(
        MenuByCampusResponse instance) =>
    <String, dynamic>{
      'menuId': instance.menuId,
      'name': instance.name,
      'amountPrice': instance.amountPrice,
      'currencyPrice': instance.currencyPrice,
      'minCookingTime': instance.minCookingTime,
      'maxCookingTime': instance.maxCookingTime,
      'unitOfTimeCookingTime': instance.unitOfTimeCookingTime,
      'urlImage': instance.urlImage,
    };

ListMenuByCampusResponse _$ListMenuByCampusResponseFromJson(
        Map<String, dynamic> json) =>
    ListMenuByCampusResponse(
      products: (json['products'] as List<dynamic>)
          .map((e) => MenuByCampusResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ListMenuByCampusResponseToJson(
        ListMenuByCampusResponse instance) =>
    <String, dynamic>{
      'products': instance.products,
    };