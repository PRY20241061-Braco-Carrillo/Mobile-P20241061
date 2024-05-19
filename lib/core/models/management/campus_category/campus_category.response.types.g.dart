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
    );

Map<String, dynamic> _$CampusCategoryResponseToJson(
        CampusCategoryResponse instance) =>
    <String, dynamic>{
      'campusCategoryId': instance.campusCategoryId,
      'name': instance.name,
      'urlImage': instance.urlImage,
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
