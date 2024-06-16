import "package:dio/dio.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "../../constants/reservation_bc/reservation.constants.dart";
import "../../models/base_response.dart";
import "../../models/reservation/reservation_by_user.response.types.dart";
import "../../models/reservation/save_reservation.request.types.dart";
import "../../network/api_service.dart";

final Provider<ReservationRepository> reservationRepositoryProvider =
    Provider<ReservationRepository>((ProviderRef<ReservationRepository> ref) {
  final ApiService apiService = ref.read(apiServiceProvider);
  return ReservationRepository(apiService);
});

class ReservationRepository {
  final ApiService apiService;

  ReservationRepository(this.apiService);

  Future<BaseResponse<String>> saveReservation(
      SaveReservationRequest reservationRequest) async {
    const String endpoint = ReservationEndpoints.reservation;

    final Response response = await apiService.postRequest(
      endpoint,
      reservationRequest.toJson(),
    );
    final Map<String, dynamic> responseData = response.data;

    return BaseResponse<String>.fromJson(responseData, (Object? json) {
      return json as String;
    });
  }

  Future<BaseResponse<List<ReservationsResponseByUserId>>>
      getAllReservationByUserId(String userId) async {
    final String endpoint =
        "${ReservationEndpoints.reservation}${ReservationEndpoints.user}/$userId";

    final Response response = await apiService.getRequest(endpoint);
    final Map<String, dynamic> responseData = response.data;

    return BaseResponse<List<ReservationsResponseByUserId>>.fromJson(
        responseData, (Object? json) {
      final List<dynamic> jsonList = json as List<dynamic>;
      return jsonList
          .map((dynamic e) =>
              ReservationsResponseByUserId.fromJson(e as Map<String, dynamic>))
          .toList();
    });
  }
}
