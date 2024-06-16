import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "../../models/base_response.dart";
import "../../models/reservation/save_reservation.request.types.dart";
import "../../repository/reservation_bc/reservation_repository.dart";
import "../base.notifier.dart";

final StateNotifierProviderFamily<ReservationNotifier,
        AsyncValue<BaseResponse<String>>, SaveReservationRequest>
    reservationNotifierProvider = StateNotifierProvider.family<
        ReservationNotifier,
        AsyncValue<BaseResponse<String>>,
        SaveReservationRequest>((StateNotifierProviderRef<ReservationNotifier,
                AsyncValue<BaseResponse<String>>>
            ref,
        SaveReservationRequest reservationRequest) {
  return ReservationNotifier(reservationRequest, ref);
});

class ReservationNotifier extends BaseNotifier<String> {
  final SaveReservationRequest reservationRequest;

  ReservationNotifier(this.reservationRequest, super.ref);

  Future<void> saveReservation() async {
    state = const AsyncValue<BaseResponse<String>>.loading();
    await performAction(() {}, (String msg) {}, (String err) {});
  }

  @override
  Future<void> performAction(VoidCallback onLoading, Function(String) onSuccess,
      Function(String) onError) async {
    onLoading();
    try {
      final BaseResponse<String> response = await ref
          .read(reservationRepositoryProvider)
          .saveReservation(reservationRequest);
      handleResponse(response, onSuccess, onError);
      state = AsyncValue<BaseResponse<String>>.data(response);
    } on Exception catch (e) {
      state = AsyncValue<BaseResponse<String>>.error(e, StackTrace.current);
    }
  }
}
