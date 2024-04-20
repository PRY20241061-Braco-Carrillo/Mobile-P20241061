import "package:json_annotation/json_annotation.dart";

part "header.types.g.dart";

@JsonSerializable()
class HeaderBaseData {
  final String title;

  factory HeaderBaseData.fromJson(Map<String, dynamic> json) =>
      _$HeaderBaseDataFromJson(json);

  HeaderBaseData({
    required this.title,
  });
}

@JsonSerializable()
class HeaderFullData extends HeaderBaseData {
  final String logo;
  final String path;
  final String aboutInfoId;

  factory HeaderFullData.fromJson(Map<String, dynamic> json) =>
      _$HeaderFullDataFromJson(json);

  HeaderFullData({
    required this.logo,
    required this.path,
    required this.aboutInfoId,
    required super.title,
  });
}

@JsonSerializable()
class HeaderIconData extends HeaderBaseData {
  final String? icon;
  final bool? isAsset;

  factory HeaderIconData.fromJson(Map<String, dynamic> json) =>
      _$HeaderIconDataFromJson(json);

  HeaderIconData({
    this.icon,
    required super.title,
    this.isAsset,
  });
}
