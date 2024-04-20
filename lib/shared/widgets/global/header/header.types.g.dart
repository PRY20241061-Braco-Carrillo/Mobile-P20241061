// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'header.types.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HeaderBaseData _$HeaderBaseDataFromJson(Map<String, dynamic> json) =>
    HeaderBaseData(
      title: json['title'] as String,
    );

Map<String, dynamic> _$HeaderBaseDataToJson(HeaderBaseData instance) =>
    <String, dynamic>{
      'title': instance.title,
    };

HeaderFullData _$HeaderFullDataFromJson(Map<String, dynamic> json) =>
    HeaderFullData(
      logo: json['logo'] as String,
      path: json['path'] as String,
      aboutInfoId: json['aboutInfoId'] as String,
      title: json['title'] as String,
    );

Map<String, dynamic> _$HeaderFullDataToJson(HeaderFullData instance) =>
    <String, dynamic>{
      'title': instance.title,
      'logo': instance.logo,
      'path': instance.path,
      'aboutInfoId': instance.aboutInfoId,
    };

HeaderIconData _$HeaderIconDataFromJson(Map<String, dynamic> json) =>
    HeaderIconData(
      icon: json['icon'] as String?,
      title: json['title'] as String,
      isAsset: json['isAsset'] as bool?,
    );

Map<String, dynamic> _$HeaderIconDataToJson(HeaderIconData instance) =>
    <String, dynamic>{
      'title': instance.title,
      'icon': instance.icon,
      'isAsset': instance.isAsset,
    };
