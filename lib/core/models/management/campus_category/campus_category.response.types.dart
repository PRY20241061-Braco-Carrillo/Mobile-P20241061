import "package:json_annotation/json_annotation.dart";

part "campus_category.response.types.g.dart";

@JsonSerializable()
class CampusCategoryResponse {
  final String campusCategoryId;

  final String name;

  final String urlImage;

  CampusCategoryResponse({
    required this.campusCategoryId,
    required this.name,
    required this.urlImage,
  });

  factory CampusCategoryResponse.fromJson(Map<String, dynamic> json) =>
      _$CampusCategoryResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CampusCategoryResponseToJson(this);
}

@JsonSerializable()
class CampusCategoryListResponse {
  final List<CampusCategoryResponse> categories;

  CampusCategoryListResponse({required this.categories});

  factory CampusCategoryListResponse.fromJson(Map<String, dynamic> json) =>
      _$CampusCategoryListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CampusCategoryListResponseToJson(this);
}
