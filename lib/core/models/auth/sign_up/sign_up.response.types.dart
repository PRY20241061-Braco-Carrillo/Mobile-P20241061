import "package:json_annotation/json_annotation.dart";

part "sign_up.response.types.g.dart";

@JsonSerializable()
class SignUpResponse {
  final String userId;
  final String names;
  final String lastNames;
  final String email;
  final String roles;
  final int cancelReservation;
  final int acceptReservation;

  SignUpResponse({
    required this.userId,
    required this.names,
    required this.lastNames,
    required this.email,
    required this.roles,
    required this.cancelReservation,
    required this.acceptReservation,
  });

  factory SignUpResponse.fromJson(Object? json) {
    if (json is! Map<String, dynamic>) {
      throw ArgumentError(
          "The JSON argument must be of type Map<String, dynamic>");
    }
    return _$SignUpResponseFromJson(json);
  }
}
