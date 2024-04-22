import "package:json_annotation/json_annotation.dart";

part "login_response.types.g.dart";

@JsonSerializable()
class LoginResponse {
  final String userId;
  final String roles;
  final int cancelReservation;
  final int acceptReservation;
  final String token;

  factory LoginResponse.fromJson(Object? json) {
    if (json is! Map<String, dynamic>) {
      throw ArgumentError(
          "The JSON argument must be of type Map<String, dynamic>");
    }
    return _$LoginResponseFromJson(json);
  }

  LoginResponse({
    required this.userId,
    required this.roles,
    required this.cancelReservation,
    required this.acceptReservation,
    required this.token,
  });
}
