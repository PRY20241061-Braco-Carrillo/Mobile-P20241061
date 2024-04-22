import "package:json_annotation/json_annotation.dart";

part "sign_up.request.types.g.dart";

@JsonSerializable()
class SignUpRequest {
  final String names;
  final String lastNames;
  final String email;
  final String password;
  final String role;

  factory SignUpRequest.fromJson(Map<String, dynamic> json) =>
      _$SignUpRequestFromJson(json);

  Map<String, dynamic> toJson() => _$SignUpRequestToJson(this);

  SignUpRequest({
    required this.email,
    required this.password,
    required this.names,
    required this.lastNames,
    required this.role,
  });
}
