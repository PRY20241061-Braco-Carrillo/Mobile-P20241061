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
    try {
      await performAction(
        () {
          // Callback de onLoading
          debugPrint("Cargando la reserva...");
        },
        (String msg) {
          // Callback de onSuccess
          debugPrint("Reserva creada exitosamente con datos: $msg");
        },
        (String err) {
          // Callback de onError
          debugPrint("Error al crear la reserva: $err");
        },
      );
    } catch (e) {
      state = AsyncValue<BaseResponse<String>>.error(e, StackTrace.current);
    }
  }

  @override
  Future<void> performAction(VoidCallback onLoading, Function(String) onSuccess,
      Function(String) onError) async {
    onLoading();
    debugPrint("Iniciando la acción de guardar reserva...");

    try {
      final BaseResponse<String> response = await ref
          .read(reservationRepositoryProvider)
          .saveReservation(reservationRequest);

      debugPrint(
          "Respuesta recibida: Código - ${response.code}, Datos - ${response.data}");

      if (response.code == 'CREATED') {
        onSuccess(response.data);
        state = AsyncValue<BaseResponse<String>>.data(response);
      } else {
        throw Exception("Error al crear la reserva.");
      }
    } catch (e) {
      onError(e.toString());
      state = AsyncValue<BaseResponse<String>>.error(e, StackTrace.current);
    }
  }
}
