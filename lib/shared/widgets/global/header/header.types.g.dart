// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'header.types.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HeaderFullData _$HeaderFullDataFromJson(Map<String, dynamic> json) =>
    HeaderFullData(
      logo: json['logo'] as String,
      path: json['path'] as String,
      aboutInfoId: json['aboutInfoId'] as String,
      title: json['title'] as String,
    );

Map<String, dynamic> _$HeaderFullDataToJson(HeaderFullData instance) =>
    <String, dynamic>{
      'logo': instance.logo,
      'path': instance.path,
      'aboutInfoId': instance.aboutInfoId,
      'title': instance.title,
    };

HeaderIconData _$HeaderIconDataFromJson(Map<String, dynamic> json) =>
    HeaderIconData(
      icon: json['icon'] as String?,
      title: json['title'] as String,
      isAsset: json['isAsset'] as bool?,
    );

Map<String, dynamic> _$HeaderIconDataToJson(HeaderIconData instance) =>
    <String, dynamic>{
      'icon': instance.icon,
      'isAsset': instance.isAsset,
      'title': instance.title,
    };
