import "dart:convert";

import "package:hooks_riverpod/hooks_riverpod.dart";

import "../../../core/models/auth/sign_up/sign_up.response.types.dart";
import "../../../core/models/auth/sign_up/sign_up.request.types.dart";
import "../../../core/models/base_response.dart";

final Provider<MockSignUpService> mockSignUpServiceProvider =
    Provider<MockSignUpService>((ProviderRef<MockSignUpService> ref) {
  return MockSignUpService();
});

class MockSignUpService {
  Future<BaseResponse<SignUpResponse>> signUpUser(
      SignUpRequest signUpData) async {
    // ignore: always_specify_types
    await Future.delayed(const Duration(seconds: 3));

    final String responseJson = '''
    {
      "code": "CREATED",
      "data": {
          "userId": "13642fa3-3c48-448a-9cf8-608e812544c3",
          "names": "${signUpData.names}",
          "lastNames": "${signUpData.lastNames}",
          "email": "${signUpData.email}",
          "roles": "${signUpData.role.toString().split('.').last.toUpperCase()}",
          "cancelReservation": 0,
          "acceptReservation": 0
      }
    }''';

    final Map<String, dynamic> responseData = jsonDecode(responseJson);
    return BaseResponse<SignUpResponse>.fromJson(
        responseData, SignUpResponse.fromJson);
  }
}
