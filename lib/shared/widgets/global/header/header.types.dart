import "package:json_annotation/json_annotation.dart";

part "header.types.g.dart";

@JsonSerializable()
class HeaderFullData {
  final String logo;
  final String path;
  final String aboutInfoId;
  final String title;

  factory HeaderFullData.fromJson(Map<String, dynamic> json) =>
      _$HeaderFullDataFromJson(json);

  Map<String, dynamic> toJson() => _$HeaderFullDataToJson(this);

  HeaderFullData({
    required this.logo,
    required this.path,
    required this.aboutInfoId,
    required this.title,
  });
}

@JsonSerializable()
class HeaderIconData {
  final String? icon;
  final bool? isAsset;
  final String title;

  factory HeaderIconData.fromJson(Map<String, dynamic> json) =>
      _$HeaderIconDataFromJson(json);

  Map<String, dynamic> toJson() => _$HeaderIconDataToJson(this);

  HeaderIconData({
    this.icon,
    required this.title,
    this.isAsset,
  });
}
