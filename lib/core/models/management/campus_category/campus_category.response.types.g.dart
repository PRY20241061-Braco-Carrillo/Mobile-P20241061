// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'campus_category.response.types.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CampusCategoryResponse _$CampusCategoryResponseFromJson(
        Map<String, dynamic> json) =>
    CampusCategoryResponse(
      campusCategoryId: json['campusCategoryId'] as String,
      name: json['name'] as String,
      urlImage: json['urlImage'] as String,
      isPromotion: json['isPromotion'] as bool?,
      isCombo: json['isCombo'] as bool?,
      isMenu: json['isMenu'] as bool?,
    );

Map<String, dynamic> _$CampusCategoryResponseToJson(
        CampusCategoryResponse instance) =>
    <String, dynamic>{
      'campusCategoryId': instance.campusCategoryId,
      'name': instance.name,
      'urlImage': instance.urlImage,
      'isPromotion': instance.isPromotion,
      'isCombo': instance.isCombo,
      'isMenu': instance.isMenu,
    };

CampusCategoryListResponse _$CampusCategoryListResponseFromJson(
        Map<String, dynamic> json) =>
    CampusCategoryListResponse(
      categories: (json['categories'] as List<dynamic>)
          .map(
              (e) => CampusCategoryResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CampusCategoryListResponseToJson(
        CampusCategoryListResponse instance) =>
    <String, dynamic>{
      'categories': instance.categories,
    };
