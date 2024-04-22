import "../../models/auth/login/login_request.types.dart";
import "../../models/auth/login/login_response.types.dart";
import "../../models/auth/sign_up/sign_up.request.types.dart";
import "../../models/auth/sign_up/sign_up.response.types.dart";
import "../../models/base_response.dart";

abstract class IAuthenticationRepository {
  Future<BaseResponse<LoginResponse>> logIn(LoginRequest loginRequest);
  Future<BaseResponse<SignUpResponse>> signUp(SignUpRequest signUpRequest);
}
