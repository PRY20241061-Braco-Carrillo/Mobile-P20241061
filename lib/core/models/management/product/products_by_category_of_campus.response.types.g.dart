// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'products_by_category_of_campus.response.types.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductByCategoryOfCampusResponse _$ProductByCategoryOfCampusResponseFromJson(
        Map<String, dynamic> json) =>
    ProductByCategoryOfCampusResponse(
      productId: json['productId'] as String,
      name: json['name'] as String,
      minCookingTime: json['minCookingTime'] as int,
      maxCookingTime: json['maxCookingTime'] as int,
      unitOfTimeCookingTime: json['unitOfTimeCookingTime'] as String,
      urlImage: json['urlImage'] as String,
      amountPrice: (json['amountPrice'] as num).toDouble(),
      hasVariant: json['hasVariant'] as bool,
      currencyPrice: json['currencyPrice'] as String,
    );

Map<String, dynamic> _$ProductByCategoryOfCampusResponseToJson(
        ProductByCategoryOfCampusResponse instance) =>
    <String, dynamic>{
      'productId': instance.productId,
      'name': instance.name,
      'minCookingTime': instance.minCookingTime,
      'maxCookingTime': instance.maxCookingTime,
      'unitOfTimeCookingTime': instance.unitOfTimeCookingTime,
      'urlImage': instance.urlImage,
      'amountPrice': instance.amountPrice,
      'hasVariant': instance.hasVariant,
      'currencyPrice': instance.currencyPrice,
    };

ListProductByCategoryOfCampusResponse
    _$ListProductByCategoryOfCampusResponseFromJson(
            Map<String, dynamic> json) =>
        ListProductByCategoryOfCampusResponse(
          products: (json['products'] as List<dynamic>)
              .map((e) => ProductByCategoryOfCampusResponse.fromJson(
                  e as Map<String, dynamic>))
              .toList(),
        );

Map<String, dynamic> _$ListProductByCategoryOfCampusResponseToJson(
        ListProductByCategoryOfCampusResponse instance) =>
    <String, dynamic>{
      'products': instance.products,
    };
