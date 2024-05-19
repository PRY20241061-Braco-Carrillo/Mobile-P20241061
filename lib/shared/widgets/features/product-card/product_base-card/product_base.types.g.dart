// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_base.types.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductBaseCardData _$ProductBaseCardDataFromJson(Map<String, dynamic> json) =>
    ProductBaseCardData(
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

Map<String, dynamic> _$ProductBaseCardDataToJson(
        ProductBaseCardData instance) =>
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
