import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "../../models/base_response.dart";
import "../../models/reservation/update_reservation_status.request.types.dart";
import "../../repository/reservation_bc/reservation_repository.dart";
import "../base.notifier.dart";

final StateNotifierProviderFamily<UpdateReservationNotifier,
        AsyncValue<BaseResponse<String>>, UpdateReservation>
    updateReservationNotifierProvider = StateNotifierProvider.family<
        UpdateReservationNotifier,
        AsyncValue<BaseResponse<String>>,
        UpdateReservation>((StateNotifierProviderRef<UpdateReservationNotifier,
                AsyncValue<BaseResponse<String>>>
            ref,
        UpdateReservation updateReservation) {
  return UpdateReservationNotifier(updateReservation, ref);
});

class UpdateReservationNotifier extends BaseNotifier<String> {
  final UpdateReservation updateReservation;

  UpdateReservationNotifier(this.updateReservation, super.ref);

  Future<void> updateReservationStatus() async {
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
          .updateReservationStatus(updateReservation);
      handleResponse(response, onSuccess, onError);
      state = AsyncValue<BaseResponse<String>>.data(response);
    } on Exception catch (e) {
      state = AsyncValue<BaseResponse<String>>.error(e, StackTrace.current);
    }
  }
}
