import "package:json_annotation/json_annotation.dart";

part "guest_response.types.g.dart";

@JsonSerializable()
class GuestResponse {
  final String roles;
  final String token;

  factory GuestResponse.fromJson(Object? json) {
    if (json is! Map<String, dynamic>) {
      throw ArgumentError(
          "The JSON argument must be of type Map<String, dynamic>");
    }
    return _$GuestResponseFromJson(json);
  }

  GuestResponse({
    required this.roles,
    required this.token,
  });
}
