// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_button.types.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryButtonData _$CategoryButtonDataFromJson(Map<String, dynamic> json) =>
    CategoryButtonData(
      campusCategoryId: json['campusCategoryId'] as String,
      name: json['name'] as String,
      urlImage: json['urlImage'] as String,
      is_promotion: json['is_promotion'] as bool?,
      is_combo: json['is_combo'] as bool?,
      is_menu: json['is_menu'] as bool?,
    );

Map<String, dynamic> _$CategoryButtonDataToJson(CategoryButtonData instance) =>
    <String, dynamic>{
      'campusCategoryId': instance.campusCategoryId,
      'name': instance.name,
      'urlImage': instance.urlImage,
      'is_promotion': instance.is_promotion,
      'is_combo': instance.is_combo,
      'is_menu': instance.is_menu,
    };
